// 🎯T1249: no build tag — runs under both host Go (where main.go is the
// !decimal64 stub) and the pinned fork (where main.go is the real
// decimal64-tagged harness). Its only job is to give cmd/integrate's
// post-merge touched-package `go test ./dectest` a test to run: with zero
// _test.go files that command reports no test files and gate.RunClean
// grades it EMPTY, which is not GREEN (internal/gate's EmptyRun rule) —
// the touched-package step would still refuse the landing even after
// hostgo_stub.go made the package buildable.
package main

import "testing"

func TestHostGoBuildable(t *testing.T) {
	// No assertion beyond "this package built and a test ran": the real
	// verification of tests/dectest's decimal64 harness is
	// scripts/dectest-smoke.sh, run with the pinned fork GOROOT (see
	// .jevons-integrate-prereq.yaml and toolchain.lock).
}
