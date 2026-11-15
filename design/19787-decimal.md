# Proposal: add decimal floating-point types (`decimal64`, `decimal128`)

Author: Marcelo Cantos (marcelo.cantos@gmail.com)

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Last updated: 2026-11-15 (proposed revision)

Discussion at https://go.dev/issue/19787.

Related issues: https://go.dev/issue/82668, https://go.dev/issue/12127, https://go.dev/issue/19770, https://go.dev/issue/26699, https://go.dev/issue/9455

---

**Draft status.** This file is the working outline for submission to
[`golang/proposal`](https://github.com/golang/proposal) as
`design/19787-decimal.md` via Gerrit, per the
[Go proposal process](https://github.com/golang/proposal/blob/master/README.md)
and the critical path in [ROADMAP.md](../ROADMAP.md).
Substance is discussed on [#19787](https://go.dev/issue/19787); a README in a
personal repository is not a submission.

**Sources of truth for this outline:**

| Source | Role |
|--------|------|
| [README.md](../README.md) | Full motivation, proposal text, examples, compatibility, open issues |
| [docs/audits/deep-dive-2026-10-27.md §6](../docs/audits/deep-dive-2026-10-27.md#6-decisions-to-make-before-the-design-document) | Questions the design doc must answer before implementation proceeds |
| [README — Design decisions](../README.md#design-decisions) | Recorded answers (2026-10-27), applied consistently in this outline |
| [ROADMAP.md](../ROADMAP.md) | Roadmap; reconcile its sequence with the completed kernel rewrite and remaining integration work |

**Outline convention:** sections marked *(expand for Gerrit)* should be copied
or condensed from the README anchors in the map below; sections marked
*(decision)* state normative choices that override accidental strawman behaviour.

---

## Abstract

*(Mostly complete — tighten wording for Gerrit.)*

Add two built-in decimal floating-point types following IEEE 754-2019, `decimal64` and
`decimal128`, computed in software on most targets and by the decimal units of
the IBM targets (decision §10). They participate in
Go’s existing operator set, constant system, and conversions without new syntax.
Real numeric constants gain optional *quantum* metadata, used in decimal
conversion and typed decimal arithmetic. Untyped values remain exact; typed
decimal operations round at their declared precision. Equal values such as
`1.50` and `1.5` may retain distinct representations. The fork implements
these rules, with both type checkers and export data in agreement.

Primary motivation: bounded base-10 arithmetic integrated with operators,
language constants and numeric equality. #82668 can supply correct arithmetic
and a shared standard-library type. No adoption study or migration trial here
establishes that built-in integration justifies its permanent cost.

An implementation exists in a fork and playground. Independent decimal64
differential testing found no discrepancy in its tested scope; this is not
a certificate of complete IEEE conformance. Constants, compatibility gates,
API shape and debugger support remain unfinished.
This document states the intended language semantics; the
[Implementation](#implementation) section separates plan from current code.

---

## Document map (README alignment)

| § in this doc | README section | Notes for Gerrit paste |
|---------------|----------------|------------------------|
| [Background](#background) | Background through “What does success look like?” | Motivation, precedent, encodings, both widths |
| [Proposal](#proposal) | Proposal | Types, operators, constants, conversions, stdlib, size, interactions, spec |
| [Design decisions](#design-decisions) | Design decisions | **Normative** — matches audit §6 |
| [Non-goals](#non-goals) | Non-goals | Money, fixed-point, big decimals, modes, decimal32 |
| [Examples](#examples) | Examples | Keep short in design doc; link or embed key demos |
| [Rationale](#rationale) | Rationale | Library vs builtin, encodings, complex comparison |
| [Compatibility](#compatibility) | Compatibility | Go 1 promise, Kind append, experiments |
| [Implementation](#implementation) | Implementation + Implementation status | Current status + ROADMAP phases |
| [Open issues](#open-issues) | Open issues | Thread feedback |

---

## Background

*(expand for Gerrit from README.)*

- **Problem:** binary floats cannot exactly represent many decimal inputs.
  Libraries can solve that problem; the language question concerns operators,
  constants and numeric equality that retains cohorts.
- **Audience:** applications whose values and intermediates fit 16 or 34 digits
  and the format's exponent limits. Named workloads and migration evidence
  remain needed; library dependency counts do not identify this audience.
- **Library alternative:** see README
  [Why a library is inadequate](../README.md#why-a-library-is-inadequate).
  #82668's arbitrary precision and explicit rounding are different choices,
  not defects imposed by lack of operators. A library can implement specials
  through methods. A standard-library type could reduce fragmentation too.
- **Precedent:** complex types show an integration pattern, not a comparative
  user count or acceptance threshold. A library does not foreclose built-ins.
- **Cost:** quantum rules, two type checkers, export data, normalized hashes,
  public kinds, codecs, XOR-aware debugging and ports require continuing
  maintenance. Maintainers and review commitments have not been established.
- **Encoding:** the in-memory form is the target's, XOR-adjusted so that all
  bits clear means zero: BID in software, DPD with the decimal units of
  `ppc64le` and `s390x`. It is not fixed by the language; the `bits` functions
  expose its exact stored words. Explicit codecs exchange either IEEE encoding,
  while wire formats retain their specified encoding contracts.
- **Widths:** both `decimal64` and `decimal128`; no demonstrated case for
  `decimal32`. Shared generation does not replace tests of each width.
- **Quantum:** representation metadata, not measurement certainty or business
  rounding. Equal map keys can replace their stored representation; NaN keys
  cannot be retrieved by ordinary lookup.
- **Success:** demonstrated benefit to real applications, a settled semantic
  contract and verified integration. Prototype feasibility alone is insufficient.

---

## Proposal

### New types

*(expand for Gerrit.)*

Predeclared:

```
decimal64   // IEEE 754-2019 64-bit decimal floating-point
decimal128  // IEEE 754-2019 128-bit decimal floating-point
```

Same operator classes as `float32` / `float64` (arithmetic, comparison,
assignment); no `%`, bitwise, or shift.

### Operators

Round to nearest, ties to even only — *(decision §4)*. No dynamic rounding
modes on operators.

### Constants

*(decision §1 — expand for Gerrit from README [Constants](../README.md#constants).)*

No new constant kind is proposed. Untyped arithmetic remains exact rational
arithmetic, including `1.0/3.0`; a nonterminating decimal expansion has no
quantum. The default floating type remains `float64`.

The README [constant table](../README.md#constants) is the proposed contract
for literals, naming, unary operations, integer division, shifts, `iota`,
conversions, complex-derived constants and typed operations. Integer operations
reset quantum to zero; binary-floating conversions and complex operations
discard it. These rules are new choices for review, not existing guarantees.

Typed decimal operations round to 16 or 34 digits with ties to even.
Constant division by zero and nonfinite results are illegal; constant zero
has no sign and converts to positive zero with its representable quantum.
Run-time operations can instead produce signed zero, NaN and infinity.
Exact conversions retain a quantum that fits, otherwise use the smallest
coefficient allowed by the format. Inexact conversions retain the exponent
required by rounding, including trailing zeros.

Cross-package declarations such as `const Base, Other = 1.50, 2.00` and
`const Twice = Base * 2` must retain quantum through export/import, unary
operations and conversion. Both type checkers and the compiler must agree
on values, quantum and diagnostics. The prototype does: see decision 1's status.

### Conversions

*(decision §5 — expand for Gerrit from README [Conversions](../README.md#conversions).)*

- Non-constant `float64` → decimal: correctly rounded from the **exact** binary
  value at destination precision (IEEE-style), not “shortest decimal digits” only.
- Constants: exact where representable (e.g. `decimal128(0.1)` is `0.1`).
- Decimal → integer: truncate toward zero; out-of-range and NaN behaviour
  implementation-defined, analogous to float → integer.
- Rune literals, hex floats, and representability: spec must state rules (audit
  C3 and related).

### Standard library additions

*(decisions §3, §8 — expand for Gerrit.)*

- **`math`:** only `bits` / `frombits`-style accessors mirroring `Float64bits`.
  They copy exact stored words, including the zero-value XOR, and preserve every
  pattern. They perform no encoding conversion or canonicalization.
  `Float64bits` has two properties: its result is the value's memory form, and
  it is the IEEE interchange encoding. The decimal functions keep the first and
  not the second, because a decimal's memory form is XOR-adjusted (decision §9)
  and IEEE 754-2019 has two decimal encodings; the interchange encodings are
  `math/decimal`'s codecs.
- **`math/decimal`:** generic helpers over `~decimal64 | ~decimal128`, named
  and specified as `math`'s are: `Abs`, `Ceil`, `Floor`, `Trunc`, `Round`,
  `RoundToEven`, `Copysign`, `Signbit`, `Dim`, `FMA`, `Mod`, `Remainder`,
  `NaN`, `Inf`, `IsNaN`, `IsInf`, `Sqrt`, `Exp`, `Log`, `Log10`, `Pow`,
  `Ldexp` (x × 10^n, IEEE's scaleB in the format's radix), `Logb`, `Ilogb`
  and `Nextafter` (IEEE's nextUp and nextDown are `Nextafter` toward an
  infinity), and the limit constants `MaxDecimal64`,
  `SmallestNonzeroDecimal64`, `MaxDecimal128` and `SmallestNonzeroDecimal128`.
  The quantum operations have no float counterpart: `Quantize`,
  `QuantizeMode`, `SameQuantum`, `Quantum` and `Reduce`. `Pown`, `Rootn`,
  `Compound` and the payload operations are open (see [Open issues](#open-issues)).
  The package is separate from `math` as `math/cmplx` is, and it is generic
  rather than `decimal128`-only, unlike `math`'s `float64`-only functions,
  because results depend on the format: the preferred exponent and whether a
  coefficient fits (`Quantize` returns NaN when it does not) differ between the
  widths, so computing in `decimal128` and narrowing would give other results.
  The `math` functions with no counterpart here (`Frexp`, `Modf`, `Cbrt`,
  `Hypot`, `Log1p`, `Expm1`, `Log2`, `Exp2`, `Pow10`, the trigonometric and
  special functions) are left out for now, not by decision; adding one later
  breaks nothing. `Min` and `Max` are the built-ins. The package also provides explicit
  `BID64bits`/`BID64frombits`, `BID128bits`/`BID128frombits`,
  `DPD64bits`/`DPD64frombits` and `DPD128bits`/`DPD128frombits` codecs.
  These exchange IEEE encoding words without XOR, high word first for decimal128.
  `NativeRepresentation` is a typed constant of type `Representation`, with values
  `BIDXOR` and `DPDXOR`; its documentation specifies each width's zero mask.
  Matching-native codecs preserve every encoding bit; conversions between
  encodings can canonicalize non-canonical patterns while preserving their IEEE
  value, quantum and NaN payload.
- **`strconv`:** parse and format with quantum-preserving default (decision §2),
  otherwise as `ParseFloat` and `FormatFloat` do.
- **Text and codecs:** default text preserves canonical finite value, sign
  and quantum at the same width, not NaN payloads or noncanonical bits.
  JSON rejects NaN/Inf and rounds values exceeding destination precision;
  it is not lossless for arbitrary JSON numbers. `database/sql` converts a
  decimal to text with `'g'` at precision −1, as it does a float, which for a
  decimal is the canonical string and keeps a positive quantum (`1.5e+03`).
  It becomes a string, not a float64 `driver.Value`, because there is no
  decimal `driver.Value` type and float64 would change the value. Driver and
  schema behavior need tests.
- **`strconv` details:** `ParseDecimal` accepts what `ParseFloat` accepts:
  Go floating-point literal syntax with underscores, hexadecimal mantissas with
  a binary exponent (rounded once from the exact binary value; the quantum is
  that of a constant without one), `NaN` unsigned and `Inf`/`Infinity` signed.
  There is no signalling or signed NaN spelling, as for floats. A bitSize other
  than 64 is taken as 128, as `ParseFloat` takes one other than 32 as 64.
  `FormatDecimal` checks its arguments as `FormatFloat` does: a bitSize other
  than 64 or 128 panics, bitSize 64 rounds the value to `decimal64` first, and
  an unknown format byte gives `%` and the byte. `'b'` is the coefficient and
  the decimal exponent of its last digit (`150e-2`), the radix-ten form of a
  float's `'b'`. `'x'` and `'X'` are a float's: `-0xh.hhhhp±dd`, a hexadecimal
  fraction and a binary exponent laid out as `FormatFloat` lays them out, of
  the decimal's value rounded to nearest, ties to even, at the precision asked
  for, so a decimal that is exactly a `float64` value formats as that
  `float64` does. Most decimal values have no finite binary fraction, so the
  digits are rounded, as `'e'` with a precision rounds. The precision has no
  cap, as for `FormatFloat`; unlike a float's, the expansion of a decimal
  whose reduced denominator has a factor of 5 does not terminate, so digits
  past its first ones are real digits, not zeros. With the decimal
  formats (`e`, `E`, `f`, `g`, `G`), precision −1 means every coefficient
  digit, where for a float it means the fewest digits that round-trip,
  because a decimal's digits carry its quantum. With `'x'` and `'X'` it means
  what it means for a float, the fewest digits that `ParseDecimal` at the same
  bitSize reads back as the same value: hexadecimal text has no quantum, so
  the value round-trips and the member of its cohort does not (`1.50` is
  `0x1.8p+00`). Explicit precision changes output, not the stored value.
- **`fmt`:** the verbs are a float's, with `%b` as `'b'` above and `%x` and
  `%X` as `'x'` and `'X'`; `go vet` checks the same set. Scanning accepts what
  scanning a float accepts.
- **`reflect`:** `Type.Bits` returns 64 and 128, and `Value.OverflowDecimal`
  reports overflow as `OverflowFloat` does. `Type` has no `OverflowDecimal`,
  because an interface method cannot be absent while the experiment is off
  (decision §7).
- **`encoding/binary`, `encoding/gob`:** wire layouts per [decision §8](#8-wire-formats).
- **No** `sort` decimal slice types (strawman mistake).

### Size and alignment

Sizes are 8 and 16 bytes. Alignment is target-dependent; the reviewed
darwin/arm64 compiler uses 8-byte alignment for both. No 16-byte alignment
guarantee is proposed for decimal128. Other ABIs still need verification.

### Interaction with other language features

Generics, interfaces, `switch`, `reflect`, `go/types`, generics constraints —
*(expand for Gerrit; reflect Kind **append** only — decision §7).*

### Language spec changes

*(expand for Gerrit from README [Language spec changes](../README.md#language-spec-changes); add quantum, constant folding, and formatting normative text absent from strawman spec diff.)*

---

## Design decisions

Each item answers one question from
[audit §6](../docs/audits/deep-dive-2026-10-27.md#6-decisions-to-make-before-the-design-document).
Disagreement should be raised on [#19787](https://go.dev/issue/19787).

One rule governs these decisions and any still to be made. The decimal
types behave as Go's binary floating-point types do, in the language, the
runtime and the standard library, in every observable respect, unless there
is a good reason for them to differ. A good reason follows from what decimals
are: they carry a quantum (IEEE 754-2019 cohorts), their radix is ten, or an
IEEE 754-2019 decimal clause requires something different. Implementation
convenience, performance and preference are not. Each divergence states its
reason where it is specified; an undocumented divergence is a defect. As with
Go's floats, there is no dynamic rounding environment and there are no status
flags.

The divergences this document specifies, each with its reason:

| Divergence from the binary floats | Reason |
|---|---|
| Constants carry an optional quantum (§1) | Quantum: `1.50` and `1.5` are different members of one cohort, and conversion must be able to keep the difference |
| `%v`, `%g` and precision −1 write every coefficient digit, and use exponent form for a quantum above the units digit (§2) | Quantum: the digits are the representation; fixed notation cannot show a positive exponent |
| `==`, map keys and `switch` treat members of one cohort as equal while they print differently | Quantum: equality is of value, as IEEE comparison is; the representation is not part of it |
| `min` and `max` of equal values of one sign return the first argument | Quantum: a float has one representation per value; IEEE 754-2019 leaves the choice open |
| Underflow gives a zero with the clamped exponent (`0e-398`), not a plain 0 | Quantum: IEEE 754-2019 decimal arithmetic gives the result its exponent |
| `%b` and `'b'` write a power of ten | Radix: a float's `%b` writes its integer significand and a power of two |
| `'x'`, `'X'`, `%x` and `%X` at precision −1 give the value back, not the cohort member | Quantum: hexadecimal text has none to carry |
| The zero value is `0E+0`, XOR-adjusted in memory (§9) | Quantum: the zero value has the exponent of `decimal64(1)`; IEEE's all-bits-zero decimal is `0E-398` |
| `math`'s `bits` functions give the memory form, not an interchange encoding | Follows from the zero value, and IEEE 754-2019 has two decimal encodings |
| Directed rounding of the quantum (`QuantizeMode`), and the quantum operations | Quantum: quantization to a business exponent is a quantum operation; floats have none |
| `math/decimal` is generic over both widths | IEEE 754-2019 decimal: preferred exponents and what fits depend on the format |
| NaN propagation is specified (first signalling NaN, sign and payload kept) where floats leave it to the hardware | Not a divergence in behaviour: a refinement of what floats leave unspecified |
| No complex type with decimal parts; `complex` rejects decimals | No decimal complex format exists, and the proposal adds decimal types only |
| gob keeps a decimal field equal to zero unless it is `0E+0` (§8) | Quantum: omitting `0.00` would lose its exponent; the test of the representation also keeps `-0`, which a float field loses |
| `reflect.Kind` values are appended after `UnsafePointer` (§7) | Go 1 compatibility: existing Kind values cannot change |
| No `Type.OverflowDecimal` method | An interface method cannot be absent while `GOEXPERIMENT=decimal` is off (§7) |

### 1. Constants

Untyped constants retain exact rational values and optional quantum; typed
decimal operations round. The [constant table](../README.md#constants) defines
propagation and the constant/run-time exceptions. Quantum-free constants would
simplify the model but lose the distinction between `1.50` and `1.5` when
converted. This tradeoff needs review and implementation evidence.

*Status:* implemented. Export data carries the quantum, and both type checkers
fold typed decimal constant expressions through the kernel.

### 2. Default formatting

`%v`, `%g`, `String`, JSON, XML, and `database/sql` preserve quantum (`1.50`
prints as `1.50`) for representable finite values. Text does not preserve
arbitrary NaN bits, as it does not for floats. `println` writes what `%v`
writes, as it does for floats. Each member of a cohort has its own digits:
the coefficient 1000000 with exponent 0 prints as `1.000000e+06` and `1E+6` as
`1e+06`, and the notation is chosen by the value's leading digit.
`#` keeps float meaning; `IsZero`, `omitempty`, and
`DeepEqual` are numeric semantics. Shortest form via explicit reduce operation
(`math/decimal`'s `Reduce`). The layout is Go's float layout: `println`,
`%v`, `%g` and `strconv`'s shortest form agree, in exponent form with a
lowercase `e` when the leading digit's exponent is below -4 or at least 6, as
a `float64`'s shortest form is (`1234567.89` prints as `1.23456789e+06`), and
when the quantum is above the units digit, which fixed notation cannot show.
JSON writes a decimal as it writes a float: fixed notation unless the
absolute value is below 1e-6 or at least 1e21, so `1234567.89` is
`1234567.89` there.

*Strawman gap, closed:* shortest-by-default, `#` sentinel, bitwise `IsZero`.

### 3. Helper functions

`math/decimal` package with generics; not forty-four prefixed functions in
`math`. The package is separate as `math/cmplx` is. It is generic because
results depend on the format (see [Standard library additions](#standard-library-additions)).
Each function that has a `math` counterpart takes its name, argument order
and special cases: `Ldexp`, `Logb`, `Ilogb` and `Nextafter`, not IEEE's
`scaleB`, `logB`, `nextUp` and `nextDown`, whose operations they are.

*Strawman gap, closed:* `math.Decimal64*` surface and `sort` additions.

### 4. Rounding modes and sNaN

Operators: round-half-even only. Directed rounding in `math/decimal`. sNaN
accepted and quieted. A NaN operand propagates as in `float64`, quieted with
its sign and payload (IEEE 754-2019 clause 6.2.3); of several, the first
signalling NaN wins, otherwise the first. Invalid operations give the
canonical NaN. Implemented.

*Historical gap:* the October 27 audit found double rounding in the old
kernel. It has been replaced by `internal/bid`; the later independent probe
found no discrepancies in its stated decimal64 scope. `math/decimal` has the
directed roundings (`Ceil`, `Floor`, `Trunc`, `Round`, `RoundToEven`, `QuantizeMode`).

### 5. Conversions

Correct rounding from exact source value; constant conversions exact when
representable; decimal→integer like float truncation with implementation-defined
edge cases.

*Status:* implemented, including conversions to a type parameter.

### 6. Widths

Ship **`decimal64` and `decimal128`**; no `decimal32`. Shared width-parameterised
kernel in the reference implementation (ROADMAP phase 1).

*Status:* both widths now use `internal/bid`, generated from one template.
That sharing does not establish decimal128 conformance from decimal64 tests.

### 7. Rollout

Decimal is opt-in at build time with `GOEXPERIMENT=decimal` for
at least one release. New public API declarations use `goexperiment.decimal`
build constraints; the ordinary public API is retained when off. `go.mod` language version gate
as needed. **`reflect.Kind` and `go/types.BasicKind` values appended**, never
renumbered (Go 1 compatibility).

*Strawman gap, closed:* inserted kinds before `Complex64`; no experiment gate.
*Status:* both gates and appended kinds are implemented. Default-off and the
conditionally compiled public API are verified locally at 518d5cb6cf.
With the experiment enabled and `go 1.22` in
`go.mod`, `var x decimal64` fails with "predeclared decimal64 requires go1.28 or later".

### 8. Wire formats

- `encoding/binary`: explicitly specified IEEE BID interchange encoding, MSW-first for `BigEndian` as
  specified in README.
- `gob`: one wire type, `decimal`, for both widths, as `float` serves both
  float widths: the value widened to `decimal128` (exact, keeping the
  quantum), sent as its IEEE BID encoding in two words, the high one
  byte-reversed as a float's bits are and sent first. Either decimal type
  receives it; into `decimal64` it rounds, and a finite value beyond the
  largest `decimal64` is an error, as for `float32`. A field is omitted only
  when it is `0E+0`: `0.00` equals zero, and omitting it would lose the
  quantum, so the test is of the representation, which also keeps `-0`.
- JSON: every coefficient digit, in fixed notation unless the absolute value is below 1e-6 or at
  least 1e21 (the thresholds `encoding/json` uses for floats) or the quantum is above the units
  digit; reject NaN/Inf.

*Strawman gap, closed:* LSW-first in binary/gob; JSON fixed notation bloat;
a gob wire type per width, which no float precedent called for.

### 9. Zero value

- The zero value is `decimal64(0)` or `decimal128(0)`, which is `0E+0`, so
  `var total decimal64; total += 19.99` gives `19.99`.
- A value in memory is the target's encoding XORed with the encoding of that zero, so
  all bits clear means `0E+0`. The `bits` functions expose that stored form
  exactly, so `bits(0)` is zero and every bit pattern round-trips. Explicit
  BID/DPD codecs undo the XOR and convert only when their encoding differs
  from the native one. Wire formats retain their own explicit encoding contracts.
- Cost: C `_Decimal64` code cannot share values in memory without conversion;
  `unsafe` sees the XOR-adjusted form. Current DWARF marks it as decimal
  float, so a debugger that reads the plain encoding misdecodes it. GDB has a
  printer that undoes the XOR; Delve has no decimal support. In software the XOR masks are `0x31c0000000000000`
  for decimal64 and `0x3040000000000000` in decimal128's high word; with DPD
  they are `0x2238000000000000` and `0x2208000000000000`.

*Historical gap, closed:* the zero value was `0E-398`. The independent
probe confirmed `var total decimal64; total += 19.99` now gives `19.99`.

---

### 10. Decimal hardware

- On `ppc64le` and `s390x` the compiler lowers decimal operators to decimal
  instructions, with XOR-adjusted DPD in memory, so an operator needs no
  change of encoding. The software milestone does not depend on it.
- The `bits` functions expose the native XOR-adjusted representation.
  Explicit BID/DPD codecs and wire formats perform interchange conversion.

*Status:* implemented for `ppc64le`.
Under QEMU the hardware path passes the oracle, the conformance suite and the
three published suites, and matches the software kernel bit for bit at 10^6
cases per operator. QEMU's decimal emulation is built on decNumber, so this is
not hardware evidence. Not implemented for `s390x`.

### 11. No decimal literal suffix

No suffix such as `1.50d` gives a floating-point constant a decimal default
type. Untyped constants already convert exactly, with their quantum, wherever a
decimal is needed. A suffix is new syntax that can be added later without
breaking anything that adding it now wouldn't, so it is left for a separate
proposal made with experience of the types.

*Status:* nothing to implement.

## Non-goals

*(expand for Gerrit from README [Non-goals](../README.md#non-goals).)*

Currency policy, enforced fixed scale, arbitrary precision, global rounding
state and `decimal32` are not supplied. Values and intermediates must fit
the coefficient and exponent limits. Even exact addition can coarsen scale:
`99999999999999.99 + 0.01` in decimal64 is `100000000000000.0`.
Business quantization, overflow checks and allocation rules remain necessary.

---

## Examples

*(embed for Gerrit — minimum set.)*

**0.1 + 0.2** — decimal addition vs `float64`.

**Quantum** — `var d decimal64 = 1.50` prints `1.50` under default formatting.

**Invoice** — use the README example with explicit input bounds, integral
quantity checks, once-per-invoice ties-to-even tax quantization and nonfinite
result checks. Formatting to two places alone is not stored cent rounding.

Full set: README [Examples](../README.md#examples).

---

## Rationale

*(expand for Gerrit from README [Rationale](../README.md#rationale).)*

Built-in types vs library; software and hardware encodings; comparison with complex types.

---

## Compatibility

*(expand for Gerrit from README [Compatibility](../README.md#compatibility).)*

Go 1 guarantee; append-only API constants; no silent migration of existing
`reflect` kind integers; experiment gating for early adopters.

---

## Implementation

### Reviewed prototype

The README pins the compiler revision in `toolchain.lock`
(`8dd921da41`). The historical comparisons below refer to the earlier
published revision `32c1829380`.
The October 27 audit found defects in the old kernel; that kernel has since
been replaced by the shared `internal/bid`. Do not describe those historical
defects as findings against the rewrite.

The independent November 3 report tested compiler
`3395b13718777d5ef94c94554ca63b34a753069b`: 97,130 decimal64 cases per
target, including 18,800 compiled operator/public-helper checks, with zero
discrepancies. The same corpus ran natively on darwin/arm64 and under emulation
on linux/386 and linux/s390x. No committed kernel changes were found between
the two compiler revisions; the whole toolchains are not thereby identical.
See README [Independent probe](../README.md#independent-probe) for provenance
and limits. The report and reproductions must accompany a public citation.
This is not exhaustive conformance, decimal128 coverage, full ABI coverage,
physical hardware validation or performance evidence.

### Remaining work

1. Review the constant contract, which is implemented with cross-package
   tests and agreement between `go/types`, `types2` and the compiler.
2. Reconcile helper APIs and SQL text policy; test parsing, formatting and
   codec boundaries at both widths.
3. Add XOR-aware decoding to Delve; GDB has it. (Appended kind values and
   both gates are implemented.)
4. Verify supported ports, ABI paths and compatibility using the actual
   compiled language path. Establish named maintenance and review commitments.
5. Measure representative workloads against checked integer amounts,
   fixed-width libraries and #82668 with equivalent business rules.
6. Verify and measure the `ppc64le` hardware path on physical hardware, and
   implement `s390x`. Emulated execution verifies lowering and encodings only.

Reconcile the roadmap with these completed and remaining steps before CL
planning. No new kernel rewrite is being scheduled by this outline.

### AI-assisted provenance

Disclosed in README; clean-room path available if contribution policy requires it.

---

## Open issues

*(expand for Gerrit from README [Open issues](../README.md#open-issues).)*

Items requiring Go team or community input beyond the eleven decisions above.

- **Decimal-only functions in `math/decimal`.** `Pown`, `Rootn` and `Compound`
  (IEEE 754-2019 clause 9.2) and `Payload`, `NaNWithPayload` and
  `SignalingNaNWithPayload` (clause 9.7) are recommended operations that do not
  depend on the radix, and `math` offers none of them for floats. The fork has
  them. Whether the proposal keeps them is open: the intent is to add a
  decimal type, not to modify float, so the question is whether a decimal
  workload (compound interest is the case made for `Compound`) is a good
  reason to give decimals what floats lack, or whether they belong to a
  separate proposal that would add them for both.
- **Other packages with float support.** `flag` (`Float64`), `expvar`
  (`Float`), `math/big` (`SetFloat64`) and `math/rand` (`Float64`) have no
  decimal counterpart. They are follow-ups, not part of this proposal.

---

## Acknowledgements

*(expand for Gerrit from README [Acknowledgements](../README.md#acknowledgements).)*

---

## Appendix A — Audit §6 traceability

| Audit §6 question | Design decision § | Strawman mis-alignment (see audit) |
|-------------------|-------------------|-------------------------------------|
| Constants | §1 | `origLit`, folding, cross-package |
| Default formatting | §2 | Shortest default, `#`, `IsZero` |
| Helper location | §3 | `math` ×44, `sort` |
| Rounding / sNaN | §4 | Kernel rounding bugs |
| Conversions | §5 | Shortest-round-trip, trunc rules |
| Widths | §6 | Dual kernels |
| Rollout | §7 | Kind renumbering, no experiment |
| Wire formats | §8 | Endianness, JSON shape |

---

## Appendix B — Gerrit submission checklist

From [ROADMAP.md](../ROADMAP.md):

1. Expand *(expand for Gerrit)* sections; drop outline-only markers.
2. Open CL against `golang/proposal` adding `design/19787-decimal.md`.
3. Post CL link on [#19787](https://go.dev/issue/19787).
4. After thread feedback, align README proposal sections and strawman schedule
   with any revised decisions (audit §7 step 1).

Do **not** start the reviewable CL series on `go` until the design doc has had
at least one round of feedback (audit §7).
