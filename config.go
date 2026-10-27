package main

import (
	"crypto/sha256"
	"crypto/subtle"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

// This file holds the request-side controls: what the server will accept
// before it will compile and run a stranger's Go program.
//
// Read sandbox.go for what constrains the program once it is running,
// and docs/SECURITY.md for the parts of the threat model that are
// deliberately NOT closed here.

// Environment variables. Named as constants because they are part of the
// deployment contract — fly.toml and the Dockerfile refer to the same
// strings, and a typo in one of them fails open if it is a bare literal.
const (
	// AuthTokenEnv holds the shared secret a caller must present to
	// POST /api/run. Unset means the execution endpoint is disabled;
	// see requireAuth.
	AuthTokenEnv = "PLAYGROUND_AUTH_TOKEN"
	// AllowAnonymousEnv, set to "1", re-opens /api/run to the public
	// internet with no token. It exists so that turning the endpoint on
	// without a secret is a deliberate, greppable act rather than the
	// default.
	AllowAnonymousEnv = "PLAYGROUND_ALLOW_ANONYMOUS"
	// SandboxCmdEnv is an argv prefix the compile-and-run command is
	// executed through, e.g. "nsjail -C /etc/nsjail.cfg --". Empty means
	// no external sandbox: the process-level limits in sandbox.go still
	// apply, but filesystem and network isolation do not. See
	// docs/SECURITY.md.
	SandboxCmdEnv = "PLAYGROUND_SANDBOX_CMD"
	// MaxConcurrentEnv overrides maxConcurrentRuns.
	MaxConcurrentEnv = "PLAYGROUND_MAX_CONCURRENT"
)

// authHeader carries the shared secret. A header rather than a query
// parameter so the secret does not land in access logs or Referer.
const authHeader = "X-Playground-Token"

// maxRequestBytes bounds one submission. The largest bundled example is
// under 2 KB; 64 KB accepts anything a human will paste and refuses a
// body sized to exhaust memory. Enforced by http.MaxBytesReader, so an
// oversized body is rejected while streaming rather than after buffering.
const maxRequestBytes = 64 << 10

// maxOutputBytes bounds what one program may return. A program that
// prints in an infinite loop is stopped by runTimeout, but not before it
// can generate gigabytes; this caps what is held in memory and returned.
const maxOutputBytes = 256 << 10

// maxConcurrentRuns bounds compile-and-run jobs in flight. Each one is a
// Go compiler plus the built binary, so without a bound a handful of
// simultaneous requests is a denial of service against a 1 GB machine —
// no exploit required. Overridable via MaxConcurrentEnv.
const maxConcurrentRuns = 2

// Server timeouts. The default http.Server has none, so a client that
// opens a connection and never finishes its headers holds it forever.
const (
	readHeaderTimeout = 10 * time.Second
	readTimeout       = 30 * time.Second
	// writeTimeout must exceed runTimeout, or a legitimately slow
	// program's output is cut off by the server rather than returned.
	writeTimeout = runTimeout + 30*time.Second
	idleTimeout  = 60 * time.Second
)

// config is the server's validated startup configuration.
type config struct {
	// authToken is the required shared secret, or "" when anonymous
	// access has been explicitly allowed.
	authToken string
	// anonymous reports that /api/run runs without authentication.
	anonymous bool
	// sandboxCmd is the argv prefix from SandboxCmdEnv, already split.
	sandboxCmd []string
	// maxConcurrent is the in-flight run limit.
	maxConcurrent int
}

// errNoAuthConfigured is returned by loadConfig when neither a token nor
// an explicit anonymous opt-in is present. The server still starts and
// still serves the UI; /api/run refuses. Failing closed matters more
// here than uptime: the endpoint compiles and runs whatever it is sent.
var errNoAuthConfigured = errors.New(
	"no " + AuthTokenEnv + " set: /api/run is disabled. Set a token, or set " +
		AllowAnonymousEnv + "=1 to deliberately expose code execution to every caller")

func loadConfig() (config, error) {
	cfg := config{
		sandboxCmd:    strings.Fields(os.Getenv(SandboxCmdEnv)),
		maxConcurrent: maxConcurrentRuns,
	}
	if v := os.Getenv(MaxConcurrentEnv); v != "" {
		n, err := strconv.Atoi(v)
		if err != nil || n < 1 {
			return config{}, fmt.Errorf("%s=%q: want a positive integer", MaxConcurrentEnv, v)
		}
		cfg.maxConcurrent = n
	}

	token := os.Getenv(AuthTokenEnv)
	anonymous := os.Getenv(AllowAnonymousEnv) == "1"
	switch {
	case token != "":
		cfg.authToken = token
		return cfg, nil
	case anonymous:
		cfg.anonymous = true
		return cfg, nil
	default:
		return cfg, errNoAuthConfigured
	}
}

// requireAuth reports whether the request may run code, writing the
// refusal itself when it may not.
//
// Three outcomes, and the order matters: an unconfigured server refuses
// everything (503), an anonymous-by-choice server accepts everything,
// and a configured server compares the presented token in constant time.
// The comparison is over SHA-256 digests so that it is length-independent
// — subtle.ConstantTimeCompare returns early on a length mismatch, which
// leaks the secret's length to a caller who can time it.
func (c config) requireAuth(w http.ResponseWriter, r *http.Request) bool {
	if c.authToken == "" {
		if c.anonymous {
			return true
		}
		http.Error(w, "code execution is disabled on this server", http.StatusServiceUnavailable)
		return false
	}
	got := sha256.Sum256([]byte(r.Header.Get(authHeader)))
	want := sha256.Sum256([]byte(c.authToken))
	if subtle.ConstantTimeCompare(got[:], want[:]) != 1 {
		// No WWW-Authenticate: this is a shared secret in a header, not
		// an HTTP auth scheme, and advertising one invites a browser
		// credential prompt that cannot satisfy it.
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return false
	}
	return true
}
