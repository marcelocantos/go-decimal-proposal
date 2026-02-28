# Proposal: Add decimal floating-point types

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Design document: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-02-28

Discussion at [#19787](https://go.dev/issue/19787)

Related issues: [#12127](https://go.dev/issue/12127), [#19770](https://go.dev/issue/19770), [#26699](https://go.dev/issue/26699), [#9455](https://go.dev/issue/9455)

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
with human direction but no detailed human review of the generated code.
See ["Open issues" item 6](#open-issues) for caveats and next steps.
If legal restrictions prevent AI-generated code from being contributed to Go,
the author is in a position to produce a clean-room implementation,
though not necessarily with the capacity or inclination
to single-handedly take on a project of this scope.

**Try it now:** A [live playground](https://go-decimal-proposal.fly.dev/)
is available for interactive experimentation with `decimal64` and `decimal128`.

**Reading guide:**
This is a long document. Depending on your interest:

- **"Show me what it looks like"** — read [Examples](#examples).
- **"Why not just use a library?"** — read [Why a library is not sufficient](#why-a-library-is-not-sufficient).
- **"What breaks?"** — read [Compatibility](#compatibility).
- **"How real is the implementation?"** — read [Implementation](#implementation) and the [Roadmap](ROADMAP.md).
- **"What's the spec impact?"** — read [Language spec changes](#language-spec-changes).

## Contents

- [Links](#links)
- [Language change questionnaire](#language-change-questionnaire)
- [Background](#background)
- [Proposal](#proposal)
- [Examples](#examples)
- [Rationale](#rationale)
- [Compatibility](#compatibility)
- [Implementation](#implementation)
- [Open issues](#open-issues)
- [Acknowledgements](#acknowledgements)

## Links

- **Proposal discussion**: https://go.dev/issue/19787
- **Implementation**: https://github.com/marcelocantos/go/tree/decimal64
- **This document**: https://github.com/marcelocantos/go-decimal-proposal
- **IEEE 754-2008**: https://standards.ieee.org/ieee/754/6210/
- **Intel DFP library**: https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html
- **Cowlishaw decimal FAQ**: http://speleotrove.com/decimal/decifaq1.html
- **Roadmap**: [ROADMAP.md](ROADMAP.md) — post-acceptance work required for production readiness

## Language change questionnaire

Per the [Go 2 language change template](https://github.com/golang/proposal/blob/master/go2-language-changes.md):

- **Would you consider yourself a novice, intermediate, or experienced Go programmer?**
  Experienced. Over ten years of active use,
  including championing adoption of Go
  at a major financial institution.

- **What other languages do you have experience with?**
  C/C++, Java, Python, C#, F#, JS/TS, Basic (many flavors),
  OCaml, Perl, Objective-C/C++, Pascal,
  Assembly (Z-80, x86, ARM), Erlang, HTML.

- **Would this change make Go easier or harder to learn, and why?**
  Marginally harder: two new predeclared type names to learn.
  In practice, developers who don't need decimal types
  can ignore them entirely,
  just as most Go programmers never use `complex64` or `complex128`.
  Developers who do need decimal arithmetic
  will find the types immediately familiar —
  they work exactly like `float64` with operators and constants.

- **Has this idea, or one like it, been proposed before?
  If so, how does this proposal differ?**
  Yes. [#19787](https://go.dev/issue/19787) (2017) proposed decimal types
  but had no implementation.
  [#12127](https://go.dev/issue/12127) proposed a `math/big.Decimal` library type.
  [#19770](https://go.dev/issue/19770) requested operator overloading
  specifically to enable decimal libraries.
  This proposal differs by providing a complete, tested implementation
  (129 files, ~12,000 lines) with a working playground,
  and by proposing built-in types rather than a library.

- **Who does this proposal help, and why?**
  Developers building financial, e-commerce, accounting,
  and database-backed software — see [Who needs this](#who-needs-this).
  Over 40,000 Go packages already depend on third-party decimal libraries,
  and many more use integer-cents workarounds.

- **What is the proposed change?**
  Two new predeclared types (`decimal64`, `decimal128`)
  with the same operator set as `float64`.
  See [Proposal](#proposal) for the precise specification
  and [Language spec changes](#language-spec-changes) for verbatim spec text.

- **Is this change backward compatible?**
  Yes. See [Compatibility](#compatibility).
  The new names are predeclared identifiers (not keywords)
  and can be shadowed, like `int` or `string`.

- **Show example code before and after the change.**

  Before (library):
  ```go
  total := price.Mul(qty).Mul(decimal.NewFromInt(1).Add(taxRate))
  ```
  After (built-in):
  ```go
  total := price * qty * (1 + taxRate)
  ```
  See [Examples](#examples) and [Why a library is not sufficient](#why-a-library-is-not-sufficient)
  for more detailed comparisons.

- **What is the cost of this proposal?**
  - **Tools affected:** `go vet` (printf analyzer — already done),
    `gopls` (type support — needs verification),
    `go/types` (already done).
    Third-party tools that exhaustively switch on `reflect.Kind`
    or `go/types.BasicKind` will need updates;
    see the [roadmap](ROADMAP.md) for details.
  - **Compile time cost:** Negligible.
    Two new type entries in the compiler's type system.
    Decimal constant evaluation uses runtime BID arithmetic
    rather than `go/constant`, but this only applies
    to the rare typed decimal constant expressions.
  - **Run time cost:** Zero for programs that don't use decimal types.
    For programs that do, see [Performance](#performance):
    addition, multiplication, and comparison are 2–3x slower
    than hardware float64; division is 13x slower.
    All operations are zero-allocation.
  - **Execution:** The implementation is complete but needs
    IEEE 754 conformance testing against the decTest suite,
    a rebase onto master, splitting into reviewable CLs,
    and a `GOEXPERIMENT=decimal` gating pass.
    See the [roadmap](ROADMAP.md) for the full plan.

- **Can you describe a possible implementation?
  Do you have a prototype?**
  A complete implementation exists — not just a prototype.
  It spans 129 files with ~12,000 lines added and ~500 modified,
  covering the compiler (type system, SSA, constant folding),
  runtime (BID arithmetic, hashing, equality),
  and 18+ standard library packages
  (`strconv`, `fmt`, `math`, `reflect`,
  `encoding/json`, `encoding/binary`, `encoding/gob`, `encoding/xml`,
  `database/sql`, `debug/dwarf`, `go/types`, `hash/maphash`,
  `cmp`, `sort`, `testing/quick`,
  `text/template`, and others).
  It includes over 3,500 lines of tests.
  A [live playground](https://go-decimal-proposal.fly.dev/)
  is available for interactive experimentation.
  See [Implementation](#implementation) for details.

- **Orthogonality: how does this change interact or overlap
  with existing features?**
  See [Interaction with other language features](#interaction-with-other-language-features).
  Decimal types participate in type switches, generic constraints,
  `reflect`, `unsafe.Sizeof`, and `go/constant`
  with no special cases beyond what `complex128` already requires.

- **Is the goal of this change a performance improvement?**
  No. The goal is correctness for base-10 arithmetic.
  See [Performance](#performance) for benchmark data.

- **Does this affect error handling?**
  No.

- **Is this about generics?**
  No, though `decimal64` and `decimal128` are added
  to the `cmp.Ordered` constraint,
  which is a natural consequence of being ordered types.

## Background

### The problem

Binary floating-point types cannot exactly represent
many common decimal fractions.
The value `0.1` in `float64` is actually
`0.1000000000000000055511151231257827021181583404541015625`.
This leads to well-documented problems in financial software:

```go
a, b := 0.1, 0.2
fmt.Println(a + b) // 0.30000000000000004
```

This is not a bug in Go or in IEEE 754 binary floating-point.
It is a fundamental consequence of using a base-2 representation
for values that humans think about in base-10.
[Mike Cowlishaw's FAQ](http://speleotrove.com/decimal/decifaq1.html#inexact)
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
  [Apache Arrow](https://arrow.apache.org/docs/format/Columnar.html#decimal) defines `Decimal128` and `Decimal256`.
  [BSON](https://bsonspec.org/spec.html) (MongoDB) has a `decimal128` type.
  The IETF ["Structured Field Values for HTTP" (RFC 8941)](https://www.rfc-editor.org/rfc/rfc8941)
  includes a decimal type.

The demand is not hypothetical.
[`shopspring/decimal`](https://github.com/shopspring/decimal)
alone is imported by over 38,000 packages on pkg.go.dev,
placing it in the top 0.1% of all Go packages by dependents.
Across the major decimal libraries
(`shopspring/decimal`, `cockroachdb/apd`, `ericlagergren/decimal`,
and others), more than 40,000 packages depend on third-party
decimal implementations.
The original language proposal
([#19787](https://go.dev/issue/19787))
has 164 thumbs-up reactions and 41 comments,
reflecting long-standing community demand.
According to the
[2025 Go Developer Survey](https://go.dev/blog/survey2025),
13% of Go developers work in financial services —
the sector where decimal arithmetic is most critical.

These numbers likely understate the true demand.
Many Go developers avoid decimal libraries entirely
and instead store money as `int64` cents —
a workaround that is pervasive in blog posts,
forum answers, and community guides.
Libraries like [`Rhymond/go-money`](https://github.com/Rhymond/go-money)
(1,900 stars) and [`robaho/fixed`](https://github.com/robaho/fixed)
(350 stars) exist specifically to formalize this pattern.
The Stripe Go SDK uses `int64` cents for all monetary amounts,
setting a widely followed industry precedent.
These developers need decimal arithmetic
but have concluded that the ergonomic and performance costs
of library-based decimals are too high,
so they accept the limitations of integer workarounds instead
(no sub-cent precision, manual scaling, currency-dependent logic).
A built-in decimal type with operators and constants
would let these developers express their intent directly,
without workarounds.

### Why a library is not sufficient

Go does not have operator overloading.
This means a library-based decimal type
forces users to write arithmetic as method calls.
Consider a common financial operation —
computing an invoice line with tax and discount:

```go
// With this proposal:
func invoiceLine(price, qty, taxRate, discount decimal64) decimal64 {
    subtotal := price * qty
    discounted := subtotal * (1 - discount)
    tax := discounted * taxRate
    return discounted + tax
}
```

```go
// With shopspring/decimal today:
func invoiceLine(price, qty, taxRate, discount decimal.Decimal) decimal.Decimal {
    subtotal := price.Mul(qty)
    discounted := subtotal.Mul(decimal.NewFromInt(1).Sub(discount))
    tax := discounted.Mul(taxRate)
    return discounted.Add(tax)
}
```

The library form is harder to read,
harder to get right (operator precedence is lost in method chains),
and harder to maintain.
Arithmetic that a junior developer can verify at a glance
with operators requires careful left-to-right tracing
with method calls,
and a missed parenthesis silently changes the result
rather than producing a compilation error.
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

- [`shopspring/decimal`](https://github.com/shopspring/decimal) — arbitrary precision using `*big.Int`,
  ~7,200 GitHub stars, widely used but slow.
- [`cockroachdb/apd`](https://github.com/cockroachdb/apd) — arbitrary precision, used in CockroachDB.
- [`ericlagergren/decimal`](https://github.com/ericlagergren/decimal) — arbitrary precision,
  designed for correctness.
- [`woodsbury/decimal128`](https://github.com/woodsbury/decimal128) — fixed-size IEEE 754,
  the closest to what this proposal provides,
  but still limited by method-call syntax.

The fragmentation itself is a problem.
As pointed out by [@typeless](https://github.com/typeless) on [#19787](https://go.dev/issue/19787):
"libraries working with [decimal] are hard to cooperate.
A package provides finance calculations based on a particular decimal type
would not be naturally composable with another decimal type
belonging to a time series data store."

A built-in type eliminates the fragmentation
and provides a standard that the ecosystem can build upon.

### Precedent in other languages

**C23** added `_Decimal32`, `_Decimal64`, and `_Decimal128`
as built-in types (TS 18661-2).
These are the closest precedent to this proposal:
fixed-size, IEEE 754-2008, operator support,
and part of the core language rather than a library.
C23 uses the same BID/DPD encoding choice as this proposal
(implementation-defined, but Intel's BID is dominant in practice).
The key difference is that C23 supports all five IEEE 754 rounding modes
via `fesetround()`, while this proposal follows Go's float64 precedent
of using round-to-nearest-even only.

**C#** has a built-in `decimal` type (128-bit, 28–29 significant digits)
with full operator support.
It is the success story for built-in decimal types:
widely used in finance, e-commerce, and business applications.
C#'s `decimal` is not IEEE 754 —
it uses a custom representation (96-bit integer + scale factor)
with a different exponent range than IEEE 754 decimal128.
This proposal's use of IEEE 754 provides better interoperability
with databases, wire formats, and other languages.

**Java** has `java.math.BigDecimal` (arbitrary precision, library type).
It is widely regarded as verbose and error-prone
due to method-call syntax:
`a.multiply(b).add(c.multiply(d))` instead of `a*b + c*d`.
Java's `BigDecimal` is a cautionary example
of what decimal arithmetic looks like without operator support,
and is the situation Go users currently face
with `shopspring/decimal`.

**Python** has `decimal.Decimal` (library type, configurable precision).
Python's operator overloading makes it ergonomic (`a * b + c`),
but the type is not built-in:
it requires an import and explicit construction from strings
(`Decimal("0.1")` rather than a literal).
Python's approach works well for Python
but is not available to Go
due to the absence of operator overloading.

**SQL** defines `DECIMAL`/`NUMERIC` as built-in types
with configurable precision and scale.
Every major database engine implements these natively.
Go programs that interact with SQL databases
must currently round-trip decimal values through strings;
built-in decimal types would allow direct scanning.

**COBOL** has packed decimal as a core data type,
reflecting its origin in business computing.
COBOL remains dominant in financial systems
in part because decimal arithmetic is first-class.

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
[Intel's open-source BID library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)
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

Crucially, quantum is not merely preserved through storage;
it follows IEEE 754 rules through arithmetic.
Multiplication adds the quanta of the operands:
`decimal64(1.50) * decimal64(1.20)` produces `1.8000`
(two decimal places + two decimal places = four decimal places).
Addition takes the maximum quantum (finest scale) of the operands:
`decimal64(1.5) + decimal64(0.10)` produces `1.60`
(one decimal place promoted to two to match the finer operand).
This means that financial expressions like
`unit_price * quantity`
naturally produce results with the expected number of decimal places,
without the programmer having to manage rounding manually.

### What does success look like?

This proposal succeeds if:

- Financial and business Go code can use `decimal64` and `decimal128`
  with the same ease and fluency as `float64`,
  using operators, constants, and standard formatting.
- Database drivers map SQL `DECIMAL`/`NUMERIC` columns
  to native Go types, eliminating string round-trips.
- JSON APIs can round-trip decimal numbers without precision loss.
- The ecosystem converges on the built-in types,
  reducing fragmentation across `shopspring/decimal`,
  `cockroachdb/apd`, and other libraries.
- Above all, Go becomes a natural choice for financial software,
  alongside C#, COBOL, and SQL,
  rather than an outlier that requires workarounds.
  Today, teams building financial systems in Go
  must accept awkward ergonomics or choose another language.
  Built-in decimal types remove that barrier.

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

The `%`, bitwise, and shift operators are not supported,
consistent with binary floating-point types.

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
See [open issue 7](#open-issues) regarding `decimal128`
as a lossless default for JSON number decoding.

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

### Interaction with other language features

**Type switches and type assertions.**
Decimal types work in type switches and type assertions
like any other concrete type:

```go
switch v := x.(type) {
case decimal64:
    fmt.Println(v + 1)
case decimal128:
    fmt.Println(v + 1)
}
```

**Generic constraints.**
`decimal64` and `decimal128` satisfy the `cmp.Ordered` constraint
and can be used with any generic function
constrained to ordered or numeric types.
Custom constraints can include decimal types:

```go
type Decimal interface {
    decimal64 | decimal128
}
```

**`unsafe.Sizeof`.**
Returns 8 for `decimal64` and 16 for `decimal128`,
consistent with their fixed-size representations.

**`go/constant`.**
Decimal constants use the existing `constant.Float` kind.
The constant system's arbitrary-precision rationals
are converted to BID encoding
when assigned to a decimal variable.
Typed decimal constant expressions are evaluated
by the compiler using the runtime's BID arithmetic
(not `go/constant.BinaryOp`)
in order to preserve quantum through constant folding.

**`reflect.DeepEqual`.**
Uses numeric comparison, not bitwise comparison,
so `decimal64(1.0)` and `decimal64(1.00)` are DeepEqual
despite having different bit representations.

### Language spec changes

The following changes to the
[Go language specification](https://go.dev/ref/spec)
are required. These are already implemented
in the [fork](https://github.com/marcelocantos/go/tree/decimal64).

**Numeric types.** Add after the `float32`/`float64` entries:

> ```
> decimal64   the set of all IEEE 754-2008 64-bit decimal floating-point numbers
> decimal128  the set of all IEEE 754-2008 128-bit decimal floating-point numbers
> ```
>
> The types `float32` and `float64` are binary floating-point types
> that use a base-2 representation.
> The types `decimal64` and `decimal128` are decimal floating-point types
> that use a base-10 representation (Binary Integer Decimal encoding)
> as defined by IEEE 754-2008.
> Decimal floating-point types can represent decimal fractions exactly,
> unlike binary floating-point types
> where values such as 0.1 have no exact representation.
> Both binary and decimal floating-point types
> support the same arithmetic and comparison operators.

**Predeclared identifiers.** Add to the Types line:

> ```
> complex64 complex128 decimal64 decimal128 error float32 float64
> ```

**Representability.** Add to the examples table:

> ```
> 1.23                decimal64   1.23 is in the set of decimal64 values
> ```

**Comparison operators.** Add after the floating-point bullet:

> Decimal floating-point types are comparable and ordered.
> Two decimal floating-point values are compared
> as defined by the IEEE 754-2008 standard.

**Conversions between numeric types.** Add:

> When converting between binary floating-point types
> (`float32`, `float64`)
> and decimal floating-point types
> (`decimal64`, `decimal128`),
> the result is rounded to the precision of the destination type.
> Such conversions may lose precision
> due to differences in radix representation;
> for example, the decimal value 0.1
> has no exact binary floating-point representation.

**Size and alignment guarantees.** Update the table:

> ```
> uint64, int64, float64, complex64, decimal64     8
> complex128, decimal128                           16
> ```

## Examples

These examples can be run on the
[live playground](https://go-decimal-proposal.fly.dev/).

### The 0.1 + 0.2 problem

```go
a, b := 0.1, 0.2
fmt.Println("Binary: ", a+b)   // 0.30000000000000004

da, db := decimal64(0.1), decimal64(0.2)
fmt.Println("Decimal:", da+db) // 0.3
```

### Invoice calculation

```go
type LineItem struct {
    Description string
    Price       decimal64
    Quantity    decimal64
}

items := []LineItem{
    {"Widget A", 19.99, 3},
    {"Widget B", 4.50, 12},
    {"Shipping", 7.95, 1},
}

taxRate := decimal64(0.0825)
var subtotal decimal64
for _, item := range items {
    subtotal += item.Price * item.Quantity
}
tax := subtotal * taxRate
total := subtotal + tax

fmt.Printf("Subtotal: $%#6.2f\n", subtotal) // $121.92
fmt.Printf("Tax:      $%#6.2f\n", tax)      // $ 10.06
fmt.Printf("Total:    $%#6.2f\n", total)     // $131.98
```

Note that the struct literal uses ordinary numeric constants
(`19.99`, `3`, `4.50`).
No string parsing, no constructor functions,
no special constant declarations.

### Currency conversion

```go
usdToEur := decimal64(0.92)
usdToGbp := decimal64(0.79)
amount := decimal64(1000.00)

fmt.Printf("$%#.2f = €%#.2f\n", amount, amount*usdToEur) // €920.00
fmt.Printf("$%#.2f = £%#.2f\n", amount, amount*usdToGbp) // £790.00
```

### Quantum preservation

```go
price := decimal64(29.90)
qty := decimal64(3)
result := price * qty

fmt.Printf("Price:  %#g\n", price)  // 29.90
fmt.Printf("Qty:    %#g\n", qty)    // 3
fmt.Printf("Total:  %#g\n", result) // 89.70
```

Multiplication adds the quanta of the operands:
`29.90` (2 decimal places) times `3` (0 decimal places)
produces `89.70` (2 decimal places),
without any explicit rounding or formatting.

## Rationale

### Why built-in types and not a library?

See the [Background](#background) section.
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

This proposal does not break any existing Go program at the source level.
No existing valid program will fail to compile.

**Predeclared identifiers.**
The new type names `decimal64` and `decimal128`
will be added as predeclared identifiers,
not as keywords.
Like all predeclared names in Go,
they can be shadowed by user-defined identifiers,
so any existing code that happens to use these names
will continue to compile and behave as before,
just as existing code can define a variable named `int` or `string`.
Access to the new types is gated by the `go` directive in `go.mod`,
following the precedent set by `any` and `comparable` in Go 1.18.

**Type system.**
The new types participate in Go's existing type system
with no changes to the rules for type identity,
assignability, or type inference.
The `Ordered` constraint in `cmp` gains two new types.
Existing instantiations of generic functions
constrained by `Ordered` will not be affected
because they already have a concrete type argument.

**`reflect.Kind`.**
This proposal adds two new `reflect.Kind` values:
`Decimal64` and `Decimal128`.
No new Kind value has been added since Go 1.0,
so this is unprecedented,
but the Go team has explicitly acknowledged
that Kind growth is a legitimate future event
(see [#38831](https://go.dev/issue/38831),
where Rob Pike noted that
"code depending on Kind already must change
when new Kinds are added").

Code that switches on `reflect.Kind` with a `default` case
will handle the new kinds correctly.
Code that uses `reflect.Kind` values as array indices
(e.g., `[reflect.UnsafePointer + 1]T`)
or that exhaustively matches all known kinds without a `default`
may panic or silently mishandle decimal values at runtime.
This is a soft compatibility concern, not a compilation break.

The `GOEXPERIMENT=decimal` rollout plan
(one release behind a flag before default-on)
gives library and tool authors a full release cycle
to audit their Kind switches before the new values
appear in default builds.

**`go/types.BasicKind`.**
Similarly, `go/types` gains two new `BasicKind` values.
This affects tools that use `go/types` for static analysis.
Well-written tools that use a `default` case are unaffected.

**`encoding/gob`.**
The `encoding/gob` wire format was explicitly designed
for expansion: it has reserved type IDs
and a `firstUserId` gap that accommodates new built-in types
without breaking existing encoded streams.

## Implementation

A complete working implementation exists
as a fork of the Go compiler and standard library
at [marcelocantos/go (decimal64 branch)](https://github.com/marcelocantos/go/tree/decimal64).
A [live playground](https://go-decimal-proposal.fly.dev/)
is available where readers can try decimal64 and decimal128 interactively.

The implementation touches 129 files
with approximately 12,000 lines added
and 500 lines modified.
It has been built and tested on macOS (darwin/arm64),
where the full test suite (`all.bash`) passes.
The implementation has not yet been built or tested
on Linux (linux/amd64) or other platforms
(Windows, FreeBSD, etc.),
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
- Over 3,500 lines of test code across all packages.

### Performance

The implementation is pure Go with no assembly fast paths.
Preliminary benchmarks on Apple M4 Max (arm64):

| Operation | decimal64 | float64 | Ratio |
|-----------|-----------|---------|-------|
| Add       | 5.0 ns    | 1.7 ns  | 3x    |
| Multiply  | 4.9 ns    | 1.7 ns  | 3x    |
| Divide    | 20.5 ns   | 1.6 ns  | 13x   |
| Compare   | 3.3 ns    | 1.6 ns  | 2x    |
| Sprintf   | 50 ns     | 49 ns   | 1x    |

Addition, multiplication, and comparison are 2–3x slower
than hardware float64, which is reasonable
for a pure software implementation
doing base-10 coefficient arithmetic.
Division is more expensive (13x)
because it requires iterative quotient computation
with BID renormalization.
Formatting is equivalent to float64.

All operations are zero-allocation
and operate on register-sized values (8 bytes for decimal64),
so the overhead is bounded and predictable.
For comparison, library-based decimal types
typically allocate on every arithmetic operation
(`shopspring/decimal` uses `*big.Int` internally).

These numbers have not been optimized.
Division in particular could benefit
from assembly fast paths on amd64 and arm64.

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

A detailed [roadmap](ROADMAP.md) describes the work
required to take the implementation from its current state
to production readiness, including IEEE 754 conformance testing,
CL splitting, and third-party ecosystem impact.

Following the precedent set by generics, range-over-func,
and other major language changes,
the proposed rollout is:

1. **Go 1.XX**: Ship behind `GOEXPERIMENT=decimal`.
   Early adopters can opt in; the types are invisible
   to programs that do not set the flag.
2. **Go 1.XX+1**: Enable by default.
   Remove the experiment flag
   after one release cycle with no major issues.

This gives tool authors (gopls, staticcheck, Delve, etc.)
a full release cycle to add decimal support
before the types appear in default builds.

## Open issues

1. **`decimal32`**: This proposal does not include `decimal32`.
   The 7-digit precision is insufficient for most use cases,
   and omitting it simplifies the implementation.
   If there is demand, it could be added later.

2. **~~`reflect.Value.Call` ABI~~** (resolved):
   The ABI register allocation now handles decimal types correctly.
   `decimal64` is passed in a single integer register
   and `decimal128` is decomposed into two `uint64` halves (lo, hi),
   matching the pattern used for `complex128`.

3. **Performance tuning**: The runtime arithmetic is pure Go
   and has not been heavily optimized.
   Benchmarking against [Intel's C BID library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)
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
   The generated code has not received detailed human review.
   Specific areas that need careful review include:
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
   - **Linux/amd64 bootstrap** has not yet been tested natively.
   The author intends to perform this review
   and welcomes help from the community.
   If legal restrictions prevent AI-generated code
   from being contributed to the Go project,
   the author is in a position
   to produce a clean-room implementation,
   though not necessarily with the capacity or inclination
   to single-handedly take on a project of this scope.

7. **Lossless JSON number decoding**.
   JSON numbers are base-10 text,
   which means `decimal128` (with 34 digits of precision)
   can represent any JSON number exactly,
   whereas `float64` silently loses precision
   for values like `0.1`, large integers beyond 2^53,
   or numbers with more than ~15 significant digits.
   Today, `json.Unmarshal` into `interface{}`
   decodes all numbers as `float64`.
   The alternative is `json.Number`,
   which preserves the text but requires manual parsing.
   With decimal types available,
   it would be natural to offer a mode
   where JSON numbers decode as `decimal128` by default
   in weakly typed contexts
   (i.e., when unmarshalling into `interface{}`
   or `map[string]interface{}`).
   This could take the form of a `Decoder` option
   (analogous to `Decoder.UseNumber`)
   or a global default change in a future Go version.
   The advantage is lossless round-tripping of JSON numbers
   through Go without requiring type annotations.
   The trade-off is that code switching on the dynamic type
   of decoded values would need to handle `decimal128`
   in addition to `float64`.
   This is a design question for the Go team
   and does not block the initial implementation.

## Acknowledgements

This design document builds on
[#19787](https://go.dev/issue/19787),
originally proposed by Mura Li ([@typeless](https://github.com/typeless)) in 2017.
The discussion on that issue, spanning 41 comments over nine years,
shaped the direction of this proposal —
in particular the argument for built-in types over a library
and the focus on IEEE 754 conformance.
Thanks to all who contributed to that discussion.
