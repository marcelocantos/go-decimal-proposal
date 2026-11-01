// 🎯T1249: main.go needs the fork's decimal64/decimal128 operators, which do
// not exist as identifiers under the host Go toolchain — not a missing
// import, an undefined-identifier compile failure no build flag can paper
// over. Gated behind the decimal64 build tag so the real harness only
// compiles when deliberately requested (e.g. by scripts/dectest-smoke.sh,
// run with the pinned fork GOROOT; see toolchain.lock).
//
// Without that tag — the case for a host `go build`/`go test` of this
// package, including cmd/integrate's post-merge touched-package gate — this
// stub is the package's only non-test file, so it stays trivially buildable
// on host Go rather than failing with "undefined: decimal64".
//
//go:build !decimal64

package main

func main() {}
