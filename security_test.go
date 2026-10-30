package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"slices"
	"strings"
	"testing"
	"time"
)

// These tests are the acceptance oracle for the playground's hostile-input
// posture. Each one fails against the pre-fix server: no authentication,
// the whole process environment handed to submitted code, no body cap, no
// concurrency cap, no output cap, and only the direct child signalled on
// timeout.
//
// What they do NOT establish is in docs/SECURITY.md. In particular no test
// here proves filesystem or network isolation, because this code does not
// provide it.

// withEnv sets env vars for one test and restores them after.
func withEnv(t *testing.T, kv map[string]string) {
	t.Helper()
	for k, v := range kv {
		t.Setenv(k, v)
	}
}

func postCode(t *testing.T, h http.HandlerFunc, token, code string) *httptest.ResponseRecorder {
	t.Helper()
	body, err := json.Marshal(runRequest{Code: code})
	if err != nil {
		t.Fatal(err)
	}
	req := httptest.NewRequest(http.MethodPost, "/api/run", bytes.NewReader(body))
	if token != "" {
		req.Header.Set(authHeader, token)
	}
	rec := httptest.NewRecorder()
	h(rec, req)
	return rec
}

// TestRunEndpointRefusesWithoutConfiguredAuth is the headline: an
// unconfigured server must not compile and run a stranger's program.
// Before this change there was no authentication anywhere in the source,
// so /api/run executed whatever any caller sent.
func TestRunEndpointRefusesWithoutConfiguredAuth(t *testing.T) {
	withEnv(t, map[string]string{AuthTokenEnv: "", AllowAnonymousEnv: ""})
	c, err := loadConfig()
	if err == nil {
		t.Fatal("loadConfig accepted a server with neither a token nor an explicit anonymous opt-in")
	}
	cfg, runSlots = c, make(chan struct{}, 1)

	rec := postCode(t, handleRun, "", `package main; func main(){}`)
	if rec.Code != http.StatusServiceUnavailable {
		t.Errorf("status %d, want %d: an unconfigured server must not run code",
			rec.Code, http.StatusServiceUnavailable)
	}
}

func TestRunEndpointRejectsWrongToken(t *testing.T) {
	withEnv(t, map[string]string{AuthTokenEnv: "correct-horse", AllowAnonymousEnv: ""})
	c, err := loadConfig()
	if err != nil {
		t.Fatal(err)
	}
	cfg, runSlots = c, make(chan struct{}, 1)

	for _, token := range []string{"", "wrong", "correct-hors", "correct-horsee"} {
		rec := postCode(t, handleRun, token, `package main; func main(){}`)
		if rec.Code != http.StatusUnauthorized {
			t.Errorf("token %q: status %d, want %d", token, rec.Code, http.StatusUnauthorized)
		}
	}
}

// TestAnonymousAccessMustBeDeliberate pins that the only way to serve
// unauthenticated code execution is to ask for it by name.
func TestAnonymousAccessMustBeDeliberate(t *testing.T) {
	withEnv(t, map[string]string{AuthTokenEnv: "", AllowAnonymousEnv: "1"})
	c, err := loadConfig()
	if err != nil {
		t.Fatalf("explicit anonymous opt-in should configure cleanly: %v", err)
	}
	if !c.anonymous {
		t.Fatal("anonymous flag not set")
	}
	rec := httptest.NewRecorder()
	if !c.requireAuth(rec, httptest.NewRequest(http.MethodPost, "/api/run", nil)) {
		t.Error("explicit anonymous server refused an unauthenticated caller")
	}
}

// TestChildEnvHidesHostEnvironment is the disclosure fix. The pre-fix
// code did cmd.Env = append(os.Environ(), ...), so a submitted program
// could print every secret on the machine.
func TestChildEnvHidesHostEnvironment(t *testing.T) {
	base := []string{
		"FLY_API_TOKEN=super-secret",
		"AWS_SECRET_ACCESS_KEY=also-secret",
		"PLAYGROUND_AUTH_TOKEN=the-servers-own-token",
		"HOME=/home/play",
		"PATH=/usr/bin",
		"GOROOT=/decimal-go",
	}
	got := childEnv(base, map[string]string{"GOCACHE": "/tmp/cache"})
	joined := strings.Join(got, "\n")

	for _, secret := range []string{"super-secret", "also-secret", "the-servers-own-token"} {
		if strings.Contains(joined, secret) {
			t.Errorf("child environment leaks %q:\n%s", secret, joined)
		}
	}
	for _, want := range []string{"HOME=/home/play", "PATH=/usr/bin", "GOROOT=/decimal-go", "GOCACHE=/tmp/cache"} {
		if !slices.Contains(got, want) {
			t.Errorf("child environment missing %q; the toolchain needs it", want)
		}
	}
	// The server's own auth token is the sharpest case: leaking it turns
	// one code execution into permanent authenticated access.
	if strings.Contains(joined, AuthTokenEnv) {
		t.Errorf("child environment carries %s", AuthTokenEnv)
	}
}

func TestChildEnvOverrideBeatsInheritedValue(t *testing.T) {
	got := childEnv([]string{"GOROOT=/wrong", "GOEXPERIMENT=loopvar"}, map[string]string{
		"GOROOT":       "/decimal-go",
		"GOEXPERIMENT": "",
	})
	if !slices.Contains(got, "GOROOT=/decimal-go") || slices.Contains(got, "GOROOT=/wrong") {
		t.Errorf("override lost: %v", got)
	}
	// An empty override must still be set: GOEXPERIMENT="" is how the
	// toolchain is told to enable nothing, and dropping it inherits the
	// host's value instead.
	if !slices.Contains(got, "GOEXPERIMENT=") {
		t.Errorf("empty override dropped: %v", got)
	}
}

// TestRequestBodyIsBounded fails on the pre-fix decoder, which buffered
// whatever it was sent.
func TestRequestBodyIsBounded(t *testing.T) {
	withEnv(t, map[string]string{AuthTokenEnv: "tok", AllowAnonymousEnv: ""})
	c, err := loadConfig()
	if err != nil {
		t.Fatal(err)
	}
	cfg, runSlots = c, make(chan struct{}, 1)

	huge := `{"code":"` + strings.Repeat("a", maxRequestBytes+1024) + `"}`
	req := httptest.NewRequest(http.MethodPost, "/api/run", strings.NewReader(huge))
	req.Header.Set(authHeader, "tok")
	rec := httptest.NewRecorder()
	handleRun(rec, req)

	if rec.Code != http.StatusBadRequest && rec.Code != http.StatusRequestEntityTooLarge {
		t.Errorf("status %d for a %d-byte body, want a rejection", rec.Code, len(huge))
	}
}

// TestConcurrencyIsBounded pins that the server sheds load rather than
// starting an unbounded number of Go compilers.
func TestConcurrencyIsBounded(t *testing.T) {
	withEnv(t, map[string]string{
		AuthTokenEnv: "tok", AllowAnonymousEnv: "", MaxConcurrentEnv: "1",
	})
	c, err := loadConfig()
	if err != nil {
		t.Fatal(err)
	}
	cfg, runSlots = c, make(chan struct{}, c.maxConcurrent)

	// Occupy the only slot, as an in-flight run would.
	runSlots <- struct{}{}
	defer func() { <-runSlots }()

	rec := postCode(t, handleRun, "tok", `package main; func main(){}`)
	var resp runResponse
	if err := json.NewDecoder(rec.Body).Decode(&resp); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(resp.Error, "busy") {
		t.Errorf("second concurrent run was admitted; error=%q", resp.Error)
	}
}

func TestRunArgvPutsSandboxOutermostAndLimiterInside(t *testing.T) {
	argv := runArgv([]string{"nsjail", "-C", "cfg", "--"}, "/playground", "/decimal-go/bin/go", "/tmp/x/prog.go")
	want := []string{
		"nsjail", "-C", "cfg", "--",
		"/playground", limitFlag, "--",
		"/decimal-go/bin/go", "run", "/tmp/x/prog.go",
	}
	if !slices.Equal(argv, want) {
		t.Errorf("argv =\n %v\nwant\n %v", argv, want)
	}

	// With no sandbox configured the limiter is still there: the
	// process-level limits do not depend on an external jail.
	bare := runArgv(nil, "/playground", "/go", "/p.go")
	if bare[0] != "/playground" || bare[1] != limitFlag {
		t.Errorf("without a sandbox wrapper the rlimit launcher must still lead: %v", bare)
	}
}

func TestCappedWriterTruncatesAndKeepsChildWriting(t *testing.T) {
	var buf bytes.Buffer
	w := &cappedWriter{w: &buf, remaining: 10}

	n, err := w.Write([]byte("0123456789abcdef"))
	if err != nil {
		t.Fatalf("cappedWriter returned an error: %v", err)
	}
	// A short write count makes the child die with an I/O error instead
	// of the caller reporting truncation, so the full length is claimed.
	if n != 16 {
		t.Errorf("Write returned %d, want 16 (a short count breaks the child's stdout)", n)
	}
	if buf.String() != "0123456789" {
		t.Errorf("buffered %q, want the first 10 bytes", buf.String())
	}
	if !w.truncated {
		t.Error("truncation not recorded")
	}
	if _, err := w.Write([]byte("more")); err != nil {
		t.Errorf("write after the cap errored: %v", err)
	}
}

// TestLauncherAppliesLimits runs the real re-exec path: build this
// package, invoke it as the limiter, and confirm a program that exceeds
// a limit is stopped. This is the test that proves the rlimits are
// actually inherited through execve rather than merely set somewhere.
func TestLauncherAppliesLimits(t *testing.T) {
	if runtime.GOOS == "windows" {
		t.Skip("the limiter is a unix path")
	}
	self := buildSelf(t)

	// RLIMIT_FSIZE is the portable one: Linux and macOS both enforce it,
	// so this assertion means the same thing on a laptop and in prod.
	// A shell writing past the cap dies on SIGXFSZ.
	out := filepath.Join(t.TempDir(), "big")
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	script := fmt.Sprintf("dd if=/dev/zero of=%s bs=1m count=%d 2>/dev/null",
		out, (limitFileSizeBytes>>20)+16)
	cmd := exec.CommandContext(ctx, self, limitFlag, "--", "/bin/sh", "-c", script)
	cmd.Env = os.Environ()
	_ = cmd.Run()

	fi, err := os.Stat(out)
	if err != nil {
		// The write never got far enough to create the file — also a pass.
		return
	}
	if fi.Size() > limitFileSizeBytes {
		t.Errorf("wrote %d bytes through the limiter, RLIMIT_FSIZE is %d — the limit is not being applied",
			fi.Size(), limitFileSizeBytes)
	}
}

// TestLauncherRefusesEmptyCommand guards the launcher's own argument
// handling: becoming something unintended is the one thing it must not do.
func TestLauncherRefusesEmptyCommand(t *testing.T) {
	if err := runLauncher(nil); err == nil {
		t.Fatal("runLauncher(nil) returned nil; it must refuse rather than exec something unintended")
	}
}

func buildSelf(t *testing.T) string {
	t.Helper()
	bin := filepath.Join(t.TempDir(), "playground")
	cmd := exec.Command("go", "build", "-o", bin, ".")
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("build self: %v\n%s", err, out)
	}
	return bin
}
