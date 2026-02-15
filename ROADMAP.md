# Roadmap: from proposal to production

This document outlines the work required to take the decimal64/decimal128
implementation from its current proof-of-concept state
to production-ready code suitable for merging into the Go tree.

## Phase 0: Fix known bugs

These must be resolved before any review process begins.

### Linux bootstrap ICE

The toolchain builds correctly via cross-compilation,
but a native `make.bash` on linux/amd64 panics
when compiling certain standard library packages.
The likely cause is kind-indexed tables
(in `cmd/compile` and `runtime`)
that were not extended for the new decimal type kinds.

**Work**: Reproduce on Linux, identify the panicking table lookups,
add the missing entries, verify `make.bash` completes
and `all.bash` passes.

### `reflect.Value.Call` ABI

Calling a function with decimal arguments
via `reflect.Value.Call` does not work correctly.
The ABI register allocation code in `internal/abi`
does not know about decimal kinds.

**Work**: Extend `internal/abi` register assignment
to handle decimal64 (one integer register)
and decimal128 (two integer registers or stack slot).
Add test cases covering `reflect.Value.Call`
with decimal arguments and return values.

## Phase 1: IEEE 754 conformance

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

### Signaling NaN

The current implementation only handles quiet NaN.
IEEE 754 defines signaling NaN (sNaN),
which should be converted to quiet NaN on first use.
Go's float64 does not expose sNaN either,
so the question is whether decimal types should.
At minimum, the sNaN bit pattern should be representable
via `Decimal64frombits` and handled without crashing.

### Subnormal handling

BID has minimum exponent clamping.
Verify that the behavior at exponent boundaries
matches IEEE 754 precisely.
The `bid64Normalize` and `bid128Normalize` functions
handle this, but they have not been validated
against spec test vectors.

### Rounding modes

The implementation uses round-to-nearest-even throughout.
IEEE 754 defines five rounding modes:
round-to-nearest-even, round-to-nearest-away,
round-toward-positive, round-toward-negative,
and round-toward-zero.

Go's float64 only exposes round-to-nearest-even,
so precedent says that's sufficient.
However, the financial community may want explicit round-half-up.
This is a design question for the Go team.
If additional rounding modes are desired,
they can be added via `math` package functions
(e.g., `Decimal64RoundHalfUp`)
without changing the operators.

## Phase 2: Code quality

### Rebase onto tip

The branch is based on the go1.26 release.
It needs to be rebased onto `master`
(the development branch for the next release).

### Split into reviewable CLs

The Go project expects small, focused CLs.
A suggested split of the ~12,700 lines:

| CL | Scope | Description |
|----|-------|-------------|
| 1 | Type system | `cmd/compile/internal/types`, `go/types`, `go/ast` — type definitions only |
| 2 | IR and SSA | `cmd/compile/internal/ir`, `ssa/`, `ssagen/` — opcodes and lowering |
| 3 | Runtime arithmetic | `runtime/decimal64.go`, `decimal128.go`, `decimalconv.go` |
| 4 | Static data | `staticdata/`, `noder/`, `escape/` — constant encoding, quantum preservation |
| 5 | Compiler wiring | `walk/`, type checker integration, conversions |
| 6 | `strconv` | Parsing and formatting |
| 7 | `fmt` | Verb support, quantum-preserving `#` flag |
| 8 | `math` | Bits/frombits, abs, floor/ceil/round, FMA, quantize, mod |
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
- **Quantum semantics.** The spec should say something about
  trailing-zero preservation in arithmetic,
  since this is a property unique to decimal types
  and not obvious from the IEEE 754 reference alone.
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
- **`go/constant` interaction.** The constant folding bypass
  (needed to preserve quantum) means that `go/constant.BinaryOp`
  is not called for typed decimal expressions.
  Document this interaction clearly
  in the `go/types` or `go/constant` package.

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
These numbers provide a reasonable starting point;
addition, multiplication, and comparison are within 3x of hardware float64.
Division is the main outlier.

### Comprehensive benchmarks

Write benchmarks covering the full operation set:
- Arithmetic: add, sub, mul, div (both 64 and 128)
- Comparison: eq, lt, le
- Formatting: `Sprintf("%g")`, `Sprintf("%#g")`, `AppendDecimal64`
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
| 0. Fix known bugs | Small | Yes — prerequisite for everything |
| 1. IEEE 754 conformance | Large | Yes — correctness gate |
| 2. Code quality / CL split | Medium | Yes — required for review |
| 3. Spec and docs | Small (review and polish) | Yes — required for release |
| 4. Tooling | Small (mostly verification) | Partially — gopls is blocking |
| 5. Performance | Medium | No — can follow in later releases |
| 6. GOEXPERIMENT rollout | Small | Yes — required for initial release |
| 7. Ecosystem | Ongoing | No — can happen after release |

The critical path is:
**submit proposal to `golang/proposal` via Gerrit CL** →
**Linux ICE fix** →
**reflect.Value.Call fix** →
**decTest conformance** →
**rebase onto tip** →
**CL split** →
**spec review** →
**GOEXPERIMENT CL series** →
**review cycles with Go team**.

Note: The proposal document must be submitted
as `design/19787-decimal.md` in the
[`golang/proposal`](https://github.com/golang/proposal) repository
via a Gerrit CL,
per the [Go proposal process](https://github.com/golang/proposal/blob/master/README.md).
Discussion of substance happens on
[#19787](https://go.dev/issue/19787).
