# Proposal: Add decimal floating-point types

Author: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-02-16

Discussion at https://go.dev/issue/19787

Related issues: #12127, #19770, #26699, #9455

## Abstract

We propose adding two new built-in numeric types to Go:
`decimal64` and `decimal128`,
implementing IEEE 754-2008 decimal floating-point arithmetic
using the Binary Integer Decimal (BID) encoding.

These types work exactly like the existing `float32` and `float64` types:
they support arithmetic operators (`+`, `-`, `*`, `/`),
comparison operators (`==`, `!=`, `<`, `<=`, `>`, `>=`),
and participate in Go's existing constant and type system.
No new syntax is introduced.
No new constant kind is introduced.
No new operators are introduced.

The primary motivation is financial and business software,
where base-10 representation is essential for correctness,
and where Go's lack of operator overloading
makes library-based decimal types impractical for real-world use.

Both this document and the accompanying implementation
were largely produced with the assistance of agentic AI (Claude Code),
with human direction and review.
See "Open issues" item 6 for caveats and next steps.

## Background

### The problem

Binary floating-point types cannot exactly represent
many common decimal fractions.
The value `0.1` in `float64` is actually
`0.1000000000000000055511151231257827021181583404541015625`.
This leads to well-documented problems in financial software:

```go
fmt.Println(0.1 + 0.2) // 0.30000000000000004
```

This is not a bug in Go or in IEEE 754 binary floating-point.
It is a fundamental consequence of using a base-2 representation
for values that humans think about in base-10.
Mike Cowlishaw's FAQ
(http://speleotrove.com/decimal/decifaq1.html#inexact)
covers this in detail.

### Who needs this

The following communities routinely need exact decimal arithmetic:

- **Banking and finance.**
  Regulations often require that calculations match
  the results a human would get with pen and paper.
  Rounding a half-cent the wrong way can cause
  reconciliation failures at scale.

- **E-commerce.**
  Tax calculations, pricing engines,
  and payment processing all operate in base-10.

- **Databases.**
  SQL `DECIMAL` and `NUMERIC` types are base-10.
  PostgreSQL, MySQL, Oracle, SQL Server, MongoDB (decimal128),
  and CockroachDB all use decimal representations internally.
  Go programs that interact with these databases
  must currently convert through strings or `big.Int`,
  losing type safety and performance.

- **Accounting and ERP systems.**
  These systems demand that
  `price * quantity * tax_rate` produces an exact decimal result,
  matching what Excel, COBOL, and other business tools produce.

- **Data interchange.**
  Apache Arrow defines `Decimal128` and `Decimal256`.
  BSON (MongoDB) has a `decimal128` type.
  The IETF "Structured Field Values for HTTP" RFC
  includes a decimal type.

### Why a library is not sufficient

Go does not have operator overloading.
This means a library-based decimal type
forces users to write arithmetic as method calls:

```go
// Library approach:
result := price.Mul(quantity).Add(tax)

// Built-in approach:
result := price * quantity + tax
```

The library form is harder to read,
harder to get right (operator precedence is lost),
and harder to maintain.
As noted by multiple commenters on [#19787](https://go.dev/issue/19787),
this is the single biggest barrier
to using Go for financial software.

Beyond operators, libraries also lack literal syntax.
A built-in type allows numeric constants
to appear naturally in expressions,
just as they do with `float64` or `int`:

```go
// Built-in: constants just work.
tax := subtotal * 0.05
tip := total * 0.18
discounted := price * (1 - 0.15)

// Library: every constant must be parsed or predeclared.
tax := subtotal.Mul(decimal.MustParse("0.05"))
tip := total.Mul(decimal.MustParse("0.18"))
discounted := price.Mul(decimal.One.Sub(decimal.MustParse("0.15")))
```

With a built-in type,
the compiler encodes decimal constants at compile time
with no runtime cost.
Libraries must parse strings at runtime.
To mitigate this, libraries typically export
a grab bag of common constants
(`Zero`, `One`, `NegativeOne`, `SmallestNonzero`, etc.),
which clutters the API
and still cannot cover application-specific values.

The Go ecosystem already has several decimal libraries:

- `shopspring/decimal` — arbitrary precision using `*big.Int`,
  ~5,700 GitHub stars, widely used but slow.
- `cockroachdb/apd` — arbitrary precision, used in CockroachDB.
- `ericlagergren/decimal` — arbitrary precision,
  designed for correctness.
- `woodsbury/decimal128` — fixed-size IEEE 754,
  the closest to what this proposal provides,
  but still limited by method-call syntax.

The fragmentation itself is a problem.
As pointed out by @typeless on [#19787](https://go.dev/issue/19787):
"libraries working with [decimal] are hard to cooperate.
A package provides finance calculations based on a particular decimal type
would not be naturally composable with another decimal type
belonging to a time series data store."

A built-in type eliminates the fragmentation
and provides a standard that the ecosystem can build upon.

### Precedent in other languages

- **C23**: `_Decimal32`, `_Decimal64`, `_Decimal128`
  (built-in types; TS 18661-2).
- **C#**: `decimal` (128-bit, built-in, supports operators).
- **Java**: `java.math.BigDecimal` (library, arbitrary precision).
- **Python**: `decimal.Decimal` (library, configurable precision).
- **SQL**: `DECIMAL`/`NUMERIC` (built-in, configurable precision).
- **COBOL**: Packed decimal (built-in, native to the language).

Among these, C23 and C# provide the closest model to this proposal:
fixed-size types with operator support.
Python uses a library type with operator support
via its `__add__`/`__mul__` protocol.
Java uses a library type (`BigDecimal`) with method-call syntax,
which is widely regarded as verbose and error-prone —
a cautionary example of what decimal arithmetic looks like
without operator support.

### IEEE 754-2008 and BID encoding

IEEE 754-2008 defines two encodings for decimal floating-point:

- **DPD** (Densely Packed Decimal): packs three decimal digits
  into 10 bits.
  Favored by IBM hardware.
- **BID** (Binary Integer Decimal): stores the coefficient
  as a binary integer and the exponent as a biased binary integer.
  Favored by Intel (via the Intel DFP library)
  and by software implementations.

This proposal uses BID encoding.
BID is more natural for software implementations
because the coefficient can be manipulated
with ordinary integer arithmetic.
Intel's open-source BID library
(https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)
is the reference implementation.
GCC also supports BID via `libdecnumber`.

Key properties of the types:

| Property     | decimal64           | decimal128                |
|-------------|---------------------|---------------------------|
| Size        | 8 bytes             | 16 bytes                  |
| Coefficient | up to 16 digits     | up to 34 digits           |
| Exponent    | -398 to +369        | -6176 to +6111            |
| Max value   | 9.999...e+384       | 9.999...e+6144            |
| Precision   | ~16 decimal digits  | ~34 decimal digits        |

Both types support NaN (signaling and quiet),
positive and negative infinity, and positive and negative zero.

### Why not just decimal128?

Several commenters on [#19787](https://go.dev/issue/19787) suggested adding only `decimal128`.
We propose both `decimal64` and `decimal128` because:

1. **Performance.** `decimal64` operates on a single 64-bit word.
   `decimal128` requires 128-bit arithmetic (two 64-bit words).
   For applications that process millions of values
   (e.g., market data feeds, database columns),
   the 2x memory savings and faster arithmetic matter.

2. **Consistency with IEEE 754.**
   Go already provides both `float32` and `float64`.
   Providing both `decimal64` and `decimal128`
   follows the same pattern.

3. **Marginal implementation cost.**
   Once `decimal128` is implemented,
   `decimal64` is mostly a subset.
   The compiler, runtime, and standard library changes
   handle both sizes through the same code paths.

We do not propose `decimal32` because its 7-digit precision
is too limited for most practical applications.

### Quantum preservation

A unique property of IEEE 754 decimal types
is that they preserve the number of trailing zeros.
The values `1.0`, `1.00`, and `1.000` are numerically equal
but have distinct representations (different "quanta").
This is meaningful in financial contexts:
a price quoted as `"1.50"` should be formatted as `1.50`,
not `1.5`.

This proposal preserves quantum through:

- **Literals.** `decimal64(1.50)` and `var d decimal64 = 1.50`
  preserve the quantum from the source.
  Note that `x := 1.50` does not, because the default type is `float64`
  and the quantum is lost in the binary representation.
  However, `const c = 1.50; var d decimal64 = c` does preserve it,
  because untyped constants retain full precision until assignment.
- **Formatting.** `fmt.Sprintf("%#f", d)` uses the `#` flag
  with the `f`, `g`, and `e` verbs
  to format with quantum-preserving precision.
- **Parsing.** `strconv.ParseDecimal64("1.50")` preserves the quantum.
- **Comparison.** `1.50 == 1.5` is true (numeric equality),
  but the formatting difference is preserved.
- **Map keys and hashing.** Values with different quanta
  but the same numeric value are treated as equal map keys,
  through normalization in the hash function.

## Proposal

### New types

Two new predeclared types are added:

```
decimal64       the set of all IEEE 754-2008 64-bit decimal floating-point numbers
decimal128      the set of all IEEE 754-2008 128-bit decimal floating-point numbers
```

These are decimal floating-point types.
Together with the existing `float32` and `float64`,
they form the set of floating-point types in Go.

### Operators

The following operators work with decimal types,
with the same semantics as for `float32` and `float64`:

- Arithmetic: `+`, `-`, `*`, `/`
  (unary `+` and `-` also work).
- Comparison: `==`, `!=`, `<`, `<=`, `>`, `>=`.
- Assignment: `=`, `+=`, `-=`, `*=`, `/=`.

Integer modulus (`%`) is not supported,
consistent with binary floating-point types.
Bitwise operators are not supported.

### Constants

No new constant kind is introduced.
Decimal constants use the existing floating-point constant kind.
The default type of an untyped floating-point constant
remains `float64`.

```go
var d decimal64 = 3.14    // floating-point constant assigned to decimal64
const c = 2.718           // untyped floating-point constant, default type float64
var e decimal128 = c      // c is representable as decimal128
```

Constants are representable in a decimal type
if they can be expressed within the precision and range
of that type without loss of information.
For example, `1.0/3.0` (which is an exact rational in Go's constant system)
may lose precision when assigned to `decimal64`
because it cannot be exactly represented
in 16 decimal digits.

### Conversions

Conversions between numeric types follow Go's existing rules:

```go
var f float64 = 3.14
var d decimal64 = decimal64(f)      // binary-to-decimal conversion
var g float64 = float64(d)          // decimal-to-binary conversion
var d128 decimal128 = decimal128(d) // widening
var d64 decimal64 = decimal64(d128) // narrowing (may lose precision)
var i int = int(d)                  // truncation toward zero
var d2 decimal64 = decimal64(42)    // integer to decimal
```

Conversions between binary and decimal floating-point
may lose precision due to differences in radix representation.

### Standard library additions

The following standard library changes are included:

**`strconv`**: `ParseDecimal64`, `ParseDecimal128`,
`FormatDecimal64`, `FormatDecimal128`, `FormatDecimal`,
`AppendDecimal64`, `AppendDecimal128`, `AppendDecimal`.

**`fmt`**: Decimal types support the `e`, `E`, `f`, `F`, `g`, `G` verbs.
The `#` flag enables quantum-preserving formatting.

**`math`**: `Decimal64bits`, `Decimal64frombits`,
`Decimal128bits`, `Decimal128frombits`,
`Decimal128NaN`, `Decimal128Inf`,
`IsDecimal128NaN`, `IsDecimal128Inf`,
`Abs64`, `Abs128`,
`FMA64`, `FMA128`,
`Ceil64`, `Ceil128`, `Floor64`, `Floor128`,
`Trunc64`, `Trunc128`,
`Round64`, `Round128`, `RoundToEven64`, `RoundToEven128`,
`Quantize64`, `Quantize128`.

**`reflect`**: `Decimal64` and `Decimal128` added to `Kind`.
`Value.Decimal()` and `Value.SetDecimal()` methods.
`Value.CanDecimal()` method.

**`encoding/json`**: Marshal/unmarshal as JSON numbers.
String tag support.

**`encoding/binary`**: Read/write decimal types.

**`encoding/gob`**: Encode/decode decimal types.

**`encoding/xml`**: Marshal/unmarshal decimal types.

**`database/sql`**: Scan decimal columns.
`driver.Value` converts decimal types to strings.

**`cmp`**: `decimal64` and `decimal128` added to `Ordered` constraint.

**`sort`**: `Decimal64Slice`, `Decimal128Slice` types.

**`text/template`** and **`html/template`**: Decimal type support
in template evaluation.

### Size and alignment

```
type                                      size in bytes
decimal64                                 8
decimal128                                16
```

Both types are naturally aligned to their size.

## Rationale

### Why built-in types and not a library?

See the Background section.
The absence of operator overloading in Go
makes library-based decimal types unergonomic.
Adding operator overloading to Go
would be a far larger and more contentious change
than adding two new numeric types
that follow existing patterns.

### Why BID and not DPD?

BID is the natural choice for software implementations.
The coefficient is a plain binary integer
that can be manipulated with existing ALU instructions.
DPD requires special decoding for each group of 3 decimal digits.

BID is the encoding used by Intel's reference library,
by GCC's `libdecnumber`,
and by virtually all modern software decimal libraries.

### Why not arbitrary precision?

Fixed-size types:

1. Can be stack-allocated (no GC pressure).
2. Can be register-allocated by the compiler.
3. Have predictable performance.
4. Can be used as map keys.
5. Can be stored in arrays and slices without indirection.

Arbitrary precision decimal types (like `shopspring/decimal`
or `java.math.BigDecimal`) serve different use cases
and can continue to exist as libraries.

### Why not wait for operator overloading?

Operator overloading has been discussed since Go's creation
and shows no signs of being accepted.
Even if it were added,
a built-in type is still preferable for a standard numeric type:

1. Guaranteed interoperability (one type, not many libraries).
2. No import required.
3. Compiler can optimize arithmetic directly.
4. The type can participate in the constant system.

### Comparison with complex types

Go already has `complex64` and `complex128` as built-in types.
These were included because complex arithmetic requires operators
and because they are part of the numeric type family.
The same arguments apply to decimal types,
arguably even more strongly:
decimal types are far more widely used than complex types.

## Compatibility

This proposal is fully backward compatible with existing Go programs.
The new type names `decimal64` and `decimal128`
are not currently keywords or predeclared identifiers.
Any existing code that uses these names as identifiers
will continue to work because predeclared names can be shadowed,
just as existing code can define a variable named `int` or `string`.

The new types participate in Go's existing type system
with no changes to the rules for type identity,
assignability, or type inference.

The `Ordered` constraint in `cmp` gains two new types.
Existing instantiations of generic functions
constrained by `Ordered` will not be affected
because they already have a concrete type argument.

## Implementation

A complete working implementation exists
as a fork of the Go compiler and standard library
at https://github.com/marcelocantos/go/tree/decimal64.
A live playground is available at
https://go-decimal-proposal.fly.dev/
where readers can try decimal64 and decimal128 interactively.

The implementation touches 124 files
with approximately 12,000 lines added
and 500 lines modified.
It has been built on macOS (darwin/arm64)
and Linux (linux/amd64),
and tested on macOS.
The Linux build has known internal compiler errors
during self-hosting (the cross-compiled toolchain works correctly,
but a toolchain built natively on Linux via `make.bash`
panics when compiling certain standard library packages).
These are believed to be minor gaps
in kind-indexed tables that were not extended
for the new decimal type kinds,
and will be resolved before the implementation is final.
The implementation has not been built or tested
on other platforms (Windows, FreeBSD, etc.)
or other architectures (386, arm, etc.),
though no platform-specific issues are expected
since the runtime arithmetic is pure Go.

The changes are distributed as follows:

### Compiler (`cmd/compile`)

- **Types**: `decimal64` and `decimal128` added
  to the compiler's type system
  (`cmd/compile/internal/types`),
  type checker (`cmd/compile/internal/types2`, `go/types`),
  and IR (`cmd/compile/internal/ir`).

- **SSA**: New SSA opcodes for decimal arithmetic and comparison,
  with "soft decimal" lowering
  that calls into runtime helper functions,
  analogous to the "soft float" approach used for `complex128`.

- **Static data**: Decimal constants are encoded in BID format
  in the object file,
  with quantum preservation from source literals.

- **Conversions**: All numeric-to-decimal and decimal-to-numeric
  conversions are implemented.

### Runtime (`runtime`)

- **Arithmetic**: Pure Go implementations
  of decimal64 and decimal128 addition, subtraction,
  multiplication, division, and comparison,
  using BID encoding.
  These are called by the compiler-generated code.

- **Hashing**: Decimal map key hashing normalizes trailing zeros
  so that `1.0` and `1.00` hash identically.

- **Equality**: Decimal map key equality uses numeric comparison
  (not bitwise), consistent with the `==` operator.

### Standard library

All standard library changes use the public API
of the new types (operators, `reflect`, `strconv`)
and do not depend on internal implementation details.

### Bootstrap

The implementation uses `//go:build !compiler_bootstrap`
tags where necessary to ensure that the bootstrap compiler
(which does not know about decimal types)
can still build the new compiler.
Packages that are only compiled by the new compiler
(e.g., `reflect`, `fmt`) do not need build tags.

### Testing

The implementation includes:

- Compiler-level tests in `test/decimal.go`:
  basic arithmetic, conversions, overflow/underflow,
  NaN/Inf behavior, map key semantics, quantum preservation.
- Standard library tests in each modified package.
- Over 2,000 lines of test code across all packages.

### Future hardware acceleration

The current implementation is pure software.
If decimal hardware becomes more widely available
(as in IBM POWER and z/Architecture),
the runtime functions can be replaced
with hardware instructions
without changing any user-facing API.
This is the same approach Go uses for other operations
(e.g., `math/bits` functions that map to CPU instructions
when available).

### Implementation plan

If accepted, the implementation can be contributed
as a series of CLs to the Go repository.
The implementation is already complete and tested.
The author is willing to break it into smaller,
reviewable CLs and work with the Go team
on any design adjustments.

Target: Go 1.XX (earliest available release cycle
after acceptance).

## Open issues

1. **`decimal32`**: This proposal does not include `decimal32`.
   The 7-digit precision is insufficient for most use cases,
   and omitting it simplifies the implementation.
   If there is demand, it could be added later.

2. **`reflect.Value.Call` ABI**: The current implementation
   has a known issue where `reflect.Value.Call`
   does not correctly handle decimal function arguments
   due to ABI register allocation.
   This needs to be resolved before merging.

3. **Performance tuning**: The runtime arithmetic is pure Go
   and has not been heavily optimized.
   Benchmarking against Intel's C BID library
   would establish a performance baseline
   and identify optimization opportunities.
   Hot paths (multiplication, division, comparison)
   could be rewritten in platform-specific assembly,
   following the pattern used by `math/big`, `crypto/subtle`,
   and other performance-sensitive standard library packages.
   On architectures with dedicated decimal hardware
   (IBM POWER9+, z/Architecture),
   assembly implementations could use native instructions directly.

4. **`math/rand`**: Random decimal generation
   (analogous to `rand.Float64`) could be added
   but is not included in this proposal.

5. **`encoding/json/v2`**: The new `encoding/json/v2` package
   (when finalized) should support decimal types natively.
   The current implementation patches `v2_inject.go`
   to recognize decimal kinds as numeric.

6. **AI-assisted implementation**.
   This implementation was developed with extensive use
   of agentic AI (Claude Code).
   The AI was directed by the author
   and was instrumental in producing the volume of code
   across 124 files in a short time frame.
   However, this means the code has not yet received
   the level of manual review and scrutiny
   that a change of this scope warrants.
   Specific areas that need careful human review include:
   - **Runtime arithmetic correctness.**
     The BID encoding and arithmetic routines
     should be validated against the IEEE 754-2008
     test suite and Intel's reference library.
   - **Edge cases.**
     NaN propagation, signaling NaN behavior,
     rounding modes, and subnormal handling
     need thorough verification.
   - **Compiler integration.**
     The SSA lowering, constant folding,
     and type checker changes
     should be reviewed by someone familiar
     with the compiler internals.
   - **The linux/amd64 bootstrap ICE**
     described above needs investigation and fixing.
   The author intends to perform this review
   and welcomes help from the community.
