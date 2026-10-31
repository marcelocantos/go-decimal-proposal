# Kernel review against IEEE 754-2008, 2026-10-31

Target 🎯T1.6.6 of the fork's ledger: an independent review of
`internal/bid`, the rewritten decimal kernel, against IEEE 754-2008
clauses 3, 5, 6 and 7 and against the package contract in `doc.go`.

Tree reviewed: fork branch `decimal` at b7cc5d04b8. Findings fixed in
73a8a451d3 on the same branch.

Two reviewers, neither of which wrote the code it reviewed. Each had the
oracle and vector results in hand: `TestKernel` (differential against an
exact `math/big` model) at 0 mismatches at 10^6 cases per operation;
`TestConformance` at 4168 of 4168 vectors from the independently written
suite; decTest in kernel mode at pass=21405 fail=0 with every skip named.
Both were asked to look for what those judges cannot see.

**Verdict of both: no wrong value, no wrong flag, no reachable panic.**
Ten findings, all in contract text or comments, all fixed in 73a8a451d3.

## Review 1 (Opus 5.5): rounding, division, binary to decimal, contract

Scope: `roundW`, `overflowW`, `roundPartsW`, `round.go`; `div_tmpl.go`;
`fromfloat.go`, `fromfloat_tmpl.go`; the whole of `doc.go`; and the
conformance vectors for those areas.

Evidence independent of the in-tree oracle: 1,951,820 kernel outputs
compared with libmpdec (Python `decimal` 2.5.1) in all five modes with
the clamp on, as character strings so that exponents count, and with the
Status for Round; 725 character-form vectors from `round.txt`, `div.txt`
and `float.txt` checked against libmpdec and exact rational binary
rounding; the 124 Div, Round and Float worked examples in `doc.go`;
exact checks that `log10Of2Fixed` is ⌊2^32·log10 2⌋, that the
convergents used to bound `log10Pow2` are right, that `floatNat` peaks
at 14 words, and that no float64 has more than 18 leading nines below a
power of ten (float32: 9), so the no-carry claims in the suite's README
hold.

### Findings

1. **Contract text wrong, doc.go:306-308.** A subnormal's "encoding has exponent MinExp". `Parse64("1E-390")` is subnormal with exponent -390; only inexact subnormal results sit at MinExp (clauses 3.3, 5.2).
2. **Contract text wrong, doc.go:152-154.** "clause 5.12 adopts" GDA to-scientific-string. As I recall, 5.12.2 requires correctly rounded, quantum-preserving conversion but fixes no notation. Recall uncertain.
3. **Unmarked divergence, doc.go:109-116.** "raises no flags". Clause 7.1 requires a status flag per exception. doc.go:32-33 promises every departure is marked "Divergence"; this one isn't.
4. **Contract text wrong, doc.go:19.** "Every exported function is width-suffixed": `Widen` and `Narrow` are not.
5. **Stale text.**
   - doc.go:26 and doc.go:49-51 still speak of unimplemented operations; none remain.
   - doc.go:1531-1533 puts binary conversion in a file excluded from bootstrap, but fromfloat.go and zfromfloat*.go are compiled there (float.go says so).
6. **Comment wrong, arith_tmpl.go:249-253 (roundW caller contract).** With ≤P digits, a non-zero class is "taken to be below every rounding boundary, whatever class says". The code honours the class:
   - Input: `round64(false, 1, 0, classHalf, ToNearestAway, MinExp64)`.
   - Expected per the comment: 1.000000000000000. Actual: 1.000000000000001.
   - Latent: no caller passes such a class (Quantize and RoundToIntegral pass classZero; Round, Parse and the compiler keep a round digit).
7. **Comment wrong, fromfloat_tmpl.go:72-74.** "below e + 16 − PrecisionW for every e ≥ 0" is false at e = 0, and k < e needs t < e + P. The code is safe: the branch needs e ≥ 76, where min(e − k) = 54.


Clauses checked from memory: 3.3, 3.5.2, 4.3, 5.2, 5.3.1, 5.3.2, 5.12,
6.1 to 6.3, 7.1 to 7.6. Not read: the coefficient helpers, `u128`/`u256`,
the other operations, the `internal/strconv` decimal-to-binary path, the
oracle's code.

## Review 2 (Fable 5.1): every other operation

Scope: the templates for add, mul, fma, rem, quant, intconv, string and
minmax, the compare, totalOrder and key functions, `encoding.go`,
`digits.go`, `u128.go`, `u256.go`, `coef64.go`, `coef128.go`,
`float.go` with `internal/strconv/atofcoeff.go`.

Evidence: 300,000 random bit patterns per operation, including both
non-canonical forms, specials with reserved bits and payloads, signaling
NaNs, every `Mode` byte 0 to 255, and Round with any coefficient and
exponents at the int extremes: no panic, and every Append output parses
back exactly. Decimal to binary checked against an exact `big.Rat`
oracle in all five modes at ties, the neighbours of the largest and
smallest finite values, half the smallest subnormal, and the float32
thresholds. Hand cases for the sign of an exact zero in each mode,
fold-down, overflow decided after rounding, tininess before rounding,
exact subnormals, Quantize's NaN cases, RoundToIntegral's exponent,
Reduce at MaxExp, remainders with 12,000-digit quotients, integer
saturation, non-canonical operands through every comparison, and the
maximum character-form lengths. Zero allocations confirmed for the slow
paths. Compiles for linux/386 and linux/arm with no 32-bit integer
arithmetic on exponents, which are clamped before use.

### Findings

1. Cosmetic, dead vocabulary. doc.go rule 4 ("Width parameterisation")
   lists `cHalfW(k)` as a helper the core uses; `cHalf64` (coef64.go:103)
   and `cHalf128` (coef128.go:78) have no caller in any z*.go file.
   `u256Cmp`, `u256Shl`, `u256Shr` (u256.go:38,64,76) are likewise called
   only from tests. Contract section: rule 4. Fix: delete or drop from the
   rule's list.
2. Cosmetic, contract text. doc.go:1470 is an over-long line inside rule 1
   ("Nobody edits a z*.go file. A test, TestGenerated, guarded by …").
3. Contract text, clause naming (my memory of the wording is uncertain).
   "Integer conversions" calls Int64From* "convertToInteger of clauses
   5.4.1 and 5.8" and reports Inexact. In 5.8 the plain
   convertToInteger{...} operations signal only invalid; the inexact
   signal belongs to convertToIntegerExact{...}. The behaviour matches
   the Exact variants; the clause reference should name them.


Not read: `div_tmpl.go`, `fromfloat*.go`, the body of `roundW` (Review
1's scope), `gen_arith.go`, the generated power tables (trusted through
`TestGenerated`), `internal/strconv`'s shift and scaling internals, the
oracle model beyond its generator.

## Resolution

Every finding was fixed in the tree rather than filed, since none
changed behaviour: the contract text now says what the code does and
marks the flags departure as a Divergence; the two wrong comments were
rewritten with the correct bound and the correct description of the
class contract; the dead helper was deleted. The one finding with a
behavioural reading, the `roundW` caller-contract comment, was latent:
no caller passes the class the comment misdescribed, and the test
`TestRoundIsTheOnlyPacker` continues to enforce that every operation
reaches the encoder through `roundW`.

Both reviewers quoted IEEE clause numbers from memory, since the
standard's text was not available to them, and each flagged where that
memory was uncertain. The clause citations in `doc.go` carry the same
caveat.

Residue for the ledger: the review did not re-measure the width-spike
timings or the kernel's benchmarks (🎯T1.6.4), and the 28 hex-operand
vectors in the three sampled suite files were not independently checked.
