# Proposal: Add decimal floating-point types

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Design document: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-11-01

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
were largely produced with the assistance of agentic AI,
with human direction.
The implementation is a fork of Go,
and it can be run in the [playground](https://marcelocantos.github.io/go-decimal-proposal/).
Its arithmetic is one kernel, `internal/bid`,
checked against an exact reference model,
an independently written conformance suite and published test vectors.
Several design decisions are not implemented yet:
the constant model, default formatting, `math/decimal`,
appended `reflect.Kind` values, the rollout gates and the wire formats.
An independent audit on 2026-10-27
([docs/audits/deep-dive-2026-10-27.md](docs/audits/deep-dive-2026-10-27.md))
found the first implementation's arithmetic kernel wrong on ordinary inputs,
and the design decisions recorded in
[Design decisions](#design-decisions) followed from it.
The kernel was then rewritten and reviewed
([docs/audits/kernel-review-2026-10-31.md](docs/audits/kernel-review-2026-10-31.md)).
[Implementation status](#implementation-status) summarises what is verified
and what is still wrong or missing.
If legal restrictions prevent AI-generated code from being contributed to Go,
the author is in a position to produce a clean-room implementation,
though not necessarily with the capacity or inclination
to single-handedly take on a project of this scope.

**Try it now:** A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
compiles and runs `decimal64` and `decimal128` programs in your browser.

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
  This proposal differs by providing a working implementation
  (about 12,800 lines outside tests, and 31,500 lines of tests and test data)
  with a playground,
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
  - **Tools affected:** `go vet` (printf analyzer, done in the fork's
    vendored copy of `x/tools`, not yet sent upstream),
    `gopls` (type support — needs verification),
    `go/types` (types done; it does not yet agree with `cmd/compile`
    about typed decimal constant expressions).
    Third-party tools that exhaustively switch on `reflect.Kind`
    or `go/types.BasicKind` will need updates;
    see the [roadmap](ROADMAP.md) for details.
  - **Compile time cost:** Expected to be negligible; not measured.
    Two new type entries in the compiler's type system.
    The fork currently writes one extra string per constant into
    export data, the literal's source text.
    The proposed design replaces that with the quantum attribute,
    a small integer propagated alongside the exact value
    that `go/constant` already holds.
  - **Run time cost:** None for programs that don't use decimal types,
    apart from code size:
    a program that imports `fmt` links about 18 KB of `internal/bid`
    (darwin/arm64).
    For programs that do, see [Performance](#performance):
    a provisional baseline of the kernel's own functions puts
    addition and multiplication at about 11 ns for `decimal64`,
    against about 1 ns for `float64` in the same benchmark loop.
    No exported function of the kernel allocates (`TestAllocs`).
  - **Execution:** The arithmetic kernel has been rewritten and validated
    against an exact oracle and conformance vectors,
    and upstream `master` has been merged into the branch.
    Before it can become a CL series,
    the constant model must be implemented as specified here,
    the API and wire formats must be brought into line with
    [Design decisions](#design-decisions),
    the public constants must be appended rather than renumbered,
    and the types must be gated behind `GOEXPERIMENT=decimal`
    and the `go.mod` version.
    Then the branch can be split into reviewable CLs.
    See [Implementation status](#implementation-status)
    and the [roadmap](ROADMAP.md).

- **Can you describe a possible implementation?
  Do you have a prototype?**
  A working implementation exists.
  Against its merge base with upstream `master`
  the branch changes 252 files and adds about 44,300 lines,
  of which about 31,500 are tests and test data.
  The other 12,800 cover the arithmetic kernel (`internal/bid`, about 8,600),
  the compiler (type system, SSA, constant handling),
  the runtime (wrappers over the kernel, hashing, equality),
  and these standard library packages:
  `strconv`, `fmt`, `math`, `reflect`,
  `encoding/json`, `encoding/json/v2`, `encoding/binary`, `encoding/gob`,
  `encoding/xml`, `database/sql`, `database/sql/driver`, `debug/dwarf`,
  `go/types`, `cmp`, `sort`, `testing/quick` and `text/template`.
  The tests include an exact `math/big` oracle
  and 4,168 conformance vectors written independently of the kernel.
  Parts of the design are not implemented yet.
  A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
  runs the fork in the browser.
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
- **Constant expressions.**
  Finance code is full of constants derived from other constants:
  `const gross = 1 + vat`, `const daily = annual / 360`,
  `const eurPerDem = 1 / 1.95583`.
  An untyped constant expression is evaluated exactly
  and rounded once, on conversion to a decimal type,
  so `daily` is correctly rounded at either width from one declaration.
  A library computes such values at run time,
  rounding at each method call,
  and keeps them in package-level variables
  that are mutable and depend on initialization order.
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
with small changes elsewhere in the toolchain
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

This proposal uses BID encoding for interchange,
and a value in memory is that encoding XORed with a constant
so that all bits clear means zero
(see [Design decisions](#design-decisions) item 9).
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
Typed decimal constant expressions are constant expressions.
Each operation on typed decimal constants is rounded to the type's precision,
as `go/types` and `cmd/compile` do for typed `float32` and `float64` constants,
so a typed constant expression gives the same result as the same
expression on variables.
Untyped constant expressions stay exact until they are converted,
so the author chooses by typing the constant or not:

```go
const a decimal64 = 1
const b = a / 3 * 3             // 0.9999999999999999, as at run time
const c decimal64 = 1.0 / 3 * 3 // 1: exact, then converted
```

The rounding here is to the type's 16 or 34 digits.
Rounding to a business precision such as cents is a `Quantize` call,
which happens at run time.

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
the fork's current API differs in the ways listed under
[Implementation status](#implementation-status)
and will be brought into line.

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
constant expression, except that each operation is rounded to the type's
precision by the same kernel routines the run-time operators use,
so constant and run-time results agree.

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
> that use a base-10 representation as defined by IEEE 754-2008.
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
>
> An operation on constants of a decimal floating-point type
> is not evaluated exactly.
> Its result, in value and quantum, is the result the corresponding
> IEEE 754-2008 operation gives for those operands,
> rounding to nearest even.
> A result that overflows is illegal.

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

**Floating-point operators.** Extend the paragraph on fused operations:

> This applies to both binary and decimal floating-point types.

**The zero value.** Add to the section on the zero value:

> The zero value of a decimal floating-point type
> is the result of converting the integer constant `0` to that type,
> and so has quantum 0.

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
[audit](docs/audits/deep-dive-2026-10-27.md) of the first implementation.
Each entry states the decision, the reason, and whether the fork
implements it yet. Reviewers who disagree with a decision should say so
on [#19787](https://go.dev/issue/19787); the point of recording them
is that each is now a single answer applied everywhere,
rather than something the implementation decides by accident.

Two principles govern these decisions and any still to be made.
Conformance to IEEE 754-2008 comes first.
Below that, decimal types are semantically as close to `float32` and `float64`
as possible, so a difference from floats needs the standard to require it.
The standing exception to the first principle is the environment IEEE assumes
around its operations: Go's floats have no status flags or dynamic rounding modes,
and decimal types don't add them.

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

   Typed decimal constants round after each operation, as typed float
   constants do in `go/types` and `cmd/compile`; this was decided on
   2026-11-01.
   Untyped constants are unaffected, so typing a constant is how an author
   asks for the rounding that run-time code would do.
   Reason: a typed constant expression and the same expression on variables
   give the same result, and comparisons agree at compile time and run time.
   The spec's sentence that constant expressions are always evaluated exactly
   does not describe what those type checkers do for typed floats,
   so the spec change above states the decimal rule explicitly.

   *Status:* not implemented. The fork threads the literal's source text
   through export data. A direct literal, a conversion of one,
   and a constant from a single-name declaration in the same
   package keep their quantum. Other constants don't:
   `prices.Base` from another package gives `1.500000000000000`,
   as do `-c` for a named `c`, `b` in `const a, b = 1.25, 1.50`,
   and `T(1.50)` for a type parameter `T`.
   A computed constant takes a 16-digit coefficient at both widths.
   `go/types` and `cmd/compile` disagree about whether typed decimal
   constant expressions are constants:
   `const a = decimal64(1.50) * 2` passes `go/types`,
   and `cmd/compile` rejects it as not constant.

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
   *Status:* partly implemented. `IsZero`, `omitempty` and `DeepEqual`
   are numeric. `%v`, `%g`, `strconv` with precision −1, JSON, XML
   and `database/sql` still print the shortest form (`1.5`),
   and `#` is still repurposed to print the quantum,
   through an undocumented precision sentinel of −2.
   `println` and the parsers keep the quantum.
   `decimal.Reduce` doesn't exist yet.

3. **Helper functions live in `math/decimal`.**
   `math` receives only the `bits`/`frombits` pairs that mirror
   `Float64bits`; everything else is a generic function in a new
   `math/decimal` package, and `sort` gains nothing.
   Reason: `math` is `float64`-only by design and has no `Float32`
   variants; forty-four `Decimal64X`/`Decimal128X` functions would
   double its surface and would be the strongest argument against
   built-in types in the review. Generics make one function per
   operation possible.
   *Status:* not implemented. `math` has 40 decimal functions,
   36 of them beyond the `bits`/`frombits` pairs, each a thin wrapper
   over the kernel; `sort` has `Decimal128Slice` and `SearchDecimal128s`;
   there is no `math/decimal`.

4. **Operators round to nearest, ties to even; nothing else.**
   Directed rounding and round-half-away live in `math/decimal`
   as explicit functions. Signalling NaN is accepted as input and
   quieted; NaN payloads and signs are not propagated.
   Reason: this is the `float64` precedent; dynamic rounding modes
   are global state Go does not have, and the financial half-up case
   is a rounding *operation* (`Round`, `Quantize`), not a mode.
   The treatment of NaN payloads is not settled by that precedent;
   see [open issue 8](#open-issues).
   *Status:* implemented for the operators, which round once,
   to nearest with ties to even; signalling NaN is quieted,
   and payloads and signs are dropped.
   The kernel implements all five IEEE modes.
   Explicit-mode rounding has no public API until `math/decimal` exists.

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
   *Status:* implemented for non-constant values and for constants
   of a concrete decimal type, through the kernel.
   One defect remains: for a type parameter `T`,
   `T(float64(0.1))` is treated as the literal `0.1`.

6. **Both `decimal64` and `decimal128`; no `decimal32`.**
   Reason: see [Why not just decimal128?](#why-not-just-decimal128).
   The "decimal64 is nearly free" argument holds only with a shared
   arithmetic kernel parameterised by width, which `internal/bid` now is.
   *Status:* implemented. Both widths are generated from one template,
   a form chosen by a measured spike recorded in the package documentation.

7. **Rollout behind `GOEXPERIMENT=decimal` and a `go.mod` version gate;
   public constants are appended, never renumbered.**
   `reflect.Kind` and `go/types.BasicKind` gain their new values after
   the existing ones.
   Reason: the Go 1 compatibility promise; `api/except.txt` is not a
   licence to change existing constant values.
   *Status:* not implemented. The fork inserts the new kinds
   before `Complex64` in `reflect` and before `String` in `go/types`,
   shifting twelve existing `reflect.Kind` values and nine
   `go/types.BasicKind` values, with the failures silenced in `api/except.txt`.
   It has neither gate: `GOEXPERIMENT=decimal` is rejected as unknown,
   and a module declaring `go 1.20` can use the types.

8. **Wire formats.**
   `encoding/binary` writes the IEEE interchange encoding in the
   requested byte order (most significant word first for `BigEndian`);
   `gob` writes the two words most significant first;
   JSON uses the canonical string with the float exponent-form thresholds
   and rejects NaN and infinities.
   Reason: these freeze on first release and must match the standard
   and each other.
   *Status:* partly implemented. JSON rejects NaN and infinities.
   `gob`, and `binary` with `BigEndian`, still write the least significant
   word first. JSON still always uses fixed notation,
   producing 400-character literals for small decimal128 values,
   and does not preserve the quantum on output.

9. **The zero value is `decimal64(0)` or `decimal128(0)`.**
   `var total decimal64` has the value and quantum of `decimal64(0)`,
   so `total += 19.99` gives `19.99`, as `var total float64` would.
   Go's zero value is all bits clear, so all bits clear must mean `0E+0`.
   A value in memory is therefore its BID encoding XORed with the encoding
   of that zero: `0x31c0000000000000` for `decimal64`,
   and `0x3040000000000000` in the high word of `decimal128`.
   The `bits` functions, `encoding/binary` and `gob`
   still give the BID interchange encoding, and arithmetic is unchanged.
   Reason: Go's spec says the zero value of a numeric type is `0`,
   and `0E+0` is what IEEE 754-2008 gives for converting the integer 0,
   so the zero value has the same exponent as `decimal64(1)`.
   IEEE 754-2008 defines no default value for a variable,
   and its encodings govern interchange.
   The alternatives were plain BID in memory,
   where the zero value is `0E-398` and `total` holds `19.99000000000000`,
   and treating a zero at the minimum exponent specially,
   which departs from IEEE's preferred exponent.
   The cost is that C code using `_Decimal64` can't share decimal values
   in memory without conversion,
   `unsafe` reinterpretation sees the XORed form,
   and debuggers that decode `DW_ATE_decimal_float` as BID need the same conversion.
   *Status:* not implemented. The fork's zero value is `0E-398`
   for `decimal64` and `0E-6176` for `decimal128`.

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
19.4 MB compressed;
the default example then compiles, links and runs in about 0.4 s,
and about 0.13 s on later runs
(Chromium 156 on an Apple M4 Max, measured 2026-11-01;
[details](playground/README.md#measurements)).
The output shown here is what the proposal specifies.
The first three examples print it today.
The quantum preservation example does not yet,
because the formatting in design decision 2 is not implemented:
`%v` prints the shortest form, so it prints `29.9`, `3` and `89.7`.
The fork's `#` flag prints the quantum,
and the playground's copy of that example uses `%#g` and prints the output shown.

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
the fork does not implement the gate yet.

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
(The fork currently inserts them before `Complex64`,
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

A working implementation exists
as a fork of the Go compiler and standard library
at [marcelocantos/go (decimal branch)](https://github.com/marcelocantos/go/tree/decimal).
A [live playground](https://marcelocantos.github.io/go-decimal-proposal/)
compiles and runs it in the browser, with no server involved.
It is built from the fork commit pinned in [`toolchain.lock`](toolchain.lock),
32c14fd1b1 at the time of writing, and this section describes that commit.

Upstream `master` has been merged into the branch.
Against the merge base (5be815fece, 2026-10-30)
the branch changes 252 files, adding 44,326 lines and removing 496:

| Part | Lines added |
|---|---|
| Kernel `internal/bid`, hand-written | about 6,000 |
| Kernel `internal/bid`, generated | about 2,600 |
| Compiler, runtime, standard library, API files and spec | about 4,200 |
| Test code | about 24,600 |
| Conformance vectors and benchmark baseline (`testdata`) | about 7,000 |

`all.bash` passes on darwin/arm64 at that commit.
This repository's CI builds the fork with `make.bash` on linux/amd64
and there runs the kernel's tests including the long oracle run,
the end-to-end quantum checks in [`tests/quantum_validate.go`](tests/quantum_validate.go),
and the decimal tests of `strconv`, `fmt` and `math`.
It also runs the kernel's tests under `GOARCH=386`,
the tests of the kernel, `strconv`, `fmt` and `math` under js/wasm,
and the playground's examples in a headless browser.
`go build std` succeeds for linux/386, linux/arm, linux/s390x,
windows/amd64 and js/wasm.
`all.bash` has not been run on any other platform,
and nothing has been run on a big-endian target or on Windows.
On 32-bit targets only the kernel's tests have run:
decimal behaviour through the language is unverified there.

### Implementation status

The first implementation, called the strawman in the audit,
was audited on 2026-10-27
([full report](docs/audits/deep-dive-2026-10-27.md)).
The audit found its integration sound and its arithmetic wrong.
The arithmetic was then replaced.

Sound, verified by the audit:
the type system, SSA lowering and ABI
(values pass correctly through calls, closures, channels, `defer`,
interfaces, type switches, generics, struct and array embedding);
comparison and equality including NaN, signed zero and cross-quantum
operands; map-key hashing and equality; special-value handling
(division by zero, `0/0`, `Inf - Inf`, `0 * Inf`, `x - x`);
`encoding/gob` compatibility with streams from stock Go,
rechecked against go1.27.3 in both directions.

Fixed since the audit:

- **Arithmetic kernel.** Rewritten as `internal/bid`, one package
  on bit patterns, with both widths generated from one template.
  Every operation computes an exact intermediate
  and reaches the encoding through one rounding function.
  The audit's reproducers now give IEEE results:
  `1 / 70000000000000` is `1.428571428571429E-14` in decimal64,
  and `1e20 + 1e-20` has the value `1e20` in decimal128.
  See [Testing](#testing) for the evidence, and the
  [kernel review](docs/audits/kernel-review-2026-10-31.md):
  at b7cc5d04b8, before the runtime moved onto the kernel,
  two independent AI reviewers found no wrong value, no wrong flag
  and no reachable panic, and ten faults in contract text and comments,
  which were fixed.
  Both quoted IEEE clause numbers from memory,
  because the standard's text was not available to them.
- **Conversions.** A non-constant `float64` converts from its exact
  binary value, and `decimal128(f)` for `f := 0.1` is
  `0.1000000000000000055511151231257827`.
- **Rune and hexadecimal literals.** `'a'` assigned to a decimal is `97`
  and `0x1p-2` is `0.25`.
- **Map keys.** `map[struct{A decimal64; B int}]int` and
  `map[[2]decimal128]int` compile and treat cohort members as one key.
- **32-bit targets.** `std` builds, as stated above.
- **`reflect.Value.Call`.** `decimal128` arguments and results round-trip.
- **`strconv`.** `ParseDecimal64` and `ParseDecimal128` return `ErrRange`
  on overflow, round excess digits to nearest even,
  and reject `NaNxyz`.
- **`reflect.Value.IsZero`, `omitempty` and templates.** Numeric,
  so a zero with any exponent is zero.

Still wrong or missing, to be fixed before any CL series:

- **Constant model.** Still a source-text side channel
  (`ir.BasicLit.origLit`, one string per constant in export data);
  to be replaced by the quantum attribute in
  [Design decisions](#design-decisions) item 1.
  The quantum survives only for a direct literal,
  a conversion of one, and a single-name constant in the same package.
  `cmd/compile` demotes typed decimal constant expressions to run-time
  values while `go/types` folds them, so `const a = decimal64(1.50) * 2`
  passes `go/types` and fails to compile.
  `go/constant` has no quantum accessor.
  A typed decimal constant keeps its exact value in both type checkers,
  and the compiler rounds it once, through the kernel.
  So after `const a decimal64 = 1.00000000000000001`,
  `a == 1` is false at compile time and true at run time,
  which [Design decisions](#design-decisions) item 1 will fix.
- **Public constants renumbered** in `reflect` and `go/types`
  (item 7), with entries in `api/except.txt`.
- **Rollout gates.** Neither `GOEXPERIMENT=decimal` nor the `go.mod`
  version gate exists (item 7).
- **API shape** differs from this document (items 2, 3 and 8).
  `%v` and the encoders print the shortest form;
  `strconv` has `ParseDecimal64` and `ParseDecimal128`
  in place of `ParseDecimal(s, bitSize)`, and precision −1 is shortest,
  with −2 as an undocumented sentinel for the quantum;
  `math` holds the helpers, and `math/decimal` doesn't exist;
  `gob`, and `binary` with `BigEndian`, write the low word first;
  JSON uses fixed notation only;
  `text/template` does not compare across widths
  (`lt` and `le` return an error,
  and `eq` of `decimal64(1.5)` and `decimal128(1.5)` is false).
- **Generic conversion.** For a type parameter `T`,
  `T(0.1)` takes a 16-digit coefficient
  and `T(float64(0.1))` is treated as the literal `0.1`.
- **Zero value.** The fork's zero value is `0E-398`,
  so `var total decimal64; total += 19.99` holds `19.99000000000000`,
  and `subtotal` in the invoice example holds `121.9200000000000`.
  `fmt` hides this only because `%v` still prints the shortest form.
  [Design decisions](#design-decisions) item 9 will fix it.
- **Performance.** The baseline is provisional and
  linux/amd64 has not been measured; see [Performance](#performance).

The changes are distributed as follows:

### Compiler (`cmd/compile`)

- **Types**: `decimal64` and `decimal128` added
  to the compiler's type system
  (`cmd/compile/internal/types`),
  type checker (`cmd/compile/internal/types2`, `go/types`),
  and IR (`cmd/compile/internal/ir`).

- **SSA**: `ssagen` lowers every decimal operator and conversion
  to a call to a runtime function on bit patterns, as `softfloat64.go` does:
  `decimal64` is passed as a `uint64`,
  and `decimal128` as two `uint64` halves, high first.
  The remaining SSA opcodes cover constants, negation
  and the parts of a `decimal128`.
  A `softdecimal` pass removes the decimal types from what remains,
  and `decimal64` is decomposed into two halves on 32-bit targets.

- **Static data**: Decimal constants are rounded and encoded by the kernel,
  through one helper, `ir.DecimalConst`,
  used for both static data and SSA constants.
  The fork derives the quantum from the literal's source text;
  the proposal derives it from the constant's quantum attribute.

- **Conversions**: All numeric-to-decimal and decimal-to-numeric
  conversions are implemented, and call the kernel.

### Runtime (`runtime`)

- **Arithmetic**: One-line wrappers over `internal/bid`
  for decimal64 and decimal128 addition, subtraction,
  multiplication, division, comparison, min and max.
  These are called by the compiler-generated code.
  The runtime holds no decimal arithmetic of its own,
  and `internal/bid` is compiled in runtime mode,
  so it is safe under `-race`, `-msan` and `-asan`.

- **Hashing**: Decimal map keys hash the kernel's canonical key,
  so that `1.0` and `1.00` hash identically.

- **Equality**: Decimal map key equality uses numeric comparison
  (not bitwise), consistent with the `==` operator.

- **Printing**: The `print` and `println` builtins write the kernel's
  character form, which keeps the quantum (`1.50`, `1E+3`, `Infinity`).

### Standard library

`internal/bid` is the one kernel.
The runtime, `strconv`, `math`, `testing/quick`
and the compiler's constant encoding go through it directly,
and `hash/maphash` through the runtime's hasher.
The other packages use the public API
of the new types (operators, `reflect`, `strconv`).
`TestNoBIDStrawman` in `internal/bid` parses every non-test Go file
under `src` and `test` and fails on BID encoding logic
outside the kernel, with six files allowlisted, each for a stated reason.
It runs in `all.bash`.

### Bootstrap

The minimum bootstrap toolchain is upstream's, go1.26.0,
and this repository's CI bootstraps with go1.26.
`internal/bid` operates on bit patterns and has no decimal-typed signatures,
so the bootstrap compiler can compile it,
and it is in the list of packages `cmd/dist` copies for the compiler.
The implementation uses `//go:build !compiler_bootstrap` tags
on `internal/bid/float.go`, `cmp/ordered.go` and `sort/sort_decimal.go`
to ensure that the bootstrap compiler
(which does not know about decimal types)
can still build the new compiler.
Packages that are only compiled by the new compiler
(e.g., `reflect`, `fmt`) do not need build tags.

### Testing

Each of these ran green at the commit above.

- **Oracle.** `TestKernel` compares the kernel with an exact reference model
  in `internal/bid`'s external tests, built on `math/big`.
  It reports no mismatch at 10^6 cases per operation and width,
  in three operand regimes.
  It runs at that size in this repository's CI on linux/amd64,
  and at 10^5 in the package's ordinary test run.
- **Conformance suite.** `TestConformance` runs 4,168 vectors over
  88 functions in `internal/bid/testdata`,
  written from the package contract and the standard
  without reading the kernel or the oracle.
  All pass against the kernel, and `TestConformanceReference` holds
  the oracle to the same vectors.
  It runs in `all.bash`, and in CI on linux/amd64, 386 and js/wasm.
- **Worked examples.** `TestContractExamples` checks each
  example in the package documentation against both the kernel and the oracle.
- **Published vectors.** The decTest and Intel `readtest.in` vectors
  are a local check and stay out of the tree;
  `TestNoPublishedVectors` enforces that.
  The kernel passes 21,405 decTest vectors and 58,027 Intel vectors
  with no failures.
  Another 114,045 are skipped, each with a named reason,
  such as other formats, non-IEEE operations and named divergences.
  The runner is one file that will be deleted before a CL series.
- **Allocation.** `TestAllocs` asserts that every exported function of the
  kernel, at both widths and in six rounding modes,
  allocates nothing on operands that reach the slow paths.
- **Through the language.** `test/decimal.go`, `test/decimal_const.go`,
  `test/decimal_const_overflow.go`, `test/decimal_map.go` and
  `test/decimal_print.go` cover operators, rounding, quantum through
  inexact arithmetic, overflow ties, subnormals, constants, map keys and
  printing.
  The audit's oracle in [`tests/oracle`](tests/oracle),
  run through the language's operators, reports no mismatch
  at 10^5 cases per operation and width.
  It is run by hand.
  Its two reproducers are also compared in the playground's browser journey.
- **Standard library.** Tests in each modified package.

Not yet covered: decimal behaviour through the language on 32-bit targets;
the kernel on a big-endian target, where its tests compile but have not run;
`all.bash` on any platform other than darwin/arm64;
and the constant model, which doesn't exist yet.

### Performance

The implementation is pure Go with no assembly fast paths.
These are medians from the kernel's benchmark baseline on an Apple M4 Max,
[`src/internal/bid/testdata/bench_baseline_darwin_arm64.txt`](https://github.com/marcelocantos/go/blob/decimal/src/internal/bid/testdata/bench_baseline_darwin_arm64.txt).
**The baseline is provisional.**
It was taken on 2026-10-31 on a machine shared with other builds,
at a load average between about 18 and 31,
and it is to be retaken on a quiet machine.
The kernel's code has not changed since.
Treat the figures as indicating magnitude only.
linux/amd64 has not been measured.

| Operation | decimal64 | decimal128 | float64 |
|-----------|-----------|------------|---------|
| Add, subtract | 11 ns | 17 ns | 1 ns |
| Multiply | 11 ns | 23 ns | 1 ns |
| Divide | 12 ns | 33 ns | 1 ns |
| Fused multiply-add | 17 ns | 31 ns | 1 ns |
| Less than | 7 ns | 9 ns | 1 ns |
| Convert from `float64`, typical | 13 ns | 21 ns | |
| Parse, short string | 20 ns | 16 ns | 13 ns |
| Format to a buffer | 13 ns | 23 ns | 24 ns |

Every row includes a benchmark loop floor of about 0.9 ns,
which is nearly all of the `float64` arithmetic rows,
so the table does not give a meaningful ratio against hardware `float64`.
The figures are for the kernel's functions;
operators reach them through a runtime wrapper,
whose cost has not been measured separately.
`fmt` has no row.
Slow paths cost more:
converting the largest `float64` takes about 0.4 µs.

The arithmetic allocates nothing:
`TestAllocs` asserts that for every exported kernel function,
and every row of the baseline reports zero allocations.
For comparison, library-based decimal types
typically allocate on every arithmetic operation
(`shopspring/decimal` uses `*big.Int` internally).

The kernel has not been profiled or tuned for speed.

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
once the constant model and the API in
[Design decisions](#design-decisions) are in place.
The author is willing to break it into smaller,
reviewable CLs and work with the Go team
on any design adjustments.

A detailed [roadmap](ROADMAP.md) describes the work
required to take the implementation from its current state
to production readiness, including the constant model,
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

2. **Decimal literal suffix** (not proposed, recorded for discussion):
   because the default type of a floating-point constant is `float64`,
   `fmt.Println(1.10)` prints `1.1`.
   A suffix giving a floating-point constant a decimal default type,
   by analogy with the imaginary suffix `i`
   (whose constants default to `complex128`),
   would let `fmt.Println(1.10d)` print `1.10`.
   C# has exactly this (`1.10m`). It is new syntax, so it is left out
   of this proposal; the quantum attribute makes it a small addition
   later if there is demand.

3. **Performance tuning**: The kernel is pure Go
   and has not been profiled or tuned, and its benchmark baseline
   is provisional and covers darwin/arm64 only (see [Performance](#performance)).
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

5. **`encoding/json/v2`**: Upstream's `jsonv2` experiment is on by
   default at the fork's merge base, so `encoding/json` runs on
   `encoding/json/v2` there.
   The fork adds decimal marshalers and unmarshalers to `encoding/json/v2`
   and patches `v2_inject.go` to recognize decimal kinds as numeric.
   `encoding/json/v2` has no decimal tests of its own;
   the decimal tests in `encoding/json` run through it.

6. **AI-assisted implementation**.
   This implementation was developed with extensive use
   of agentic AI.
   The AI was directed by the author
   and was instrumental in producing the volume of code
   in a short time frame.
   The generated code did not receive detailed human review
   when written.
   On 2026-10-27 an independent review with a current-generation model,
   an exact-arithmetic oracle, and hand-verified reproducers
   ([report](docs/audits/deep-dive-2026-10-27.md))
   found defects including an arithmetic kernel that was wrong on
   ordinary inputs.
   The kernel has since been rewritten with an oracle and conformance suite
   written separately from it,
   and reviewed by two AI reviewers that did not write the code they reviewed
   ([report](docs/audits/kernel-review-2026-10-31.md)).
   These reviews were done by AI models, not by people.
   The compiler's constant handling still needs the design in
   [Design decisions](#design-decisions) item 1.
   The author welcomes help from the community.
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

8. **NaN payloads**.
   Decimal arithmetic returns a canonical NaN, dropping the payload and sign.
   On darwin/arm64, a `float64` NaN with payload `0x123`
   keeps that payload through `x + 1`.
   Go doesn't promise this for floats, but IEEE 754-2008 recommends it,
   so the principles in [Design decisions](#design-decisions)
   favour propagating payloads, and design decision 4 is the place to change.
   This is undecided.

## Acknowledgements

This design document builds on
[#19787](https://go.dev/issue/19787),
originally proposed by Mura Li ([@typeless](https://github.com/typeless)) in 2017.
The discussion on that issue, spanning fifty comments over nine years,
shaped the direction of this proposal —
in particular the argument for built-in types over a library
and the focus on IEEE 754 conformance.
Thanks to all who contributed to that discussion.
