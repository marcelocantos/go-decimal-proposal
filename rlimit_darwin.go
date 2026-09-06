//go:build darwin

package main

// Darwin exposes neither limit usefully: Go's syscall package has no
// RLIMIT_NPROC, and setrlimit on the address-space slot returns EINVAL
// for the values we want (verified 2026-09-06 on macOS 26 — the launcher
// failed with "setrlimit RLIMIT_AS: invalid argument" before this file
// stopped claiming the limit exists).
//
// So on a development Mac a submitted program is bounded by wall clock,
// CPU time and file size, and not by memory or process count. Production
// is Linux, where all four hold. applyLimits prints which ones were
// skipped rather than letting a local run imply a constraint it does not
// have. See docs/SECURITY.md.
const (
	rlimitNPROC = limitUnavailable
	rlimitAS    = limitUnavailable
)
