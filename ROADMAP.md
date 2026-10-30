# Roadmap: from proposal to production

This document outlines the work required to take the decimal64/decimal128
implementation from its current proof-of-concept state
to production-ready code suitable for merging into the Go tree.

Status as of 2026-10-27, after the
[audit](docs/audits/deep-dive-2026-10-27.md).
The design decisions that the implementation must follow are recorded
in the README under [Design decisions](README.md#design-decisions);
nothing below should be built against the strawman's current choices
where they differ.

## Phase 0: Fix known bugs

These must be resolved before any review process begins.

### Linux bootstrap — *done*

Native `make.bash` and the decimal tests pass on linux/amd64
in this repository's CI (`build.yml`, green since 2026-02-16).
`all.bash` passes on darwin/arm64.

### 32-bit targets — *open*

`GOOS=linux GOARCH=386 go build std` fails with
`internal compiler error: not lowered: Store SSA PTR UINT64 SSA`.
The `softdecimal` pass retypes `decimal64` as `uint64` after
`expand_calls`, but nothing decomposes that into two 32-bit halves.

**Work**: add the `TDECIMAL64` case to `decomposeAsNecessary`
(or lower via the existing 64-bit-integer predicates), and cross-build
`std` for every port in CI.

### Composite map keys — *open*

`map[struct{A decimal64; B int}]int` crashes the compiler:
`reflectdata/alg.go` asks for `runtime.d64hash`, which
`typecheck/_builtin/runtime.go` does not declare.

**Work**: declare `d64hash`, `d128hash`, `d64equal`, `d128equal`
alongside `f64hash` and `c128hash`; add struct and array key tests.

### `reflect.Value.Call` ABI — *partly done*

The compiler side is fixed: `cmd/compile/internal/abi/abiutils.go`
passes `decimal64` in one integer register and `decimal128`
as two `uint64` halves, matching `complex128`.
`reflect/abi.go` still assigns `decimal128` as a single 16-byte
register and panics with `invalid argSize` on any `decimal128`
argument or result, which breaks `testing/quick` and template functions.

**Work**: mirror the compiler's split in `reflect/abi.go`; add a
`reflect.Value.Call` round-trip test for both widths.

### `strconv` range and rounding — *open*

`ParseDecimal64("1e999")` returns `1e+369, nil`; `"1e-400"` returns
`1e-398`; `ParseDecimal128("1e6144")` decodes as garbage because the
biased exponent overflows into the Form-2 prefix. Excess digits are
truncated (`"12345678901234569"` → `…560`) and the test table asserts
the truncation.

**Work**: `ErrRange` parity with `ParseFloat`, round-half-even on excess
digits, reject `"NaNxyz"`-style prefixes; rewrite the test table.

### Public constant renumbering — *open*

`reflect.Decimal64 = 15` and `Decimal128 = 16` were inserted before
`Complex64`, shifting twelve existing `reflect.Kind` values;
`go/types.Decimal64/128` shift `String` and the untyped kinds.
The `cmd/api` failure was silenced in `api/except.txt`.

**Work**: append both pairs after the last existing value; remove the
`api/except.txt` entries.

### DWARF debug support — *done*

Added `debug/dwarf.DecimalFloatType` to handle the
`DW_ATE_decimal_float` encoding,
enabling debuggers to display decimal values.

### BID128 exponent formatting — *done*

Fixed `strconv.appendExp` to support 4-digit exponents
(BID128 exponents can reach ~6176).
Added test coverage for extreme exponent values.

## Phase 1: IEEE 754 conformance

### Rewrite the arithmetic kernel — *open, blocking*

The audit's exact-arithmetic oracle ([`tests/oracle`](tests/oracle))
shows the strawman's operators are wrong in value, not merely in
quantum, on ordinary inputs: decimal64 division for about 24 percent
of random operand pairs with exponents in −10..10, decimal128 division
for about 52 percent, decimal128 addition for about 7 percent
(`1e20 + 1e-20` → `1.318…e18`), multiplication off by one ulp for
about 1 percent, and decimal128 overflow undetected.
Root causes: a wrapping 128-bit multiply in exponent alignment,
a discarded high quotient word in 128-bit division,
a fixed 10^16 dividend scale in 64-bit division,
`xe + ye` where IEEE wants `xe − ye` as the division exponent,
digit-at-a-time rounding (double rounding) in every path,
and a one-digit sticky bit in multiplication.

**Work**: one width-parameterised kernel on `uint64`/`[2]uint64`
signatures (so the runtime compiles without the language feature,
as `softfloat64.go` does): exact aligned sum or product in 128/256
bits, a single round-half-even with a true sticky bit, preferred
exponent, clamp, overflow to infinity. Correctly rounded conversions
(`float64` ↔ decimal via exact binary value; integer ↔ decimal).
Gate: the oracle reports zero value and zero quantum mismatches at
10^5 cases per operation per width, then the decTest vectors below.

### Validate against decTest suite

The [Speleotrove decTest suite](http://speleotrove.com/decimal/dectest.html)
contains thousands of test vectors covering every IEEE 754 operation
and edge case. This is the standard conformance suite
used by Intel's BID library, IBM's decNumber, and others.

**Work**: Write a test harness that reads decTest files
and runs each test vector against the runtime arithmetic.
Fix all failures. This is likely the single largest work item
and will uncover edge cases in rounding, overflow, underflow,
and special-value handling.

Priority test files:
- `ddAdd`, `ddSubtract`, `ddMultiply`, `ddDivide` (basic arithmetic)
- `ddCompare`, `ddCompareSig` (comparisons)
- `ddToIntegral*` (rounding)
- `ddQuantize` (quantum operations)
- `ddFMA` (fused multiply-add)
- The `dq` equivalents for decimal128

### Signaling NaN — *decided*

Design decision 4: signalling NaN is accepted as input, treated as NaN,
and quieted; payloads and signs are not propagated.
The strawman already recognises the sNaN bit pattern as NaN.
**Work**: document it; add decTest `ddNaN`-style vectors.

### Subnormal handling

BID has minimum exponent clamping.
Verify that the behavior at exponent boundaries
matches IEEE 754 precisely.
The `bid64Normalize` and `bid128Normalize` functions
handle this, but they have not been validated
against spec test vectors.

### Rounding modes — *decided*

Design decision 4: operators round to nearest, ties to even, only.
IEEE 754's other modes (nearest-away, toward positive, toward negative,
toward zero) are provided as explicit functions in `math/decimal`
(`Round`, `Quantize` with a mode argument), never as a global mode.
**Work**: implement in `math/decimal` once the kernel exposes a
round-with-mode primitive.

### Constant model — *open, blocking*

Design decision 1 replaces the strawman's source-text side channel
(`ir.BasicLit.origLit`, an extra string per constant in export data,
two duplicated literal parsers in `ssagen` and `staticdata`) with a
quantum attribute on `go/constant` floating-point values.

**Work**: add the accessor to `go/constant` and set it in
`MakeFromLiteral`; propagate it in `BinaryOp`/`UnaryOp` for exact
results by the preferred-exponent rules; consume it in the conversion
to decimal types in both `go/types` and `types2`; delete `origLit`,
the export-data string, and the duplicated parsers; remove the
`types2/expr.go` rule that demotes typed decimal constant expressions
to values; add `internal/types/testdata` cases, including cross-package
constants, rune and hexadecimal literals, multi-name declarations and
negated named constants.

## Phase 2: Code quality

### Rebase onto tip

The branch is based on the go1.26 release.
It needs to be rebased onto `master`
(the development branch for the next release).

### Split into reviewable CLs

The Go project expects small, focused CLs.
The split cannot start until the kernel rewrite and the constant model
(Phase 1) have landed, because both change the interfaces everything
else sits on; splitting first would mean splitting twice.
The audit's section 7 gives a dependency order
(abi/reflect kinds → runtime kernel → go/constant → type checkers with
testdata → compiler front end → SSA and staticdata → DWARF → x/tools
printf upstream → one CL per standard-library package).
A suggested split of the ~12,150 lines:

| CL | Scope | Description |
|----|-------|-------------|
| 1 | Type system | `cmd/compile/internal/types`, `go/types`, `go/ast` — type definitions only |
| 2 | IR and SSA | `cmd/compile/internal/ir`, `ssa/`, `ssagen/` — opcodes and lowering |
| 3 | Runtime arithmetic | `runtime/decimal64.go`, `decimal128.go`, `decimalconv.go` |
| 4 | Static data | `staticdata/`, `noder/`, `escape/` — constant encoding, quantum preservation |
| 5 | Compiler wiring | `walk/`, type checker integration, conversions |
| 6 | `strconv` | Parsing and formatting |
| 7 | `fmt` | Verb support, canonical quantum-preserving output |
| 8 | `math`, `math/decimal` | Bits/frombits in `math`; generic helpers in `math/decimal` |
| 9 | `reflect` | Kind, Value.Decimal, Value.SetDecimal |
| 10 | Encodings | `encoding/json`, `encoding/binary`, `encoding/gob`, `encoding/xml` |
| 11 | Database | `database/sql` |
| 12 | Generics and templates | `cmp`, `sort`, `text/template`, `html/template` |
| 13 | Tests | `test/decimal.go`, package-level test files |
| 14 | Bootstrap | Existing `//go:build !compiler_bootstrap` constraints |

Each CL should compile and pass tests independently.
Earlier CLs can use stub implementations
that later CLs flesh out.

### Code style pass

The AI-generated code may not match the Go project's conventions
in variable naming, comment style, or function organization.
A manual pass is needed to align with the surrounding code
in each package.

### Dead code audit

Verify that every function and branch is exercised.
Remove any speculative code that was generated
but isn't actually needed.

## Phase 3: Specification and documentation

The implementation already includes substantial spec and doc work:

- **Language spec** (`doc/go_spec.html`): Updated with decimal floating-point type
  definitions, predeclared type entries, comparison semantics,
  conversion rules (including binary↔decimal precision loss),
  and size/alignment table entries.
- **Builtin docs** (`builtin/builtin.go`): `decimal64` and `decimal128`
  type documentation added.
- **Package docs**: Exported functions in `strconv`, `math`, `fmt`,
  and `reflect` have doc comments.

### Remaining spec/doc work

- **Review for accuracy.** The spec changes were AI-generated
  and need careful review by someone familiar with the spec's
  precise language and conventions.
- **Quantum semantics.** Draft spec text for the constant quantum
  attribute, representability and constant conversion now exists in
  the README under [Language spec changes](README.md#language-spec-changes);
  it must be reviewed and then implemented in `doc/go_spec.html`.
- **Release notes.** A major new type warrants a prominent section
  in the release notes with examples and migration guidance.
- **Package doc polish.** Verify that all exported functions
  have idiomatic doc comments matching Go conventions.

## Phase 4: Tooling

The implementation already includes:

- **`go vet`**: The `printf` analyzer recognizes decimal types
  and reports invalid format verbs (e.g., `%s` or `%d` for `decimal64`).
  Test cases exist in `cmd/vet/testdata/print/print.go`.
- **`go/types`**: Fully updated with decimal type support,
  including the type checker, assignability rules,
  and constant representability.

### Remaining tooling work

- **`gopls`.** The `go/types` changes affect gopls,
  which is the primary Go IDE backend.
  Verify that autocomplete, hover info,
  type inference, and diagnostics work correctly
  with decimal types.
- **Third-party static analysis.** Tools like `staticcheck`,
  `golangci-lint`, and any tool that depends on `go/types`
  must handle the new `Kind` values without crashing.
  This is likely automatic for well-written tools,
  but should be verified.
- **`go/constant` interaction.** Under design decision 1 there is
  no folding bypass: typed decimal constant expressions fold through
  `go/constant` like any other, and the quantum attribute is a
  documented, additive part of the `go/constant` API.
  Document the accessor and the propagation rules there.

## Phase 5: Performance

### Current baseline

Preliminary benchmarks on Apple M4 Max (arm64)
show the pure Go implementation at:

| Operation | decimal64 | float64 | Ratio |
|-----------|-----------|---------|-------|
| Add       | 5.0 ns    | 1.7 ns  | 3x    |
| Multiply  | 4.9 ns    | 1.7 ns  | 3x    |
| Divide    | 20.5 ns   | 1.6 ns  | 13x   |
| Compare   | 3.3 ns    | 1.6 ns  | 2x    |
| Sprintf   | 50 ns     | 49 ns   | 1x    |

All operations are zero-allocation.
These numbers were measured on the strawman before the kernel rewrite.
Addition, multiplication and comparison are within 3x of hardware
float64 and that order of magnitude should survive the rewrite;
the division figure is not meaningful, because the division it
measures produces too few digits. Re-measure after Phase 1.

### Comprehensive benchmarks

Write benchmarks covering the full operation set:
- Arithmetic: add, sub, mul, div (both 64 and 128)
- Comparison: eq, lt, le
- Formatting: `Sprintf("%v")`, `Sprintf("%.2f")`, `AppendDecimal`
- Parsing: `ParseDecimal64`, `ParseDecimal128`
- Conversions: float64-to-decimal, int-to-decimal, widen, narrow
- Map operations: insert, lookup, iteration with decimal keys

Compare against:
- Intel's BID C library (via cgo shim) — the reference implementation
- `shopspring/decimal` — the most popular Go library
- `cockroachdb/apd` — used in production at scale
- `ericlagergren/decimal` — correctness-focused library

### Profiling and tuning the Go implementation

Before resorting to assembly,
profile the existing pure Go code to identify hot spots
and apply algorithmic improvements:

- **Division.** At 13x slower than float64, this is the priority.
  Investigate whether lookup tables, Newton-Raphson reciprocal estimation,
  or reduced iteration counts can bring this closer to 5–6x.
- **128-bit arithmetic.** The `u128Mul`, `u128Div`, and `u128Add`
  helper functions are on the critical path for decimal128 operations.
  Profile to determine whether they dominate
  or whether the BID normalization logic is the bottleneck.
- **Branch elimination.** The BID coefficient encoding
  has two forms (small and large coefficient).
  If profiling shows branch misprediction overhead,
  consider branchless implementations.
- **Formatting.** Currently equivalent to float64 (50 ns),
  but worth profiling to ensure
  no unnecessary allocations or conversions exist.

### Compiler optimizations

Currently all decimal arithmetic goes through
runtime function calls via the SSA "soft decimal" lowering.
Potential optimizations:

- **Inline simple operations.** Comparisons and zero checks
  could be inlined by the SSA backend.
- **Constant propagation.** When both operands are known at compile time
  and quantum preservation is not needed
  (e.g., in a comparison), the result could be computed at compile time.
- **Strength reduction.** Multiplication by powers of 10
  could be lowered to exponent adjustment.

### Assembly fast paths

For the two most common architectures (amd64 and arm64),
hand-written assembly for hot operations
could provide significant additional speedups,
following the pattern used by `math/big` and `crypto/subtle`.

Priority order, based on current profiling:

1. **`ddiv64` / `ddiv128`** — division is 13x slower than float64
   and is the most impactful target.
2. **`dmul64` / `dmul128`** — multiplication involves
   widening multiply and normalization;
   architecture-specific `UMULH`/`MUL` pairs can help.
3. **`dadd64` / `dadd128`** — addition requires coefficient alignment;
   already fast (5 ns) but could benefit from branchless paths.
4. **`dcmp64` / `dcmp128`** — comparison is already 2x;
   diminishing returns unless profiling shows otherwise.

Other architectures (386, arm, ppc64, s390x, etc.)
can continue to use the pure Go fallback.
On IBM POWER9+ and z/Architecture,
native decimal hardware instructions exist
and could be used directly.

## Phase 6: Incremental rollout

### `GOEXPERIMENT=decimal`

The Go team's practice for large new features
(generics, range-over-func, Swiss maps)
is to ship behind a `GOEXPERIMENT` flag for one release cycle.
This lets early adopters test the feature
while keeping it out of stable builds.

**Work**: Add `GOEXPERIMENT=decimal` gating
to the type system, runtime, and standard library changes.
After one release cycle with no major issues,
remove the flag and make the types always available.

### Gradual standard library integration

The implementation already includes support in
`database/sql`, `encoding/json`, `encoding/binary`,
`encoding/gob`, `encoding/xml`, `cmp`, `sort`,
`text/template`, `html/template`, `reflect`,
`hash/maphash`, `internal/fmtsort`, and `testing/quick`.

Packages that could be added in follow-up releases:
- `math/rand` (new feature, not a fix)
- `encoding/json/v2` (depends on v2 finalization)

## Phase 7: Ecosystem

### Database drivers

The `database/sql` package already supports scanning
and converting decimal types, with tests.
Once the types ship, third-party drivers need to be tested
for round-trip behavior with `DECIMAL`/`NUMERIC` columns:
- `lib/pq` (PostgreSQL)
- `jackc/pgx` (PostgreSQL)
- `go-sql-driver/mysql` (MySQL)
- `mattn/go-sqlite3` (SQLite)

### `encoding/json` backward compatibility

The `encoding/json` package already marshals and unmarshals
decimal types as JSON numbers, with test coverage
including NaN/Inf error handling and string tags.
The changes need review to verify they do not alter behavior
for existing programs. Decimal awareness should only activate
when the target type is `decimal64` or `decimal128`.

### Third-party tooling impact

Adding new built-in types affects any tool that switches
on `reflect.Kind` or `go/types.BasicKind`.
Code that uses a `default` case will handle the new kinds gracefully;
code that exhaustively matches known kinds without a `default` will
fail to compile or silently mishandle decimal values.

**Static analysis and linting:**

- [**staticcheck**](https://staticcheck.dev/) (`honnef.co/go/tools`):
  Uses `go/types` extensively for type-aware analysis.
  Any checker that pattern-matches on numeric kinds
  (e.g., detecting integer overflow, unnecessary conversions)
  will need to learn about decimal types.
- [**golangci-lint**](https://golangci-lint.run/):
  Aggregates staticcheck and dozens of other linters.
  Impact depends on individual linters,
  but the aggregator itself should be unaffected.
- [**revive**](https://github.com/mgechev/revive):
  Another popular linter with type-aware rules.
  Same considerations as staticcheck.

**Debugger:**

- [**Delve**](https://github.com/go-delve/delve):
  The standard Go debugger. Needs to display decimal values
  in a human-readable form rather than as raw bytes.
  Delve already handles `complex128` display,
  so the pattern exists, but decimal BID encoding
  is not trivial to pretty-print.

**IDEs:**

- [**GoLand**](https://www.jetbrains.com/go/) (JetBrains):
  Maintains its own Go type analysis independent of `gopls`.
  Will need to recognize the new predeclared types
  for syntax highlighting, code completion, and refactoring.

**Testing:**

- [**testify**](https://github.com/stretchr/testify):
  `assert.Equal` and friends use `reflect.DeepEqual`
  and custom comparison logic that switches on `reflect.Kind`.
  Decimal values should compare correctly via `DeepEqual`
  (which the implementation already supports),
  but testify's diff formatting may need updating
  to display decimal values readably.

**ORMs and database tools:**

- [**GORM**](https://gorm.io/):
  Uses `reflect` to map struct fields to database columns.
  Decimal struct fields will need a type mapping
  to SQL `DECIMAL`/`NUMERIC`.
- [**sqlc**](https://sqlc.dev/):
  Generates Go code from SQL queries.
  Should map `DECIMAL`/`NUMERIC` columns to `decimal64` or `decimal128`
  instead of `string` or `shopspring/decimal`.
- [**sqlx**](https://github.com/jmoiron/sqlx):
  Extends `database/sql` with struct scanning.
  Should work automatically via `database/sql.Scan`,
  but needs verification.

**Code generation:**

- [**protoc-gen-go**](https://pkg.go.dev/google.golang.org/protobuf):
  Protocol Buffers has no native decimal type,
  but projects like
  [`googleapis/google-cloud-go`](https://github.com/googleapis/google-cloud-go)
  define decimal proto messages.
  A standard mapping from proto decimal to Go `decimal128` would be valuable.
- [**oapi-codegen**](https://github.com/oapi-codegen/oapi-codegen)
  and [**go-swagger**](https://github.com/go-swagger/go-swagger):
  OpenAPI code generators. Could map `type: number, format: decimal`
  to `decimal64` or `decimal128`.

Most of these tools will "just work" for basic use cases
because they fall through to `default` handling.
The risk is in tools that have exhaustive type switches
or that format values by switching on kind —
these will need explicit decimal support
to avoid silent mishandling.
If the types ship behind `GOEXPERIMENT=decimal`,
tool authors will have a release cycle to adapt.

### Third-party library interop

Establish conventions for converting between
the built-in decimal types and existing library types:
- `shopspring/decimal` ↔ `decimal64`/`decimal128`
- `cockroachdb/apd` ↔ `decimal128`
- Protocol Buffers decimal representation

## Summary

| Phase | Effort | Blocking? |
|-------|--------|-----------|
| 0. Fix known bugs | Small to medium | Open — 32-bit, composite keys, reflect ABI, strconv range, Kind renumbering |
| 1. IEEE 754 conformance | Large | Yes — kernel rewrite, constant model, decTest |
| 2. Code quality / CL split | Medium | Yes — required for review |
| 3. Spec and docs | Small (review and polish) | Yes — required for release |
| 4. Tooling | Small (mostly verification) | Partially — gopls is blocking |
| 5. Performance | Medium | No — can follow in later releases |
| 6. GOEXPERIMENT rollout | Small | Yes — required for initial release |
| 7. Ecosystem | Ongoing | No — can happen after release |

The critical path is:
**record design decisions** (done 2026-10-27) →
**submit proposal to `golang/proposal` via Gerrit CL** →
**kernel rewrite, gated by the oracle and decTest** →
**constant model** →
**Phase 0 fixes and cross-port build** →
**API reshaped to the design decisions** →
**rebase onto tip** →
**`GOEXPERIMENT` gating and CL split** →
**review cycles with Go team**.
The kernel rewrite can start in parallel with the proposal submission
and is the strongest evidence to bring to the discussion.

Note: The proposal document must be submitted
as `design/19787-decimal.md` in the
[`golang/proposal`](https://github.com/golang/proposal) repository
via a Gerrit CL,
per the [Go proposal process](https://github.com/golang/proposal/blob/master/README.md).
Discussion of substance happens on
[#19787](https://go.dev/issue/19787).
