package main

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"syscall"
)

// This file is what constrains a submitted program once it runs. Read
// docs/SECURITY.md before changing anything here: it records which
// properties are actually enforced and which are still open, and a fix
// that quietly weakens one of these is worse than no fix, because the
// endpoint's whole safety story rests on this file.

// limitFlag re-execs this binary as a launcher that applies resource
// limits to itself and then execs the real command. Go cannot set a
// child's rlimits directly — syscall.SysProcAttr has no field for them —
// so the limits have to be applied by a process that then becomes the
// target via execve, which preserves them.
//
// Usage: playground --exec-limited -- /path/to/go run prog.go
const limitFlag = "--exec-limited"

// Resource limits applied to the compile-and-run child.
//
// These bound a program that is merely wasteful. They do not bound one
// that is malicious about the filesystem or the network — nothing here
// can, without namespaces; that is SandboxCmdEnv's job.
const (
	// limitCPUSeconds is wall-independent CPU time. runTimeout already
	// bounds wall clock, but a busy loop can burn a full core for the
	// whole 30s and the machine has one; SIGXCPU stops it sooner.
	limitCPUSeconds = 10
	// limitFileSizeBytes stops a program filling the container's disk.
	// The compiler writes objects under GOCACHE, so this cannot be tight;
	// 256 MB is far above any legitimate single output.
	limitFileSizeBytes = 256 << 20
	// limitProcesses bounds fork bombs. The Go build spawns compile and
	// link processes per package, so this is not a small number.
	limitProcesses = 256
	// limitAddressSpaceBytes bounds virtual memory. The machine has 1 GB;
	// 768 MB leaves the server itself room to answer while the child is
	// being killed. Not enforced on every platform — see applyLimits.
	limitAddressSpaceBytes = 768 << 20
)

// envAllowlist is the complete set of variables passed to the child.
//
// The pre-fix code did cmd.Env = append(os.Environ(), ...), which handed
// every submitted program the whole container environment. On Fly that
// includes the machine's own identifiers and any secret set on the app,
// so a three-line program could print the deployment's credentials. An
// allowlist rather than a denylist: a variable added to the platform
// later must be named here to be visible, instead of leaking by default.
var envAllowlist = []string{
	"GOROOT",      // where the decimal64 toolchain lives
	"GOCACHE",     // build cache, or the compiler writes to $HOME
	"GOTOOLCHAIN", // pinned to local; without it go may fetch another toolchain
	"GOEXPERIMENT",
	"CGO_ENABLED",
	"HOME",
	"PATH",
	"TMPDIR",
}

// childEnv renders the child environment from base, keeping only
// envAllowlist entries and then applying overrides. Overrides win, and
// an override with an empty value is still set — GOEXPERIMENT="" is
// meaningful, it is not the same as unset.
func childEnv(base []string, overrides map[string]string) []string {
	allowed := make(map[string]bool, len(envAllowlist))
	for _, k := range envAllowlist {
		allowed[k] = true
	}
	out := make([]string, 0, len(envAllowlist)+len(overrides))
	seen := make(map[string]bool, len(envAllowlist))
	for _, kv := range base {
		k, _, ok := cutEnv(kv)
		if !ok || !allowed[k] || seen[k] {
			continue
		}
		if _, overridden := overrides[k]; overridden {
			continue
		}
		seen[k] = true
		out = append(out, kv)
	}
	for k, v := range overrides {
		out = append(out, k+"="+v)
	}
	return out
}

func cutEnv(kv string) (key, value string, ok bool) {
	for i := 0; i < len(kv); i++ {
		if kv[i] == '=' {
			return kv[:i], kv[i+1:], true
		}
	}
	return "", "", false
}

// runArgv assembles the argv for one submission: the optional external
// sandbox prefix, then this binary as the rlimit launcher, then the
// toolchain invocation.
//
// Exported shape rather than an inline append so a test can assert what
// is actually executed. The ordering is load-bearing: the external
// sandbox must be outermost, because it is the only layer that can
// remove the ability to escape the ones inside it.
func runArgv(sandboxCmd []string, self, goBin, srcPath string) []string {
	argv := make([]string, 0, len(sandboxCmd)+6)
	argv = append(argv, sandboxCmd...)
	argv = append(argv, self, limitFlag, "--", goBin, "run", srcPath)
	return argv
}

// limitUnavailable marks a resource this platform does not expose. A
// limit so marked is skipped and announced, never silently dropped.
const limitUnavailable = -1

// applyLimits sets this process's resource limits. Called only in the
// re-exec'd launcher, immediately before execve.
//
// A limit the kernel refuses is a hard error, not a warning: the only
// caller is about to become hostile code, and running it unlimited is
// the failure this file exists to prevent. A limit the platform does not
// have at all is different — that is a known gap, reported on stderr so
// a development run on a Mac never reads as a promise of a constraint
// that in fact only holds in production.
func applyLimits() error {
	for _, l := range []struct {
		name     string
		resource int
		value    uint64
	}{
		{"RLIMIT_CPU", syscall.RLIMIT_CPU, limitCPUSeconds},
		{"RLIMIT_FSIZE", syscall.RLIMIT_FSIZE, limitFileSizeBytes},
		{"RLIMIT_NPROC", rlimitNPROC, limitProcesses},
		{"RLIMIT_AS", rlimitAS, limitAddressSpaceBytes},
	} {
		if l.resource == limitUnavailable {
			fmt.Fprintf(os.Stderr, "playground: %s unavailable on %s; that resource is unbounded\n",
				l.name, runtime.GOOS)
			continue
		}
		lim := syscall.Rlimit{Cur: l.value, Max: l.value}
		if err := syscall.Setrlimit(l.resource, &lim); err != nil {
			return fmt.Errorf("setrlimit %s: %w", l.name, err)
		}
	}
	return nil
}

// runLauncher is the --exec-limited entry point: apply limits, then
// become the target command. It never returns on success.
func runLauncher(args []string) error {
	if len(args) == 0 {
		return errors.New("--exec-limited: no command given")
	}
	if err := applyLimits(); err != nil {
		return err
	}
	bin, err := exec.LookPath(args[0])
	if err != nil {
		return fmt.Errorf("--exec-limited: %w", err)
	}
	return syscall.Exec(bin, args, os.Environ())
}

// errOutputTruncated marks a result cut short by maxOutputBytes.
var errOutputTruncated = errors.New("output truncated")

// runProgram compiles and runs src, returning its combined output.
//
// The process group is the reason this is not a plain CombinedOutput.
// `go run` spawns a compiler, a linker, and then the built binary;
// exec.CommandContext signals only the direct child, so on timeout the
// program the user actually submitted keeps running with no parent. The
// child is given its own process group and the whole group is killed.
func runProgram(ctx context.Context, cfg config, goBin, goCache, src string) (string, error) {
	dir, err := os.MkdirTemp("", "playground-run-")
	if err != nil {
		return "", fmt.Errorf("scratch dir: %w", err)
	}
	defer os.RemoveAll(dir)

	srcPath := filepath.Join(dir, "prog.go")
	if err := os.WriteFile(srcPath, []byte(src), 0o600); err != nil {
		return "", fmt.Errorf("write source: %w", err)
	}

	self, err := os.Executable()
	if err != nil {
		return "", fmt.Errorf("locate self: %w", err)
	}
	argv := runArgv(cfg.sandboxCmd, self, goBin, srcPath)

	cmd := exec.CommandContext(ctx, argv[0], argv[1:]...)
	cmd.Dir = dir
	cmd.Env = childEnv(os.Environ(), map[string]string{
		"GOROOT":       goToolchain,
		"GOCACHE":      goCache,
		"GOTOOLCHAIN":  "local",
		"GOEXPERIMENT": "",
		"CGO_ENABLED":  "0",
		"HOME":         dir,
		"TMPDIR":       dir,
	})
	setProcessGroup(cmd)
	cmd.Cancel = func() error { return killGroup(cmd) }

	var buf bytes.Buffer
	w := &cappedWriter{w: &buf, remaining: maxOutputBytes}
	cmd.Stdout = w
	cmd.Stderr = w

	runErr := cmd.Run()
	// Kill the group unconditionally: a program that returns while
	// leaving a background goroutine's child alive is not our problem to
	// diagnose, it is a process to reap.
	_ = killGroup(cmd)

	if w.truncated {
		return buf.String(), errOutputTruncated
	}
	return buf.String(), runErr
}

// cappedWriter writes at most remaining bytes and records that it
// stopped. It reports every write as fully accepted: a short write makes
// the child see a failing stdout and die with a confusing I/O error
// instead of the truncation message the caller should see.
type cappedWriter struct {
	w         *bytes.Buffer
	remaining int
	truncated bool
}

func (c *cappedWriter) Write(p []byte) (int, error) {
	if c.remaining <= 0 {
		c.truncated = true
		return len(p), nil
	}
	if len(p) > c.remaining {
		c.w.Write(p[:c.remaining])
		c.remaining = 0
		c.truncated = true
		return len(p), nil
	}
	c.w.Write(p)
	c.remaining -= len(p)
	return len(p), nil
}
