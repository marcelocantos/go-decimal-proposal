# Proposal: add decimal floating-point types (`decimal64`, `decimal128`)

Author: Marcelo Cantos

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Last updated: 2026-11-16

Discussion at https://go.dev/issue/19787.

Related issues: https://go.dev/issue/82668, https://go.dev/issue/12127,
https://go.dev/issue/19770, https://go.dev/issue/26699,
https://go.dev/issue/9455

## Abstract

Add two predeclared decimal floating-point types following [IEEE
754-2019](https://standards.ieee.org/ieee/754/6210/), `decimal64` and
`decimal128`.
They are computed in software on most targets and by the decimal units of the
IBM targets (design decision 10).
They take part in Go's existing operators, constant system and conversions.
No new syntax or operator is introduced.

The constant system does change.
Real numeric constants gain an optional *quantum*, the exponent that
distinguishes `1.50` from `1.5`, used in decimal conversion and typed decimal
constant arithmetic.
It is an attribute of existing constants rather than a new constant kind, but
every constant operation must propagate it.
Untyped constant values and default types are unchanged: untyped arithmetic
stays exact, and typed decimal operations round at the type's precision.
Equal values such as `1.50` and `1.5` keep distinct representations.

The motivation is software whose quantities are stipulated in decimal: prices,
rates, taxes, tariffs and regulated limits.
A library can compute in base 10, but a library type cannot take part in Go's
operators, constants, equality or `cmp.Ordered`.
The question for review is whether that integration justifies a permanent
numeric kind in the language.

A fork of Go implements the design decisions below apart from
[Delve](https://github.com/go-delve/delve) support and the `s390x` hardware
backend, and runs in a browser playground.
Its `ppc64le` hardware backend has run only under emulation.
Its arithmetic is checked against an exact reference model, a conformance suite
written without reference to the kernel, and published test vectors.
That is not a certificate of complete IEEE conformance;
[Implementation](#implementation) separates what is verified from what remains.

This document and the fork were produced largely with agentic AI.
The fork adds about 34,000 lines of non-test code, which have not had detailed
human review ([AI-assisted provenance](#ai-assisted-provenance)).

## Background

### The problem

Binary floating-point types cannot represent most decimal fractions exactly.
The `float64` nearest `0.1` is
`0.1000000000000000055511151231257827021181583404541015625`, so

```go
a, b := 0.1, 0.2
fmt.Println(a + b) // 0.30000000000000004
```

This is not a defect in Go or in binary floating point.
It follows from using a base-2 representation for values written in base 10.

### Who needs decimal arithmetic

Decimal arithmetic matters where a quantity is stipulated rather than measured:
it was written in base 10 in a contract, a law, a tariff or a standard, and the
digits, the rounding and the trailing zeros are part of what was agreed.
Money is the largest case, and the rates applied to it the next.
The users are banking and finance, e-commerce, billing and tax, accounting and
ERP systems, regulated measurement (clinical results and food labelling round on
decimal digits), databases (SQL `DECIMAL` and `NUMERIC` are base 10, and MongoDB
has decimal128), and data interchange ([Apache
Arrow](https://arrow.apache.org/docs/format/Columnar.html)'s `Decimal128`,
[BSON](https://bsonspec.org/spec.html)'s `decimal128` and [RFC
9651](https://www.rfc-editor.org/rfc/rfc9651)'s decimal type).

[`shopspring/decimal`](https://github.com/shopspring/decimal) had 40,713
[importing
packages](https://pkg.go.dev/github.com/shopspring/decimal?tab=importedby) on
pkg.go.dev on 3 November 2026, and
[`cockroachdb/apd`](https://github.com/cockroachdb/apd),
[`ericlagergren/decimal`](https://github.com/ericlagergren/decimal) and others
add more.
According to the [2025 Go Developer Survey](https://go.dev/blog/survey2025), 13%
of Go developers work in financial services.
Many programs avoid decimal libraries and store money as `int64` minor units
(e.g., cents), as the [Stripe Go SDK](https://github.com/stripe/stripe-go) does
for every amount.
These figures show demand for decimal arithmetic.
They do not show how much of it needs built-in types; named workloads and
migration evidence are still needed.

### What a library cannot do

A library can compute decimal arithmetic.
`shopspring/decimal` does today, and [#82668](https://go.dev/issue/82668)
proposes a careful `math/decimal` for the standard library.
What a library cannot have is the treatment Go reserves for its predeclared
types:

- **Operators.** `price * qty * (1 - discount)` becomes
  `price.Mul(qty).Mul(One.Sub(discount))`.
- **Constants.** A library constant is a string parsed at initialization
  (`decimal.MustParse("0.20")`), with no compile-time check, while the literal
  `0.20` written from habit is silently a `float64`.
  Derived constants such as `const daily = annual / 360` become package-level
  variables computed at run time.
  With a built-in type, `var vat decimal64 = 0.20` is checked at compile time,
  and an untyped constant expression is evaluated exactly and rounded once on
  conversion.
- **Equality.** A struct compares field by field.
  [`woodsbury/decimal128`](https://github.com/woodsbury/decimal128), a
  fixed-size IEEE implementation, is `struct { lo, hi uint64 }`: `==` compiles,
  reports `1.5 != 1.50`, and reports a NaN equal to itself.
  [#82668](https://go.dev/issue/82668) disables `==` with a `_ [0]func()` field,
  so its `Decimal` cannot be a map key or a field of a comparable struct.
  Numeric equality across a cohort, where `1.5 == 1.50` and each keeps its own
  digits, is something only the language can define.
- **Ordering and generics.** No library decimal satisfies `cmp.Ordered`, so
  `slices.Sort`, `min`, `max` and every function written against `cmp.Ordered`
  are closed to it.
- **IEEE special values.** A library can define NaN and infinity as values, but
  not their behaviour under `==`, `<` and map lookup.
- **Decimal hardware.** A built-in type lets the compiler make `a + b` one
  decimal instruction with its operands in registers.
  A fixed-width library type in the standard library could get the same through
  compiler intrinsics; an arbitrary-precision one cannot (see [Native decimal
  hardware](#native-decimal-hardware)).

[#82668](https://go.dev/issue/82668)'s disabled `==` and string constants are
the shape the language forces on any library.
Its omission of the special values and its unbounded scale are its own choices.
The fixed-width libraries, `woodsbury/decimal128` and
[`migueldecimal128/decimal128-go`](https://github.com/migueldecimal128/decimal128-go),
show that an IEEE decimal library can be built well in Go, and they still have
every gap listed above.

The common workaround, integer minor units, is correct when used carefully and
fails quietly when not: a missing multiplication or division by 100 compiles,
runs and returns a plausible number.
A calculation that carries amounts to eight decimal places and rates in parts
per million overflows an `int64` balance-times-rate product at a balance of
about $1.8 million, and Go's integer overflow wraps silently.

### An example

A fixed-rate loan schedule shows the difference in ordinary code.
Given a principal, an annual rate and a term in months, `Schedule` returns the
balance after each monthly payment.
The three versions below follow one rounding policy.
The monthly rate is the annual rate divided by 12, to 12 places.
The growth factor (1+r)^months is carried to 12 places.
The annuity factor r×f/(f−1) is taken to 12 places.
The payment and each month's interest are rounded to cents.
Every rounding is to nearest with ties to even, IEEE 754's default and the
operators' own rounding, and the last payment clears the balance.
For a principal of at most $10,000,000.00, a positive annual rate of at most 25%
with four places and at most 480 months, every product is exact in `decimal128`,
as it always is in the two arbitrary-precision libraries.
Each step is then one exact operation followed by at most one rounding, so the
three compute the same thing by construction.

With this proposal's `decimal128`:

```go
func Schedule(principal, annualRate decimal128, months int) []decimal128 {
	const place, cent decimal128 = 1e-12, 0.01
	const even = decimal.ToNearestEven
	r := decimal.QuoQuantize(annualRate, 12, place, even)
	f := decimal128(1)
	for range months {
		f = decimal.Quantize(f*(1+r), place)
	}
	a := decimal.QuoQuantize(r*f, f-1, place, even)
	payment := decimal.Quantize(principal*a, cent)

	balances := make([]decimal128, months)
	balance := principal
	for i := range balances {
		interest := decimal.QuoQuantize(balance*annualRate, 12, cent, even)
		repaid := payment - interest
		if i == months-1 || repaid > balance {
			repaid = balance
		}
		balance -= repaid
		balances[i] = balance
	}
	return balances
}

balances := Schedule(300000.00, 0.0625, 360)
```

With `shopspring/decimal`, the most widely imported decimal library:

```go
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	one := decimal.NewFromInt(1)
	twelve := decimal.NewFromInt(12)
	r := divRoundBank(annualRate, twelve, 12)
	f := one
	for range months {
		f = f.Mul(one.Add(r)).RoundBank(12)
	}
	a := divRoundBank(r.Mul(f), f.Sub(one), 12)
	payment := principal.Mul(a).RoundBank(2)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := divRoundBank(balance.Mul(annualRate), twelve, 2)
		repaid := payment.Sub(interest)
		if i == months-1 || repaid.GreaterThan(balance) {
			repaid = balance
		}
		balance = balance.Sub(repaid)
		balances[i] = balance
	}
	return balances
}

// divRoundBank returns x / y rounded once to places decimal places, ties to
// even. DivRound rounds ties away from zero only, and Div followed by
// RoundBank rounds twice, the first time to 16 places.
func divRoundBank(x, y decimal.Decimal, places int32) decimal.Decimal {
	q, r := x.QuoRem(y, places)
	if r.IsZero() {
		return q
	}
	unit := decimal.New(1, -places)
	half := r.Abs().Add(r.Abs()).Cmp(y.Abs().Mul(unit))
	if half > 0 || half == 0 && q.Shift(places).BigInt().Bit(0) == 1 {
		if x.Sign() != y.Sign() {
			return q.Sub(unit)
		}
		return q.Add(unit)
	}
	return q
}

principal := decimal.RequireFromString("300000.00")
rate := decimal.RequireFromString("0.0625")
balances := Schedule(principal, rate, 360)
```

With the `math/decimal` package of [#82668](https://go.dev/issue/82668), as
implemented in [CL 855581](https://go.dev/cl/855581):

```go
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	const even = decimal.ToNearestEven
	twelve := decimal.FromInt(12)
	r := annualRate.Quo(twelve, 12, even)
	f := decimal.One
	for range months {
		f = f.Mul(decimal.One.Add(r)).Round(12, even)
	}
	a := r.Mul(f).Quo(f.Sub(decimal.One), 12, even)
	payment := principal.Mul(a).Round(2, even)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := balance.Mul(annualRate).Quo(twelve, 2, even)
		repaid := payment.Sub(interest)
		if i == months-1 || repaid.Greater(balance) {
			repaid = balance
		}
		balance = balance.Sub(repaid)
		balances[i] = balance
	}
	return balances
}

principal := decimal.MustParse("300000.00")
rate := decimal.MustParse("0.0625")
balances := Schedule(principal, rate, 360)
```

They give the same 360 balances, and those match the same policy computed in
exact rational arithmetic;
[`research/loan`](https://github.com/marcelocantos/go-decimal-proposal/tree/master/research/loan)
runs all three and checks them.
They differ in two ways.

- **Notation.** The growth step is `f*(1+r)` against `f.Mul(one.Add(r))`, a
  comparison is `repaid > balance` rather than `repaid.GreaterThan(balance)`,
  and the inputs are literals rather than parsed strings.
- **What each API offers.** shopspring can round a value in any mode
  (`RoundBank` is ties to even), but its only division that rounds once,
  `DivRound`, rounds ties away from zero, and `Div` followed by `RoundBank`
  rounds twice.
  Its version therefore needs `divRoundBank`, built on `QuoRem`. #82668's `Quo`
  takes the mode directly, as `math/decimal`'s `QuoQuantize` does.
  A policy of ties away from zero would have hidden this; the policy here is the
  IEEE default rather than one chosen to suit any of the three.

The rounding is explicit in all three, as a stated policy requires: the
operators of `decimal128` round to 34 digits, not to a business scale, so the
built-in version calls `Quantize` and `QuoQuantize` where the libraries call a
rounding method and a division with a scale.

Without a stated policy the three would not agree.
shopspring's `Div` keeps 16 places unless a package variable says otherwise,
#82668's `Quo` takes a scale on every call, and `decimal128` rounds every
operation to 34 digits.
A division followed by quantizing rounds twice, which `QuoQuantize` exists to
avoid (see [Standard library additions](#standard-library-additions)).

Whether the difference in notation, constants and comparison, repeated across a
code base, justifies a language change is the question this proposal puts.

### Precedent

Go added `complex64` and `complex128` as a numeric kind with operators,
constants and conversions.
This proposal asks for a comparable slot: a row in the numeric table, the
existing untyped-constant rules, no new operators and no new literal syntax.
The precedent has limits, set out in [Comparison with complex
types](#comparison-with-complex-types).

The closest precedent elsewhere is C23, which added `_Decimal32`, `_Decimal64`
and `_Decimal128` to the core language ([TS
18661-2](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1912.pdf)).
Like this proposal, C23 leaves the in-memory encoding to the implementation; GCC
uses BID on x86 and Arm and DPD on IBM hardware.
Unlike this proposal, C23 supports all five IEEE rounding modes through
`fesetround`.
C# has a built-in `decimal` that is not an IEEE format, and Java's `BigDecimal`
and Python's `decimal.Decimal` are library types.

### IEEE 754-2019 decimal formats

IEEE 754-2019 defines two encodings for decimal floating point:

- **DPD** (densely packed decimal) packs three decimal digits into 10 bits.
  IBM's decimal hardware operates on it.
- **BID** (binary integer decimal) stores the coefficient as a binary integer,
  which ordinary integer instructions manipulate directly.
  Software implementations favour it.

Both encode the same values, signs and quanta.
The in-memory form is not part of the language: each target uses the encoding
its arithmetic works on, BID in software and DPD with the decimal units of
`ppc64le` and `s390x`, XORed so that all bits clear means zero (design decisions
9 and 10).

| Property    | decimal64          | decimal128         |
|-------------|--------------------|--------------------|
| Size        | 8 bytes            | 16 bytes           |
| Coefficient | up to 16 digits    | up to 34 digits    |
| Exponent    | -398 to +369       | -6176 to +6111     |
| Max value   | 9.999...e+384      | 9.999...e+6144     |

Both types have quiet and signalling NaNs, positive and negative infinity, and
positive and negative zero.

A value is exact when it is an integer coefficient of at most 16 or 34 digits
times a power of ten in the format's range.
Within that envelope the types are exact; beyond it they round, as IEEE 754
specifies.

### Two widths

Commenters on [#19787](https://go.dev/issue/19787) suggested adding only
`decimal128`.
This proposal adds both.
`decimal64` is one word and `decimal128` two, and for applications holding
millions of values, such as market data feeds and database columns, the factor
of two in storage may matter; workload measurements are needed to show whether
it justifies both widths.
Go provides both `float32` and `float64`, and both decimal widths follow the
same pattern.
One kernel template generates both widths, and the compiler, runtime and
standard library handle both through the same code paths, though each width
still needs its own boundary tests, ABI support and public API coverage.
`decimal32` is not proposed: its seven digits are too few for most applications,
and no workload case for it has been made.

### Quantum

An IEEE decimal value can retain trailing zeros, subject to its coefficient and
exponent limits.
`1.0`, `1.00` and `1.000` are numerically equal members of one *cohort*, with
different quanta.
In financial software a price quoted as `1.50` should print as `1.50`.

The quantum follows the IEEE 754-2019 preferred-exponent rules through
arithmetic.
For an exact result, multiplication adds the operands' exponents, so
`decimal64(1.50) * decimal64(1.20)` is `1.8000`.
Addition and subtraction use the smaller exponent, so
`decimal64(1.5) + decimal64(0.10)` is `1.60`.
Division of a representable exact quotient uses the preferred exponent, the
difference of the operands' exponents, if it fits, and otherwise the nearest
exponent that represents the quotient: `decimal64(1.00) / decimal64(4)` is
`0.25`.
An inexact result is rounded to the full precision of the type, so
`decimal64(1) + decimal64(1e-20)` is `1.000000000000000`.

The quantum records a representation.
It is not measurement certainty or business policy.
Multiplication can add unwanted places, rounding can discard digits silently,
and even an exact addition can require a coarser quantum:
`99999999999999.99 + 0.01` in decimal64 is `100000000000000.0`.
Stored business scale needs explicit quantization; display needs formatting.

Equal values with different quanta are equal map keys: hashing normalizes them.
Assigning through an equal key can replace the stored representation, so
inserting `1.50` and then assigning with `1.5` can yield `1.5` when ranging the
map.
A NaN key cannot be retrieved by an ordinary lookup, even with itself.
Applications that need representation identity need a separate key.

### Goals

The proposal succeeds if business Go code can use `decimal64` and `decimal128`
as fluently as `float64`, with operators, constants and standard formatting; if
database drivers can scan SQL `DECIMAL` and `NUMERIC` columns into native types
and send them back, within the types' range; if JSON APIs can round-trip decimal
numbers of up to 34 digits without loss; and if the ecosystem converges on one
decimal type.
A working prototype is necessary but not sufficient.
Success also needs a settled semantic contract, verified integration on every
port and demonstrated benefit to real applications.

## Proposal

### New types

Two predeclared types are added:

```
decimal64   the set of all IEEE 754-2019 64-bit decimal floating-point numbers
decimal128  the set of all IEEE 754-2019 128-bit decimal floating-point numbers
```

These are decimal floating-point types.
Together with `float32` and `float64` they form the floating-point types of Go.
The names are predeclared identifiers, not keywords.

### Operators

The decimal types support the operators of the binary floating-point types, with
IEEE decimal arithmetic and comparison: `+`, `-`, `*` and `/`, unary `+` and
`-`, the comparisons, and the assignment forms.
`%`, the bitwise operators and the shifts are not supported, as for floats.
Every operator rounds to nearest, ties to even; there are no dynamic rounding
modes and no status flags (design decision 4).

### Constants

No new constant kind is introduced.
Decimal constants use the existing floating-point constant kind, and the default
type of an untyped floating-point constant remains `float64`.

```go
var d decimal64 = 3.14 // floating-point constant assigned to decimal64
const c = 2.718        // untyped floating-point constant, default type float64
var e decimal128 = c   // c is representable as decimal128
```

**Quantum attribute.** A real numeric constant may carry an optional decimal
exponent alongside its value.
The attribute affects decimal conversion and typed decimal arithmetic, not
comparison, default types or existing nondecimal arithmetic.
`1.50` has value 3/2 and quantum −2; `150` has quantum 0; `1.5e3` has quantum 2.

Untyped arithmetic distinguishes a finite decimal expansion from an exact
rational value.
`1.0 / 3.0` is the exact rational 1/3.
It has no finite decimal expansion and no quantum, and it is not rounded until
conversion.

The propagation rules follow.
`q(x)` denotes a present quantum.

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
| `min` or `max` on real constants | Use the selected operand's quantum; among equal values, the one IEEE 754-2019's totalOrder puts first (`min`) or last (`max`), as at run time. |
| Decimal conversion or typed decimal operation | Use the rules below; the resulting representable value carries its format exponent. |

**Decimal conversion.** The value is rounded to the destination's precision,
ties to even; overflow is an error.
An exact conversion retains the supplied quantum if the coefficient fits the
format's precision, and otherwise uses the exponent closest to the quantum, as
parsing does at run time.
A constant without a quantum takes exponent zero if it is an integer that fits,
and otherwise the smallest coefficient that holds its value.
An inexact conversion uses the precision and exponent required by rounding,
including trailing zeros in its coefficient.
Underflow may produce zero.
A decimal-to-decimal constant conversion starts from the already rounded value
and its quantum, not from its source spelling.

The quantum survives package boundaries:

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

Both type checkers, export data and the compiler must agree on value and quantum
for every row of the table.

**What `fmt.Println(1.10)` prints.** `1.1`.
With no decimal type in the context, the constant takes its default type
`float64`, which has no quantum to receive, by the same mechanism that makes
`fmt.Println(1.0)` print `1`.
`fmt.Println(decimal64(1.10))` prints `1.10`.
C#, Python and Java also keep the scale only for an explicitly decimal value
(`1.10m`, `Decimal("1.10")`, `new BigDecimal("1.10")`).
Go cannot make an unsuffixed `1.10` a decimal, as SQL does, without changing the
meaning of every fractional literal, and a literal suffix is left out (design
decision 11).

**Typed constants.** Typed decimal constant expressions are constant
expressions.
Each operation on typed decimal constants is rounded to the type's precision, as
`go/types` and `cmd/compile` do for typed `float32` and `float64` constants, so
finite nonzero results agree with the same sequence of rounded run-time
operations when those are not fused.
Constants keep Go's restrictions: division by zero and nonfinite results are
errors, and a constant zero has no sign and converts to positive zero, retaining
its quantum.
Run-time operations can instead produce NaN, infinity or negative zero.
These are the exceptions to run-time parity.
Untyped constant expressions stay exact until converted, so the author chooses
by typing the constant or not:

```go
const a decimal64 = 1
const b = a / 3 * 3             // 0.9999999999999999, as at run time
const c decimal64 = 1.0 / 3 * 3 // 1: exact, then converted
```

The rounding here is to the type's 16 or 34 digits.
Rounding to a business precision such as cents is a `Quantize` call at run time.

**Representability.** A constant is representable by a decimal type if it can be
rounded to the type's precision without overflow, so `decimal64(1.0/3.0)` is
`0.3333333333333333`, while `decimal64(1e400)` is a compile-time error, as
`float64(1e400)` is.

### Conversions

Conversions between numeric types follow Go's existing rules:

```go
var f float64 = 3.14
var d decimal64 = decimal64(f)      // binary to decimal
var g float64 = float64(d)          // decimal to binary
var d128 decimal128 = decimal128(d) // widening
var d64 decimal64 = decimal64(d128) // narrowing (may lose precision)
var i int = int(d)                  // truncation toward zero
var d2 decimal64 = decimal64(42)    // integer to decimal
```

- A non-constant binary value converts to the decimal value nearest its exact
  binary value at the destination's precision, as IEEE 754-2019 specifies.
  `decimal128(f)` for `f := 0.1` is `0.1000000000000000055511151231257827`,
  while `decimal128(0.1)` with a constant operand is exactly `0.1`.
  For finite `float64` values, the intended round-trip property is
  `float64(decimal128(f)) == f`.
- A decimal value converted to an integer type truncates toward zero.
  The result for values out of range and for NaN is implementation-dependent, as
  it is for binary floats.
- Widening `decimal64` to `decimal128` is exact and preserves the quantum.
  Narrowing rounds to nearest, ties to even.
- A rune literal converts as its integer value: `'a'` assigned to a decimal is
  `97`.
  A hexadecimal floating literal has no quantum and converts by the rule for
  constants without one: `0x1p-2` is `0.25`.

### Standard library additions

**`math`** is unchanged.
As the complex types add nothing to `math`, keeping their functions in
`math/cmplx`, the decimal types keep theirs in `math/decimal`, the counterparts
of `Float64bits` included.

**`math/decimal`** (new).
Functions generic over `Decimal interface { ~decimal64 | ~decimal128 }`, each
computing in the format of its type argument:

- named and specified as `math`'s are: `Abs`, `Ceil`, `Floor`, `Trunc`, `Round`,
  `RoundToEven`, `Copysign`, `Signbit`, `Dim`, `FMA`, `Mod`, `Remainder`, `NaN`,
  `Inf`, `IsNaN`, `IsInf`, `Sqrt`, `Exp`, `Log`, `Log10`, `Pow`, `Ldexp`,
  `Logb`, `Ilogb` and `Nextafter`;
- the limit constants `MaxDecimal64`, `SmallestNonzeroDecimal64`,
  `MaxDecimal128` and `SmallestNonzeroDecimal128`, corresponding to `math`'s;
- the quantum operations, which have no float counterpart: `Quantize`,
  `QuantizeMode`, `QuoQuantize`, `SameQuantum`, `Quantum` and `Reduce`.
  `QuantizeMode` quantizes with an explicit `RoundingMode`, for the directed and
  half-away roundings the operators do not provide.
  `QuoQuantize(x, y, q, mode)` divides and rounds once to the quantum of `q`,
  the division to a fixed scale of SQL and of Java's
  `BigDecimal.divide(divisor, scale, mode)`, which a division followed by
  `QuantizeMode` can get wrong by rounding twice;
- `Decompose` and `Compose`, which convert between a value and its sign,
  coefficient (`hi, lo uint64`) and exponent, for drivers and other libraries;
- `RoundingMode`, with `math/big.RoundingMode`'s six names, values and `String`
  method: IEEE 754-2019's five modes and `AwayFromZero`, which rounds every
  inexact magnitude up ("round up to the next cent");
- `Pown`, `Rootn` and `Compound` (IEEE 754-2019 clause 9.2) and `Payload`,
  `NaNWithPayload` and `SignalingNaNWithPayload` (clause 9.7), which have no
  `math` counterpart and are an [open issue](#open-issues).

Each function with a `math` counterpart takes its name, argument order and
special cases.
`Ldexp(frac, exp)` is frac × 10^exp, IEEE's scaleB in the format's radix.
`Logb` returns the decimal type and `Ilogb` an `int`.
IEEE's nextUp and nextDown are `Nextafter` toward an infinity.
`Sqrt`, `Ldexp`, `Logb`, `Ilogb` and `Nextafter` are operations IEEE 754-2019
requires (clauses 5.4.1, 5.3.3 and 5.3.1); `Exp`, `Log`, `Log10` and `Pow` are
recommended operations of clause 9.2.

The square root, powers, roots, exponential and logarithms are correctly
rounded: the result is the value of the type nearest the exact one, with ties to
even, so every implementation gives the same bits.
An exact result has the exponent the standard prefers: `Sqrt(2.25)` is `1.5`,
`Pown(1.5, 2)` is `2.25` and `Log10(1000)` is `3`.
`Compound(x, n)` is (1+x)^n without the rounding of 1+x, for a rate too small
for the sum to hold.
A signalling NaN is invalid even where a quiet one is passed over, so
`Pow(sNaN, 0)` is a NaN while `Pow(NaN, 0)` is 1.
`Min` and `Max` are the built-ins.

The package also provides three families of width-specific bits functions.
`Native64bits`/`Native64frombits` and `Native128bits`/`Native128frombits` are
the counterparts of `Float64bits`.
They copy the exact stored words, including the zero-value XOR, and perform no
conversion or canonicalization, so `Native64bits(0)` is zero and
`Native64bits(Native64frombits(b)) == b` for every bit pattern; the same holds
for both decimal128 words.
`Float64bits` returns both a float's memory form and its IEEE interchange
encoding; these return the first only, because a decimal's memory form is
XOR-adjusted (design decision 9) and IEEE 754-2019 has two decimal encodings.
As for a float, the words do not depend on byte order.
They differ only between a target that stores BID and one that stores DPD.

The interchange codecs are `BID64bits`/`BID64frombits`,
`BID128bits`/`BID128frombits`, `DPD64bits`/`DPD64frombits` and
`DPD128bits`/`DPD128frombits`.
They exchange IEEE encoding words without the zero-value XOR.
Every decimal128 function in the three families takes and returns
`(hi, lo uint64)`, high word first, as `math/bits`' `Mul64` does.
A codec matching the native encoding preserves every encoding bit; a codec
crossing encodings preserves the IEEE value, quantum and NaN payload and can
canonicalize non-canonical patterns.
The typed constant `NativeRepresentation`, of type `Representation`, is `BIDXOR`
or `DPDXOR`, naming the encoding and the XOR adjustment; its documentation
specifies each width's zero mask.

The package is separate from `math` as `math/cmplx` is.
It is generic rather than `decimal128`-only, unlike `math`'s `float64`-only
functions, because results depend on the format: the preferred exponent and
whether a coefficient fits (`Quantize` returns NaN when it does not) differ
between the widths, so computing in `decimal128` and narrowing would give other
results.
The exact set of functions is open to review.

**`strconv`.** `ParseDecimal(s string, bitSize int) (decimal128, error)`,
`FormatDecimal(d decimal128, fmt byte, prec, bitSize int) string` and
`AppendDecimal` behave as `ParseFloat`, `FormatFloat` and `AppendFloat` do,
except where the quantum or the radix requires otherwise.

`ParseDecimal` accepts what `ParseFloat` accepts: Go floating-point literal
syntax with underscores where `ParseFloat` allows them, hexadecimal mantissas
with a binary exponent, `NaN` without a sign and `Inf` and `Infinity` with one.
There is no signalling or signed NaN spelling, as for floats.
A decimal numeral keeps the quantum of its digits.
A hexadecimal one is rounded once from its exact binary value and takes the
quantum of a constant without one: exponent 0 for an integer that fits,
otherwise the smallest coefficient (`0x1p-2` is `0.25`).
Excess digits are rounded, not truncated.
A value too large for the type returns a signed infinity and `ErrRange`, and one
too small rounds to a subnormal or zero without an error, as `ParseFloat` does.
A bitSize other than 64 is taken as 128, as `ParseFloat` takes one other than 32
as 64.

`FormatDecimal` checks its arguments as `FormatFloat` does.
A bitSize other than 64 or 128 panics, bitSize 64 converts the value to
`decimal64` first, and a format byte other than `b`, `e`, `E`, `f`, `g`, `G`,
`x` or `X` gives `%` and the byte.

- `'b'` writes the coefficient and the decimal exponent of its last digit,
  `150e-2` for `1.50`, the radix-ten form of a float's `'b'`.
- `'x'` and `'X'` write a float's `-0xh.hhhhp±dd`, a hexadecimal fraction and a
  binary exponent laid out as `FormatFloat` lays them out, of the decimal's
  value rounded to nearest, ties to even, at the precision asked for.
  A decimal that is exactly a `float64` value formats as that `float64` does.
  Most decimal values have no finite binary fraction, so the digits are rounded,
  as `'e'` with a precision rounds.
  The precision has no cap, as for `FormatFloat`; unlike a float's, the
  expansion of a decimal whose reduced denominator has a factor of 5 does not
  terminate, so digits past its first ones are real digits, not zeros.
- With the decimal formats (`e`, `E`, `f`, `g`, `G`), precision −1 means every
  coefficient digit, where for a float it means the fewest digits that
  round-trip, because a decimal's digits carry its quantum.
  With `'x'` and `'X'` it means what it means for a float, the fewest digits
  that `ParseDecimal` at the same bitSize reads back as the same value.
  Hexadecimal text has no quantum, so the value round-trips and the member of
  its cohort does not (`1.50` is `0x1.8p+00`).
- `'g'` at precision −1 is the canonical string, laid out as design decision 2
  specifies: `1234567.89` formats as `1.23456789e+06`, as a `float64` does, and
  `1e+03` is not `1000`.

An explicit precision changes the text, not the stored value.

**`fmt`.** The decimal types take a float's verbs, `v`, `b`, `e`, `E`, `f`, `F`,
`g`, `G`, `x` and `X`, with `%b`, `%x` and `%X` as `strconv`'s `'b'`, `'x'` and
`'X'`, and the flags, width and precision a float takes.
`go vet` accepts the same verbs.
`%v` and `%g` without a precision print the canonical string (`1.50` for a value
with quantum −2).
A precision quantizes the output as it does for floats: `%.2f` of `1.5` is
`1.50`.
The `#` flag keeps its float meaning.
Scanning a decimal accepts what scanning a float accepts, including the `1.2p4`
form, whose product is formed exactly and rounded once.

Default text round-trips value, sign and quantum for canonical finite encodings
at the same width, signed zero included.
It does not preserve NaN payloads, signalling state or non-canonical encodings,
as for floats: a NaN with bits `7c00000000000123` formats as `NaN` and parses as
`7c00000000000000`.

**`reflect`.** `Decimal64` and `Decimal128` are appended to `Kind` after
`UnsafePointer`; no existing value changes.
`Value.Decimal`, `Value.SetDecimal` and `Value.CanDecimal` follow the complex
family, and `Value.OverflowDecimal` reports overflow as `OverflowFloat` does.
`Type.Bits` returns 64 and 128.
`Type.OverflowDecimal` is added when the experiment graduates: `Type` is an
interface, and an interface method cannot be absent while the experiment is off
(design decision 7).
`Value.IsZero` and `DeepEqual` compare numerically, so `0.00` is zero and `1.0`
equals `1.00`.

**`encoding/json`.** A decimal is marshalled as a JSON number with every
coefficient digit, laid out as design decision 8 specifies, so `1.50`
round-trips as `1.50`.
Unmarshalling preserves value and quantum when both fit the destination format;
excess precision is rounded.
JSON syntax supplies no precision or range bound, so decoding is not lossless
for arbitrary JSON numbers.
The `string` tag is supported.
NaN and the infinities are an error, as for floats.
Upstream's `jsonv2` experiment is on by default at the fork's merge base, so
`encoding/json/v2` carries the same marshalers and unmarshalers.

**`encoding/binary` and `encoding/gob`** use the BID wire layouts of design
decision 8.
**`encoding/xml`** uses the canonical string.

**`database/sql`.** Decimal columns scan from strings, byte slices, integers and
floats.
A decimal parameter becomes its canonical string, the text a float gets from
`'g'` at precision −1, which keeps a positive quantum (`1.5e+03`).
It is a string rather than a `float64` `driver.Value`, because there is no
decimal `driver.Value` type and `float64` would change the value.
Scanning a binary float cannot recover the original decimal input, and SQL
values outside the destination's precision or range cannot round-trip exactly.
Column scale is not a guarantee made by the Go type, and driver and schema
behaviour need their own tests.
A driver with a binary protocol, such as PostgreSQL's `numeric`, can build and
read decimals from their coefficient and exponent with `decimal.Compose` and
`decimal.Decompose`.

**`cmp`** adds `decimal64` and `decimal128` to `Ordered`, as its documentation
anticipates.
**`sort`** gains nothing; `slices.Sort` covers decimal slices.
**`text/template`** and **`html/template`** support the decimal types, including
numeric comparison across widths.

**`go/constant` and `go/types`.** `go/constant` gains
`Quantum(x Value) (exp int, ok bool)`, which reports a value's optional quantum,
and its operations propagate the quantum by the table above.
`go/types` gains the basic kinds `Decimal64` and `Decimal128`, appended after
the existing kinds, and the `BasicInfo` flag `IsDecimal`, which the masks
`IsNumeric`, `IsOrdered` and `IsConstType` include.

### Size and alignment

```
type          size in bytes
decimal64     8
decimal128    16
```

Alignment is target-dependent; size does not imply alignment.
The darwin/arm64 compiler aligns both types to 8 bytes.
No 16-byte alignment guarantee is proposed for `decimal128`.
The ABI on other targets still needs verification.

### Interaction with other language features

**Type switches, assertions and generics.** The decimal types work in type
switches and type assertions like any other concrete type.
They satisfy `cmp.Ordered` and can be used with generic functions whose type
sets include them; existing custom numeric type sets do not acquire them.
A constraint can name them:

```go
type Decimal interface {
	decimal64 | decimal128
}
```

**`unsafe.Sizeof`** returns 8 and 16.

**`go/constant`.** Typed decimal constants use the existing `constant.Float`
kind; their rounded values are themselves exact rationals.

**Equality and map keys.** `==` compares values as IEEE comparison does, so
cohort members are equal. Map keys hash a canonical key and compare numerically,
including in composite keys such as `map[struct{A decimal64; B int}]int` and
`map[[2]decimal128]int`.

**`print` and `println`** write the text `%v` writes (`1.50`, `1e+03`, `+Inf`),
as they do for floats.

### Language spec changes

The following changes to the [Go specification](https://go.dev/ref/spec) are
required.
The fork implements the behaviour each describes.

**Numeric types.** Add after the `float32` and `float64` entries:

> ```
> decimal64   the set of all IEEE 754-2019 64-bit decimal floating-point numbers
> decimal128  the set of all IEEE 754-2019 128-bit decimal floating-point numbers
> ```
>
> The types `float32` and `float64` are binary floating-point types that use a
> base-2 representation.
> The types `decimal64` and `decimal128` are decimal floating-point types that
> use a base-10 representation as defined by IEEE 754-2019.
> Decimal floating-point types can represent decimal fractions exactly within
> their coefficient and exponent limits, unlike binary floating-point types,
> where values such as 0.1 have no exact representation.
> Both binary and decimal floating-point types support the same arithmetic and
> comparison operators.

**Predeclared identifiers.** Add to the Types line:

> ```
> complex64 complex128 decimal64 decimal128 error float32 float64
> ```

**Constants.** Add to the Constants section:

> A real numeric constant may have an optional quantum: an integer recording a
> decimal exponent.
> Literal and expression propagation follow the table in
> [Constants](#constants).
> The attribute does not change the value of an untyped constant, its default
> type or its comparison behavior.
>
> An operation on constants of a decimal floating-point type rounds to that type
> with ties to even and uses the IEEE preferred exponent subject to the format's
> precision and exponent limits.
> Constant division by zero and results that would be nonfinite are illegal. A
> constant zero has no sign and converts to positive zero, retaining a
> representable quantum.
> Untyped arithmetic remains exact, including rational results without finite
> decimal expansions.

This is draft wording.
The final edit should fold the propagation table and the constant conversion
rules into the spec's text on constant expressions, beside its sentence that
they are evaluated exactly.

**Constant expressions.** After the sentence that constant expressions are
always evaluated exactly, add:

> The value of a typed constant must be representable by its type, so the result
> of each operation on typed floating-point constants is rounded to the type, as
> for `const f float32 = 1<<24`, where `f + 1 - 1` is `16777215`.

This changes the text for the binary types, not their behaviour: `go/types` and
`cmd/compile` already round typed `float32` and `float64` constant operations
this way, and Go 1.27 prints `16777215` for that example.
The spec does not say so today, and the decimal rule needs it said.

**Representability.** Add to the rules:

> `x` is representable by a value of type `T` if `T` is a decimal floating-point
> type and `x` can be rounded to `T`'s precision (16 or 34 significant decimal
> digits, to nearest even) without overflow.

and to the examples:

> ```
> 1.23       decimal64   1.23 is in the set of decimal64 values
> 1.0/3.0    decimal64   rounds to 0.3333333333333333
> 1e400      decimal64   overflows decimal64
> ```

**Conversions of constants.** Add to the Conversions section:

> When a constant `x` is converted to a decimal floating-point type `T`, the
> value is rounded to nearest, ties to even, at `T`'s precision.
> Overflow is illegal. An exact conversion retains the quantum if it fits;
> otherwise it uses the exponent closest to the quantum.
> A constant without a quantum has exponent zero if it is an integer that fits,
> and otherwise the smallest coefficient that holds its value.
> An inexact conversion uses the exponent required by precision and range,
> without reducing trailing zeros.
> Constant zero converts to positive zero.

**Floating-point operators.** Extend the paragraph on fused operations:

> This applies to both binary and decimal floating-point types.

**The zero value.** Add:

> The zero value of a decimal floating-point type is the result of converting
> the integer constant `0` to that type, and so has quantum 0.

**Comparison operators.** Add after the floating-point bullet:

> Decimal floating-point types are comparable and ordered.
> Two decimal floating-point values are compared as defined by the IEEE 754-2019
> standard.

**Conversions between numeric types.** Add:

> When converting between binary floating-point types (`float32`, `float64`) and
> decimal floating-point types (`decimal64`, `decimal128`), the result is
> rounded to the precision of the destination type.
> Such conversions may lose precision due to differences in radix
> representation; for example, the decimal value 0.1 has no exact binary
> floating-point representation.

**Min and max.** Add after the table of floating-point rules:

> For decimal floating-point arguments, values that are equal may still differ
> in their quantum, as `1.0` and `1.00` do.
> Among them, as negative zero is smaller than zero, the order is the totalOrder
> of IEEE 754-2019: `min` returns the one with the smaller exponent and `max`
> the one with the larger if they are positive, and the reverse if they are
> negative.

So `min(1.0, 1.00)` and `min(1.00, 1.0)` are both `1.00`, `max` of either is
`1.0`, and `min(-1.0, -1.00)` is `-1.0`, at run time and in constants.

**Manipulating complex numbers.** Add:

> There is no complex type with decimal floating-point constituents, so the
> arguments of `complex` cannot be of a decimal floating-point type.

The comment on the `Float` type-set example becomes "all binary floating-point
types".

**Size and alignment guarantees.** Update the table:

> ```
> uint64, int64, float64, complex64, decimal64     8
> complex128, decimal128                           16
> ```

## Design decisions

Each entry states the decision, its reason and whether the fork implements it.
Disagreement with any of them should be raised on
[#19787](https://go.dev/issue/19787).
Recording them makes each a single answer applied everywhere, rather than
something the implementation decides by accident.

One rule governs these decisions and any still to be made.
The decimal types behave as Go's binary floating-point types do, in the
language, the runtime and the standard library, in every observable respect,
unless there is a good reason for them to differ.
A good reason follows from what decimals are: they carry a quantum (IEEE
754-2019 cohorts), their radix is ten, or an IEEE 754-2019 decimal clause
requires something different.
Implementation convenience, performance and preference are not.
Floats have one cohort, the two zeros, which are equal and yet distinct;
whatever floats do with `-0` and `+0`, the decimal types do with every cohort,
and that is not a divergence.
Each divergence states its reason where it is specified; an undocumented
divergence is a defect.
As with Go's floats, there is no dynamic rounding environment and there are no
status flags.

The divergences this document specifies are listed below, each with its reason
and how other decimal implementations decide the same question (C23 as in draft
[N3220](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf); GDA is the
[General Decimal Arithmetic](https://speleotrove.com/decimal/) specification):

| Divergence from the binary floats | Reason | Precedent |
|---|---|---|
| Constants keep the quantum, where a float constant has no sign: `-0.0` is `0` (§1) | Quantum: carrying the quantum is what the types are for, and conversion must be able to keep it | C23 decimal constants: `0.00dd` keeps exponent −2 ◆ Python `Decimal("1.50")` ◆ .NET `1.50m` ◆ Against: [TC39 Decimal](https://github.com/tc39/proposal-decimal) hides trailing zeros |
| Hexadecimal text (`'x'`, `%x`) gives the value back, not the cohort member, where a float's keeps the sign of a zero (`-0x0p+00`) | Quantum: hexadecimal text has no place for a power of ten | None: C23's `%Da` is decimal, not hexadecimal ◆ C23's `strtod64` reads hexadecimal input by value |
| gob keeps a zero field's quantum, where it folds a float's `-0` into `+0` (§12) | Quantum: a zero's exponent is its scale (`0.00` is zero to the cent), and a round trip through a struct field should not lose it | The interchange encodings keep a zero's exponent ◆ Java serializes the scale ◆ Python pickles `0.00` as `'0.00'` |
| `%b` and `'b'` write a power of ten | Radix: a float's `%b` writes its integer significand and a power of two | None as a format ◆ Python's `as_tuple()` and Java's `unscaledValue()` and `scale()` expose the same pair |
| The stored bits (`decimal.Native64bits`, `unsafe`) are the encoding XORed with that of `0E+0`, not the IEEE interchange encoding a float's bits are (§9) | Quantum: Go's zero value is all bits clear and must be `0E+0`, which has the exponent of `decimal64(1)`; IEEE's all-bits-zero decimal is `0E-398` | Python's `Decimal()`, Java's `BigDecimal.ZERO` and the older .NET `decimal`'s default have exponent 0 ◆ Against: [TR 24733](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2009/n2849.pdf) and GCC's static zero are `0E-398` ◆ C23 leaves it to the implementation |
| `math/decimal` is generic over both widths | IEEE 754-2019 decimal: preferred exponents and what fits depend on the format | .NET's `IDecimalFloatingPointIeee754<T>` ◆ [Boost.Decimal](https://github.com/boostorg/decimal)'s templates ◆ C23's `<tgmath.h>` over per-width functions |
| No complex type with decimal parts; `complex` rejects decimals | No decimal complex format exists, and the proposal adds decimal types only | C23 and TS 18661-2 define no decimal complex types |
| No `Type.OverflowDecimal` method yet | Temporary: an interface method cannot be absent while `GOEXPERIMENT=decimal` is off (§7); it is added when the experiment graduates | Not applicable: specific to Go's experiment mechanism |

The rules below are not divergences.
Each does with every cohort what the floats do with their one cohort, the two
zeros:

| Decimals, for every cohort | Floats, for `-0` and `+0` | Precedent |
|---|---|---|
| `==`, map keys and `switch` treat the members of a cohort as one value | `-0 == +0`; they are one map key and match one case | C23 `==` ◆ Python `==` and `hash` ◆ .NET `Decimal64` ◆ Db2 `DECFLOAT` ◆ Against: Java's `BigDecimal.equals` and `hashCode` depend on the scale |
| `min` and `max` order the members of a cohort by IEEE 754-2019's totalOrder | `min(-0.0, 0.0)` is `-0` | GDA and Python `max` and `min` break ties by sign and exponent ◆ IEEE 754-2019 and C23 leave it open ◆ Java and .NET choose by operand position |
| Default text and precision −1 write the member: every coefficient digit, in exponent form for a quantum above the units digit (§2) | The shortest text that reads back as the same float writes `-0`, not `0` | Every digit: C23 `%Da`, GDA to-scientific-string, Python, Java `BigDecimal`, .NET `Decimal64` ◆ Thresholds are Go's floats', where theirs leave `1234567` in fixed notation |
| Underflow gives the zero IEEE 754-2019 specifies, with its exponent (`0e-398`) | Underflow gives the zero IEEE 754 specifies, with its sign | C23 (5.2.5.3.4), GDA and Python ◆ GCC's `_Decimal64` gives `0E-398` too |
| `Quantum` and `SameQuantum` inspect the member; `Quantize` and `QuantizeMode` choose it | `Signbit` inspects the member; `Copysign` chooses it | Python `quantize(exp, rounding=…)` ◆ Java `setScale(n, RoundingMode)` ◆ Db2 `QUANTIZE` ◆ The rounding fields of the POWER and z/Architecture quantize instructions |
| `IsZero`, `omitempty` and `DeepEqual` go by value, so `0.00` is zero and `1.0` equals `1.00` | They go by value, so `-0` is zero and equals `+0` | — |

Nor is NaN propagation a divergence.
Floats leave the choice of NaN to the hardware; the decimal types make one of
the choices that permits, the first signalling NaN and otherwise the first NaN,
keeping its sign and payload (design decision 4), as GDA and Python do.

### 1. Constants

**Constants carry an optional quantum; untyped values stay exact rationals;
typed decimal constants round after each operation.** The table in
[Constants](#constants) defines where the quantum is retained, reset or absent,
and the constant exceptions to run-time behaviour.
Decimal conversion and typed decimal arithmetic consume the quantum; other
numeric behaviour is unchanged.

*Reason:* this gives `var d decimal64 = 1.50` the quantum of `1.50` without
changing the meaning of any existing program.
It survives package boundaries and named constants, and it lets `go/types` and
the compiler share one definition.
The alternatives were a new constant kind, a far larger change to `go/constant`
and the spec, and constants without a quantum, which would make `1.50`
indistinguishable from `1.5` at compile time.
Typed constants round as typed float constants do, so finite nonzero results
agree with run time, absent fused operations, and typing a constant is how an
author asks for that rounding.
The spec's sentence that constant expressions are always evaluated exactly does
not describe what the type checkers do for typed floats, so the spec change
states the decimal rule explicitly.
The tradeoff needs review.

*Status:* implemented.
`go/constant` carries the quantum and reports it through `constant.Quantum`.
Both type checkers and the compiler encode decimal constants through one shared
package, `internal/constdecimal`, which folds typed decimal operations through
the kernel.
Export data carries the quantum, so every row of the cross-package example
holds, as do multiple-name declarations, negated named constants and `T(1.50)`
for a type parameter `T`, while `T(float64(0.1))` converts from the `float64`.
`const a = decimal64(1.50) * 2` is a constant with the value `3.00` in both type
checkers.

### 2. Default formatting

**Default output preserves the quantum.** `%v`, `%g`, `strconv.FormatDecimal`,
JSON, XML and `database/sql` write `1.50` for a value with quantum −2, and
`strconv.ParseDecimal` of that text returns the same value, sign and quantum for
canonical finite values parsed at the same width.
Text does not preserve arbitrary NaN bits or non-canonical encodings, as it does
not for floats.
`println` writes what `%v` writes, as it does for floats.

The layout is Go's float layout.
`println`, `%v`, `%g` and `strconv.FormatDecimal(d, 'g', -1, …)` write one form,
laid out as a `float64`'s shortest form is: fixed notation unless the exponent
of the leading digit is below −4 or at least 6, and otherwise a lowercase `e`
with at least two exponent digits (`1e-05`, `1.23456789e+06`), with `+Inf` and
`-Inf`.
The one difference is the quantum: every coefficient digit is written, and a
quantum above the units digit, which fixed notation cannot show, forces the
exponent form (`1e+02` is not `100`).
Each member of a cohort has its own digits: the coefficient 1000000 with
exponent 0 prints as `1.000000e+06` and `1E+6` as `1e+06`.
JSON writes a decimal with the thresholds it uses for a float (design decision
8), so `1234567.89` is `1234567.89` there.
Callers who want `1.5` apply `decimal.Reduce`, IEEE's reduce operation.
The `#` flag keeps its float meaning, and `IsZero`, `omitempty` and `DeepEqual`
are numeric.

*Reason:* `%v` for a float prints the shortest string that round-trips the
value.
For a decimal, the shortest string that round-trips the value and the quantum is
the coefficient with its exponent.
Keeping the quantum is what IEEE 754's convertToDecimalCharacter, Java's
`BigDecimal`, Python's `Decimal` and C#'s `decimal` do; the layout follows Go's
floats.

*Status:* implemented, `database/sql` included.

### 3. Helper functions

**Helper functions live in `math/decimal`, and nothing is added to `math`.** The
generic arithmetic helpers, the counterparts of `Float64bits` (`Native64bits`
and its siblings) and the interchange codecs all live in the new `math/decimal`,
and `sort` gains nothing.
Each function with a `math` counterpart takes its name, argument order and
special cases: `Ldexp`, `Logb`, `Ilogb` and `Nextafter`, not IEEE's scaleB,
logB, nextUp and nextDown, whose operations they are.

*Reason:* a separate package for a family of types follows `math/cmplx`, and the
complex types add nothing to `math`, not even bits functions.
The functions are generic over both widths, where `math` is `float64`-only,
because a decimal result depends on its format (see [Standard library
additions](#standard-library-additions)).

*Status:* implemented.
`math` is unchanged.

### 4. Rounding modes and sNaN

**Operators round to nearest, ties to even; nothing else.** Directed rounding
and round-half-away are explicit functions in `math/decimal` (`Ceil`, `Floor`,
`Trunc`, `Round`, `RoundToEven`, `QuantizeMode`, `QuoQuantize`), and
`RoundingMode` adds `AwayFromZero` to IEEE's five.
A signalling NaN is accepted as input and quieted.
A NaN operand propagates as it does in `float64`: the result is that NaN made
quiet, with its sign and payload (IEEE 754-2019 clause 6.2.3).
Of several NaN operands the first signalling one wins, otherwise the first,
which is the General Decimal Arithmetic rule.
A NaN created by an invalid operation is the canonical quiet NaN.
Conversions to and from `float64` and text do not carry payloads.

*Reason:* this is the `float64` precedent.
Dynamic rounding modes are global state that Go does not have, and the financial
half-up case is a rounding operation (`Round`, `QuantizeMode`), not a mode.
`AwayFromZero` is not an IEEE 754 mode, but fixed-scale rules use it, and
`math/big.RoundingMode`, the General Decimal Arithmetic, Java, Python, SQL and
#82668 all have it; `RoundingMode` takes `math/big`'s names and values so that
Go has one vocabulary for rounding.
Payload propagation follows the same precedent and IEEE's recommendation.

*Status:* implemented.
The operators round once, to nearest with ties to even, quiet signalling NaNs,
and propagate payloads and signs as described.
The kernel implements all six rounding modes, and `QuantizeMode` and
`QuoQuantize` make them public.

### 5. Conversions

**Conversions are correctly rounded from the exact source value.** A
non-constant `float64` converts to the decimal nearest its exact binary value at
the destination's precision.
Constants convert exactly when representable.
Decimal to integer truncates toward zero and is implementation-dependent out of
range or for NaN, as for floats.

*Reason:* a conversion of a value is a conversion of that value; converting the
shortest printed decimal string can choose a different decimal value.
The intended round-trip property for finite `float64` values,
`float64(decimal128(f)) == f`, does not distinguish the two policies; correct
rounding from the exact source value does.

*Status:* implemented for non-constant values and for constants of a concrete
decimal type or a type parameter, through the kernel.

### 6. Widths

**Both `decimal64` and `decimal128`; no `decimal32`.**

*Reason:* see [Two widths](#two-widths).
A shared kernel reduces duplicated implementation, but each width still needs
its own boundary and integration evidence.

*Status:* implemented.
Both widths use `internal/bid`, generated from one template, a form chosen by a
measured spike recorded in the package documentation.
That sharing does not establish `decimal128` conformance from `decimal64` tests.

### 7. Rollout

**Decimal is opt-in at build time with `GOEXPERIMENT=decimal` for at least one
release, and the types require a `go.mod` language version; public constants are
appended, never renumbered.** `reflect.Kind` and `go/types.BasicKind` gain their
new values after the existing ones.
The order of `Kind` values is not a semantic property, so appending them is not
a divergence from the floats.
New public declarations carry `goexperiment.decimal` build constraints, and the
existing public API is unchanged when the experiment is off.

*Status:* implemented.
The new kinds follow `UnsafePointer` in `reflect` and `UntypedNil` in
`go/types`.
The types require `go1.28` in `go.mod`: with the experiment enabled and
`go 1.22` in `go.mod`, `var x decimal64` fails with "predeclared decimal64
requires go1.28 or later".
The new public declarations in `math/decimal`, `reflect`, `strconv`,
`go/constant`, `go/types` and `debug/dwarf` are in files constrained by
`goexperiment.decimal`, and standard-library code uses private decimal access,
available in either mode.
The experimental API is recorded in `api/next/19787.txt`, and the API checker
verifies both surfaces.
At the pinned revision, `all.bash`, which runs the API checker, passes on
darwin/arm64 with the experiment off and with it on.

### 8. Wire formats

**Wire formats are specified explicitly and do not depend on the target's memory
form.**

- `encoding/binary` writes the IEEE BID interchange encoding in the requested
  byte order, most significant word first for `BigEndian`.
- `gob` has one wire type, `decimal`, for both widths, as `float` serves both
  float widths.
  It takes built-in type id 9, the first of the ids gob reserves for new
  built-in types.
  A value is sent widened to `decimal128`, which is exact and keeps the quantum,
  as its IEEE BID encoding in two words, each a gob unsigned integer: the high
  one byte-reversed, as a float's bits are, and sent first.
  Either decimal type receives it; into `decimal64` it rounds, and a finite
  value beyond the largest `decimal64` is an error, as for `float32`.
  A field is omitted only when it is `0E+0` (design decision 12).
  Existing streams are unaffected.
  A stream that contains a decimal cannot be read by a decoder built with an
  older Go: Go 1.27 rejects it with `gob: bad data: undefined type`, even when
  the receiving struct has no field for the decimal.
- JSON writes every coefficient digit, in fixed notation unless the absolute
  value is below 1e-6 or at least 1e21 (the thresholds `encoding/json` uses for
  floats) or the quantum is above the units digit, and rejects NaN and the
  infinities.

*Reason:* wire formats freeze on first release, and they must match the standard
and each other.

*Status:* implemented.

### 9. Zero value

**The zero value is `decimal64(0)` or `decimal128(0)`, which is `0E+0`.** So
`var total decimal64; total += 19.99` gives `19.99`, as it would for `float64`.
Go's zero value is all bits clear, so all bits clear must mean `0E+0`.
A value in memory is therefore the target's encoding XORed with the encoding of
that zero.
In software the masks are `0x31c0000000000000` for `decimal64` and
`0x3040000000000000` in the high word of `decimal128`; with DPD they are
`0x2238000000000000` and `0x2208000000000000`.
The `Native` bits functions expose that stored form exactly, so
`Native64bits(0)` is zero and every bit pattern round-trips.
Explicit BID and DPD codecs undo the XOR and convert only when their encoding
differs from the native one.
Wire formats keep their own explicit encoding contracts.
Arithmetic is unchanged.

*Reason:* the spec says the zero value of a numeric type is `0`, and `0E+0` is
what IEEE 754-2019 gives for converting the integer 0, so the zero value has the
exponent of `decimal64(1)`.
IEEE 754-2019 defines no default value for a variable, and its encodings govern
interchange.
The alternatives were the plain encoding in memory, where the zero value is
`0E-398` and `total` holds `19.99000000000000`, and treating a zero at the
minimum exponent specially, which departs from IEEE's preferred exponent.

*Cost:* C code using `_Decimal64` cannot share decimal values in memory without
conversion, `unsafe` reinterpretation sees the XOR-adjusted form, and a debugger
that decodes `DW_ATE_decimal_float` as the plain encoding misdecodes it.

*Status:* implemented, with debugger support in GDB.
Go's GDB support script (`runtime-gdb.py`) has a decimal printer that undoes the
XOR using two runtime constants recorded in DWARF and prints the `fmt` form,
quantum included, for variables, fields, elements and values behind pointers.
It is tested live on linux/arm64 and statically on linux/amd64 and
linux/ppc64le.
Delve has no decimal support.

### 10. Decimal hardware

**On `ppc64le` and `s390x` the compiler lowers decimal operators to the
hardware's decimal instructions, and a value in memory is its DPD encoding XORed
with the DPD encoding of `0E+0`, so an operator needs no change of encoding.**
The software milestone does not depend on this.
The memory form is not part of the language: the `Native` bits functions expose
the native stored representation, and the explicit codecs and the wire formats
perform interchange conversion on every target.

*Reason:* see [Native decimal hardware](#native-decimal-hardware).

*Status:* implemented for `ppc64le`.
Under QEMU the hardware path passes the oracle, the conformance suite and the
three published suites, and matches the software kernel bit for bit at 10^6
cases per operator.
QEMU's decimal emulation is built on decNumber, so this verifies the lowering
and the encodings, not the hardware.
Not implemented for `s390x`, whose decimal instructions QEMU does not emulate.

### 11. No decimal literal suffix

**No suffix such as `1.50d` gives a floating-point constant a decimal default
type.** An untyped constant already becomes a decimal, exactly and with its
quantum, wherever a decimal is needed, so `var price decimal64 = 1.50` and
`price * 1.10` need no marker.
What a suffix would add is a decimal default type: without one, `x := 1.50` is a
`float64`, and an untyped constant expression such as `1.50 / 3` is evaluated
exactly, not as a decimal.

*Reason:* a suffix is new syntax, and it can be added later without breaking
anything that adding it now would not, since `1.50d` is a syntax error today.
Leaving it out keeps this proposal to the types, and the case for a suffix can
be made separately, with experience of the types.

*Status:* nothing to implement.

### 12. gob keeps a zero's quantum

**gob omits a decimal struct field only when it is the zero value, `0E+0`.** gob
omits a float field that equals zero, and so folds `-0` into `+0`.
Under the cohort rule above, a decimal field equal to zero would be omitted too,
folding `0.00`, `0E+3` and `-0` into `0E+0`.
The decimal types do not fold their cohorts: the test is of the representation,
so every other zero is sent and arrives with its exponent and sign.
Array elements and map entries are always sent, as for floats.

*Reason:* the quantum.
A float zero's sign is seldom data.
A decimal zero's exponent is the scale the program chose: `0.00` is zero to the
cent, and a round trip through a struct field should not change it.
This is a divergence from the floats, recorded as one.

*Status:* implemented.

## Non-goals

This proposal adds numeric types and their language and library integration.
It does not supply money policy, enforced fixed scale or arbitrary precision.
Libraries can supply those abstractions with or without built-in decimals.

**Currency and money.** A money type combines an amount with a currency,
permitted operations and rounding policy, and this proposal chooses none of
those.
Decimal operators can round silently, overflow to infinity or return NaN, so
applications must validate inputs, intermediate bounds and results.
Currency units, settlement scale, tax rules, exchange rates and allocation
belong in application or library contracts.

**Fixed-point decimal.** [#68272](https://go.dev/issue/68272) asks for
fixed-point decimal types.
An IEEE decimal can represent a fixed-scale amount within its coefficient and
exponent limits, but its type does not enforce that scale: in decimal64,
`99999999999999.99 + 0.01` is `100000000000000.0`, and quantizing that back to
cents does not fit and returns NaN.
A fixed-scale abstraction needs bounds checks and explicit quantization,
including checks for invalid results.
Widening before arithmetic provides headroom; it does not remove the need to
establish bounds.

**Arbitrary precision.** Arbitrary-precision libraries serve different needs and
keep their place, as `math/big` does beside `int64`.
They interoperate through the canonical string or through (coefficient,
exponent) pairs, which the libraries already expose and `decimal.Decompose` and
`decimal.Compose` provide.

**Rounding modes as state.** IEEE's directed roundings are functions in
`math/decimal` (design decision 4), never a per-goroutine or global mode.

**`decimal32`.** No workload case is made for a third width.
It can be added later without disturbing anything here.

## Examples

The examples run in the
[playground](https://marcelocantos.github.io/go-decimal-proposal/), which
compiles and runs the fork in the browser.

### 0.1 + 0.2

```go
a, b := 0.1, 0.2
fmt.Println("Binary: ", a+b) // 0.30000000000000004

da, db := decimal64(0.1), decimal64(0.2)
fmt.Println("Decimal:", da+db) // 0.3
```

### Quantum

```go
var d decimal64 = 1.50
fmt.Println(d) // 1.50

price := decimal64(29.90)
qty := decimal64(3)
fmt.Println(price * qty) // 89.70: multiplication adds the operands' quanta
```

### Invoice

This example assumes USD, nonnegative prices with at most two decimal places,
and prices and integral quantities no greater than 1,000,000, with at most 1,000
lines.
`decimal128` gives enough coefficient headroom for the exact products, the sum
and the multiplication by the rate.
Tax is rounded once on the subtotal, to cents, ties to even.
Other tax policies need different code.

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

`tax` and `total` themselves have cent quantum; `%.2f` only controls
presentation, and formatting to two places alone is not stored cent rounding.
Literals remove the constructors, but the bounds, the rounding policy and the
validation remain necessary.
A library can enforce the same policy.

## Rationale

### Built-in types or a library

A library decimal is excluded from operators, constants, `==` and `cmp.Ordered`
by the language's definition of them (see [What a library cannot
do](#what-a-library-cannot-do)), and the exclusion falls on the code that
handles money.
When the correct path is verbose, people route around it: `float64` is still
common in billing code, and many teams store money as `int64` minor units.

[#82668](https://go.dev/issue/82668) is the strongest form of the library
answer, and adopting it is not a smaller step toward built-in types.
Once code, drivers and tutorials are written against a decimal struct in the
standard library, a built-in type would have to justify itself as a second way
to do the same thing, so adopting [#82668](https://go.dev/issue/82668) very
likely decides that Go will not have decimal types.
That may be the right decision, but it should be made as that decision.
Third-party arbitrary-precision libraries are unaffected either way.

The cost of the language change falls on the Go project: a numeric kind threaded
through the specification, both type checkers, the compiler, the runtime and the
standard library, with quantum rules, export data, normalized hashing, new
public kinds, codecs, XOR-aware debugging and ports to maintain.
The cost of a library's gaps falls on every user of decimal arithmetic.

### Operator overloading

Operator overloading has been discussed since Go's creation and has not been
accepted.
It would also not close the gap: overloaded operators give a library type
arithmetic, but not `==` across a cohort, not `cmp.Ordered` and not a place in
the constant system.

### Arbitrary precision

Fixed-size types have no separately allocated coefficient (escaping values may
still allocate), can be register-allocated, have predictable cost, can be map
keys, and can be stored in arrays and slices without indirection.

### Native decimal hardware

IBM Z has had decimal floating point since the z9, in microcode at first, and
POWER has had a hardware unit since POWER6.
Go runs on `s390x` and `ppc64le` and cannot reach those units.
A library could wrap each operation in an assembly function, but its values
would still cross a call in general-purpose registers.
A fixed-width type in the standard library could instead have its methods made
compiler intrinsics, as the `math/bits` functions are.
A built-in type gets what `float64` gets without a second mechanism: one
instruction per operator, with its operands in floating-point registers.
On `ppc64le` the fork compiles arithmetic and comparison to single decimal
instructions (`DADD`, `DSUB`, `DMUL`, `DDIV`, `DCMPU` and their `decimal128`
forms), and `decimal64` values stay in floating-point registers across an
expression.
The hardware works on fixed-width IEEE values, so an arbitrary-precision library
such as [#82668](https://go.dev/issue/82668) cannot use it at all.

Using the hardware gives up one bit layout across targets, which costs nothing a
program may rely on.
BID and DPD encode the same values, signs and quanta, so arithmetic, comparison,
hashing and formatting cannot tell them apart.
Interchange is explicit through the codecs and the BID wire formats.
Byte order already differs between targets, and design decision 9 makes memory a
plain IEEE encoding nowhere, so code reading decimals through `unsafe` was never
portable.
The compiler encodes constants for the target, so cross-compilation works.

The costs are conversion time in codecs and wire formats whose encoding differs
from the native one; non-canonical patterns that have no counterpart in the
other encoding, which a crossing codec returns as the canonical encoding of
their IEEE value; decimal operations in the compiler's SSA, with conversions at
the boundary for what the hardware lacks (parsing, formatting, conversion to
unsigned integers and to and from `float64`); and verification that hardware
results match the kernel's in value, quantum and rounding.

### Comparison with complex types

`complex64` and `complex128` are the precedent for adding a numeric kind with
operators, constants and conversions to Go.
Decimal asks for the same kind of slot and nothing more: no new operators, no
new literal syntax and no new constant kind.
Unlike complex, it brings its own constant rule, the quantum, and its own
equality rule, numeric equality across a cohort.

The precedent shows how a numeric kind fits the language, not that adding one is
cheap or would be done again.
Complex numbers were in Go from the start.
Alan Donovan [wrote on
#19787](https://github.com/golang/go/issues/19787#issuecomment-6634121640) that
"I think it is unlikely we would add them today", since outside scientific
programming they are "just another annoying case that every library must handle
in a switch over reflect.Kind", and that it "might still be better for the
minority that cares about decimals to pay that cost (by using a library) to save
the majority from having to deal with it".
The decimal types add two such cases.
[Compatibility](#compatibility) measures what they cost.

### Alternatives considered

Each design decision records the alternatives it rejected: among them a new
constant kind, shortest-digits default output, prefixed helper functions in
`math`, dynamic rounding modes, conversion through the shortest decimal string,
`decimal128` alone, renumbered kinds, the plain IEEE encoding in memory and a
literal suffix.

## Compatibility

The design preserves the behaviour of existing programs under the [Go 1
compatibility guarantee](https://go.dev/doc/go1compat).

**Predeclared identifiers.** `decimal64` and `decimal128` are predeclared
identifiers, not keywords.
Like all predeclared names they can be shadowed, so existing code that uses the
names keeps compiling and behaving as before.
Access to the types is gated by the `go` directive in `go.mod`, following `any`
and `comparable` in Go 1.18.

**Type system.** The rules for type identity, assignability and type inference
are unchanged.
`cmp.Ordered` gains two types, as its documentation reserves the right to do
("If future releases of Go add new ordered types, this constraint will be
modified to include them").
That can stop existing generic code compiling.
In

```go
type narrow interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64 |
		~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64 | ~uintptr |
		~float32 | ~float64 | ~string
}

func g[T narrow](x T) T { return x }
func F[T cmp.Ordered](x T) T { return g[T](x) }
```

the constraint `narrow` lists every type `cmp.Ordered` holds today, so `F`
compiles.
Once `cmp.Ordered` includes the decimal types, `F` fails with "T does not
satisfy narrow".
The fork reports that error with the experiment on, in a module whose `go.mod`
says `go 1.24`: the language-version gate does not apply, because the type set
of `cmp.Ordered` does not depend on the module's version.
How much published code has this shape has not been measured.

**`reflect.Kind`.** `Decimal64` and `Decimal128` are appended after
`UnsafePointer`, so no existing value changes.
No `Kind` has been added since Go 1.0.
On [#38831](https://go.dev/issue/38831) Rob Pike
[wrote](https://github.com/golang/go/issues/38831#issuecomment-635008873) that
"Code that depends on Kind is likely to have to change if any Kinds are added".
Code that indexes arrays by `Kind` (`[reflect.UnsafePointer + 1]T`) or switches
exhaustively on known kinds without a `default` may panic or mishandle decimal
values at run time.
This is a soft compatibility concern, not a compilation break.

The Go team has measured part of this.
For [#9455](https://go.dev/issue/9455), Alan Donovan
[found](https://github.com/golang/go/issues/9455#issuecomment-4211408199) that
only 10 of 8,873 sampled `reflect.Kind` switches were exhaustive, and concluded
that "adding new reflect.Kinds may be less disruptive than I had feared".

A survey for this proposal ran 27 widely imported reflection-based packages
against the fork's types, 74 entry points in all, and CI reruns it to keep its
table current.
For `decimal128`, the worst outcome per entry point was 18 correct, 35 clean
errors (such as `unsupported type: decimal128`), 13 panics and 8 silent
mishandlings.
Two of the panics are mongo-driver's: its packages panic at start-up if
`reflect` has a kind they do not know, whether or not the program uses one.
The fixes range from one added case in a `Kind` switch (go-cmp, kr/pretty, gorm,
testify), through about 15 functions (spf13/cast), to a new encoder and decoder
(goccy/go-json, json-iterator, segmentio, cbor, msgpack) and number-preserving
conversion (sigs.k8s.io/yaml).
The same matrix with `shopspring/decimal`, whose `encoding` and `database/sql`
methods make it work in the JSON, YAML, TOML and SQL libraries, gave 22 entry
points correct, 16 correct in value but with the quantum lost, 10 silent
mishandlings and 6 panics.
Two of those panics are mongo-driver's start-up check again, which the fork's
new kinds trigger and stock Go does not.
A library type pays less of this cost, but not none, because many reflection
libraries do not consult those interfaces.
The details are in the
[survey](https://github.com/marcelocantos/go-decimal-proposal/blob/master/research/reflect-survey/README.md).

**`go/types.BasicKind`.** `Decimal64` and `Decimal128` are appended, so
`String`, `UnsafePointer` and the untyped kinds keep their values.
The `BasicInfo` masks do change value: with the experiment on, `IsNumeric`,
`IsOrdered` and `IsConstType` include the new flag `IsDecimal`, so `IsNumeric`
is 154 rather than 26.
For both kinds, a `default` case is safe but does not establish correct
handling, so tools must test the new kinds.

**Export data.** The fork's export data moves from version 5 to version 6 of
`internal/pkgbits`, with the experiment off as well as on, because each
floating-point constant is followed by its quantum.
Tools that read export data with their own copy of the reader, such as
`golang.org/x/tools`, need the new version, as for any change to the format.

**Experiment gate.** As `loopvar` and `rangefunc` did, the types spend at least
one release behind a flag before default-on.
While the experiment is off, the new public declarations are excluded, `reflect`
names the reserved kind numbers `"kind27"` and `"kind28"`, `go/types` keeps its
original `IsNumeric`, `IsOrdered`, `IsConstType`, `Universe` and `Typ` surface,
and ordinary declarations named `decimal64` or `decimal128` continue to work.
CI checks the released API baseline, compiles consumers against both surfaces
and runs the standard library with the experiment off.
This removes the start-up failure observed in mongo-driver, and library authors
get at least a release, and the survey's list of fixes, before the new kinds
appear in default builds.

**`encoding/gob`.** The gob wire format has reserved type ids and a
`firstUserId` gap for new built-in types, so existing streams are unaffected.
Compatibility with streams from stock Go was rechecked against go1.27.3 in both
directions.
A stream that carries a decimal cannot be read by a decoder built with an older
Go, even into a struct without the field (design decision 8), so a service that
sends decimals by gob must upgrade its readers first.

**Cost to programs that do not use decimals.** No decimal arithmetic cost is
intended for them, and broad regressions have not been measured.
Code size changes: a program that imports `fmt` links about 18 KB of
`internal/bid` on darwin/arm64.
Compile-time cost has not been measured; export data carries each floating-point
constant's quantum, a small integer beside the exact value `go/constant` already
holds.

## Implementation

### Prototype

The implementation is a fork of the Go compiler and standard library at
[marcelocantos/go](https://github.com/marcelocantos/go/tree/decimal), branch
`decimal`, pinned at `ccc8ddcdac`.
A [playground](https://marcelocantos.github.io/go-decimal-proposal/) built from
that revision compiles and runs decimal programs in the browser; its checkbox
selects experiment-off builds without changing the program.
The fork exists to run the playground and to make questions about the design
concrete.
It is a prototype, not a finished contribution: if the proposal is accepted, it
is the starting point for the series of CLs described in [Plan](#plan).
Against its upstream merge base it changes 419 files, adding 34,285 lines of
non-test code and 51,427 lines of tests.
It changes:

- **The compiler.** The types are added to `cmd/compile/internal/types`,
  `types2`, `go/types` and the IR.
  In general `ssagen` lowers a decimal operation to a runtime call on bit
  patterns, as `softfloat64.go` does, with `decimal128` passed as two `uint64`
  halves, high first.
  On arm64 and amd64 `+`, `-` and `*` on word-sized coefficients, the
  comparisons, quantizing and integral rounding are inline integer code, and
  what those paths refuse calls the kernel directly.
  On `linux/ppc64le` the operators become POWER decimal instructions.
  Constants are rounded and encoded by the kernel through one helper,
  `ir.DecimalConst`.
- **The runtime.** One-line wrappers over the kernel for the operations the
  compiler does not inline; the runtime holds no decimal arithmetic of its own.
  Map keys hash the kernel's canonical key and compare numerically.
- **The standard library.** `internal/bid` is the one kernel, and
  `TestNoBIDStrawman` fails on BID encoding logic anywhere else in `src` or
  `test`, with eight files allowlisted, each for a stated reason.
- **Bootstrap.** The minimum bootstrap toolchain is upstream's, go1.26.0.
  `internal/bid` has no decimal-typed signatures, so the bootstrap compiler can
  build it, and `//go:build !compiler_bootstrap` constraints cover the few files
  that name the types.
- **Tools.** `go vet`'s printf analyzer accepts the decimal verbs, in the fork's
  vendored copy of `x/tools`, not yet sent upstream.

The first implementation was reviewed on 2026-10-27 by an AI model that had not
written it.
The review found its integration sound and its arithmetic kernel wrong on
ordinary inputs.
The kernel was replaced by `internal/bid`, in which every operation computes an
exact intermediate and reaches the encoding through one rounding function.
The review's reproducers now give IEEE results: `1 / 70000000000000` is
`1.428571428571429e-14` in decimal64, and `1e20 + 1e-20` has the value `1e20` in
decimal128.

### Verification

Each of the following runs green.

- **Oracle.** `TestKernel` compares the kernel with an exact reference model
  built on `math/big` and reports no mismatch at 10^6 cases per operation and
  width, in three operand regimes.
  CI runs it at that size on linux/amd64, and the ordinary test run uses 10^5.
- **Conformance suite.** `TestConformance` runs 4,535 vectors over 98
  operations, written from the package contract and the standard without reading
  the kernel or the oracle.
  All pass, and the oracle is held to the same vectors.
- **Published vectors.** Cowlishaw's
  [decTest](https://speleotrove.com/decimal/dectest.html),
  [Intel](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)'s
  `readtest.in` and IBM Haifa's FPgen 1.02 are a local check kept out of the
  tree.
  The kernel and `math/decimal`'s functions pass 24,224 decTest vectors, 60,049
  Intel vectors and 34,668 FPgen vectors, 118,941 in all, with no failures.
  Another 107,301 are skipped, each with a named reason, such as other formats,
  rounding modes the functions do not take, non-IEEE operations and named
  divergences (GDA's `power(0, 0)` is a NaN where IEEE 754-2019's is 1).
- **Elementary functions.** `math/decimal`'s square root, powers, exponential
  and logarithms are checked against an independent `math/big` reference (30,000
  generated cases per function and width), against 3,113 decTest and Intel
  vectors, and under emulation on six architectures.
- **Allocation.** `TestAllocs` asserts that no exported kernel function
  allocates.
  `TestElementaryAllocs` asserts the same for the elementary functions on their
  first two attempts; the rare result that needs a third takes memory from the
  heap.
- **Through the language.** `test/decimal.go`, `test/decimal_const.go`,
  `test/decimal_const_overflow.go`, `test/decimal_map.go` and
  `test/decimal_print.go` cover operators, rounding, quantum through inexact
  arithmetic, overflow ties, subnormals, constants, map keys and printing.
  The earlier review's oracle, run by hand through the operators, reports no
  mismatch at 10^5 cases per operation and width.
- **Builds and ports.** The pinned revision passes `all.bash` on darwin/arm64
  with the experiment off and with it on, the decimal suites under POWER
  emulation, and the browser playground journey.
  CI also runs the kernel's tests under `GOARCH=386` and the kernel, `strconv`,
  `fmt` and `math` tests under js/wasm.
  At the earlier published revision `32c1829380`, `go build std` succeeded for
  linux/386, linux/arm, linux/s390x, windows/amd64 and js/wasm.

A separate probe, "Independent decimal64 conformance probe — 3 November 2026",
used compiler commit `3395b13718777d5ef94c94554ca63b34a753069b` and a separate
Python decimal reference.
It found zero discrepancies in 97,130 decimal64 cases per target: 94,000
arithmetic cases, 100 parses and 3,030 default-format round trips, of which
18,800 also checked compiled operators or the public `Quantize` helper.
The corpus ran natively on darwin/arm64 and under emulation on linux/386 and
linux/s390x.
The kernel was tuned after the probe, and the oracle, the conformance vectors
and the published suites held at every commit.
The probe does not establish complete IEEE conformance, `decimal128` coverage,
non-canonical encoding coverage, full ABI and codec coverage, physical IBM
hardware behaviour or performance.
The report and its reproduction sources are not published with this document.

### Performance

There is no hand-written assembly.
The kernel is Go, and the compiler generates the inline fast paths.
Unless stated otherwise, the figures are from one Apple M4 Max (darwin/arm64),
each the median of 12 rounds that interleave the things compared.
The kernel's benchmark baseline puts addition and multiplication at about 6 ns
for `decimal64` and 6–7 ns for `decimal128`, against about 1 ns for `float64` in
the same loop, and word-sized operands take under 2 ns through the operators; on
money amounts `decimal64` `+` takes 0.55 ns against `float64`'s 0.44.
Those two are the inline fast paths for small coefficients.
`math/decimal`'s elementary functions take 0.25 to 3.3 µs on the measured
operands and do not allocate on them.
No arithmetic operator allocates.
The figures, the comparison with other implementations and the application
benchmarks are in
[docs/performance.md](https://github.com/marcelocantos/go-decimal-proposal/blob/master/docs/performance.md).

### Remaining work

1. **Debuggers.** Add XOR-aware decimal support to Delve.
   GDB shows correct values only with Go's printer script loaded, and not in its
   own expression arithmetic or assignment.
   GDB on ppc64le has not been checked in a live session.
2. **Ports and ABI.** Verify the full language and ABI on 32-bit and big-endian
   ports, execution on Windows, and `all.bash` beyond darwin/arm64, through the
   compiled language path.
3. **Hardware.** Run and measure the `ppc64le` path on POWER hardware, and
   implement `s390x`.
   Emulation verifies the lowering and the encodings only.
4. **Tools.** Send the printf analyzer change to `x/tools`, and verify `gopls`
   and third-party analyzers with the new kinds.
5. **Specification.** Review the draft spec wording and fold the constant table
   and the constant conversion rules into the spec's text on constant
   expressions.
6. **Evidence.** Measure representative workloads, including the case for each
   width, the compile-time cost and broad run-time regressions.
7. **Commitment.** Establish named maintenance and review commitments.

### Plan

If the proposal is accepted, the implementation would be contributed as a series
of small, reviewable CLs once the API in the design decisions is settled.
The runner for the published vectors is one file, deleted before the series is
cut.
The author is willing to split the work and to adjust the design with the Go
team.

The rollout follows generics and range-over-func:

1. The first release after acceptance ships the types behind
   `GOEXPERIMENT=decimal`, invisible to programs that do not set it.
2. A later release considers enabling them by default, after at least one
   experimental release, completed compatibility and port checks, working
   debugger support and a maintenance commitment.
   A release cycle alone is not acceptance evidence.

This gives tool authors such as gopls, staticcheck and Delve a full release
cycle to add decimal support before the types appear in default builds.

### AI-assisted provenance

This document and the implementation were produced largely with agentic AI under
the author's direction.
The generated code did not receive detailed human review when written.
The independent review of 2026-10-27 and the review of the rewritten kernel on
2026-10-31, in which two reviewers that did not write the code found, at
b7cc5d04b8, no wrong value, no wrong flag and no reachable panic, were done by
AI models, not by people.
That review predates much of today's kernel: since b7cc5d04b8, `internal/bid`
has gained 13,605 and lost 1,328 lines of non-test code, and the elementary
functions in `internal/decimal`, 3,096 lines, were written.
Help from the community is welcome.

## Open issues

1. **`math` functions without a decimal version.** `Modf`, `Frexp`, `Cbrt`,
   `Hypot`, `Log1p`, `Expm1`, `Log2`, `Exp2`, `Pow10` and the trigonometric and
   special functions have no `math/decimal` counterpart.
   Which of them the proposal adds is a decision for the proposal: under the
   governing rule, a function `math` has is a candidate unless a reason (such as
   the radix, for `Frexp`'s power of two) says otherwise.
2. **Decimal-only functions in `math/decimal`.** `Pown`, `Rootn` and `Compound`
   (IEEE 754-2019 clause 9.2) and `Payload`, `NaNWithPayload` and
   `SignalingNaNWithPayload` (clause 9.7) are recommended operations that do not
   depend on the radix, and `math` offers none of them for floats.
   The fork has them.
   The intent is to add a decimal type, not to modify float, so the question is
   whether a decimal workload (compound interest is the case made for
   `Compound`) is a good reason to give decimals what floats lack, or whether
   they belong to a separate proposal that would add them for both.
3. **NaN payloads outside arithmetic.** Operators propagate payloads and signs
   (design decision 4): on darwin/arm64 a `decimal64` NaN keeps payload `0x123`
   through `x + 1`, as a `float64` NaN does.
   Open: whether conversions between binary and decimal, `strconv` and `fmt`
   should carry payloads too, and whether totalOrder should order NaNs by
   payload and signalling bit, as IEEE 754-2008's clause 5.10 required; IEEE
   754-2019 relaxed the ordering of NaNs.
4. **Bounded JSON number decoding.** `decimal128` represents exactly only values
   within its 34-digit coefficient and exponent limits, and a valid JSON number
   can exceed either.
   The independent probe decoded `10000000000000000000000000000000001` and
   re-encoded `1.000000000000000000000000000000000e+34`, with no error.
   This is expected rounding, not lossless interchange.
   A future opt-in `decimal128` decoder for JSON numbers, with stated rounding
   and range behaviour, could help applications with known bounds; no default
   change is proposed.
   Applications that need arbitrary JSON numeric text to survive must keep it,
   for example with `json.Number`.
5. **`encoding/json/v2`.** The fork adds decimal marshalers and unmarshalers to
   `encoding/json/v2` and makes `v2_inject.go` treat the decimal kinds as
   numeric.
   `encoding/json/v2` has no decimal tests of its own; `encoding/json`'s decimal
   tests run through it.
6. **Performance.** The elementary functions have had two tuning passes where
   the kernel had several. Assembly for the wide multiply was measured slower
   than inlined Go, which does not rule it out for a production implementation.
   POWER silicon measurements and the `s390x` backend remain.
7. **Other packages with float support.** `flag` (`Float64`), `expvar`
   (`Float`), `math/big` (`SetFloat64`) and `math/rand` (`Float64`) have no
   decimal counterpart.
   They are follow-ups, not part of this proposal.

## Acknowledgements

This design builds on [#19787](https://go.dev/issue/19787), proposed by Mura Li
([@typeless](https://github.com/typeless)) in 2017.
The discussion on that issue shaped this proposal, in particular the argument
for built-in types over a library and the focus on IEEE 754 conformance.
Thanks to all who took part.
