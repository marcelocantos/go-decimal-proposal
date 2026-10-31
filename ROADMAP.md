# Roadmap: from proposal to production

This document outlines the work required to take the decimal64/decimal128
implementation from its current state
to production-ready code suitable for merging into the Go tree.

Status as of 2026-11-01, at fork commit 32c14fd1b1.
The [audit](docs/audits/deep-dive-2026-10-27.md) of 2026-10-27 set most of
this list, and the kernel it called for has landed.
The design decisions that the implementation must follow are recorded
in the README under [Design decisions](README.md#design-decisions);
nothing below should be built against the fork's current choices
where they differ.
[Implementation status](README.md#implementation-status) in the README
says what is verified and how.

## Phase 0: Fix known bugs

These must be resolved before any review process begins.

### Linux bootstrap — *done*

Native `make.bash` and the decimal tests pass on linux/amd64
in this repository's CI (`build.yml`), at the fork commit pinned in
`toolchain.lock`.
`all.bash` passes on darwin/arm64.

### 32-bit targets — *builds; behaviour unverified*

`GOOS=linux GOARCH=386 go build std` succeeds, as it does for linux/arm:
`decimal64` is decomposed into two 32-bit halves.
CI runs the kernel's tests under `GOARCH=386`.
Decimal behaviour through the language has not been run on a 32-bit target.

**Work**: run `test/decimal*.go` and the standard library's decimal tests
on a 32-bit target, and cross-build `std` for every port in CI.

### Composite map keys — *done*

`map[struct{A decimal64; B int}]int` and `map[[2]decimal128]int` compile:
`typecheck/_builtin/runtime.go` declares `d64hash`, `d128hash`, `d64equal`
and `d128equal`. `test/decimal_map.go` covers them,
including signed zeros, cohort members, infinities and NaN.

### `reflect.Value.Call` ABI — *done*

`reflect/abi.go` splits `decimal128` into two `uint64` halves,
matching the compiler and `complex128`.
`reflect/decimal_abi_test.go` and `test/decimal.go` cover the round trip.

### `strconv` range and rounding — *done*

`ParseDecimal64("1e999")` returns `+Inf` with `ErrRange`;
`"1e-400"` returns zero with no error, as `ParseFloat` does;
`ParseDecimal128("1e6145")` returns `+Inf` with `ErrRange`.
Excess digits round to nearest even
(`"12345678901234565"` gives `…560`, `"12345678901234567"` gives `…570`),
and `"NaNxyz"` is a syntax error.
Parsing goes through the kernel.

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

### Rewrite the arithmetic kernel — *done*

The audit's exact-arithmetic oracle ([`tests/oracle`](tests/oracle))
showed the first implementation's operators wrong in value on ordinary inputs.
`internal/bid` replaces them: one package on `uint64` and two-`uint64`
bit patterns, both widths generated from one template,
every operation reaching the encoding through one rounding function,
and conversions correctly rounded from the exact source value.
`tests/oracle` through the language's operators
now reports no mismatch at 10^5 cases per operation per width.
A [review](docs/audits/kernel-review-2026-10-31.md) on 2026-10-31
found no wrong value, flag or reachable panic,
and ten faults in contract text and comments, which were fixed.

### Conformance gates — *done*

- `TestKernel` compares the kernel with an exact `math/big` reference model:
  no mismatch at 10^6 cases per operation and width, in CI on linux/amd64.
- `TestConformance` runs 4,168 vectors written independently of the kernel
  and the oracle, in `all.bash` and in CI on linux/amd64, 386 and js/wasm.
- The [Speleotrove decTest suite](http://speleotrove.com/decimal/dectest.html)
  and Intel's `readtest.in` are a local check only, and stay out of the tree:
  21,405 and 58,027 vectors pass with no failures,
  and 114,045 are skipped with a named reason.
  `TestNoPublishedVectors` keeps them out.
  The IBM files carry no licence grant.

### Big-endian targets — *open*

The kernel's test binary compiles for s390x and ppc64 but has not run.

**Work**: run it under qemu-user in CI.

### Signaling NaN — *done*

Design decision 4: signalling NaN is accepted as input, treated as NaN,
and quieted; payloads and signs are not propagated.
The kernel does this and its package contract says so.

### Subnormal handling — *done*

The rounding function handles the exponent boundaries,
and the oracle and the conformance suite cover the subnormal,
underflow and clamp cases.

### Rounding modes — *decided; public API open*

Design decision 4: operators round to nearest, ties to even, only.
IEEE 754's other modes (nearest-away, toward positive, toward negative,
toward zero) are provided as explicit functions in `math/decimal`
(`Round`, `Quantize` with a mode argument), never as a global mode.
The kernel implements all five.
**Work**: expose them in `math/decimal`, which doesn't exist yet.

### Constant model — *open, blocking*

Design decision 1 replaces the fork's source-text side channel
(`ir.BasicLit.origLit`, an extra string per constant in export data)
with a quantum attribute on `go/constant` floating-point values.
The value path is already correct: the kernel rounds and encodes constants
through one helper, `ir.DecimalConst`, and the duplicated encoders are gone.
Rune and hexadecimal literals give the right values.
The quantum is what remains:
it is lost across packages, for computed constants,
for multi-name declarations, for negated named constants
and for conversions to a type parameter.

**Work**: add the accessor to `go/constant` and set it in
`MakeFromLiteral`; propagate it in `BinaryOp`/`UnaryOp` for exact
results by the preferred-exponent rules; consume it in the conversion
to decimal types in both `go/types` and `types2`; delete `origLit`
and the export-data string; remove the
`types2/expr.go` rule that demotes typed decimal constant expressions
to values, which `go/types` doesn't have, so the two agree;
add `internal/types/testdata` cases, including cross-package
constants, multi-name declarations, negated named constants
and type parameters.
Fix `T(float64(0.1))` for a type parameter `T`,
which is treated as the literal `0.1`.

### Typed constant comparison — *undecided*

`const a decimal64 = 1.00000000000000001; a == 1` is false at compile time
and true at run time. See [open issue 9](README.md#open-issues).

### Zero value — *undecided*

`var total decimal64; total += 19.99` gives `19.99000000000000`,
because the zero value is `0E-398`.
The formatting in design decision 2 will make that visible.
See [open issue 8](README.md#open-issues).

## Phase 2: Code quality

### Track upstream — *merged, ongoing*

Upstream `master` was merged into the branch on 2026-10-30,
at 5be815fece, so the fork now requires go1.26 to bootstrap.
The branch was merged rather than rebased, and it needs further merges
until the CL series is cut.

### Split into reviewable CLs

The Go project expects small, focused CLs.
The split cannot start until the constant model (Phase 1) has landed,
because it changes the interfaces everything else sits on;
splitting first would mean splitting twice.
The kernel has landed.
The audit's section 7 gives a dependency order
(abi/reflect kinds → runtime kernel → go/constant → type checkers with
testdata → compiler front end → SSA and staticdata → DWARF → x/tools
printf upstream → one CL per standard-library package).
The vector runner `internal/bid/vectors_test.go`
and the ratchet's exception for it are deleted before the series is cut.
A suggested split of the roughly 12,800 non-test lines and their tests:

| CL | Scope | Description |
|----|-------|-------------|
| 1 | Type system | `cmd/compile/internal/types`, `go/types`, `go/ast` — type definitions only |
| 2 | IR and SSA | `cmd/compile/internal/ir`, `ssa/`, `ssacompile/`, `ssagen/` — opcodes and lowering |
| 3 | Kernel | `internal/bid` with its oracle, conformance suite and ratchets; `runtime/decimal64.go`, `decimal128.go`, `decimalconv.go` |
| 4 | Static data | `ir/decimal.go`, `staticdata/`, `noder/`, `escape/` — constant encoding, quantum preservation |
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
`gofmt` still flags `cmd/compile/internal/ir/expr.go`,
`encoding/gob/type.go` and `encoding/xml/read_test.go`.

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
- **Kernel contract**: `internal/bid/doc.go` specifies every operation,
  with worked examples that `TestContractExamples` checks.

### Remaining spec/doc work

- **Review for accuracy.** The spec changes were AI-generated
  and need careful review by someone familiar with the spec's
  precise language and conventions.
  The IEEE clause numbers cited in `internal/bid/doc.go` came from memory,
  because the standard's text was not available,
  and need checking against it.
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
  Test cases exist in `cmd/vet/testdata/printf/printf.go`.
  The change is in the vendored copy of `x/tools`.
- **`go/types`**: Updated with decimal type support,
  including the type checker, assignability rules,
  and constant representability.
  It doesn't yet agree with `cmd/compile` about typed decimal
  constant expressions (see the constant model in Phase 1).

### Remaining tooling work

- **`gopls`.** The `go/types` changes affect gopls,
  which is the primary Go IDE backend.
  Verify that autocomplete, hover info,
  type inference, and diagnostics work correctly
  with decimal types.
- **`x/tools`.** Send the `printf` analyzer change upstream.
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

### Current baseline — *provisional*

Medians from `src/internal/bid/testdata/bench_baseline_darwin_arm64.txt`
in the fork, on an Apple M4 Max:

| Operation | decimal64 | decimal128 | float64 |
|-----------|-----------|------------|---------|
| Add, subtract | 11 ns | 17 ns | 1 ns |
| Multiply | 11 ns | 23 ns | 1 ns |
| Divide | 12 ns | 33 ns | 1 ns |
| Less than | 7 ns | 9 ns | 1 ns |

The baseline was taken at a load average between about 18 and 31,
so the figures indicate magnitude only.
Every row includes a loop floor of about 0.9 ns,
which is nearly all of the `float64` rows.
`TestAllocs` asserts zero allocations for every exported kernel function.
The figures measured on the first implementation are retired;
the audit found them not meaningful.

### Comprehensive benchmarks — *partly done*

`BenchmarkKernel` has 203 rows covering every kernel operation and conversion
at both widths, with `float64` reference rows where the language has a
counterpart.
`TestBenchRatchet` is opt-in and fails a row above the baseline plus 20%
and 0.5 ns, or on any allocation.

**Work**:
- Retake the baseline on a quiet machine and tighten the band to 5%.
- Add the linux/amd64 column, which has not been measured.
  Generated `Add64` showed +9.8% against a width-specific form under Rosetta,
  unexplained, so check it on real hardware.
- Measure what the kernel's benchmarks don't reach:
  operators through the runtime wrappers, `fmt.Sprintf`,
  `strconv` formatting and map operations with decimal keys.

Compare against:
- Intel's BID C library (via cgo shim) — the reference implementation
- `shopspring/decimal` — the most popular Go library
- `cockroachdb/apd` — used in production at scale
- `ericlagergren/decimal` — correctness-focused library

### Profiling and tuning the Go implementation

The kernel has not been profiled or tuned.
Before resorting to assembly,
profile it to identify hot spots
and apply algorithmic improvements:

- **128-bit arithmetic.** decimal128 division, at about 33 ns,
  is the slowest basic operation.
  Profile to determine whether the `u128` and `u256` helpers dominate
  or whether the rounding logic is the bottleneck.
  A shortcut for a zero high word in the 128-bit inexact rounding path
  has been noted and not tried.
- **Inlining.** `roundParts64` is over the inline budget,
  which affects only the exported `Round64`.
- **Branch elimination.** The BID coefficient encoding
  has two forms (small and large coefficient).
  If profiling shows branch misprediction overhead,
  consider branchless implementations.

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

No profile exists yet, so a profile should set the order.
The candidates are `ddiv128` and `dmul128`, then `dadd128`,
then the 64-bit forms and comparison.
Multiplication and division involve widening multiply and normalization,
where architecture-specific `UMULH`/`MUL` pairs can help.

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

`encoding/json/v2` is covered too, since upstream's `jsonv2` experiment
is on by default at the fork's merge base.
`text/template` doesn't compare across widths yet, as the README specifies.

Packages that could be added in follow-up releases:
- `math/rand` (new feature, not a fix)

## Phase 7: Ecosystem

### Database drivers

The `database/sql` package already supports scanning
and converting decimal types, with tests.
It writes the shortest form until the formatting in design decision 2 lands,
so a `NUMERIC(10,2)` column doesn't round-trip its quantum yet.
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
| 0. Fix known bugs | Small | Open — Kind renumbering; 32-bit behaviour unverified |
| 1. IEEE 754 conformance | Medium | Yes — constant model, two open decisions, big-endian run; kernel and conformance gates done |
| 2. Code quality / CL split | Medium | Yes — required for review |
| 3. Spec and docs | Small (review and polish) | Yes — required for release |
| 4. Tooling | Small (mostly verification) | Partially — gopls is blocking |
| 5. Performance | Medium | No — can follow in later releases |
| 6. GOEXPERIMENT rollout | Small | Yes — required for initial release |
| 7. Ecosystem | Ongoing | No — can happen after release |

The critical path is:
**record design decisions** (done 2026-10-27) →
**submit proposal to `golang/proposal` via Gerrit CL** →
**kernel rewrite, gated by the oracle and the conformance suite** (done 2026-10-31) →
**constant model, with the zero-value and typed-comparison decisions** →
**Phase 0 fixes and cross-port build** →
**API reshaped to the design decisions** →
**final merge from upstream** →
**`GOEXPERIMENT` gating and CL split** →
**review cycles with Go team**.
The remaining implementation work can run in parallel with the proposal submission.

Note: The proposal document must be submitted
as `design/19787-decimal.md` in the
[`golang/proposal`](https://github.com/golang/proposal) repository
via a Gerrit CL,
per the [Go proposal process](https://github.com/golang/proposal/blob/master/README.md).
Discussion of substance happens on
[#19787](https://go.dev/issue/19787).
