# decTest harness smoke (🎯T1.2.5)

Smoke-runs the IBM Speleotrove decTest vectors for the priority
operations — `ddAdd`, `ddMultiply`, `ddDivide`, `dqAdd`, `dqMultiply`,
`dqDivide` — through the fork's language-level `decimal64`/`decimal128`
operators (`+`, `*`, `/`), compiled and run with the pinned fork
toolchain. This is deliberately distinct from `internal/bid`'s own
`vectors_test.go` / `TestConformance`, which exercise the kernel package
directly, built with the *host* toolchain: this harness exercises the
compiler/runtime wiring end to end, the same way `tests/oracle` and
`tests/quantum_validate.go` do.

## Not vendored

As with `internal/bid/vectors_test.go`, the decTest files carry an IBM
copyright notice with no redistribution grant, so they are not checked
into this repository or downloaded by CI. Point `dectest` at an
out-of-tree copy with `-dir` or `BID_DECTEST_DIR`:

```
GOROOT=<pinned checkout> <pinned>/bin/go run ./tests/dectest \
    -dir /path/to/dectest/files
```

A convenient already-present local source on macOS is the Python
standard library's bundled copy under
`.../lib/python3.1x/test/decimaltestdata/` (the same corpus CPython uses
for its own `decimal` module tests). Any directory holding the six
`dd*.decTest` / `dq*.decTest` priority files works.

## What it checks, and what it skips

For every vector line in the six priority files, the harness either
**passes** (the runtime operator's result matches the vector's expected
value), **fails** (value mismatch, printed with file:line and operands),
or is **skipped with a named, printed reason** — never silently. Named
skip reasons, and why each is out of scope for this smoke test:

- `rounding-mode:<mode>` — the vector's section declares a rounding mode
  other than `half_even`. The fork's runtime operators implement only
  round-to-nearest, ties-to-even (README design decision 4); the other
  four IEEE 754 modes are explicit functions in `math/decimal`
  (`Round`, `Quantize`), not operator behaviour, so vectors under those
  sections are out of scope for `+`/`*`/`/`.
- `condition:<name>` (`Division_by_zero`, `Division_impossible`,
  `Division_undefined`, `Invalid_operation`) — vectors whose point is a
  status/signal flag this harness does not check (it checks the result
  value only).
- `special-value` — either operand or the expected result contains a
  NaN/sNaN/Infinity token; comparing those needs payload/signal
  semantics this smoke harness doesn't model.
- `directive-line` — a decTest directive (`version:`, `precision:`,
  `rounding:`, `extended:`, `clamp:`, `maxExponent:`, `minExponent:`),
  not a vector.
- `operation-mismatch:<op>` — a stray vector in the file using a
  different operation keyword than the file's declared op.
- `file-missing:<name>` — one of the six priority files is absent from
  `-dir`; the whole file is skipped, named, rather than silently
  producing a shorter report. `dectest` still exits non-zero whenever
  this happens.
- `eval-error:` / `want-parse-error:` — an operand or the expected
  result failed to parse at the file's declared width; none occurred in
  the baseline run below.

Any `fail` (value mismatch on a vector this harness did evaluate) or any
`file-missing:` skip makes `dectest` exit non-zero. A clean run can only
be `fail=0` with every file present.

## Baseline (2026-11-02)

Run against the Speleotrove suite bundled with Python 3.14
(`/Library/Frameworks/Python.framework/Versions/3.14/lib/python3.14/test/decimaltestdata`),
built and run with the pinned fork toolchain
(`/Users/marcelo/work/github.com/golang/go` at fork commit `1a34837e38`,
`go version go1.28-devel_1a34837e38`):

```
ddAdd.decTest      pass=610    fail=0      skip=524    total=1134
ddMultiply.decTest pass=313    fail=0      skip=139    total=452
ddDivide.decTest   pass=431    fail=0      skip=306    total=737
dqAdd.decTest      pass=676    fail=0      skip=369    total=1045
dqMultiply.decTest pass=234    fail=0      skip=249    total=483
dqDivide.decTest   pass=430    fail=0      skip=270    total=700
TOTAL              pass=2694   fail=0      skip=1857   total=4551

skip reasons:
  operation-mismatch:apply       4
  rounding-mode:ceiling         53
  rounding-mode:floor           45
  directive-line               126
  rounding-mode:half_up        836
  rounding-mode:down           131
  special-value                310
  condition:Invalid_operation  184
  rounding-mode:up              72
  rounding-mode:05up            62
  rounding-mode:half_down       34
```

Zero failures across every evaluated (non-skipped) vector, zero silent
skips — every one of the 1,857 skipped vectors carries a printed,
named reason in the harness's own output, and that output is captured
verbatim above. This is a smoke check of the runtime wiring, not a
substitute for `internal/bid`'s own `TestConformance` (4,168 vectors,
kernel-level, all rounding modes) or its decTest/readtest ratchet
(`TestNoPublishedVectors`, 21,405 + 58,027 passing / 114,045 named-skip,
also kernel-level) — see `ROADMAP.md`'s "Conformance gates" entry.
