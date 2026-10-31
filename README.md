# Proposal: Add decimal floating-point types

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Design document: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-10-31

Discussion at [#19787](https://go.dev/issue/19787)

Related issues: [#82668](https://go.dev/issue/82668), [#12127](https://go.dev/issue/12127), [#19770](https://go.dev/issue/19770), [#26699](https://go.dev/issue/26699), [#9455](https://go.dev/issue/9455)

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
Floating-point constants gain a *quantum* attribute
(the exponent that distinguishes `1.50` from `1.5`),
which only decimal types consume;
the values of constants, and every existing program, are unchanged.

The primary motivation is financial and business software,
where base-10 representation is essential for correctness,
and where a library-based decimal type,
excluded from Go's operators, constants and equality,
is inadequate for the code that handles money.

Both this document and the accompanying implementation
were largely produced with the assistance of agentic AI (Claude Code),
with human direction.
The implementation is a **strawman**: it demonstrates how the types
integrate with the language and the standard library,
and it can be run in the [playground](https://marcelocantos.github.io/go-decimal-proposal/),
but its arithmetic kernel is not yet IEEE 754 conformant.
An independent audit on 2026-10-27
([docs/audits/deep-dive-2026-10-27.md](docs/audits/deep-dive-2026-10-27.md))
measured the gap and fixed the design decisions recorded in
[Design decisions](#design-decisions);
[Implementation status](#implementation-status) summarises what is known
to be sound and what is known to be wrong.
If legal restrictions prevent AI-generated code from being contributed to Go,
the author is in a position to produce a clean-room implementation,
though not necessarily with the capacity or inclination
to single-handedly take on a project of this scope.

**Try it now:** A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
is available for interactive experimentation with `decimal64` and `decimal128`.

**Reading guide:**
This is a long document. Depending on your interest:

- **"Show me what it looks like"** — read [Examples](#examples).
- **"Why not just use a library?"** — read [Why a library is inadequate](#why-a-library-is-inadequate).
- **"What breaks?"** — read [Compatibility](#compatibility).
- **"How real is the implementation?"** — read [Implementation status](#implementation-status) and the [Roadmap](ROADMAP.md).
- **"What's the spec impact?"** — read [Language spec changes](#language-spec-changes).
- **"What has been decided, and why?"** — read [Design decisions](#design-decisions).
- **"What about money, fixed-point, big decimals?"** — read [Non-goals](#non-goals).

## Contents

- [Links](#links)
- [Language change questionnaire](#language-change-questionnaire)
- [Background](#background)
- [Proposal](#proposal)
- [Design decisions](#design-decisions)
- [Non-goals](#non-goals)
- [Examples](#examples)
- [Rationale](#rationale)
- [Compatibility](#compatibility)
- [Implementation](#implementation)
- [Open issues](#open-issues)
- [Acknowledgements](#acknowledgements)

## Links

- **Proposal discussion**: https://go.dev/issue/19787
- **Implementation**: https://github.com/marcelocantos/go/tree/decimal
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
  This proposal differs by providing a working strawman implementation
  (129 files, about 12,000 lines) with a playground,
  a worked-out design for constants, quantum and formatting,
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
  See [Examples](#examples) and [Why a library is inadequate](#why-a-library-is-inadequate)
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
    Constant expressions, typed or untyped, are evaluated
    by `go/constant` with exact rational arithmetic as today;
    the quantum attribute is a small integer propagated alongside.
  - **Run time cost:** Zero for programs that don't use decimal types.
    For programs that do, see [Performance](#performance):
    preliminary measurements on the strawman put addition,
    multiplication and comparison at 2–3x hardware float64.
    All operations are zero-allocation.
  - **Execution:** The strawman demonstrates integration.
    Before it can become a CL series its arithmetic kernel
    must be rewritten and validated against the IEEE 754 decTest suite,
    the constant model must be implemented as specified here,
    and the branch must be rebased onto master,
    gated behind `GOEXPERIMENT=decimal`, and split into reviewable CLs.
    See [Implementation status](#implementation-status)
    and the [roadmap](ROADMAP.md).

- **Can you describe a possible implementation?
  Do you have a prototype?**
  A working strawman exists.
  It spans 129 files with about 12,000 lines added and 500 modified,
  covering the compiler (type system, SSA, constant handling),
  runtime (BID arithmetic, hashing, equality),
  and 18 standard library packages
  (`strconv`, `fmt`, `math`, `reflect`,
  `encoding/json`, `encoding/binary`, `encoding/gob`, `encoding/xml`,
  `database/sql`, `debug/dwarf`, `go/types`, `hash/maphash`,
  `cmp`, `sort`, `testing/quick`,
  `text/template`, and others).
  It includes about 3,700 lines of tests,
  none of which yet exercise rounding, quantum through arithmetic,
  or external conformance vectors;
  its arithmetic kernel is known to be non-conformant.
  A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
  is available for interactive experimentation.
  See [Implementation](#implementation) and
  [Implementation status](#implementation-status) for details.

- **Orthogonality: how does this change interact or overlap
  with existing features?**
  See [Interaction with other language features](#interaction-with-other-language-features).
  Decimal types participate in type switches, generic constraints,
  `reflect`, and `unsafe.Sizeof`
  with no special cases beyond what `complex128` already requires.
  `go/constant` gains one additive accessor for the quantum attribute
  of floating-point constants; constant values are unchanged.

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

### Why a library is inadequate

A library solves the problem.
For example, `shopspring/decimal` computes correct decimal results today,
and [#82668](https://go.dev/issue/82668) proposes a well-designed
`math/decimal` for the standard library.
So the question is less whether a library can do decimal arithmetic, and more
whether the way a library *must* do it in Go
falls short by enough to justify adding two numeric types
to the language instead.
This section analyses the shortfall and argues that language types
offer a substantially better solution than libraries.

#### What a library can't do

Go defines `==`, `comparable`, `cmp.Ordered`, constants and
operators for the predeclared numeric types and for nothing else.
A library decimal is therefore excluded from them,
and the exclusion shows in the shape every library is forced into:

- **Equality.**
  A struct compares field by field, leaving libraries with a dilemma.
  [`woodsbury/decimal128`](https://github.com/woodsbury/decimal128),
  a careful fixed-size IEEE 754 implementation,
  is `struct { lo, hi uint64 }`: `==` compiles,
  reports `1.5 != 1.50`,
  and reports a NaN equal to itself,
  because no struct can make `x != x` true.
  [#82668](https://go.dev/issue/82668) takes the other choice
  and disables `==` with a `_ [0]func()` field,
  so its `Decimal` cannot be a map key,
  cannot be a field of a comparable struct,
  and cannot be compared with `==` at all.
  Neither library is at fault.
  Numeric equality across a cohort (`1.5 == 1.50`)
  is something only the language can define.
- **Ordering and generics.**
  `cmp.Ordered` is a fixed set of predeclared types,
  so no library decimal satisfies it.
  `slices.Sort`, `min`, `max`, `slices.Max`
  and every generic numeric function written against `cmp.Ordered`
  are closed to it.
- **Constants.**
  A library's constants are strings parsed at init
  (`decimal.MustParse("0.20")`),
  with no compile-time check and a run-time failure mode,
  and the literal `0.20` typed from habit is silently a `float64`.
  With a built-in type `const vat = 0.20` is checked when it is compiled,
  under the untyped-constant rules the spec already has.
- **Operators.**
  `price * qty * (1 - discount)` becomes
  `price.Mul(qty).Mul(One.Sub(discount))`.
  Precedence is gone from the page,
  and the reader must reconstruct the intended formula in their head.
- **IEEE 754 itself.**
  Without a language-defined `==`, NaN cannot behave as NaN,
  so [#82668](https://go.dev/issue/82668) drops NaN, infinity and
  signed zero and is, by design, not IEEE 754 decimal.

These gaps are inherent to a library approach.

#### Where the shortfall lands

Decimal arithmetic exists because binary floating point
gives wrong answers for money.
The errors are silent, and are found by auditors and customers.
A library makes the correct path the verbose one
and leaves the incorrect path,
`price * qty * (1 - discount)` in `float64`,
as the natural one.
The result is visible in the ecosystem described in
[Who needs this](#who-needs-this):
tens of thousands of packages import a decimal library,
`float64` is still everywhere in Go billing code,
and many teams have given up on both
and instead store money as `int64` cents,
which is yet another convention with its own folklore, libraries,
and bugs (no sub-cent precision, manual scaling,
currency-dependent logic, forgetting to mul/div by 100).
When the correct path is ugly, people route around it.
The job of a decimal type is to drive engineers into the pit of success
by making the correct path the default,
and only a built-in type can do that,
because only a built-in type gets operators,
compile-time constants and `==`.

#### The bar and the precedent

Go has a precedent:
`complex64` and `complex128` are a numeric kind with operators,
constants and conversions,
added for a user base that is small
next to the 13% of Go developers who work in financial services
([2025 Go Developer Survey](https://go.dev/blog/survey2025)).
This proposal asks for a comparable slot:
a row in the numeric table,
the existing untyped-constant rules,
no new operators, no new literal syntax,
no new concept for a reader of the spec to learn.
If complex earned a place as a built-in kind,
decimal's claim is stronger on every axis the team weighs:
the number of users,
the number of bugs prevented,
and what the bugs cost when they are not prevented.

Other languages have made the same call.
C# put `decimal` in the language in 2002
and it is among its least controversial features;
no one argues it should have been a library.
C23 added `_Decimal64` and `_Decimal128` as built-in types
rather than as a library,
in a language with no shortage of libraries.
COBOL has had native decimal arithmetic since 1959,
and it is one reason COBOL still runs the systems
that Go is now asked to replace.

#### What adoption needs

A library rarely becomes the default; a built-in type does.
It will appear in the Tour,
in `database/sql` and in every driver's default mapping for
`NUMERIC`,
in the output of `sqlc` and other generators,
and in the tutorials that today teach `int64` cents.
A new type changes what Go programs do in a way that
a package would likely not achieve.

A built-in type also ends the fragmentation that
[@typeless](https://github.com/typeless) described on
[#19787](https://go.dev/issue/19787):
a pricing package built on one decimal library
and a ledger package built on another
cannot exchange values without a string.
One type in the language is a standard that every package shares;
a library, however good, is one more contender.

A type also carries a weight that no library can.
A language's predeclared types are its statement of what it is for:
`chan` and `map` said that Go was built for servers,
`complex128` said that numerical work was in scope,
and nothing in Go today says money.
A library says a problem is supported;
a built-in type says the language was designed for it,
and that is read as such by the people choosing a language
for a bank, an exchange or a payments platform.
C# is the proof: `decimal` has been in the language since 2002,
and it is a large part of why C# is taken for granted
as a language for financial systems.

That audience is deciding now.
Teams moving systems off COBOL and off Java are evaluating target
languages, and both of those languages answer
"how do I do money?" without a workaround.
A language that answers "import a package and write `.Mul`"
loses that comparison before the rest of its merits are heard.
Built-in decimal types won't single-handedly win the finance sector,
but they will nudge it strongly in this direction in a way that a
library won't.

The questionnaire concedes that two new predeclared names
make Go marginally harder to learn.
For the developers who need them, the opposite holds:
they stop learning workarounds,
and a junior developer who writes `price * qty` gets the right answer.

#### The decision is one-way

A decimal struct in the standard library,
once shipped, is what code is written against,
and the standard library can never carry a second,
incompatible decimal.
Adopting [#82668](https://go.dev/issue/82668) is therefore
not a smaller step toward decimal types;
it is a decision that Go will likely never have them.
That may be the right decision,
but it should be made as that decision.
Third-party arbitrary-precision libraries are not affected either way:
they serve different needs and coexist with built-in types
as `math/big` coexists with `int64`.

#### The cost

The language change is paid once, by the Go team:
a numeric kind threaded through the compiler and the runtime
and 18 standard library packages,
with the rest of the toolchain unchanged
(see [Implementation](#implementation)).
The library's shortfalls are paid by every user,
in every line of decimal arithmetic,
for as long as the language exists.

#### The libraries that exist

The Go ecosystem already has several decimal libraries,
and each is evidence for the argument above
rather than against it:

- [`shopspring/decimal`](https://github.com/shopspring/decimal),
  arbitrary precision using `*big.Int`, by far the most used.
- [`cockroachdb/apd`](https://github.com/cockroachdb/apd),
  arbitrary precision, used in CockroachDB.
- [`ericlagergren/decimal`](https://github.com/ericlagergren/decimal),
  arbitrary precision, designed for correctness.
- [`woodsbury/decimal128`](https://github.com/woodsbury/decimal128),
  fixed-size IEEE 754-2008.
  It shows that a fixed-width IEEE library can be built well in Go,
  and it still has every gap listed above,
  because the gaps belong to the language, not to the library.
- [#82668](https://go.dev/issue/82668),
  a proposed `math/decimal` with value semantics and a fast path.
  It is the strongest form of the library answer,
  and its design decisions (`==` disabled, no IEEE specials,
  string constants) are the shape the language forces on it;
  its unbounded scale is its own choice, and a fixed-width library
  such as `woodsbury/decimal128` shows the alternative.

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

- **Constants.** Every floating-point constant carries a quantum
  attribute alongside its exact value (see [Constants](#constants)).
  `decimal64(1.50)`, `var d decimal64 = 1.50`,
  and `const c = 1.50; var d decimal64 = c` all yield `1.50`,
  in the declaring package or any other.
  `x := 1.50` does not, because the default type of a
  floating-point constant remains `float64`,
  which has no quantum to receive.
- **Formatting.** Decimal values print with their quantum by default:
  `fmt.Println(d)` prints `1.50`,
  and `strconv.ParseDecimal(fmt.Sprint(d), 64)` returns `d` bit for bit.
  This is the decimal analogue of the shortest-round-trip rule
  that `%v` applies to binary floats.
  `decimal.Reduce(d)` strips trailing zeros for callers who want `1.5`.
- **Parsing.** `strconv.ParseDecimal("1.50", 64)` preserves the quantum.
- **Comparison.** `1.50 == 1.5` is true (numeric equality),
  but the formatting difference is preserved.
- **Map keys and hashing.** Values with different quanta
  but the same numeric value are treated as equal map keys,
  through normalization in the hash function.

Crucially, quantum is not merely preserved through storage;
it follows the IEEE 754-2008 preferred-exponent rules through arithmetic.
For an exact result, multiplication adds the exponents of the operands:
`decimal64(1.50) * decimal64(1.20)` produces `1.8000`.
Addition and subtraction use the smaller exponent:
`decimal64(1.5) + decimal64(0.10)` produces `1.60`.
Division uses the difference of the exponents when the quotient
is exact at that position, and otherwise the finest exponent
that makes it exact: `decimal64(1.00) / decimal64(4)` is `0.25`.
An inexact result is rounded to the full precision of the type
(16 or 34 digits), as IEEE 754 requires:
`decimal64(1) + decimal64(1e-20)` is `1.000000000000000`.
Financial expressions like `unit_price * quantity`
therefore produce results with the expected number of decimal places
without the programmer managing rounding by hand,
and nothing is silently discarded when a result does not fit.

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
Decimal constants use the existing floating-point constant kind,
and the default type of an untyped floating-point constant
remains `float64`.

```go
var d decimal64 = 3.14    // floating-point constant assigned to decimal64
const c = 2.718           // untyped floating-point constant, default type float64
var e decimal128 = c      // c is representable as decimal128
```

**Quantum attribute.**
A floating-point constant carries, in addition to its exact value,
a *quantum*: the exponent of its last digit.
`1.50` has value 3/2 and quantum −2; `150` has quantum 0;
`1.5e3` has quantum 2.
Exact `+`, `-`, `*` and `/` on constants that have quanta
propagate the quantum by the IEEE 754-2008 preferred-exponent rules,
so `1.50 * 2` has quantum −2 and `1.00 / 4` has quantum −2.
A hexadecimal floating-point literal, and any constant produced by an
inexact operation such as `1.0 / 3.0`, has no quantum.

The quantum does not affect a constant's value,
comparisons between constants, representability,
or conversion to `float32` or `float64`,
so no existing program changes meaning.
It is consumed in exactly one place:
when a constant is converted to a decimal floating-point type,
the result takes the constant's quantum if it has one
and the value is representable at that quantum;
otherwise the result is the value rounded to the type's precision
with the canonical exponent.
Because the attribute is part of the constant,
it survives named constants, package boundaries,
and constant arithmetic alike:

```go
package prices
const Base = 1.50          // value 3/2, quantum -2

package main
var p decimal64 = prices.Base        // 1.50
var q decimal64 = prices.Base * 2    // 3.00
var r decimal64 = 1.0 / 3.0          // 0.3333333333333333 (inexact: no quantum, 16 digits)
```

**What `fmt.Println(1.10)` prints.**
`1.1`. With no decimal type in the context,
the constant takes its default type `float64`,
which has no quantum to receive;
this is the same mechanism by which `fmt.Println(1.0)` prints `1` today.
`fmt.Println(decimal64(1.10))` prints `1.10`.
This mirrors C#, where `1.10` is a `double` and `1.10m` is a scale-preserving
`decimal`, and Python and Java, where only `Decimal("1.10")`
and `new BigDecimal("1.10")` keep the scale.
SQL is the one widely used language in which an unsuffixed `1.10`
is a decimal; Go cannot follow it without changing the meaning
of every existing fractional literal.
A literal suffix giving a decimal default type,
by analogy with the imaginary suffix `i`, is noted as an
[open issue](#open-issues) and is not part of this proposal.

**Typed constants and representability.**
Typed decimal constant expressions are constant expressions:
they are evaluated exactly and the result is rounded to the
type's precision, as for `float64`.
A constant `x` is representable by a decimal type `T`
if `x` can be rounded to `T`'s precision
(16 or 34 significant decimal digits, round to nearest even)
without overflow.
`decimal64(1.0/3.0)` is therefore legal and yields
`0.3333333333333333`, while `decimal64(1e400)` is a compile-time error,
matching the behaviour of `float64(1e400)`.

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
A non-constant binary value converts to the decimal value nearest
to its exact binary value, rounded to the destination's precision,
as IEEE 754-2008 specifies:
`decimal128(f)` for `f := 0.1` is `0.1000000000000000055511151231257827`,
while `decimal128(0.1)` with a constant operand is exactly `0.1`.
Converting a decimal value to an integer type truncates toward zero;
the result for values out of range or NaN is implementation-dependent,
as it is for binary floats.
Widening `decimal64` to `decimal128` is exact and preserves the quantum;
narrowing rounds to nearest even.

### Standard library additions

The following standard library changes are included:

The shape below follows the decisions in
[Design decisions](#design-decisions);
the strawman's current API differs and will be brought into line.

**`strconv`**: `ParseDecimal(s string, bitSize int) (decimal128, error)`,
`FormatDecimal(d decimal128, fmt byte, prec, bitSize int) string`,
and `AppendDecimal`, mirroring `ParseFloat`, `FormatFloat` and `AppendFloat`.
`ParseDecimal` returns `ErrRange` for values outside the type's range
and rounds, rather than truncates, excess digits.
With `prec` of −1 the output is the canonical string:
the coefficient digits with the quantum preserved,
in exponent form when the adjusted exponent is below −6
or at or above 21, as for floats.

**`fmt`**: Decimal types support the `v`, `e`, `E`, `f`, `F`, `g`, `G` verbs.
`%v` and `%g` without a precision print the canonical string
(`1.50` for a value with quantum −2).
A precision quantizes the output as it does for floats:
`%.2f` of `1.5` is `1.50`.
The `#` flag keeps its float meaning.

**`math`**: `Decimal64bits`, `Decimal64frombits`,
`Decimal128bits`, `Decimal128frombits`, mirroring `Float64bits`.
Nothing else is added to `math`.

**`math/decimal`** (new package): functions generic over
`Decimal interface { ~decimal64 | ~decimal128 }`:
`Abs`, `Ceil`, `Floor`, `Trunc`, `Round`, `RoundToEven`,
`Quantize`, `SameQuantum`, `Reduce`, `FMA`, `Mod`, `Remainder`,
`Copysign`, `Signbit`, `Dim`, `NaN`, `Inf`, `IsNaN`, `IsInf`,
and rounding with an explicit mode for the directed and half-away
modes that the operators do not provide.
The exact set is open to review;
the point is that the forty-odd helpers live in one package
named for the types rather than doubling the surface of `math`.

**`reflect`**: `Decimal64` and `Decimal128` added to `Kind`,
appended after `UnsafePointer`; no existing `Kind` value changes.
`Value.Decimal()`, `Value.SetDecimal()` and `Value.CanDecimal()` methods.
`Value.IsZero` and `reflect.DeepEqual` compare numerically,
so `0.00` is zero and `1.0` equals `1.00`.

**`encoding/json`**: Marshal as a JSON number using the canonical string,
so `1.50` round-trips as `1.50`; unmarshal preserves the quantum
of the JSON text. String tag support. NaN and infinities are an error,
as for floats.
See [open issue 7](#open-issues) regarding `decimal128`
as a lossless default for JSON number decoding.

**`encoding/binary`**: Read/write decimal types as their IEEE 754
interchange encoding (8 or 16 bytes) in the requested byte order,
most significant word first for `BigEndian`.

**`encoding/gob`**: Encode/decode decimal types using two of the
reserved built-in type ids; `decimal128` is written most significant
word first.

**`encoding/xml`**: Marshal/unmarshal decimal types using the canonical string.

**`database/sql`**: Scan decimal columns from strings, byte slices,
integers and floats.
`driver.Value` converts decimal types to their canonical string,
preserving the quantum, so a `NUMERIC(10,2)` column round-trips.

**`cmp`**: `decimal64` and `decimal128` added to the `Ordered` constraint,
as its documentation already anticipates.

**`sort`**: no additions; `slices.Sort` covers decimal slices through `cmp.Ordered`.

**`text/template`** and **`html/template`**: Decimal type support
in template evaluation, including numeric comparison across widths.

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
Decimal constants use the existing `constant.Float` kind;
values remain exact rationals.
`go/constant` gains one accessor for the quantum attribute
(for example `Quantum(x Value) (exp int, ok bool)`),
`MakeFromLiteral` sets it from the literal,
and `BinaryOp`, `UnaryOp` and `Shift` propagate it
for exact results by the preferred-exponent rules.
Both type checkers (`go/types` and `cmd/compile/internal/types2`)
and the compiler back end consume the same attribute,
so they cannot disagree about a constant's value or quantum.
Typed decimal constant expressions fold like any other
constant expression; the result is rounded to the type's precision
when it is inexact.

**`reflect.DeepEqual` and `reflect.Value.IsZero`.**
Use numeric comparison, not bitwise comparison,
so `decimal64(1.0)` and `decimal64(1.00)` are DeepEqual
despite having different bit representations,
and a value parsed from `"0.00"` reports `IsZero`.

### Language spec changes

The following changes to the
[Go language specification](https://go.dev/ref/spec)
are required. The type, comparison, conversion and size entries
are implemented in the [fork](https://github.com/marcelocantos/go/tree/decimal);
the constant entries describe the design adopted on 2026-10-27
and are not yet implemented.

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

**Constants.** Add to the Constants section:

> A floating-point constant has, in addition to its value, a *quantum*:
> an integer recording the decimal exponent of the last digit
> of the literal it was derived from.
> A decimal floating-point literal with *n* fractional digits
> and no exponent part has quantum −*n*;
> an exponent part is added to that;
> an integer or rune literal has quantum 0.
> A hexadecimal floating-point literal has no quantum,
> and neither does the result of any operation on constants
> that is not exact or whose operands do not all have quanta.
> The quantum of the exact result of a `+`, `-`, `*` or `/` operation
> on constants with quanta is the preferred exponent
> of the corresponding IEEE 754-2008 decimal operation.
> The quantum does not affect the value of a constant,
> comparison of constants, representability,
> or conversion to any type other than a decimal floating-point type.

**Representability.** Add to the rules:

> `x` is representable by a value of type `T` if `T` is a decimal
> floating-point type and `x` can be rounded to `T`'s precision
> (16 or 34 significant decimal digits, to nearest even) without overflow.

and to the examples table:

> ```
> 1.23                decimal64   1.23 is in the set of decimal64 values
> 1.0/3.0             decimal64   rounds to 0.3333333333333333
> 1e400               decimal64   overflows decimal64
> ```

**Conversions of constants.** Add to the Conversions section:

> When a constant `x` is converted to a decimal floating-point type `T`,
> the result is the value of `x` rounded to `T`'s precision.
> If `x` has a quantum and its value is exactly representable in `T`
> with that quantum, the result has that quantum;
> otherwise the result has the canonical (smallest coefficient) representation.

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

## Design decisions

Recorded on 2026-10-27, after the
[audit](docs/audits/deep-dive-2026-10-27.md) of the strawman.
Each entry states the decision, the reason, and whether the strawman
implements it yet. Reviewers who disagree with a decision should say so
on [#19787](https://go.dev/issue/19787); the point of recording them
is that each is now a single answer applied everywhere,
rather than something the implementation decides by accident.

1. **Constants carry a quantum attribute; their values stay exact fractions.**
   Untyped constants remain the exact rationals they are today.
   Literals record a quantum, exact constant arithmetic propagates it
   by the IEEE preferred-exponent rules, and only conversion to a decimal
   type consumes it (see [Constants](#constants)).
   Reason: it gives `var d decimal64 = 1.50` the quantum `1.50`
   without changing the meaning of any existing program,
   survives package boundaries and named constants,
   and lets `go/types` and the compiler share one definition.
   The alternatives were a new constant kind (a far larger change to
   `go/constant` and the spec) or no quantum in constants at all
   (which would make `1.50` indistinguishable from `1.5` at compile time).
   *Strawman:* not implemented; it threads the literal's source text
   through export data, which is lost across packages and for computed
   constants, and makes `go/types` and `cmd/compile` disagree about
   whether typed decimal constant expressions are constants.

2. **Default output preserves the quantum.**
   `%v`, `%g`, `String`, JSON, XML and `database/sql` print `1.50`
   for a value with quantum −2; `strconv.ParseDecimal` of that string
   returns the same bits.
   Reason: `%v` for floats prints the shortest string that round-trips
   the value; for a decimal the shortest string that round-trips the
   value *and its representation* is the coefficient with its quantum,
   so this is the same rule, not a special case.
   It is also what IEEE 754's `convertToDecimalCharacter`,
   Java `BigDecimal`, Python `Decimal` and C# `decimal` do.
   Callers who want `1.5` apply `decimal.Reduce`, the IEEE `reduce` operation.
   The `#` flag keeps its float meaning, and `IsZero`, `omitempty`
   and `DeepEqual` are numeric.
   *Strawman:* prints the shortest form by default and repurposes `#`
   through an undocumented precision sentinel; `IsZero` is bitwise.

3. **Helper functions live in `math/decimal`.**
   `math` receives only the `bits`/`frombits` pairs that mirror
   `Float64bits`; everything else is a generic function in a new
   `math/decimal` package, and `sort` gains nothing.
   Reason: `math` is `float64`-only by design and has no `Float32`
   variants; forty-four `Decimal64X`/`Decimal128X` functions would
   double its surface and would be the strongest argument against
   built-in types in the review. Generics make one function per
   operation possible.
   *Strawman:* 44 functions in `math`, plus `sort.Decimal128Slice`.

4. **Operators round to nearest, ties to even; nothing else.**
   Directed rounding and round-half-away live in `math/decimal`
   as explicit functions. Signalling NaN is accepted as input and
   quieted; NaN payloads and signs are not propagated.
   Reason: this is the `float64` precedent; dynamic rounding modes
   are global state Go does not have, and the financial half-up case
   is a rounding *operation* (`Round`, `Quantize`), not a mode.
   *Strawman:* implements round-to-nearest-even, with the double-rounding
   defects described in the audit.

5. **Conversions are correctly rounded from the exact source value.**
   A non-constant `float64` converts to the decimal nearest its exact
   binary value at the destination's precision; constants convert
   exactly, so `decimal128(0.1)` is `0.1` and `decimal128(f)` for a
   variable holding `0.1` is `0.1000000000000000055511151231257827`.
   Decimal to integer truncates toward zero and is
   implementation-dependent out of range or for NaN, as for floats.
   Reason: a conversion of a value is a conversion of *that* value;
   "shortest round-trip digits" would make `decimal128(f) == f` false
   for most `f` in a way that surprises later, and Go's constant system
   already gives literals the exact behaviour people want.
   *Strawman:* uses shortest-round-trip digits and truncates in places.

6. **Both `decimal64` and `decimal128`; no `decimal32`.**
   Reason: see [Why not just decimal128?](#why-not-just-decimal128).
   The "decimal64 is nearly free" argument holds only with a shared
   arithmetic kernel parameterised by width, which the rewrite will have.
   *Strawman:* both widths, implemented as two separate copies.

7. **Rollout behind `GOEXPERIMENT=decimal` and a `go.mod` version gate;
   public constants are appended, never renumbered.**
   `reflect.Kind` and `go/types.BasicKind` gain their new values after
   the existing ones.
   Reason: the Go 1 compatibility promise; `api/except.txt` is not a
   licence to change existing constant values.
   *Strawman:* inserts the new kinds before `Complex64`, shifting twelve
   existing `reflect.Kind` values and eleven `go/types.BasicKind` values,
   and has neither gate.

8. **Wire formats.**
   `encoding/binary` writes the IEEE interchange encoding in the
   requested byte order (most significant word first for `BigEndian`);
   `gob` writes the two words most significant first;
   JSON uses the canonical string with the float exponent-form thresholds
   and rejects NaN and infinities.
   Reason: these freeze on first release and must match the standard
   and each other.
   *Strawman:* least significant word first in `binary` and `gob`;
   JSON always uses fixed notation, producing 400-character literals
   for small decimal128 values.

## Non-goals

This proposal adds two numeric types and nothing else.
The discussion on [#19787](https://go.dev/issue/19787) and
[#68272](https://go.dev/issue/68272) has repeatedly widened to the
things people build *with* decimal numbers; this section says where
each of those belongs and why it is not here.
In every case the decimal types are the missing foundation,
and in no case does the foundation need the thing built on it
to be in the language.

### Currency and money

A money type is not arithmetic. It is an amount tagged with an
ISO 4217 unit, together with policy that varies by unit and
jurisdiction: the number of minor units (0 for JPY, 2 for USD,
3 for JOD), cash-rounding increments, exchange at a rate on a date,
and locale-dependent formatting.
No general-purpose language has a currency primitive, and the one
serious attempt to standardise one in a core library, Java's JSR 354
(`javax.money`), was specified and implemented but kept out of the JDK.
C# has `decimal` in the language and no money type in its base library;
Python, Rust and .NET all leave it to packages.

Nor does the case for built-in decimal types carry over.
That case rests on operators and constants:
`price * qty` instead of `price.Mul(qty)`.
A money type cannot use operators in Go in any event,
because `usd + eur` must fail, and an operation that can fail
is exactly what a method call is for.
`a.Add(b)` on money is idiomatic; `a.Add(b)` on a plain number is
the thing this proposal removes.

What a money library cannot build for itself is the amount:
an exact, fixed-size, comparable value with a quantum,
usable as a map key and a struct field without allocation.
That is what `decimal64` and `decimal128` supply.
The natural home for the rest already exists:
[`golang.org/x/text/currency`](https://pkg.go.dev/golang.org/x/text/currency)
models units, the `Standard`, `Cash` and `Accounting` rounding kinds
with their scale and increment, and formatting through `x/text/message`,
and its `Amount` is agnostic about the numeric type it wraps.
Making `decimal128` its natural amount, quantized to the unit's scale,
is the obvious extension and needs no language change.
Exchange, ledgers and allocation (splitting 100.00 three ways without
losing a cent) are third-party territory, as they are everywhere else.

One Go-specific design falls out of generics and is worth noting
because no Java or C# library can offer it:
a phantom type parameter, `Money[USD]` and `Money[EUR]`,
makes mixing currencies a compile-time error rather than a runtime panic,
with a dynamically tagged variant for amounts whose currency arrives
from a database. It works only because the amount is a value type.

### Fixed-point decimal

[#68272](https://go.dev/issue/68272) asks for fixed-point decimal types.
An IEEE 754 decimal with a fixed quantum *is* a fixed-point number:
`decimal64` values with exponent −2 are exactly the set of amounts
with two decimal places, and the quantum rules in
[Quantum preservation](#quantum-preservation) keep `+`, `-` and
integer `*` at that quantum without any help.
Fixed-point is therefore a discipline, not a type:
quantize after any operation that can change the exponent
(`decimal.Quantize(x, 0.01)` after a division or a percentage),
which is also what SQL `NUMERIC(p, s)` does on store.
A library can wrap that discipline in a type with a fixed scale
if a project wants the compiler to enforce it;
the standard library does not need to.

### Arbitrary precision

Fixed-size types are the point: stack allocation, register passing,
predictable cost, map keys, no indirection.
Third-party arbitrary-precision decimals (`shopspring/decimal`,
`cockroachdb/apd`, `ericlagergren/decimal`) serve different needs
and keep their place, as `math/big` does beside `int64`.
A decimal *struct in the standard library*
([#81886](https://go.dev/issue/81886), [#82668](https://go.dev/issue/82668))
is a different matter: see
[The decision is one-way](#the-decision-is-one-way).
Interoperation is a conversion through the canonical string,
or through `(coefficient, exponent)` pairs that the libraries already
expose and `math/decimal` can provide.

### Rounding modes as state

IEEE 754's directed rounding modes are provided as functions in
`math/decimal` (design decision 4), never as a per-goroutine or global
mode. Go has no floating-point environment and should not acquire one
for decimals.

### `decimal32`

Seven significant digits are too few for prices, quantities or rates
in practice; the type would exist for completeness and see almost no use.
It is left out and can be added later without disturbing anything here.

## Examples

These examples can be run on the
[live playground](https://marcelocantos.github.io/go-decimal-proposal/),
which compiles and runs them in your browser with no server involved.
The first visit downloads the compiler, linker and standard library,
18.2 MB compressed;
the default example then compiles, links and runs in about 0.4 s,
and about 0.15 s on later runs
(Chromium 156 on an Apple M4 Max, measured 2026-10-31;
[details](playground/README.md#measurements)).
Note that the playground runs the strawman, whose formatting follows
the pre-decision rules (shortest form by default, quantum with `#`);
the output shown here is what the proposal specifies.

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

fmt.Printf("Subtotal: $%6.2f\n", subtotal) // $121.92
fmt.Printf("Tax:      $%6.2f\n", tax)      // $ 10.06
fmt.Printf("Total:    $%6.2f\n", total)     // $131.98
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

fmt.Printf("$%.2f = €%.2f\n", amount, amount*usdToEur) // €920.00
fmt.Printf("$%.2f = £%.2f\n", amount, amount*usdToGbp) // £790.00
```

### Quantum preservation

```go
price := decimal64(29.90)
qty := decimal64(3)
result := price * qty

fmt.Printf("Price:  %v\n", price)  // 29.90
fmt.Printf("Qty:    %v\n", qty)    // 3
fmt.Printf("Total:  %v\n", result) // 89.70
```

Multiplication adds the quanta of the operands:
`29.90` (2 decimal places) times `3` (0 decimal places)
produces `89.70` (2 decimal places),
without any explicit rounding or formatting.

## Rationale

### Why built-in types and not a library?

See [Why a library is inadequate](#why-a-library-is-inadequate).
In short: a library decimal is excluded from `==`, `cmp.Ordered`,
constants and operators by the language's definition of them,
the exclusion lands on the code that handles money,
`complex128` set the bar and decimal clears it,
and a decimal struct in the standard library would foreclose
built-in types for good.

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
It would also not close the gap:
overloaded operators give a library type arithmetic,
but not `==` across a cohort, not `cmp.Ordered`,
and not participation in the constant system.
A standard numeric type is still a built-in type.

### Comparison with complex types

Go already has `complex64` and `complex128` as built-in types,
a numeric kind with operators, constants and conversions
for a user base far smaller than decimal's.
They set the bar for adding a numeric kind to the language,
and [Why a library is inadequate](#why-a-library-is-inadequate)
measures decimal against it.

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
Access to the new types will be gated by the `go` directive in `go.mod`,
following the precedent set by `any` and `comparable` in Go 1.18;
the strawman does not implement the gate yet.

**Type system.**
The new types participate in Go's existing type system
with no changes to the rules for type identity,
assignability, or type inference.
The `Ordered` constraint in `cmp` gains two new types.
Existing instantiations of generic functions
constrained by `Ordered` will not be affected
because they already have a concrete type argument.

**`reflect.Kind`.**
This proposal adds two new `reflect.Kind` values,
`Decimal64` and `Decimal128`, appended after `UnsafePointer`
so that no existing `Kind` value changes.
(The strawman currently inserts them before `Complex64`,
renumbering the later kinds; that is a defect, not the proposal.)
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
Similarly, `go/types` gains two new `BasicKind` values,
likewise appended so that `String`, `UnsafePointer` and the untyped
kinds keep their values.
This affects tools that use `go/types` for static analysis.
Well-written tools that use a `default` case are unaffected.

**`encoding/gob`.**
The `encoding/gob` wire format was explicitly designed
for expansion: it has reserved type IDs
and a `firstUserId` gap that accommodates new built-in types
without breaking existing encoded streams.

## Implementation

A working strawman exists
as a fork of the Go compiler and standard library
at [marcelocantos/go (decimal branch)](https://github.com/marcelocantos/go/tree/decimal).
A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
is available where readers can try decimal64 and decimal128 interactively.

The implementation touches 129 files
with approximately 12,000 lines added
and 500 lines modified.
It bootstraps and passes the full test suite (`all.bash`)
on macOS (darwin/arm64), and bootstraps and passes its decimal tests
on Linux (linux/amd64) in this repository's CI.
It has not been built for Windows or other platforms,
and it does not currently compile for 32-bit targets
(see [Implementation status](#implementation-status)).

### Implementation status

The strawman was audited on 2026-10-27
([full report](docs/audits/deep-dive-2026-10-27.md)).
Readers should treat it as evidence that the types *integrate*,
not as evidence that the arithmetic is *correct*.

Sound, verified by the audit:
the type system, SSA lowering and ABI
(values pass correctly through calls, closures, channels, `defer`,
interfaces, type switches, generics, struct and array embedding);
comparison and equality including NaN, signed zero and cross-quantum
operands; map-key hashing and equality; special-value handling
(division by zero, `0/0`, `Inf - Inf`, `0 * Inf`, `x - x`);
BID pack and unpack including non-canonical encodings;
`encoding/gob` compatibility with streams from stock Go.

Known wrong, to be fixed before any CL series:

- **Arithmetic kernel.** Against an exact `math/big` oracle applying
  IEEE 754-2008 rounding and preferred exponents, decimal64 division
  returns a wrong value for about a quarter of ordinary operand pairs
  (`1 / 70000000000000` gives `1.43e-14`),
  decimal128 division for about half,
  and decimal128 addition for about 7 percent
  (`1e20 + 1e-20` gives `1.318…e18`);
  every operation rounds twice, multiplication drops sticky bits,
  decimal128 overflow is not detected,
  and the division exponent rule is wrong.
  The kernel will be rewritten once as a width-parameterised core
  and validated against the Speleotrove decTest suite
  and the oracle in [`tests/oracle`](tests/oracle).
- **Constant model.** Implemented as a source-text side channel;
  to be replaced by the quantum attribute in
  [Design decisions](#design-decisions) item 1.
  Until then `go/types` and `cmd/compile` disagree about typed
  decimal constant expressions, and rune and hexadecimal literals
  assigned to decimals produce wrong values.
- **Public constants renumbered** in `reflect` and `go/types`
  (item 7).
- **Compiler gaps.** A struct or array map key containing a decimal
  crashes the compiler; 32-bit targets fail to build `std`;
  `reflect.Value.Call` panics on `decimal128`.
- **`strconv`.** `ParseDecimal*` never returns `ErrRange`
  and truncates rather than rounds excess digits.
- **API shape** differs from this document throughout
  (items 2, 3 and 8).

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
  in the object file.
  The strawman derives the quantum from the literal's source text;
  the proposal derives it from the constant's quantum attribute.

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
- About 3,700 lines of test code across all packages.

What the tests do not yet cover is what matters most:
rounding at the precision boundary, sticky bits, overflow ties,
subnormals, quantum through inexact arithmetic, parse range errors,
`reflect.Value.Call`, composite map keys, and 32-bit targets.
No test runs against an external conformance suite.
The [audit's oracle](tests/oracle) is the interim gate until the
decTest harness exists.

### Performance

The implementation is pure Go with no assembly fast paths.
Preliminary benchmarks on Apple M4 Max (arm64),
measured on the strawman before the kernel rewrite,
so they indicate the cost of a software BID implementation in Go
rather than the cost of the final code
(in particular, the division measured here produces too few digits):

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
as a series of CLs to the Go repository
once the kernel rewrite and the constant model are in place.
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

2. **`reflect.Value.Call` ABI** (partly resolved):
   The compiler's ABI register allocation handles decimal types:
   `decimal64` is passed in a single integer register
   and `decimal128` is decomposed into two `uint64` halves,
   matching the pattern used for `complex128`.
   `reflect`'s own ABI assignment still treats `decimal128`
   as one 16-byte register and panics; it needs the same split.

   **Decimal literal suffix** (not proposed, recorded for discussion):
   because the default type of a floating-point constant is `float64`,
   `fmt.Println(1.10)` prints `1.1`.
   A suffix giving a floating-point constant a decimal default type,
   by analogy with the imaginary suffix `i`
   (whose constants default to `complex128`),
   would let `fmt.Println(1.10d)` print `1.10`.
   C# has exactly this (`1.10m`). It is new syntax, so it is left out
   of this proposal; the quantum attribute makes it a small addition
   later if there is demand.

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
   across 129 files in a short time frame.
   The generated code did not receive detailed human review
   when written.
   On 2026-10-27 an independent review with a current-generation model,
   an exact-arithmetic oracle, and hand-verified reproducers
   ([report](docs/audits/deep-dive-2026-10-27.md))
   found the defects summarised in
   [Implementation status](#implementation-status);
   the arithmetic kernel in particular needs a rewrite,
   and the compiler's constant handling needs the design in
   [Design decisions](#design-decisions) item 1
   rather than cleanup.
   The author intends to carry out that work
   and welcomes help from the community,
   in particular with the decTest conformance harness.
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
The discussion on that issue, spanning fifty comments over nine years,
shaped the direction of this proposal —
in particular the argument for built-in types over a library
and the focus on IEEE 754 conformance.
Thanks to all who contributed to that discussion.
