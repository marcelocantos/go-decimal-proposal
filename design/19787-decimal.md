# Proposal: add decimal floating-point types (`decimal64`, `decimal128`)

Author: Marcelo Cantos (marcelo.cantos@gmail.com)

Original proposal: Mura Li ([@typeless](https://github.com/typeless))

Last updated: 2026-11-01

Discussion at https://go.dev/issue/19787.

Related issues: https://go.dev/issue/12127, https://go.dev/issue/19770, https://go.dev/issue/26699, https://go.dev/issue/9455

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
| [ROADMAP.md](../ROADMAP.md) | Post-submission execution order (kernel, constants, API, `GOEXPERIMENT`, CL split) |

**Outline convention:** sections marked *(expand for Gerrit)* should be copied
or condensed from the README anchors in the map below; sections marked
*(decision)* state normative choices that override accidental strawman behaviour.

---

## Abstract

*(Mostly complete — tighten wording for Gerrit.)*

Add two built-in IEEE 754-2008 decimal floating-point types, `decimal64` and
`decimal128`, using Binary Integer Decimal (BID) encoding. They participate in
Go’s existing operator set, constant system, and conversions without new syntax.
Floating-point constants gain an optional *quantum* (exponent of the last digit)
consumed only when converting to a decimal type, so `1.50` and `1.5` remain
distinct at compile time where the language allows.

Primary motivation: financial and business software where base-10 semantics and
operator ergonomics matter; library decimals without operator overloading do not
meet typical Go usage patterns.

An implementation exists in a fork and playground. Its arithmetic is checked
against IEEE 754-2008, while several design decisions are not implemented yet.
This document states the intended language semantics; the
[Implementation](#implementation) section separates plan from current code.

---

## Document map (README alignment)

| § in this doc | README section | Notes for Gerrit paste |
|---------------|----------------|------------------------|
| [Background](#background) | Background through “What does success look like?” | Motivation, precedent, BID, both widths |
| [Proposal](#proposal) | Proposal | Types, operators, constants, conversions, stdlib, size, interactions, spec |
| [Design decisions](#design-decisions) | Design decisions | **Normative** — matches audit §6 |
| [Non-goals](#non-goals) | Non-goals | Money, fixed-point, big decimals, modes, decimal32 |
| [Examples](#examples) | Examples | Keep short in design doc; link or embed key demos |
| [Rationale](#rationale) | Rationale | Library vs builtin, BID, complex comparison |
| [Compatibility](#compatibility) | Compatibility | Go 1 promise, Kind append, experiments |
| [Implementation](#implementation) | Implementation + Implementation status | Current status + ROADMAP phases |
| [Open issues](#open-issues) | Open issues | Thread feedback |

---

## Background

*(expand for Gerrit from README.)*

- **Problem:** binary floats and typical decimal libraries fail financial /
  regulatory expectations; Go lacks operator overloading for library decimals.
- **Audience:** business software, invoicing, tax, ERP integrations, data that
  must round-trip as decimal strings.
- **Why not a library only:** operator and constant ergonomics; see README
  [Why a library is not sufficient](../README.md#why-a-library-is-not-sufficient).
- **Precedent:** C23 `_Decimal64` / `_Decimal128`, C# `decimal`, Java
  `BigDecimal`, Python `Decimal`; IEEE 754-2008 decimal formats.
- **Encoding:** BID in software and for interchange, DPD with decimal hardware
  on `s390x` and `ppc64le` — see README
  [IEEE 754-2008 and BID encoding](../README.md#ieee-754-2008-and-bid-encoding).
- **Widths:** both `decimal64` and `decimal128`; not `decimal32` — see
  [Design decisions §6](#6-widths) and README
  [Why not just decimal128?](../README.md#why-not-just-decimal128).
- **Quantum preservation:** business case for literals and constants; ties to
  [Constants](#constants) decision.
- **Success:** language change accepted in principle; reference implementation
  and tests (`decTest`) demonstrate conformance behind `GOEXPERIMENT=decimal`.

---

## Proposal

### New types

*(expand for Gerrit.)*

Predeclared:

```
decimal64   // IEEE 754-2008 64-bit decimal floating-point (BID)
decimal128  // IEEE 754-2008 128-bit decimal floating-point (BID)
```

Same operator classes as `float32` / `float64` (arithmetic, comparison,
assignment); no `%`, bitwise, or shift.

### Operators

Round to nearest, ties to even only — *(decision §4)*. No dynamic rounding
modes on operators.

### Constants

*(decision §1 — expand for Gerrit from README [Constants](../README.md#constants).)*

- No new constant *kind*; untyped floating-point constants remain exact rationals.
- Literals and exact constant operations may carry a **quantum** attribute
  (preferred exponent) propagated by IEEE 754-2008 rules on `+`, `-`, `*`, `/`
  when exact.
- Quantum is consumed **only** on conversion to `decimal64` / `decimal128`.
- Default type of untyped floating-point constants remains `float64`; quantum
  does not affect existing programs that never convert to decimal types.
- Typed decimal constant expressions: must fold when spec says they are constant
  expressions, with the same quantum model; spec text must resolve the
  `decimal64(1)+1` constant-expression question (audit §5.2).
- Each operation on typed decimal constants rounds to the type's precision, as
  typed float constants do, so constant and run-time results agree. Untyped
  constants stay exact until converted.

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
- **`math/decimal`:** generic helpers (`Quantize`, directed rounding, `Mod`, …)
  over `~decimal64 | ~decimal128`.
- **`strconv`:** parse and format with quantum-preserving default (decision §2);
  parity tests with `ParseFloat` / `FormatFloat` discipline.
- **`encoding/json`, `encoding/xml`, `database/sql`:** quantum-preserving
  default string form; JSON rejects NaN/Inf.
- **`encoding/binary`, `encoding/gob`:** wire layouts per [decision §8](#8-wire-formats).
- **No** `sort` decimal slice types (strawman mistake).

### Size and alignment

*(expand for Gerrit from README [Size and alignment](../README.md#size-and-alignment).)*

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

Two principles govern these decisions and any still to be made.
Conformance to IEEE 754-2008 comes first.
Below that, decimal types are semantically as close to `float32` and `float64`
as possible, so a difference from floats needs the standard to require it.

### 1. Constants

Constants carry a quantum attribute; values stay exact fractions. Untyped
constants remain today’s rationals; quantum propagates on exact operations and
is consumed on conversion to decimal types. Alternative (no quantum in constants)
is rejected because it collapses `1.50` and `1.5` at compile time.

*Strawman gap:* source-text side channel (`origLit`), cross-package loss, disagree
between `go/types` and `cmd/compile` on typed decimal constant expressions.

### 2. Default formatting

`%v`, `%g`, `String`, JSON, XML, and `database/sql` preserve quantum (`1.50`
prints as `1.50`); `#` keeps float meaning; `IsZero`, `omitempty`, and
`DeepEqual` are numeric semantics. Shortest form via explicit reduce operation
(e.g. in `math/decimal`).

*Strawman gap:* shortest-by-default, `#` sentinel, bitwise `IsZero`.

### 3. Helper functions

`math/decimal` package with generics; not forty-four prefixed functions in
`math`.

*Strawman gap:* `math.Decimal64*` surface and `sort` additions.

### 4. Rounding modes and sNaN

Operators: round-half-even only. Directed rounding in `math/decimal`. sNaN
accepted and quieted; payloads not propagated.

*Strawman gap:* double-rounding defects in kernel (audit §5.1).

### 5. Conversions

Correct rounding from exact source value; constant conversions exact when
representable; decimal→integer like float truncation with implementation-defined
edge cases.

*Strawman gap:* shortest-round-trip digit policy in places.

### 6. Widths

Ship **`decimal64` and `decimal128`**; no `decimal32`. Shared width-parameterised
kernel in the reference implementation (ROADMAP phase 1).

*Strawman gap:* duplicated 64/128 cores without shared kernel.

### 7. Rollout

`GOEXPERIMENT=decimal` for at least one release; `go.mod` language version gate
as needed. **`reflect.Kind` and `go/types.BasicKind` values appended**, never
renumbered (Go 1 compatibility).

*Strawman gap:* inserted kinds before `Complex64`; no experiment gate.

### 8. Wire formats

- `encoding/binary`: IEEE interchange encoding, MSW-first for `BigEndian` as
  specified in README.
- `gob`: two words, MSW first.
- JSON: canonical decimal string; float-style exponent thresholds; reject NaN/Inf.

*Strawman gap:* LSW-first in binary/gob; JSON fixed notation bloat.

### 9. Zero value

- The zero value is `decimal64(0)` or `decimal128(0)`, which is `0E+0`, so
  `var total decimal64; total += 19.99` gives `19.99`.
- A value in memory is its BID encoding XORed with the encoding of that zero, so
  all bits clear means `0E+0`. The `bits` functions and wire formats give BID.
- Cost: C `_Decimal64` code can't share values in memory without conversion.

*Strawman gap:* the zero value is `0E-398`.

---

### 10. Decimal hardware

- `s390x` and `ppc64le` use decimal instructions, with DPD in memory.
- The `bits` functions and wire formats give BID on every target.

*Status:* not implemented.

## Non-goals

*(expand for Gerrit from README [Non-goals](../README.md#non-goals).)*

Currency types, fixed-point decimals, arbitrary precision, global rounding mode
state, and `decimal32`.

---

## Examples

*(embed for Gerrit — minimum set.)*

**0.1 + 0.2** — decimal addition vs `float64`.

**Quantum** — `var d decimal64 = 1.50` prints `1.50` under default formatting.

**Invoice line** — short table-driven snippet from README Examples.

Full set: README [Examples](../README.md#examples).

---

## Rationale

*(expand for Gerrit from README [Rationale](../README.md#rationale).)*

Built-in types vs library; BID vs DPD; comparison with complex types.

---

## Compatibility

*(expand for Gerrit from README [Compatibility](../README.md#compatibility).)*

Go 1 guarantee; append-only API constants; no silent migration of existing
`reflect` kind integers; experiment gating for early adopters.

---

## Implementation

### Strawman (current fork)

Demonstrates integration (compiler, runtime, playground) but **arithmetic kernel
is not IEEE 754 conformant** (audit §5.1–5.4). README
[Implementation status](../README.md#implementation-status) lists verified vs
broken claims.

### Correctness plan (post-design-doc)

1. Rewrite runtime (and shared `internal/decimal` if used) as one
   width-parameterised kernel; validate with `decTest` (ROADMAP phase 1).
2. Implement constant model per [§1](#1-constants) (ROADMAP constant-model step).
3. Reshape stdlib API per [§3](#3-helper-functions) and [§8](#8-wire-formats).
4. Compiler / SSA / ports (audit §7 steps 4–8).

Order follows [ROADMAP.md critical path](../ROADMAP.md): design doc submission →
kernel + oracle → constant model → phase 0 fixes → API → rebase and CL split →
`GOEXPERIMENT` → review.

### AI-assisted provenance

Disclosed in README; clean-room path available if contribution policy requires it.

---

## Open issues

*(expand for Gerrit from README [Open issues](../README.md#open-issues).)*

Items requiring Go team or community input beyond the eight decisions above.

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
