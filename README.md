# Proposal: Add decimal floating-point types

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Design document: Marcelo Cantos (marcelo.cantos@gmail.com)

Last updated: 2026-11-03 (proposed revision)

Discussion at [#19787](https://go.dev/issue/19787)

Related issues: [#82668](https://go.dev/issue/82668), [#12127](https://go.dev/issue/12127), [#19770](https://go.dev/issue/19770), [#26699](https://go.dev/issue/26699), [#9455](https://go.dev/issue/9455)

## Abstract

We propose adding two new built-in numeric types to Go:
`decimal64` and `decimal128`,
implementing IEEE 754-2008 decimal floating-point arithmetic,
initially in software using the Binary Integer Decimal (BID) encoding.
IBM hardware acceleration is a separate, unimplemented milestone.

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
Quantum, fixed precision and IEEE special values require explicit rules;
the constant model is not yet implemented.

The primary motivation is financial and business software,
where exact representation of decimal inputs within a known range matters.
The case for a language change is integration with operators, constants
and numeric equality. A library can provide decimal arithmetic and a shared
interchange type. This proposal has not yet demonstrated that the additional
integration justifies its permanent language and tooling cost.

Both this document and the accompanying implementation
were largely produced with the assistance of agentic AI,
with human direction.
The implementation is a fork of Go,
and it can be run in the [playground](https://marcelocantos.github.io/go-decimal-proposal/).
Its arithmetic is one kernel, `internal/bid`,
checked against an exact reference model,
an independently written conformance suite and published test vectors.
Several design decisions are not implemented yet:
the constant model, `math/decimal`, appended public kind values,
rollout gates and debugger support. Default formatting and wire formats
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
  Harder for users who need decimals and for tool authors.
  The operator syntax is familiar, but quantum, finite precision,
  rounding, special values and constant conversion rules are new material.
  Users who do not use decimals need not learn their arithmetic rules;
  tools that inspect numeric kinds still need support.

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
  Existing library use establishes demand for decimal arithmetic.
  It does not establish demand for these fixed-width IEEE types.

- **What is the proposed change?**
  Two new predeclared types (`decimal64`, `decimal128`)
  with the same operator set as `float64`.
  See [Proposal](#proposal) for the precise specification
  and [Language spec changes](#language-spec-changes) for verbatim spec text.

- **Is this change backward compatible?**
  That is the design requirement, not the prototype's current state.
  See [Compatibility](#compatibility).
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
  - **Compile time cost:** Not measured. Constant propagation, folding
    and export data need measurement through the compiler.
    The fork currently writes one extra string per constant into
    export data, the literal's source text.
    The proposed design replaces that with the quantum attribute,
    a small integer propagated alongside the exact value
    that `go/constant` already holds.
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
  A compiler prototype exists; [Implementation](#implementation) identifies
  its pinned revision. It changes the arithmetic kernel, compiler, runtime,
  reflection, formatting, codecs, SQL conversion and generic constraints.
  Source volume is not evidence of correctness or maintenance cost.

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
  `go/constant` needs quantum metadata and propagation; the type checkers
  need agreement on typed decimal rounding and export/import behavior.

- **Is the goal of this change a performance improvement?**
  No. The goal is correctness for base-10 arithmetic.
  See [Performance](#performance) for benchmark data.

- **Does this affect error handling?**
  Decimal operators round silently and can return NaN or infinity.
  Applications must check range and apply their own rounding policy.
  A library with explicit errors offers a different contract.

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

Financial applications, invoicing, accounting and database interchange
all use decimal values. Their requirements differ. Some need a bounded
coefficient and exponent; others need arbitrary precision, fixed scale,
explicit errors or currency policy.

The review of 3 November 2026 recorded 40,713 known importing packages
on the `shopspring/decimal` pkg.go.dev page. This is a dated package count,
not a count of users or companies, and it does not establish a percentile
or a deduplicated total across libraries. The long-running discussion on
[#19787](https://go.dev/issue/19787) is another signal of interest.
Neither establishes how many users want 16- or 34-digit IEEE arithmetic.

Integer minor units are also a valid design for bounded amounts.
Their use does not show that developers rejected decimal library syntax.
Rates, intermediate precision, overflow and rounding need attention with
integer amounts, libraries and built-in decimals alike.

The missing evidence is a set of representative applications whose owners
can explain why fixed precision, quantum, special values and language
integration meet their requirements. No adoption study or comparative
migration trial is supplied here.

### Why a library is inadequate

A library can provide correct decimal arithmetic.
[#82668](https://go.dev/issue/82668) proposes immutable values, an integer
fast path, arbitrary-precision promotion and explicit division and rounding.
It could also establish a shared standard-library interchange type.
Those are substantial benefits without adding a language type.

The narrower question is whether users need the following integration
enough to justify changing Go.

#### What requires language support

- **Operators.** An ordinary library type cannot define arithmetic
  operators. `price * qty * (1 - discount)` expresses the formula directly;
  method calls express it differently. This is a readability argument,
  not evidence that method calls cause financial errors.
- **Constants.** A library value cannot be a Go constant. A built-in
  decimal can receive an exact untyped expression such as `annual / 360`,
  rounded at conversion, and can appear in typed constant expressions.
  `const vat = 0.20` is already exact in Go; it gains a decimal value only
  in a decimal context. `vat := 0.20` still defaults to `float64`.
  The proposed quantum and typed-folding rules are not yet implemented.
  Libraries can validate literal strings with tooling, but cannot make
  the resulting values language constants.
- **Numeric equality and map keys.** Go already defines equality for many
  nonnumeric types, including comparable structs. An ordinary struct
  cannot replace field-wise equality with decimal numeric equality while
  retaining distinct encodings of `1.5` and `1.50` in integer fields.
  The proposed types compare these values numerically, including inside
  arrays and structs used as map keys. A library can instead canonicalize
  finite values to obtain useful comparable keys, at the cost of retaining
  distinct cohorts in those keys. #82668 disables `==` and uses methods.
  A struct containing a floating-point NaN can be unequal to itself;
  the limitation is custom equality, not that all structs are reflexive.
- **Ordering.** A library struct cannot satisfy `cmp.Ordered` or use
  `min` and `max`. Built-in decimals would be added to `cmp.Ordered`.
  Libraries can use comparator-based algorithms such as `slices.SortFunc`.
  Existing custom type sets would need to include the new types explicitly.

A library can implement IEEE NaN, infinity and signed zero through methods.
#82668's omission of these values is a domain choice, not a restriction Go
imposes on decimal libraries. The fixed-width IEEE library
[`woodsbury/decimal128`](https://github.com/woodsbury/decimal128) illustrates
the alternative. This proposal chooses specials to follow IEEE arithmetic
and Go's floating-point operator model; it has not supplied production use
cases showing that financial applications need them.

#### What the argument still needs

The examples below show syntax and semantics. They are not a migration
study or evidence of fewer production defects. A convincing comparison
would implement the same business rules with these types, #82668,
a fixed-width library and checked integer minor units. It would identify
where operators, constants or composite map keys matter to real users,
and where arbitrary precision or explicit errors are preferable.

The author prefers built-in types for bounded decimal arithmetic.
That is a design judgment. Current evidence establishes feasibility and
specific language capabilities, not their net benefit to Go's users.

#### Adoption and sequencing

Both a standard-library type and a built-in type could reduce fragmentation.
Neither automatically changes database drivers, generators or application
schemas. SQL decimals whose precision or range exceeds these formats still
need another representation.

Shipping #82668 would create compatibility and migration commitments.
The author's strategic concern is that those commitments could make later
built-in types harder to justify. A library does not technically preclude
a built-in, and coexistence or explicit conversion remains possible.
This concern is not evidence that the decision is irreversible.

#### The continuing cost

The cost is not paid once. It includes the specification, two type checkers,
constant export data, compiler and runtime support, normalized equality and
hashing, public kinds, codecs, debugger decoding and tests on supported ports.
Quantum and the XOR memory representation add obligations beyond two names.
A shared kernel reduces duplication; it does not remove those obligations.

The initial milestone should be portable BID software with agreed constant,
formatting and wire contracts, append-only public kinds, rollout gates and
working debugger support. IBM DPD hardware lowering is a separate milestone.
The helper API must be settled before landing; optional additions such as
random decimal generation and literal suffixes are outside that milestone.

Before submission as implementation CLs, the project needs named maintainers
and reviewers for arithmetic, compiler semantics and tooling, with regression
checks at each toolchain update and port change. The author is willing to
prepare the CLs, but no long-term maintainer roster or review commitment is
established here. The existing `complex` types are an integration precedent,
not evidence that decimals have more users or prevent more costly bugs.

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
C#'s `decimal` is not IEEE 754 —
it uses a custom representation (96-bit integer + scale factor)
with a different exponent range than IEEE 754 decimal128.
IEEE 754 gives a defined interchange format; it does not make every
database decimal or other language's decimal model compatible.

**Java** has `java.math.BigDecimal` (arbitrary precision, library type).
It expresses arithmetic with methods:
`a.multiply(b).add(c.multiply(d))` instead of `a*b + c*d`.
This illustrates the syntax difference, not a measured defect rate.

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
A driver can scan into a decimal library today. Built-in support would
provide another destination, subject to its precision and range limits.

**COBOL** has packed decimal as a core data type,
reflecting its origin in business computing.
That is a language-design precedent, not evidence of Go adoption effects.

### IEEE 754-2008 and BID encoding

IEEE 754-2008 defines two encodings for decimal floating-point:

- **DPD** (Densely Packed Decimal): packs three decimal digits
  into 10 bits.
  Favored by IBM hardware.
- **BID** (Binary Integer Decimal): stores the coefficient
  as a binary integer and the exponent as a biased binary integer.
  Favored by Intel (via the Intel DFP library)
  and by software implementations.

This proposal uses BID encoding for interchange on every target.
A value in memory is the target's encoding XORed with a constant
so that all bits clear means zero:
BID on every target today, with DPD proposed for IBM hardware
(see [Design decisions](#design-decisions) items 9 and 10).
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
it follows the IEEE 754-2008 preferred-exponent rules through arithmetic.
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

Acceptance requires evidence that named applications benefit from language
integration enough to justify its continuing cost. The technical milestone
is a specified and tested contract for both widths: arithmetic, constants,
numeric equality, formatting, bounded interchange and supported ports.

For a value to be exact it must be expressible as an integer coefficient
of at most 16 or 34 digits times ten to an exponent in the format's range.
Arithmetic can exceed that envelope even when every input fits.
For example, decimal64 amounts at exponent −2 have at most 14 integer
positions; carrying beyond that can lose the requested scale.
No ecosystem convergence, database default mapping or lossless handling
of arbitrary JSON numbers is promised.

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

**Quantum attribute (proposed, not implemented).**
A real numeric constant may carry an optional decimal exponent alongside its
value. The attribute affects decimal conversion and typed decimal arithmetic,
not comparisons, default types or existing nondecimal arithmetic.
`1.50` has value 3/2 and quantum −2; `150` has quantum 0;
`1.5e3` has quantum 2.

For untyped arithmetic, “finite decimal expansion” must be distinguished from
“exact rational value”. `1.0 / 3.0` is the exact rational 1/3; it has no finite
decimal expansion and no quantum. It is not rounded until conversion.

The following table proposes the missing propagation rules for review.
It is a contract to implement and test, not a description of the prototype.
Here `q(x)` denotes a present quantum.

| Constant form | Proposed quantum rule |
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
the supplied quantum if the coefficient and exponent fit. Otherwise use
the exact representation with the smallest coefficient allowed by the
format; zero without a usable quantum gets exponent zero. An inexact
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
by analogy with the imaginary suffix `i`, is noted as an
[open issue](#open-issues) and is not part of this proposal.

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
so `1.50` round-trips as `1.50`; unmarshal preserves value and quantum
when both fit the destination format. Excess precision is rounded.
JSON syntax alone supplies no such precision or range bound. String tag support. NaN and infinities are an error,
as for floats.
See [open issue 7](#open-issues) regarding `decimal128`
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

This is draft spec wording. The propagation table, the existing exact-
evaluation sentence and constant conversion rules must be reconciled in
one normative edit before implementation is described as conforming.

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
> otherwise it uses the smallest coefficient allowed by the format.
> Zero without a usable quantum has exponent zero. An inexact conversion
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
IEEE 754-2008 arithmetic is the starting point.
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

   *Status:* not implemented. The fork threads the literal's source text
   through export data. A direct literal, a conversion of one,
   and a constant from a single-name declaration in the same
   package keep their quantum. Other constants don't:
   `prices.Base` from another package gives `1.5`,
   as do `-c` for a named `c`, `b` in `const a, b = 1.25, 1.50`,
   and `T(1.50)` for a type parameter `T`.
   A computed constant has exponent 0 if it is an integer that fits,
   and otherwise the smallest coefficient that holds its value,
   so `1.50 + 1.50` gives `3`, where the design gives `3.00`.
   Typed decimal constants round at conversion, in both type checkers,
   so `const a decimal64 = 1.00000000000000001; a == 1` is true,
   but a rounded inexact constant loses its trailing zeros:
   `decimal64(float64(0.1))` as a constant is `0.1`,
   where a variable converts to `0.1000000000000000`.
   Operations on typed decimal constants don't fold yet.
   `go/types` and `cmd/compile` disagree about whether they are constants:
   `const a = decimal64(1.50) * 2` passes `go/types`,
   and `cmd/compile` rejects it as not constant.

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
   *Status:* implemented.

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
   *Status:* implemented, with debuggers not yet addressed.

10. **Proposed later milestone: decimal hardware and DPD.**
    On `s390x` and `ppc64le` the compiler would lower decimal operators to the hardware's
    instructions, and a value in memory would use its DPD encoding,
    XORed with the DPD encoding of `0E+0`.
    All targets use the BID kernel until this milestone is implemented
    and verified. The initial software milestone does not depend on it.
    The memory form is not part of the language:
    the `bits` functions and wire formats give BID on every target,
    and the two encodings represent the same values and quanta.
    Reason: see [Native decimal hardware](#native-decimal-hardware).
    *Status:* not implemented. Every target uses the BID kernel today.

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
[Adoption and sequencing](#adoption-and-sequencing).
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
        item.Price != math.Decimal128Quantize(item.Price, cent) ||
        item.Quantity != math.Decimal128Trunc(item.Quantity) {
        panic("invalid invoice line")
    }
    subtotal += item.Price * item.Quantity
}
taxRate := decimal128(0.0825)
tax := math.Decimal128Quantize(subtotal*taxRate, cent)
total := math.Decimal128Quantize(subtotal+tax, cent)
if math.IsDecimal128NaN(tax) || math.IsDecimal128Inf(tax, 0) ||
    math.IsDecimal128NaN(total) || math.IsDecimal128Inf(total, 0) {
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
The argument is operators, language constants, and numeric equality that
retains cohorts, including inside composite keys. A standard-library decimal
can still be a shared type and may better serve users who need arbitrary
precision or explicit errors. The missing evidence is which applications
benefit enough from language integration to justify the continuing cost.

### Why BID and not DPD?

This section is about software targets.
All targets currently use BID. DPD on IBM targets is a later proposal;
see [Native decimal hardware](#native-decimal-hardware).

BID is the natural choice for software implementations.
The coefficient is a plain binary integer
that can be manipulated with existing ALU instructions.
DPD requires special decoding for each group of 3 decimal digits.

BID is the encoding used by Intel's reference library,
by GCC's `libdecnumber`,
and by other software implementations.

### Native decimal hardware

Go supports `s390x` and `ppc64le`, whose processors have decimal hardware.
The current fork uses software on both. A library can call assembly;
language integration could allow instruction selection and register allocation
across expressions. Neither path has been measured here, so no speedup or
claim that only a built-in can use the hardware is justified.

A later milestone proposes XOR-adjusted DPD storage and hardware operations
on those targets, with BID retained for bit accessors and interchange.
Values, quantum and rounding must match the software path. The additional
ABI, debugging and verification costs belong to that milestone.

The costs are these:

- **Round trips of the `bits` functions.** A non-canonical BID pattern has no
  DPD form, so `Decimal64bits(Decimal64frombits(x)) == x` holds only for
  canonical patterns on the IBM targets.
- **Conversion.** The `bits` functions and wire formats convert between
  encodings on those targets, which is slower than on the others.
- **Code.** Those targets need decimal operations in the compiler's SSA,
  and DPD paths for what the hardware lacks, such as parsing and formatting.
- **Verification.** Hardware results must match the kernel's in value, quantum
  and rounding, which the existing oracle can check on real hardware.

None of this has been measured or implemented yet.

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

Go's complex types demonstrate integration of another numeric kind with
operators, constants and conversions. They do not establish a present-day
acceptance threshold, relative audience size or comparative defect costs.
The decimal proposal needs its own evidence on those questions.

## Compatibility

The intended design preserves existing source behavior. The prototype still
renumbers public kind constants and lacks the proposed gates, so it is not
yet evidence of that compatibility contract.

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

A `default` case may reject a new `reflect.Kind` safely, but its presence
does not establish correct decimal handling.
Code that uses `reflect.Kind` values as array indices
(e.g., `[reflect.UnsafePointer + 1]T`)
or that exhaustively matches all known kinds without a `default`
may panic or silently mishandle decimal values at runtime.
This is a soft compatibility concern, not a compilation break.

The proposed `GOEXPERIMENT=decimal` rollout
(at least one release behind a flag before considering default-on)
gives library and tool authors a full release cycle
to audit their Kind switches before the new values
appear in default builds.

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
1a34837e38 at the time of writing, and this section describes that commit.

The prototype changes the kernel, compiler, runtime and standard library.
Earlier drafts gave inconsistent file and line counts. They are omitted here
rather than treated as measures of completeness or maintenance cost.
The pinned revision above identifies the implementation being described.

`all.bash` passes on darwin/arm64 at a558b136d2;
the two commits after it change only the spec and a comment in a benchmark file.
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
  Operations on typed decimal constants don't fold, and a rounded inexact
  constant loses its trailing zeros, until constants carry a quantum.
- **Public constants renumbered** in `reflect` and `go/types`
  (item 7), with entries in `api/except.txt`.
- **Rollout gates.** Neither `GOEXPERIMENT=decimal` nor the `go.mod`
  version gate exists (item 7).
- **API shape** differs from this document (item 3):
  `math` holds the helpers, and `math/decimal` doesn't exist.
- **Generic conversion.** For a type parameter `T`,
  `T(float64(0.1))` is treated as the literal `0.1`.
- **Debuggers.** The linker marks decimal types `DW_ATE_decimal_float`,
  and a debugger that decodes that as BID misreads the XORed form in memory
  (item 9).
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

Not yet covered: complete language and ABI coverage on 32-bit and big-endian
ports, Windows execution, `all.bash` beyond darwin/arm64, and the proposed
constant model. The independent probe below adds bounded port evidence.

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

2. **Decimal literal suffix** (not proposed, recorded for discussion):
   because the default type of a floating-point constant is `float64`,
   `fmt.Println(1.10)` prints `1.1`.
   A suffix giving a floating-point constant a decimal default type,
   by analogy with the imaginary suffix `i`
   (whose constants default to `complex128`),
   would let `fmt.Println(1.10d)` print `1.10`.
   C# has exactly this (`1.10m`). It is new syntax, so it is left out
   of this proposal. Its design and compatibility cost would need a
   separate review if there is demand.

3. **Performance tuning**: The kernel is pure Go
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

7. **Bounded JSON number decoding**.
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
The discussion on that issue, dating from 2017,
shaped the direction of this proposal —
in particular the argument for built-in types over a library
and the focus on IEEE 754 conformance.
Thanks to all who contributed to that discussion.
