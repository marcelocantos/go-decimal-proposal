# Proposal: Add decimal floating-point types

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Design document: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-11-03 (proposed revision)

Discussion at [#19787](https://go.dev/issue/19787)

Related issues: [#82668](https://go.dev/issue/82668), [#12127](https://go.dev/issue/12127), [#19770](https://go.dev/issue/19770), [#26699](https://go.dev/issue/26699), [#9455](https://go.dev/issue/9455)

## Abstract

We propose adding two new built-in numeric types to Go:
`decimal64` and `decimal128`,
following IEEE 754-2019 decimal floating-point arithmetic,
in software on most targets
and in hardware on the IBM targets Go already supports
([design decision 10](#design-decisions)).

These types use the same operator syntax as `float32` and `float64`:
they support arithmetic operators (`+`, `-`, `*`, `/`),
comparison operators (`==`, `!=`, `<`, `<=`, `>`, `>=`),
and participate in Go's existing constant and type system.
No new syntax is introduced.
No new constant kind is introduced.
No new operators are introduced.
Real numeric constants gain an optional *quantum* attribute
(the exponent that distinguishes `1.50` from `1.5`),
used in decimal conversion and typed decimal constant arithmetic.
Untyped constant values and their default types remain unchanged.

The primary motivation is financial and business software,
and anywhere else quantities are stipulated in decimal:
prices, rates, taxes, tariffs and regulated limits.
There, base-10 arithmetic is essential for correctness,
and a library decimal type, excluded from Go's operators,
constants and equality, is inadequate for the code that handles them.

Both this document and the accompanying implementation
were largely produced with the assistance of agentic AI,
with human direction.
The implementation is a fork of Go,
and it can be run in the [playground](https://marcelocantos.github.io/go-decimal-proposal/).
It exists to run the playground and to make questions about the design
concrete. It is not currently offered as the proposed implementation
and shouldn't be evaluated as one.
Its arithmetic is one kernel, `internal/bid`,
checked against an exact reference model,
an independently written conformance suite and published test vectors.
GDB shows decimal values through a printer in Go's GDB support script;
Delve has no decimal support yet. Default formatting and wire formats
are implemented, with the exceptions described below, including SQL output
that loses positive quantum and text that does not retain NaN payloads.
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
- **IEEE 754-2019**: https://standards.ieee.org/ieee/754/6210/
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
  Marginally harder: two new predeclared type names,
  and the quantum, which is what decimal users already know
  as trailing zeros (`1.50` is not written `1.5`).
  Developers who don't need decimal types can ignore them,
  just as most Go programmers never use `complex64` or `complex128`.
  Developers who do will find the types immediately familiar:
  they work like `float64`, with operators and constants.

- **Has this idea, or one like it, been proposed before?
  If so, how does this proposal differ?**
  Yes. [#19787](https://go.dev/issue/19787) (2017) proposed decimal types
  but had no implementation.
  [#12127](https://go.dev/issue/12127) proposed a `math/big.Decimal` library type.
  [#19770](https://go.dev/issue/19770) requested operator overloading
  specifically to enable decimal libraries.
  This proposal supplies a compiler prototype and playground,
  proposed rules for constants, quantum and formatting,
  and by proposing built-in types rather than a library.

- **Who does this proposal help, and why?**
  Developers building financial, e-commerce, accounting,
  and database-backed software — see [Who needs this](#who-needs-this).
  `shopspring/decimal` alone has over 40,000 importing packages,
  and many more programs use integer-cents workarounds.

- **What is the proposed change?**
  Two new predeclared types (`decimal64`, `decimal128`)
  with the same operator set as `float64`.
  See [Proposal](#proposal) for the precise specification
  and [Language spec changes](#language-spec-changes) for verbatim spec text.

- **Is this change backward compatible?**
  Yes, by design. The new `reflect.Kind` and `go/types.BasicKind` values
  are appended, so no existing value changes, and the types require
  `go1.28` in `go.mod` and `GOEXPERIMENT=decimal`;
  see [Compatibility](#compatibility).
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
    `go/types` (done, including typed decimal constant folding).
    Third-party tools that exhaustively switch on `reflect.Kind`
    or `go/types.BasicKind` will need updates;
    see the [roadmap](ROADMAP.md) for details.
  - **Compile time cost:** Not measured. Constant propagation, folding
    and export data need measurement through the compiler.
    Export data carries each floating-point constant's quantum,
    a small integer alongside the exact value `go/constant` already holds.
  - **Run time cost:** No decimal arithmetic cost is intended for programs
    that do not use it; broad regressions have not been measured. Code size
    is affected:
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
    The design decisions are implemented, apart from debugger support,
    so the branch can be split into reviewable CLs.
    See [Implementation status](#implementation-status)
    and the [roadmap](ROADMAP.md).

- **Can you describe a possible implementation?
  Do you have a prototype?**
  A compiler prototype exists; [Implementation](#implementation) identifies
  its pinned revision. It changes the arithmetic kernel, compiler, runtime,
  reflection, formatting, codecs, SQL conversion and generic constraints.

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
  with decimal-specific equality, hashing and representation rules.
  `go/constant` carries the quantum, both type checkers agree on typed
  decimal rounding, and export data carries the quantum across packages.

- **Is the goal of this change a performance improvement?**
  No. The goal is correctness for base-10 arithmetic.
  See [Performance](#performance) for benchmark data.

- **Does this affect error handling?**
  No. As with `float64`, an operator can't return an error,
  so division by zero and overflow produce infinity or NaN,
  and a calculation can be checked once at the end.
  Business rounding is explicit, through `Quantize`.

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

Decimal arithmetic matters wherever a quantity is stipulated rather than
measured: someone wrote it in base 10 in a contract, a law, a tariff or a
standard, and the digits, the rounding and the trailing zeros are part of
what was agreed. Money is the largest case, and the percentages and rates
applied to it are the next. These communities need it routinely:

- **Banking and finance.**
  Calculations must match the results a human would get with pen and paper.
  Rounding a half-cent the wrong way causes reconciliation failures at scale.

- **E-commerce, billing and tax.**
  Prices, tax rates, discounts, metering and payment processing
  all operate in base 10.

- **Databases.**
  SQL `DECIMAL` and `NUMERIC` types are base 10.
  PostgreSQL, MySQL, Oracle, SQL Server, MongoDB (decimal128)
  and CockroachDB all use decimal representations.
  Go programs that work with them convert through strings
  or a library type.

- **Accounting and ERP systems.**
  `price * quantity * tax_rate` must produce the decimal result
  that Excel, COBOL and other business tools produce.

- **Regulated measurement.**
  Clinical results, pharmacopoeia limits and food labelling
  define their rounding rules on decimal digits,
  and `1.50` and `1.5` claim different precision.

- **Data interchange.**
  [Apache Arrow](https://arrow.apache.org/docs/format/Columnar.html#decimal) defines `Decimal128` and `Decimal256`.
  [BSON](https://bsonspec.org/spec.html) (MongoDB) has a `decimal128` type.
  The IETF ["Structured Field Values for HTTP" (RFC 8941)](https://www.rfc-editor.org/rfc/rfc8941)
  includes a decimal type.

The demand is not hypothetical.
[`shopspring/decimal`](https://github.com/shopspring/decimal)
alone had 40,713 importing packages on pkg.go.dev on 3 November 2026,
and `cockroachdb/apd`, `ericlagergren/decimal` and others add more.
[#19787](https://go.dev/issue/19787) has been open since 2017.
According to the
[2025 Go Developer Survey](https://go.dev/blog/survey2025),
13% of Go developers work in financial services.

These numbers understate the demand.
Many Go developers avoid decimal libraries entirely
and store money as `int64` cents,
a workaround that is pervasive in blog posts, forum answers and guides.
Libraries such as [`Rhymond/go-money`](https://github.com/Rhymond/go-money)
and [`robaho/fixed`](https://github.com/robaho/fixed)
exist to formalize that pattern,
and the Stripe Go SDK uses `int64` minor units for every amount.
These developers need decimal arithmetic
and have concluded that library decimals cost too much to use.
A built-in type with operators and constants
lets them write what they mean.

### Why a library is inadequate

A library can compute decimal arithmetic.
`shopspring/decimal` does today, and [#82668](https://go.dev/issue/82668)
proposes a careful `math/decimal` for the standard library.
The question is not whether Go can compute in base 10.
It is whether decimal numbers get to be numbers in Go,
with operators, constants and equality,
or remain values that programs call methods on.
Go reserves those for its predeclared types,
so every library pays the same price, however well it is designed.
This section argues that the price is too high,
and that it lands on exactly the code that can least afford it.

#### What a library can't do

- **Operators.**
  `price * qty * (1 - discount)` becomes
  `price.Mul(qty).Mul(One.Sub(discount))`.
  Precedence is gone from the page,
  and the reader must reconstruct the intended formula in their head.
- **Constants.**
  A library's constants are strings parsed at init
  (`decimal.MustParse("0.20")`),
  with no compile-time check and a run-time failure mode,
  and the literal `0.20` typed from habit is silently a `float64`.
  With a built-in type, `var vat decimal64 = 0.20` is checked when it is compiled,
  under the untyped-constant rules the spec already has.
- **Constant expressions.**
  Finance code is full of constants derived from other constants:
  `const gross = 1 + vat`, `const daily = annual / 360`,
  `const eurPerDem = 1 / 1.95583`.
  An untyped constant expression is evaluated exactly
  and rounded once, on conversion to a decimal type,
  so `daily` is correctly rounded at either width from one declaration.
  A library computes such values at run time
  and keeps them in package-level variables
  that are mutable and depend on initialization order.
- **Equality.**
  A struct compares field by field, so every library faces a dilemma.
  [`woodsbury/decimal128`](https://github.com/woodsbury/decimal128),
  a careful fixed-size IEEE 754 implementation,
  is `struct { lo, hi uint64 }`: `==` compiles,
  reports `1.5 != 1.50`,
  and reports a NaN equal to itself, because its fields are integers.
  [#82668](https://go.dev/issue/82668) takes the other choice
  and disables `==` with a `_ [0]func()` field,
  so its `Decimal` can't be a map key,
  can't be a field of a comparable struct,
  and can't be compared with `==` at all.
  Numeric equality across a cohort, where `1.5 == 1.50`
  and each keeps its own digits, is something only the language can define.
- **Ordering and generics.**
  `cmp.Ordered` is a fixed set of predeclared types,
  so no library decimal satisfies it.
  `slices.Sort`, `min`, `max`, `slices.Max`
  and every generic numeric function written against `cmp.Ordered`
  are closed to it.
- **IEEE 754 behaviour.**
  A library can define NaN and infinity as values,
  but not their behaviour under `==` and `<` or as map keys,
  so a library NaN either equals itself or can't be compared at all.
  [#82668](https://go.dev/issue/82668) leaves the special values out.
- **Decimal hardware.**
  IBM's POWER and Z processors do decimal arithmetic in silicon,
  and Go already runs on both.
  A built-in type lets the compiler make `a + b` one instruction
  with its operands in registers, as it does for `float64`.
  See [Native decimal hardware](#native-decimal-hardware).

These gaps belong to the language, not to any library.
#82668's disabled `==` and string constants are where Go leaves every
decimal library, however it is designed.

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
and store money as `int64` cents.

Cents can be perfectly correct, and they go wrong easily.
A forgotten multiply or divide by 100 compiles, runs
and returns a plausible number.
Nothing fails, so the error surfaces only when someone spots the wrong amount.
It's a recurring class of bug: code that assumed every currency
has two decimal places
[charged 300,000 yen for a 3,000-yen item](https://www.drupal.org/project/commerce_stripe/issues/2913605)
in testing.
`int64` also runs out of room sooner than it appears to.
A calculation that carries amounts to eight decimal places
and rates in parts per million overflows a balance-times-rate product
at a balance of about $1.8 million,
and Go's integer overflow wraps silently.

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
no new operators and no new literal syntax.
If complex earned a place as a built-in kind,
decimal's claim is stronger:
it has far more users,
and the bugs it prevents are in their money.

Other languages have made the same call.
C# put `decimal` in the language in 2002,
and it is among its least controversial features.
C23 added `_Decimal64` and `_Decimal128` as built-in types
rather than as a library,
in a language with no shortage of libraries.
COBOL has had native decimal arithmetic since 1959,
and it is one reason COBOL still runs the systems
that Go is now asked to replace.

#### What adoption needs

A library rarely becomes the default; a built-in type does.
It will appear in the Tour,
in `database/sql` and in drivers' mappings for `NUMERIC`,
in the output of `sqlc` and other generators,
and in the tutorials that today teach `int64` cents.
A new type changes what Go programs do in a way that
a package is unlikely to achieve.

A built-in type also ends the fragmentation that
[@typeless](https://github.com/typeless) described on
[#19787](https://go.dev/issue/19787):
a pricing package built on one decimal library
and a ledger package built on another
can't exchange values without a string.
One type in the language is a standard that every package shares;
a library, however good, is one more contender.

A type also carries a weight that no library can.
A language's predeclared types are its statement of what it is for:
`chan` and `map` said that Go was built for servers,
`complex128` said that numerical work was in scope,
and nothing in Go today says money.
A library says a problem is supported;
a built-in type says the language was designed for it,
and that is how it is read by the people choosing a language
for a bank, an exchange or a payments platform.
C#'s built-in `decimal` is part of why C# is taken for granted
as a language for financial systems.

That audience is deciding now.
Teams moving systems off COBOL and off Java are evaluating target
languages, and both of those languages answer
"how do I do money?" without a workaround.
A language that answers "import a package and write `.Mul`"
loses that comparison before the rest of its merits are heard.
Built-in decimal types won't single-handedly win the finance sector,
but they will move it in Go's direction in a way that a library won't.

#### The decision is one-way

Go doesn't ship two answers to one question.
Once code, drivers and tutorials are written against
a decimal struct in the standard library,
a built-in type would have to justify itself as a second way
to do the same thing, a bar it would very likely never clear.
Adopting [#82668](https://go.dev/issue/82668) is therefore
not a smaller step toward decimal types;
it is very likely a decision that Go will never have them.
That may be the right decision,
but it should be made as that decision.
Third-party arbitrary-precision libraries are not affected either way:
they serve different needs and coexist with built-in types,
as `math/big` coexists with `int64`.

#### The cost

The language change is paid by the Go team:
a numeric kind threaded through the specification, the type checkers,
the compiler, the runtime and the standard library,
built and maintained once
(see [Implementation](#implementation)).
The fork shows the extent of that work.
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
  fixed-size IEEE 754 decimal128.
- [`migueldecimal128/decimal128-go`](https://github.com/migueldecimal128/decimal128-go),
  fixed-size IEEE 754 decimal128, verified against decTest,
  IBM Haifa's FPgen and Intel's test vectors.
- [#82668](https://go.dev/issue/82668),
  a proposed `math/decimal` with value semantics and a fast path.
  It is the strongest form of the library answer.
  Its disabled `==` and string constants are the shape the language forces on it;
  omitting the IEEE special values and allowing unbounded scale
  are its own choices.

The fixed-width libraries show that an IEEE decimal library can be built well in Go,
and they still have every gap listed above,
because the gaps belong to the language, not to the library.

### Precedent in other languages

**C23** added `_Decimal32`, `_Decimal64`, and `_Decimal128`
as built-in types (TS 18661-2).
These are the closest precedent to this proposal:
fixed-size, IEEE 754, operator support,
and part of the core language rather than a library.
Like this proposal, C23 leaves the in-memory encoding to the implementation;
GCC uses BID on x86 and Arm and DPD on IBM hardware.
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
This proposal's use of IEEE 754 gives it a standard interchange format
shared with databases, wire formats and other languages.

**Java** has `java.math.BigDecimal` (arbitrary precision, library type).
It is widely regarded as verbose and error-prone
because of method-call syntax:
`a.multiply(b).add(c.multiply(d))` instead of `a*b + c*d`.
Java's `BigDecimal` is the cautionary example
of decimal arithmetic without operator support,
and it is the situation Go users face today.

**Python** has `decimal.Decimal` (library type, configurable precision).
Python's operator overloading makes it ergonomic (`a * b + c`),
but the type is not built-in:
it requires an import and explicit construction from strings
(`Decimal("0.1")` rather than a literal).
Python's approach works well for Python
but is not available to Go,
which has no operator overloading.

**SQL** defines `DECIMAL`/`NUMERIC` as built-in types
with configurable precision and scale.
Every major database engine implements these natively.
Go programs that work with SQL databases
round-trip decimal values through strings or a library type;
built-in decimal types allow direct scanning.

**COBOL** has packed decimal as a core data type,
reflecting its origin in business computing.
COBOL remains dominant in financial systems
in part because decimal arithmetic is first-class.

### IEEE 754-2019 encodings

IEEE 754-2019 defines two encodings for decimal floating-point:

- **DPD** (Densely Packed Decimal): packs three decimal digits
  into 10 bits. IBM's decimal hardware operates on it.
- **BID** (Binary Integer Decimal): stores the coefficient
  as a binary integer, which ordinary integer instructions
  manipulate directly. Software implementations favour it.

Both encode the same values, signs and quanta.
The in-memory form is not part of the language:
each target uses the encoding its arithmetic works on,
XORed with the encoding of `0E+0` so that all bits clear means zero
(see [Design decisions](#design-decisions) items 9 and 10).
The `bits` functions and wire formats exchange one encoding on every target,
so stored data and streams are portable.

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
   the 2x storage difference may matter. Workload measurements are needed
   to show whether it justifies supporting both widths.

2. **Consistency with IEEE 754.**
   Go already provides both `float32` and `float64`.
   Providing both `decimal64` and `decimal128`
   follows the same pattern.

3. **Marginal implementation cost.**
   Sharing the kernel reduces duplicated work. Each width still needs
   its own boundary tests, ABI support and public API coverage.
   The compiler, runtime, and standard library changes
   handle both sizes through the same code paths.

We do not propose `decimal32` because its 7-digit precision
is too limited for most practical applications.

### Quantum preservation

IEEE 754 decimal types can retain trailing zeros in their representation,
subject to coefficient and exponent limits.
The values `1.0`, `1.00`, and `1.000` are numerically equal
but have distinct representations (different "quanta").
This is meaningful in financial contexts:
a price quoted as `"1.50"` should be formatted as `1.50`,
not `1.5`.

This proposal preserves quantum through:

- **Constants.** Real constants may carry a quantum
  attribute alongside its exact value (see [Constants](#constants)).
  `decimal64(1.50)`, `var d decimal64 = 1.50`,
  and `const c = 1.50; var d decimal64 = c` all yield `1.50`,
  in the declaring package or any other.
  `x := 1.50` does not, because the default type of a
  floating-point constant remains `float64`,
  which has no quantum to receive.
- **Formatting.** Decimal values print with their quantum by default:
  `fmt.Println(d)` prints `1.50`,
  and default text preserves value, sign and quantum for canonical finite
  values when parsed at the same width. NaN payloads and noncanonical
  encodings are not preserved by text.
  This is the decimal analogue of the shortest-round-trip rule
  that `%v` applies to binary floats.
  `decimal.Reduce(d)` strips trailing zeros for callers who want `1.5`.
- **Parsing.** `strconv.ParseDecimal("1.50", 64)` preserves the quantum.
- **Comparison.** `1.50 == 1.5` is true (numeric equality),
  but the formatting difference is preserved.
- **Map keys and hashing.** Values with different quanta
  but the same numeric value are treated as equal map keys,
  through numeric equality and normalization in the hash function.
  Updating an equal key can replace its stored representation: inserting
  `1.50` and then assigning with `1.5` can yield `1.5` when ranging the map.
  A NaN key cannot be retrieved by an ordinary lookup, even with itself.
  Applications that need representation identity need a separate key.

Crucially, quantum is not merely preserved through storage;
it follows the IEEE 754-2019 preferred-exponent rules through arithmetic.
For an exact result, multiplication adds the exponents of the operands:
`decimal64(1.50) * decimal64(1.20)` produces `1.8000`.
Addition and subtraction use the smaller exponent:
`decimal64(1.5) + decimal64(0.10)` produces `1.60`.
For a representable exact quotient, division uses the preferred exponent
(the difference of the operands' exponents) if it fits. Otherwise it chooses
the nearest exponent that represents the quotient within the format limits: `decimal64(1.00) / decimal64(4)` is `0.25`.
An inexact result is rounded to the full precision of the type
(16 or 34 digits), as IEEE 754 requires:
`decimal64(1) + decimal64(1e-20)` is `1.000000000000000`.
Quantum records a representation, not measurement certainty or business policy.
Multiplication can add unwanted display places, and rounding can discard
digits silently. Even an exact addition can require a coarser quantum:
`99999999999999.99 + 0.01` in decimal64 produces `100000000000000.0`.
Use explicit quantization for stored business scale and formatting for display.
The zero-value accumulation issue is fixed: `var total decimal64;
total += 19.99` gives `19.99`. This requires the XOR memory encoding in
[design decision 9](#design-decisions), whose debugger support is unfinished.

### What does success look like?

This proposal succeeds if:

- Financial and business Go code can use `decimal64` and `decimal128`
  with the same ease and fluency as `float64`,
  using operators, constants, and standard formatting.
- Database drivers map SQL `DECIMAL`/`NUMERIC` columns
  to native Go types within their range, eliminating string round-trips.
- JSON APIs can round-trip decimal numbers of up to 34 digits
  without loss.
- The ecosystem converges on the built-in types,
  reducing fragmentation across `shopspring/decimal`,
  `cockroachdb/apd`, and other libraries.
- Above all, Go becomes a natural choice for financial software,
  alongside C#, COBOL, and SQL,
  rather than an outlier that requires workarounds.
  Today, teams building financial systems in Go
  must accept awkward ergonomics or choose another language.
  Built-in decimal types remove that barrier.

A value is exact when it is an integer coefficient of at most
16 or 34 digits times a power of ten in the format's range.
Within that envelope, which `decimal128` makes very large,
these types are exact; beyond it they round, as IEEE 754 specifies.

## Proposal

### New types

Two new predeclared types are added:

```
decimal64       the set of all IEEE 754-2019 64-bit decimal floating-point numbers
decimal128      the set of all IEEE 754-2019 128-bit decimal floating-point numbers
```

These are decimal floating-point types.
Together with the existing `float32` and `float64`,
they form the set of floating-point types in Go.

### Operators

The following operators work with decimal types,
using IEEE decimal arithmetic and comparison:

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
A real numeric constant may carry an optional decimal exponent alongside its
value. The attribute affects decimal conversion and typed decimal arithmetic,
not comparisons, default types or existing nondecimal arithmetic.
`1.50` has value 3/2 and quantum −2; `150` has quantum 0;
`1.5e3` has quantum 2.

For untyped arithmetic, “finite decimal expansion” must be distinguished from
“exact rational value”. `1.0 / 3.0` is the exact rational 1/3; it has no finite
decimal expansion and no quantum. It is not rounded until conversion.

The following table gives the propagation rules.
The fork implements them, and its tests cover each row.
Here `q(x)` denotes a present quantum.

| Constant form | Quantum rule |
|---|---|
| Decimal floating literal | Exponent part minus the number of fractional digits. |
| Integer literal of any radix, rune literal, `iota`, integer-valued constant built-ins such as `len` | Zero. Repeated `const` expressions are evaluated anew with the current `iota`. |
| Hexadecimal floating literal | Absent. |
| Comparisons and other nonnumeric results | No quantum. |
| Naming, parentheses, export/import | Preserve the attribute, including multiple-name declarations. |
| Unary `+` and `-` on a real constant | Preserve the attribute. Zero has no sign in the constant system. |
| Untyped real `+` or `-`, with both quanta present | Use the smaller quantum. |
| Untyped real `*`, with both quanta present | Add the quanta. |
| Non-integer untyped real `/`, with both quanta present | If the quotient has a finite decimal expansion, use the largest exponent no greater than `q(x)-q(y)` at which its coefficient is integral. Otherwise the attribute is absent. For a zero quotient use `q(x)-q(y)`. |
| Typed integer arithmetic, integer division, remainder, bitwise operations, integer shifts | Use quantum zero for the integer result. A shift has no IEEE decimal preferred-exponent rule. |
| Other real arithmetic with an absent operand quantum | The result has no quantum. |
| Conversion to an integer type | Use quantum zero for a legal conversion. |
| Conversion to a binary floating type | Discard quantum; a later decimal conversion starts from the rounded binary constant value. |
| Complex literals, complex arithmetic, `complex`, `real`, `imag` | No quantum is retained or recovered, even when the resulting value is real. |
| `min` or `max` on real constants | Use the selected operand's quantum; for equal values use the first such operand. |
| Decimal conversion or typed decimal operation | Use the rules below; the resulting representable value carries its format exponent. |

**Decimal conversion.** Round the value to the destination's precision,
with ties to even; overflow is an error. For an exact conversion, retain
the supplied quantum if the coefficient fits the format's precision.
Otherwise use the exponent closest to the quantum, as parsing does at run
time. A constant without a quantum takes exponent zero if it is an integer
that fits, and otherwise the smallest coefficient that holds its value. An inexact
conversion uses the precision and exponent required by rounding, including
trailing zeros in its coefficient. Underflow may produce zero.
A decimal-to-decimal constant conversion starts from the already rounded
value and its quantum, not from its original source spelling.

The intended cross-package behavior is:

```go
// package prices
const Base, Other = 1.50, 2.00
const Twice = Base * 2
const Third = 1.0 / 3.0

// in an importing package
var p decimal64 = prices.Base  // 1.50
var q decimal64 = prices.Twice // 3.00
var n decimal64 = -prices.Base // -1.50
var r decimal64 = prices.Third // 0.3333333333333333
```

Both type checkers, export/import and the compiler must agree on value and
quantum for every row. An accessor alone does not establish that agreement.

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
by analogy with the imaginary suffix `i`, is deliberately left out
([design decision 11](#design-decisions)).

**Typed constants and representability.**
Typed decimal constant expressions are constant expressions.
Each operation on typed decimal constants is rounded to the type's precision,
as `go/types` and `cmd/compile` do for typed `float32` and `float64` constants,
so finite nonzero results are intended to agree with the same sequence
of rounded run-time operations. Constants retain Go's restrictions:
division by zero and nonfinite results are errors, and a constant zero
converts to positive zero. Run-time IEEE operations can instead produce
NaN, infinity or negative zero. Quantum is retained for constant zero,
but its sign is not. These are explicit exceptions to run-time parity.
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
as IEEE 754-2019 specifies:
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
and `AppendDecimal`, with roles similar to the float functions.
The text grammar is not identical: `ParseDecimal` currently rejects
underscores and hexadecimal text; Go literal syntax is separate.
The formatting precondition for `bitSize == 64` is that `d` is an exact
widening of a decimal64 value. `AppendDecimal` currently ignores `bitSize`
under that precondition; it does not perform a narrowing conversion.
Use an explicit decimal64 conversion before formatting at that width.
The supported widths are 64 and 128; invalid-width behavior still needs
an explicit API contract and tests.
`ParseDecimal` returns `ErrRange` for values outside the type's range
and rounds, rather than truncates, excess digits.
With `prec` of −1 the output has every digit of the coefficient.
With `g` it is the canonical string:
the coefficient digits with the quantum preserved,
in exponent form when the adjusted exponent is below −6
or at or above 21, as JSON does for floats,
or when the quantum is above the units digit,
which fixed notation can't show: `1e+03` is not `1000`.

**`fmt`**: Decimal types support the `v`, `e`, `E`, `f`, `F`, `g`, `G` verbs.
`%v` and `%g` without a precision print the canonical string
(`1.50` for a value with quantum −2).
A precision quantizes the output as it does for floats:
`%.2f` of `1.5` is `1.50`. This changes the text, not the stored value.
Default round-trip guarantees cover canonical finite encodings, including
signed zero, not NaN payloads, signaling state or noncanonical encodings.
For example, a NaN with bits `7c00000000000123` formats as `NaN` and
parses as `7c00000000000000`.
The `#` flag keeps its float meaning.

**`math`**: `Decimal64bits`, `Decimal64frombits`,
`Decimal128bits`, `Decimal128frombits`, mirroring `Float64bits`.
Nothing else is added to `math`.

**`math/decimal`** (new package): functions generic over
`Decimal interface { ~decimal64 | ~decimal128 }`:
`Abs`, `Ceil`, `Floor`, `Trunc`, `Round`, `RoundToEven`,
`Quantize`, `SameQuantum`, `Reduce`, `FMA`, `Mod`, `Remainder`,
`Copysign`, `Signbit`, `Dim`, `NaN`, `Inf`, `IsNaN`, `IsInf`,
and `QuantizeMode`, which quantizes with an explicit `RoundingMode`
for the directed and half-away modes that the operators do not provide.
Each function computes in the format of its type argument.
The exact set is open to review;
the point is that the forty-odd helpers live in one package
named for the types rather than doubling the surface of `math`.

**`reflect`**: `Decimal64` and `Decimal128` added to `Kind`,
appended after `UnsafePointer`; no existing `Kind` value changes.
`Value.Decimal()`, `Value.SetDecimal()` and `Value.CanDecimal()` methods.
`Value.IsZero` and `reflect.DeepEqual` compare numerically,
so `0.00` is zero and `1.0` equals `1.00`.

**`encoding/json`**: Marshal as a JSON number using the canonical string,
so `1.50` round-trips as `1.50`; unmarshal preserves value and quantum
when both fit the destination format. Excess precision is rounded.
JSON syntax alone supplies no such precision or range bound. String tag support. NaN and infinities are an error,
as for floats.
See [open issue 6](#open-issues) regarding `decimal128`
as a possible bounded option for JSON number decoding.

**`encoding/binary`**: Read/write decimal types as their IEEE 754
interchange encoding (8 or 16 bytes) in the requested byte order,
most significant word first for `BigEndian`.

**`encoding/gob`**: Encode/decode decimal types using two of the
reserved built-in type ids; `decimal128` is written most significant
word first.

**`encoding/xml`**: Marshal/unmarshal decimal types using the canonical string.

**`database/sql`**: Scan decimal columns from strings, byte slices,
integers and floats.
The proposed `driver.Value` conversion uses the canonical string.
The current implementation uses fixed notation, losing positive quantum.
Scanning binary floats cannot recover the original decimal input, and SQL
values outside the destination's precision or range cannot round-trip exactly.
Driver and schema behavior need separate tests; column scale is not a
guarantee made by the Go type.

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

Alignment is target-dependent; size does not imply alignment.
The reviewed darwin/arm64 compiler aligns both types to 8 bytes.
No 16-byte alignment guarantee for decimal128 is proposed here.
The ABI matrix still needs verification on the other supported targets.

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
and can be used with generic functions whose type sets include them.
Existing custom numeric type sets do not acquire decimals automatically.
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
Typed decimal constants use the existing `constant.Float` kind.
Untyped values remain exact rationals; typed decimal operations round to
representable values, which can themselves be stored as exact rationals.
`go/constant` needs an accessor for optional quantum, for example
`Quantum(x Value) (exp int, ok bool)`, and propagation through its operations.
The type checkers apply typed decimal rounding. The table in
[Constants](#constants) specifies the proposed division of behavior.
Agreement between `go/types`, `cmd/compile/internal/types2`, export/import
and the compiler back end must be tested; sharing metadata is not proof
that they agree.

**`reflect.DeepEqual` and `reflect.Value.IsZero`.**
Use numeric comparison, not bitwise comparison,
so `decimal64(1.0)` and `decimal64(1.00)` are DeepEqual
despite having different bit representations,
and a value parsed from `"0.00"` reports `IsZero`.

### Language spec changes

The following changes to the
[Go language specification](https://go.dev/ref/spec)
are required. The type, comparison, conversion and size entries
are implemented in the [fork](https://github.com/marcelocantos/go/tree/decimal),
and so are the constant entries, which describe the design adopted on 2026-10-27.

**Numeric types.** Add after the `float32`/`float64` entries:

> ```
> decimal64   the set of all IEEE 754-2019 64-bit decimal floating-point numbers
> decimal128  the set of all IEEE 754-2019 128-bit decimal floating-point numbers
> ```
>
> The types `float32` and `float64` are binary floating-point types
> that use a base-2 representation.
> The types `decimal64` and `decimal128` are decimal floating-point types
> that use a base-10 representation as defined by IEEE 754-2019.
> Decimal floating-point types can represent decimal fractions exactly
> within their coefficient and exponent limits,
> unlike binary floating-point types
> where values such as 0.1 have no exact representation.
> Both binary and decimal floating-point types
> support the same arithmetic and comparison operators.

**Predeclared identifiers.** Add to the Types line:

> ```
> complex64 complex128 decimal64 decimal128 error float32 float64
> ```

**Constants.** Add to the Constants section:

> A real numeric constant may have an optional quantum: an integer
> recording a decimal exponent. Literal and expression propagation follow
> the table in [Constants](#constants). The attribute does not change the
> value of an untyped constant, its default type or its comparison behavior.
>
> An operation on constants of a decimal floating-point type rounds to
> that type with ties to even and uses the IEEE preferred exponent subject
> to the format's precision and exponent limits. Constant division by zero
> and results that would be nonfinite are illegal. A constant zero has no
> sign and converts to positive zero, retaining a representable quantum.
> Untyped arithmetic remains exact, including rational results without
> finite decimal expansions.

This is draft spec wording. The final edit should fold the propagation
table and the constant conversion rules into the spec's text on constant
expressions, alongside its sentence that they are evaluated exactly.

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
> the value is rounded to nearest, ties to even, at `T`'s precision.
> Overflow is illegal. An exact conversion retains the quantum if it fits;
> otherwise it uses the exponent closest to the quantum. A constant without
> a quantum has exponent zero if it is an integer that fits, and otherwise
> the smallest coefficient that holds its value. An inexact conversion
> uses the exponent required by precision and range, without reducing
> trailing zeros. Constant zero converts to positive zero.

**Floating-point operators.** Extend the paragraph on fused operations:

> This applies to both binary and decimal floating-point types.

**The zero value.** Add to the section on the zero value:

> The zero value of a decimal floating-point type
> is the result of converting the integer constant `0` to that type,
> and so has quantum 0.

**Comparison operators.** Add after the floating-point bullet:

> Decimal floating-point types are comparable and ordered.
> Two decimal floating-point values are compared
> as defined by the IEEE 754-2019 standard.

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
IEEE 754-2019 arithmetic is the starting point.
Integration should follow Go's binary floating-point conventions where they
fit. Quantum, constant restrictions, NaN policy and zero-value encoding
need explicit decisions rather than an appeal to that analogy.
The standing exception to the first principle is the environment IEEE assumes
around its operations: Go's floats have no status flags or dynamic rounding modes,
and decimal types don't add them.

1. **Constants carry quantum; untyped values stay exact fractions.**
   Untyped constants remain the exact rationals they are today.
   The propagation table in [Constants](#constants) defines where quantum
   is retained, reset or absent. Decimal conversion and typed decimal
   arithmetic consume it; other numeric behavior is unchanged.
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
   Reason: finite nonzero results should agree with the same sequence of
   rounded run-time operations. Constant zero signs, division by zero and
   nonfinite results have the exceptions stated in [Constants](#constants).
   The spec's sentence that constant expressions are always evaluated exactly
   does not describe what those type checkers do for typed floats,
   so the spec change above states the decimal rule explicitly.

   *Status:* implemented. `go/constant` carries the quantum and reports it
   through `constant.Quantum`. Both type checkers and the compiler encode
   decimal constants through one shared package, `internal/constdecimal`,
   which folds typed decimal operations through the kernel.
   Export data carries the quantum, so every row of the cross-package
   example above holds, and so do multiple-name declarations,
   negated named constants and `T(1.50)` for a type parameter `T`,
   while `T(float64(0.1))` converts from the `float64`.
   `const a = decimal64(1.50) * 2` is a constant with the value `3.00`
   in both type checkers.

2. **Default output preserves the quantum.**
   `%v`, `%g`, `String`, JSON, XML and `database/sql` print `1.50`
   for a value with quantum −2; `strconv.ParseDecimal` of that string
   returns the same value, sign and quantum for canonical finite values
   parsed at the same width. Text does not preserve arbitrary NaN payloads
   or noncanonical encodings.
   Reason: `%v` for floats prints the shortest string that round-trips
   the value; for a decimal the shortest string that round-trips the
   value and quantum is the coefficient with its exponent. This is an
   additional observable property, with the text exceptions stated above.
   It is also what IEEE 754's `convertToDecimalCharacter`,
   Java `BigDecimal`, Python `Decimal` and C# `decimal` do.
   Callers who want `1.5` apply `decimal.Reduce`, the IEEE `reduce` operation.
   The `#` flag keeps its float meaning, and `IsZero`, `omitempty`
   and `DeepEqual` are numeric.
   *Status:* implemented, except that `decimal.Reduce` doesn't exist yet.
   `database/sql` uses fixed notation, so it drops a quantum above the units
   digit.

3. **Helper functions live in `math/decimal`.**
   `math` receives only the `bits`/`frombits` pairs that mirror
   `Float64bits`; everything else is a generic function in a new
   `math/decimal` package, and `sort` gains nothing.
   Reason: `math` is `float64`-only by design and has no `Float32`
   variants; forty-four `Decimal64X`/`Decimal128X` functions would
   double its surface and would be the strongest argument against
   built-in types in the review. Generics make one function per
   operation possible.
   *Status:* implemented. `math` keeps only the four `bits`/`frombits`
   functions, `math/decimal` holds the rest as generic functions,
   and `sort` has no decimal additions.

4. **Operators round to nearest, ties to even; nothing else.**
   Directed rounding and round-half-away live in `math/decimal`
   as explicit functions. Signalling NaN is accepted as input and
   quieted. A NaN operand propagates as it does in `float64`:
   the result is that NaN made quiet, with its sign and payload
   (IEEE 754-2019 clause 6.2.3). Of several NaN operands,
   the first signalling one wins, otherwise the first
   (the General Decimal Arithmetic rule).
   A NaN created by an invalid operation is the canonical quiet NaN.
   Conversions to and from `float64` and text do not carry payloads.
   Reason: this is the `float64` precedent; dynamic rounding modes
   are global state Go does not have, and the financial half-up case
   is a rounding *operation* (`Round`, `Quantize`), not a mode.
   Payload propagation follows the same precedent and IEEE's
   recommendation; see [open issue 7](#open-issues) for what remains open.
   *Status:* implemented for the operators, which round once,
   to nearest with ties to even; signalling NaN is quieted.
   The pinned revision still drops payloads and signs;
   propagation is implemented and tested on the fork's [`decimal-next`](https://github.com/marcelocantos/go/tree/decimal-next) branch,
   which is not yet in the pinned revision.
   The kernel implements all five IEEE modes.
   Explicit-mode rounding is public through `decimal.QuantizeMode`.

5. **Conversions are correctly rounded from the exact source value.**
   A non-constant `float64` converts to the decimal nearest its exact
   binary value at the destination's precision; constants convert
   exactly when representable, so `decimal128(0.1)` is `0.1` and `decimal128(f)` for a
   variable holding `0.1` is `0.1000000000000000055511151231257827`.
   Decimal to integer truncates toward zero and is
   implementation-dependent out of range or for NaN, as for floats.
   Reason: a conversion of a value is a conversion of *that* value;
   converting the shortest printed decimal string can choose a different
   decimal value. For finite `float64` values, the intended round-trip
   property is `float64(decimal128(f)) == f`, with explicit conversions.
   That property alone does not distinguish the two conversion policies;
   correct rounding from the exact source value does.
   *Status:* implemented for non-constant values and for constants
   of a concrete decimal type, through the kernel.
   One defect remains: for a type parameter `T`,
   `T(float64(0.1))` is treated as the literal `0.1`.

6. **Both `decimal64` and `decimal128`; no `decimal32`.**
   Reason: see [Why not just decimal128?](#why-not-just-decimal128).
   A shared arithmetic kernel reduces duplicated implementation, but both
   widths still require independent boundary and integration evidence.
   *Status:* implemented. Both widths are generated from one template,
   a form chosen by a measured spike recorded in the package documentation.

7. **Rollout behind `GOEXPERIMENT=decimal` and a `go.mod` version gate;
   public constants are appended, never renumbered.**
   `reflect.Kind` and `go/types.BasicKind` gain their new values after
   the existing ones.
   Reason: the Go 1 compatibility promise; `api/except.txt` is not a
   licence to change existing constant values.
   *Status:* implemented. The new kinds follow `UnsafePointer` in `reflect`
   and `UntypedNil` in `go/types`, so every existing value is unchanged.
   The only `api/except.txt` entries are the masks `IsNumeric`, `IsOrdered`
   and `IsConstType`, which must include the decimal types.
   The types require `go1.28` in `go.mod`, and outside the standard library
   they require `GOEXPERIMENT=decimal`, which the fork enables by default,
   so `GOEXPERIMENT=nodecimal` turns them off.

8. **Wire formats.**
   `encoding/binary` writes the IEEE interchange encoding in the
   requested byte order (most significant word first for `BigEndian`);
   `gob` writes the two words most significant first;
   JSON uses the canonical string with the float exponent-form thresholds
   and rejects NaN and infinities.
   Reason: these freeze on first release and must match the standard
   and each other.
   *Status:* implemented.

9. **The zero value is `decimal64(0)` or `decimal128(0)`.**
   `var total decimal64` has the value and quantum of `decimal64(0)`,
   so `total += 19.99` gives `19.99`, as `var total float64` would.
   Go's zero value is all bits clear, so all bits clear must mean `0E+0`.
   A value in memory is therefore the target's encoding XORed with the
   encoding of that zero. In software that is `0x31c0000000000000` for `decimal64`,
   and `0x3040000000000000` in the high word of `decimal128`;
   on the IBM targets it is the DPD encoding of zero,
   `0x2238000000000000` and `0x2208000000000000`
   ([design decision 10](#design-decisions)).
   The `bits` functions, `encoding/binary` and `gob`
   give the same interchange encoding on every target, and arithmetic is unchanged.
   Reason: Go's spec says the zero value of a numeric type is `0`,
   and `0E+0` is what IEEE 754-2019 gives for converting the integer 0,
   so the zero value has the same exponent as `decimal64(1)`.
   IEEE 754-2019 defines no default value for a variable,
   and its encodings govern interchange.
   The alternatives were the plain encoding in memory,
   where the zero value is `0E-398` and `total` holds `19.99000000000000`,
   and treating a zero at the minimum exponent specially,
   which departs from IEEE's preferred exponent.
   The cost is that C code using `_Decimal64` can't share decimal values
   in memory without conversion,
   `unsafe` reinterpretation sees the XORed form,
   and debuggers that decode `DW_ATE_decimal_float` need the same conversion.
   *Status:* implemented, including debugger support for GDB.
   Go's GDB support script (`runtime-gdb.py`) has a decimal printer.
   It undoes the XOR using two runtime constants recorded in DWARF,
   decodes BID or DPD itself, and prints the `fmt` form, quantum included,
   for locals and parameters in registers or on the stack, globals,
   struct fields, array, slice and map elements, and values behind pointers.
   It is tested live on linux/arm64 and statically on linux/amd64 and linux/ppc64le.

10. **Decimal hardware on the IBM targets.**
    On `ppc64le` and `s390x` the compiler lowers decimal operators to the hardware's
    instructions, and a value in memory is its DPD encoding,
    XORed with the DPD encoding of `0E+0`, so an operator needs no change of encoding.
    The software milestone does not depend on it.
    The memory form is not part of the language:
    the `bits` functions and wire formats exchange the same encoding on every target,
    and the two encodings represent the same values and quanta.
    Reason: see [Native decimal hardware](#native-decimal-hardware).
    *Status:* implemented for `ppc64le` on the fork's [`decimal-next`](https://github.com/marcelocantos/go/tree/decimal-next) branch, not yet
    in the pinned revision, and verified under QEMU;
    see [Native decimal hardware](#native-decimal-hardware).
    Not implemented for `s390x`, whose decimal instructions QEMU doesn't emulate.

11. **No decimal literal suffix.**
    There is no suffix (such as `1.50d`) giving a floating-point constant
    a decimal default type, by analogy with the imaginary suffix `i`.
    An untyped constant already becomes a decimal, exactly and with its quantum,
    wherever a decimal is needed, so `var price decimal64 = 1.50`
    and `price * 1.10` need no marker.
    What a suffix would add is a decimal default type:
    `x := 1.50` gives a `float64` without one,
    and an untyped constant expression such as `1.50 / 3` is evaluated
    exactly as an untyped constant, not as a decimal.
    Reason: a suffix is new syntax, and it can be added later
    without breaking anything that adding it now wouldn't,
    since `1.50d` is a syntax error today and stays one until then.
    Leaving it out keeps the proposal to the types themselves,
    and the case for it can be made on its own, with experience of the types.
    *Status:* nothing to implement.

## Non-goals

This proposal adds numeric types and their language and library integration.
It does not supply money policy, enforced fixed scale or arbitrary precision.
Libraries can supply those abstractions with or without built-in decimals.

### Currency and money

A money type combines an amount with currency, permitted operations and
rounding policy. This proposal chooses none of those policies. Decimal
operators can round silently, overflow to infinity or return NaN; applications
must validate inputs, intermediate bounds and results.

A library can provide a fixed-size amount today. Built-ins add operators,
constants and numeric equality while preserving cohorts. A money library
may prefer explicit errors or canonical fixed-scale values instead.
Currency units, settlement scale, tax rules, exchange rates and allocation
belong in application or library contracts. They do not follow from radix 10.

### Fixed-point decimal

[#68272](https://go.dev/issue/68272) asks for fixed-point decimal types.
An IEEE decimal value can represent a fixed-scale amount within its
coefficient and exponent limits, but its type does not enforce that scale.
Addition, subtraction and multiplication by an integer retain it only when
the coefficient and exponent fit. The decimal64 carry
`99999999999999.99 + 0.01` yields `100000000000000.0`.
Quantizing that result back to cents cannot fit in decimal64 and returns NaN.

A fixed-scale abstraction therefore needs bounds checks and explicit
quantization, including checks for invalid results. A library can enforce
that contract. Widening before arithmetic can provide headroom; it does not
remove the need to establish bounds.

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

This proposal supplies no workload case for a third width. Seven significant
digits leave less headroom for prices, quantities and rates.
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
The invoice example below uses helpers in the current fork. It demonstrates
a stated rounding policy on bounded inputs, not a general ledger implementation.

### The 0.1 + 0.2 problem

```go
a, b := 0.1, 0.2
fmt.Println("Binary: ", a+b)   // 0.30000000000000004

da, db := decimal64(0.1), decimal64(0.2)
fmt.Println("Decimal:", da+db) // 0.3
```

### Invoice calculation

This example assumes USD, nonnegative prices with at most two decimal
places and prices and integral quantities no greater than 1,000,000.
At most 1,000 lines are accepted. Decimal128 gives enough coefficient
headroom for the exact products, sum and multiplication by the stated rate.
Tax is rounded once on the subtotal to cents, with ties to even. Other tax
policies require different code. The example uses the fork's `math` helpers;
the proposed API would move them to `math/decimal`.

```go
type LineItem struct {
    Description string
    Price       decimal128
    Quantity    decimal128
}
items := []LineItem{
    {"Widget A", 19.99, 3},
    {"Widget B", 4.50, 12},
    {"Shipping", 7.95, 1},
}
const maxLines = 1000
const maxPrice decimal128 = 1000000
const maxQuantity decimal128 = 1000000
cent := decimal128(0.01)
if len(items) > maxLines {
    panic("too many invoice lines")
}
var subtotal decimal128
for _, item := range items {
    // Negated comparisons reject NaN as well as out-of-range values.
    if !(item.Price >= 0 && item.Price <= maxPrice) ||
        !(item.Quantity >= 0 && item.Quantity <= maxQuantity) ||
        item.Price != decimal.Quantize(item.Price, cent) ||
        item.Quantity != decimal.Trunc(item.Quantity) {
        panic("invalid invoice line")
    }
    subtotal += item.Price * item.Quantity
}
taxRate := decimal128(0.0825)
tax := decimal.Quantize(subtotal*taxRate, cent)
total := decimal.Quantize(subtotal+tax, cent)
if decimal.IsNaN(tax) || decimal.IsInf(tax, 0) ||
    decimal.IsNaN(total) || decimal.IsInf(total, 0) {
    panic("invoice result is not finite")
}
fmt.Printf("Subtotal: $%6.2f\n", subtotal) // $121.92
fmt.Printf("Tax:      $%6.2f\n", tax)      // $ 10.06
fmt.Printf("Total:    $%6.2f\n", total)    // $131.98
```

Here `tax` and `total` themselves have cent quantum; `%.2f` only controls
presentation. Ordinary numeric literals remove constructors, but bounds,
rounding policy and validation remain necessary. A library implementation
can enforce the same policy.

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
and a decimal struct in the standard library would very likely
foreclose built-in types for good.

### Native decimal hardware

Go already supports `s390x` and `ppc64le`.
IBM Z has had decimal floating point since the z9, in microcode at first,
and POWER has had a hardware unit since POWER6.
IBM Z is a mainstay of banking, often running COBOL doing decimal arithmetic.
Go can run on those machines today, and it can't reach their decimal units.

A library can't close that gap.
It can wrap each operation in an assembly function,
but its values still cross a function call in general-purpose registers.
A built-in type gets what `float64` gets:
one instruction per operator, with its operands in floating-point registers.
The hardware also works on fixed-width IEEE values,
so an arbitrary-precision library such as #82668 can't use it at all.
On the machines where decimal arithmetic matters most,
the choice between a library and a type is also a choice about
whether Go uses the hardware at all.

This means giving up one bit layout across targets.
That layout was only ever an assumption, and it costs nothing a program may rely on:

- **Values are the same.** BID and DPD are both IEEE 754-2019 encodings
  of the same values, signs and quanta,
  so arithmetic, comparison, hashing and formatting can't tell them apart.
- **Interchange is the same.** `math.Decimal64bits`, `encoding/binary`
  and `gob` give the same encoding on every target, so stored data and streams are portable.
- **Memory never was uniform.** Byte order already differs between targets,
  and [design decision 9](#design-decisions) means memory isn't a plain IEEE encoding anywhere.
  Code reading decimals through `unsafe` was never portable.
- **Constants are the compiler's.** It encodes them for the target,
  so cross-compiling works.

The costs are these:

- **Round trips of the `bits` functions.** Some non-canonical interchange patterns
  have no DPD form, so `Decimal64bits(Decimal64frombits(x)) == x` holds only for
  canonical patterns on the IBM targets; a non-canonical pattern comes back canonical.
- **Conversion.** The `bits` functions and wire formats convert between
  encodings on those targets, which is slower than on the others.
- **Code.** Those targets need decimal operations in the compiler's SSA,
  and conversions at the boundary for what the hardware lacks, such as parsing,
  formatting, conversion to unsigned integers and to and from `float64`.
- **Verification.** Hardware results must match the kernel's in value, quantum
  and rounding, which the existing oracle can check on real hardware.

On `ppc64le` this is implemented on the fork's [`decimal-next`](https://github.com/marcelocantos/go/tree/decimal-next) branch,
which is not yet in the pinned revision.
Arithmetic and comparisons compile to single decimal instructions
(`DADD`, `DSUB`, `DMUL`, `DDIV`, `DCMPU` and their `decimal128` forms),
and `decimal64` values stay in floating-point registers across an expression.
Under QEMU's POWER9 model the hardware path passes the oracle,
the conformance suite and all three published suites,
and matches the software kernel bit for bit at 10^6 cases per operator.
QEMU emulates decimal instructions with decNumber,
so this verifies the lowering and encodings, not the silicon,
and nothing has been measured on hardware yet.
`s390x` is not implemented, because QEMU doesn't emulate its decimal instructions
and no IBM Z hardware has been available.

### Why not arbitrary precision?

Fixed-size types:

1. Have no separately allocated coefficient; escaping values may still allocate.
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

The design preserves existing source behavior.
The fork appends its new kind constants, so no existing value changes,
and it implements both proposed gates.

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
following the precedent set by `any` and `comparable` in Go 1.18.
The fork implements the gate: with `go 1.22` in `go.mod`,
`var x decimal64` fails with
"predeclared decimal64 requires go1.28 or later".

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
The fork does this.
No new Kind value has been added since Go 1.0,
so this is unprecedented,
but the Go team has explicitly acknowledged
that Kind growth is a legitimate future event
(see [#38831](https://go.dev/issue/38831),
where Rob Pike noted that
"code depending on Kind already must change
when new Kinds are added").

A `default` case may reject a new `reflect.Kind` safely, but its presence
does not establish correct decimal handling.
Code that uses `reflect.Kind` values as array indices
(e.g., `[reflect.UnsafePointer + 1]T`)
or that exhaustively matches all known kinds without a `default`
may panic or silently mishandle decimal values at runtime.
This is a soft compatibility concern, not a compilation break.

The cost has been measured.
A [survey](research/reflect-survey/README.md) ran 27 widely imported
reflection-based packages against the fork's types, 74 entry points each,
and CI reruns it to keep its table current.
For `decimal128`, the worst outcome per entry point was
18 correct, 35 clean errors (such as `unsupported type: decimal128`),
13 panics and 8 silent mishandlings.
Most failures are a `Kind` switch with no case for the new kinds,
and the fix is one added case; a few encoders need a new encoder and decoder.
mongo-driver is the sharpest case: it deliberately panics at start-up
if `reflect` has a kind it doesn't know, whether or not the program uses one.
The same matrix with `shopspring/decimal`, whose `encoding` and `database/sql`
methods make it work in the JSON, YAML, TOML and SQL libraries,
still gave 10 silent mishandlings and 6 panics,
because many reflection libraries don't consult those interfaces.
A library type doesn't avoid this cost; it pays a different share of it.

The built-in's share falls on library maintainers, once per library,
and Go has rolled out changes of that shape before.
`go/types` began producing `Alias` nodes behind `gotypesalias`,
off by default in Go 1.22 and on by default in Go 1.23;
per-iteration loop variables were `GOEXPERIMENT=loopvar` in Go 1.21
and the default for `go 1.22` modules;
range-over-func was `GOEXPERIMENT=rangefunc` in Go 1.22
and standard in Go 1.23.
The proposed `GOEXPERIMENT=decimal` rollout follows them:
at least one release behind the flag before default-on.
While the experiment is off, `reflect` does not name the new kinds
(`Kind(27).String()` is `"kind27"`, as in an earlier release),
so no existing program changes at run time, mongo-driver included.
CI builds and runs the standard library's tests with the experiment off,
and runs a program outside the standard library that checks it sees no new kinds.
Some differences remain visible to tools in that mode;
see [open issue 8](#open-issues).
Library authors then have at least a release, and the survey's list of fixes,
before the new values appear in default builds.

**`go/types.BasicKind`.**
Similarly, `go/types` gains two new `BasicKind` values,
likewise appended so that `String`, `UnsafePointer` and the untyped
kinds keep their values.
This affects tools that use `go/types` for static analysis.
Tools must test their handling of new kinds; a `default` case is not
a compatibility guarantee.

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
73d98b3606 at the time of writing, and this section describes that commit.

The prototype changes the kernel, compiler, runtime and standard library.
Earlier drafts gave inconsistent file and line counts. They are omitted here
rather than treated as measures of completeness or maintenance cost.
The pinned revision above identifies the implementation being described.

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
`all.bash` has not been run on another platform, and Windows execution
remains unverified. A later independent probe at a separately identified
revision executed decimal64 kernel and language paths on emulated linux/386
and linux/s390x; see [Independent probe](#independent-probe).
That is not full language, ABI or standard-library coverage on those ports.

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

- **Constant model.** Constants carry a quantum through arithmetic,
  named constants and package boundaries,
  and typed decimal constant expressions fold as at run time
  ([Design decisions](#design-decisions) item 1).
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
- **`strconv`.** `ParseDecimal` returns `ErrRange`
  on overflow, round excess digits to nearest even,
  and reject `NaNxyz`.
- **`reflect.Value.IsZero`, `omitempty` and templates.** Numeric,
  so a zero with any exponent is zero.

Still wrong or missing, to be fixed before any CL series:

- **Debuggers.** GDB shows decimal values correctly when Go's printer
  script is loaded. Without it, and in GDB expression arithmetic or assignment,
  GDB decodes the XORed memory form and shows wrong values (item 9).
  Delve has no decimal support. ppc64le has not been checked in a live GDB session.
- **Performance.** Both baselines are provisional;
  see [Performance](#performance).

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
  The quantum comes from the constant's quantum attribute.

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
- **Published vectors.** Three independent published suites
  are a local check and stay out of the tree:
  Cowlishaw's decTest, Intel's `readtest.in` and IBM Haifa's FPgen 1.02.
  `TestNoPublishedVectors` enforces that.
  The kernel passes 21,407 decTest vectors, 58,029 Intel vectors
  and 34,668 FPgen vectors with no failures.
  Another 112,138 are skipped, each with a named reason,
  such as other formats, non-IEEE operations, FPgen vectors
  that take a trap the contract doesn't have, and named divergences.
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

Not yet covered: complete language and ABI coverage on 32-bit and big-endian
ports, Windows execution and `all.bash` beyond darwin/arm64. The independent probe below adds bounded port evidence.

### Independent probe

The independent report “Independent decimal64 conformance probe —
3 November 2026” used an archive of compiler commit
`3395b13718777d5ef94c94554ca63b34a753069b` and a separate Python decimal
reference. It found zero discrepancies in 97,130 decimal64 cases per target:
94,000 arithmetic cases, 100 parses and 3,030 default-format round trips.
Of the arithmetic cases, 18,800 per target also checked compiled operators
or the public Quantize helper. The same corpus ran natively on darwin/arm64
and under emulation on linux/386 and linux/s390x. These are repeated runs
of one corpus, not 291,390 independent inputs.

The report found no committed `internal/bid` changes between the pinned
compiler revision and the audited revision. That does not establish identity
of the rest of the toolchain or the deployed playground.

This supports the tested decimal64 operations and finite round trips.
It does not establish complete IEEE conformance, decimal128 arithmetic
coverage, noncanonical encoding coverage, every conversion or formatting
mode, full ABI and codec coverage, physical IBM hardware behavior or
performance. It also reproduced the unfinished typed-constant behavior.
The report and reproduction sources must accompany any public citation;
they are not included in this repository revision.

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
The linux/amd64 columns come from
[`bench_baseline_linux_amd64.txt`](https://github.com/marcelocantos/go/blob/decimal/src/internal/bid/testdata/bench_baseline_linux_amd64.txt),
taken on a shared GitHub Actions runner, and are provisional too.

| Operation | decimal64 | decimal128 | float64 | decimal64, linux/amd64 | decimal128, linux/amd64 |
|-----------|-----------|------------|---------|------------------------|-------------------------|
| Add, subtract | 11 ns | 17 ns | 1 ns | 22 ns | 31 ns |
| Multiply | 11 ns | 23 ns | 1 ns | 20 ns | 35 ns |
| Divide | 12 ns | 33 ns | 1 ns | 30 ns | 54 ns |
| Fused multiply-add | 17 ns | 31 ns | 1 ns | 33 ns | 61 ns |
| Less than | 7 ns | 9 ns | 1 ns | 14 ns | 17 ns |
| Convert from `float64`, typical | 13 ns | 21 ns | | 30 ns | 45 ns |
| Parse, short string | 20 ns | 16 ns | 13 ns | 28 ns | 32 ns |
| Format to a buffer | 13 ns | 23 ns | 24 ns | 27 ns | 49 ns |

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
This is a property of the measured kernel, not an advantage established
over every library. Fixed-width libraries can also avoid allocation, and
#82668 proposes an integer fast path.

The kernel has not been profiled or tuned for speed. No controlled comparison
is supplied against checked `int64` minor units, an allocation-free fixed-width
library or #82668. A useful comparison must execute equivalent invoice or
ledger rules through compiled user code, including parsing, rounding,
overflow checks, accumulation, formatting and maps. Kernel timings alone
do not establish application cost; the independent port probe supplies no
performance evidence.

### Hardware

The current implementation is pure software on every target.
[Design decision 10](#design-decisions) proposes a later hardware milestone
for `s390x` and `ppc64le`; it is not required for the first software milestone.

### Implementation plan

If accepted, the implementation can be contributed
as a series of CLs to the Go repository
once the API in
[Design decisions](#design-decisions) are in place.
The author is willing to break it into smaller,
reviewable CLs and work with the Go team
on any design adjustments.

A detailed [roadmap](ROADMAP.md) describes the work
required to take the implementation from its current state
to production readiness, including CL splitting and third-party ecosystem impact.

Following the precedent set by generics, range-over-func,
and other major language changes,
the proposed rollout is:

1. **Go 1.XX**: Ship behind `GOEXPERIMENT=decimal`.
   Early adopters can opt in; the types are invisible
   to programs that do not set the flag.
2. **A later release**: Consider enabling by default after at least one
   experimental release, completed compatibility and port checks, working
   debugger support and a maintenance commitment. A release cycle alone
   is not acceptance evidence.

This gives tool authors (gopls, staticcheck, Delve, etc.)
a full release cycle to add decimal support
before the types appear in default builds.

## Open issues

1. **`decimal32`**: This proposal does not include `decimal32`.
   No workload evidence is supplied for adding a third width,
   and omitting it reduces implementation and verification work.
   If there is demand, it could be added later.

2. **Performance tuning**: The kernel is pure Go
   and has not been profiled or tuned, and its benchmark baseline
   is provisional on both darwin/arm64 and linux/amd64 (see [Performance](#performance)).
   Benchmarking against [Intel's C BID library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)
   would establish a performance baseline
   and identify optimization opportunities.
   Hot paths (multiplication, division, comparison)
   could be rewritten in platform-specific assembly,
   following the pattern used by `math/big`, `crypto/subtle`,
   and other performance-sensitive standard library packages.
   IBM hardware acceleration remains unimplemented;
   see [design decision 10](#design-decisions).

3. **`math/rand`**: Random decimal generation
   (analogous to `rand.Float64`) could be added
   but is not included in this proposal.

4. **`encoding/json/v2`**: Upstream's `jsonv2` experiment is on by
   default at the fork's merge base, so `encoding/json` runs on
   `encoding/json/v2` there.
   The fork adds decimal marshalers and unmarshalers to `encoding/json/v2`
   and patches `v2_inject.go` to recognize decimal kinds as numeric.
   `encoding/json/v2` has no decimal tests of its own;
   the decimal tests in `encoding/json` run through it.

5. **AI-assisted implementation**.
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

6. **Bounded JSON number decoding**.
   Decimal128 exactly represents only values within its 34-digit coefficient
   and exponent limits. A valid JSON number can exceed either limit.
   The independent probe decoded `10000000000000000000000000000000001`
   and re-encoded `1.000000000000000000000000000000000e+34`, with no error.
   This is expected rounding, not lossless interchange.

   A future opt-in decimal128 decoder could help applications with known
   bounds. It must state its rounding and range behavior and would change
   the dynamic type of decoded values. No default change is proposed here.
   Applications requiring arbitrary JSON numeric text to survive must retain
   that text, for example with `json.Number`, or use a suitably capable
   arbitrary-precision representation. Even quantum-preserving decimal output
   does not preserve every original spelling, such as exponent letter case.

7. **NaN payloads**.
   Resolved for arithmetic: operators propagate NaN payloads and signs
   (design decision 4). On darwin/arm64, a `decimal64` NaN keeps
   payload `0x123` through `x + 1`, as a `float64` NaN does.
   Still open: whether conversions between binary and decimal,
   `strconv` and `fmt` should carry payloads too, and whether `TotalOrder`
   should order NaNs by payload and signalling bit,
   as IEEE 754-2008's clause 5.10 required; IEEE 754-2019 relaxed the ordering of NaNs.

8. **What tools see with the experiment off.**
   With `GOEXPERIMENT=decimal` off, programs that don't use decimals behave
   as before, but the fork still differs in ways tools can see:
   `go/types`' `IsNumeric`, `IsOrdered` and `IsConstType` have new values,
   since they include the new `IsDecimal` bit;
   `types.Universe` and `types.Typ` include the decimal types,
   so `go vet` and gopls accept code the compiler rejects;
   `debug/dwarf` decodes `DW_ATE_decimal_float` instead of reporting an error;
   and the new API (`reflect`'s decimal methods, `math/decimal`,
   the `strconv` functions) is present in every mode,
   so a value obtained from it, such as `strconv.ParseDecimal`'s result,
   can be used in arithmetic without naming the types.
   Each could be gated or kept; keeping `IsNumeric` unchanged, for example,
   would stop analyzers that check it from treating decimals as numbers.

## Acknowledgements

This design document builds on
[#19787](https://go.dev/issue/19787),
originally proposed by Mura Li ([@typeless](https://github.com/typeless)) in 2017.
The discussion on that issue, dating from 2017,
shaped the direction of this proposal —
in particular the argument for built-in types over a library
and the focus on IEEE 754 conformance.
Thanks to all who contributed to that discussion.
