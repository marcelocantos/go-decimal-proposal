# Compiled decimal comparisons

The six decimal64 comparison operators now lower entirely to integer SSA on
ARM64 and AMD64. Decimal128 comparisons use the same exact word-coefficient
paths with a runtime fallback for wider coefficients and encodings. The
coherently rebuilt fork is a3fcc308bb1442f20bf7db8ec6937d066f7fd020. This is
original compiler work in Go; no competitor implementation was inspected and
no assembly was handwritten. Ordinary zero-constant comparisons retain their
earlier dedicated predicates.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 900.4 | 919.6 | 2.1% more time | 852.4 | 2,485.1 |
| Federal tax | 2,458.2 | 2,304.2 | 6.3% less time | 2,422.6 | 9,640.1 |
| California tax | 496.2 | 483.2 | 2.6% less time | 445.4 | 1,890.6 |
| North Carolina tax | 843.5 | 853.0 | 1.1% more time | 732.9 | 3,092.3 |
| Telco | 38.0 | 39.0 | 2.9% more time | 82.7 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four accepted full
invocations use the original runner, workloads, dependencies, output goldens and
clock checks. The prior cohort is not simultaneous. Shared-host and control-
library changes limit attribution of small differences. No wrapper allowance
is subtracted from application results.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

<!-- conclusion:start -->
The POC uses 4.9% less time than Miguel on federal tax and 52.8% less on
telco (2.12 times its throughput). Euro, California and North Carolina still
use 7.9%, 8.5% and 16.4% more time respectively.

Four full invocations passed every original output and timing gate; 2 complete
invocations were excluded by unchanged timing checks and remain archived.
The change does not establish an across-the-board performance lead.
Use the alternating application pairs below for stronger attribution to this
compiler change; historical-cohort differences include host drift.
<!-- conclusion:end -->

## Why this path

The preceding federal-tax profile put nonzero comparisons at about 9% of timed
loop samples. The earlier operand census recorded 65 word-coefficient Less calls
but only four equal headers, so specializing only equal quanta would miss most
of that workload. The census includes an untimed original pass and is not a CPU
percentage. Both sources are preserved in the preceding reports; no competing
library code informed this implementation.

The compiler now exposes the comparison as integer operations in the caller.
The proof has four parts:

1. A finite first-form decimal64 coefficient fits a word. For decimal128,
   zero high coefficient bits plus the first-form guard prove a canonical
   finite word coefficient. Decimal128 operands that fail the coefficient
   guard retain the original runtime comparison and original arguments.
2. Zero's effective sign is positive for numeric comparison. Opposite effective
   signs decide ordering immediately. With equal signs, equal quanta or a zero
   coefficient need only an unsigned coefficient comparison and sign reversal.
3. For two nonzero coefficients, a quantum gap of at least 20 determines
   magnitude: 10^20 exceeds every uint64. For smaller gaps, an exact 64-by-64
   product aligns the higher-quantum coefficient. Both factors fit uint64, so
   the product fits uint128 without rounding. Compare its high/low words to
   the other coefficient, then account for operand swapping and negative sign.
4. NaNs are unordered; infinities depend only on kind and sign. Decimal64's
   second finite form is decoded into a word coefficient and exponent, with
   oversized coefficients interpreted as zero. It joins the same numeric path.
   Decimal128's second finite form and high-coefficient/high-payload cases keep
   the runtime fallback. Thus decimal64 needs no decimal comparison helper.

The power table is immutable, content-addressed compiler data. The control-flow
guards prove the index is in bounds. Source operands are evaluated exactly once
in source order before any branch. The original fallback operands and memory
flow survive every guard failure. Numeric result/NaN/zero semantics and stored
bits are unchanged. DPD targets keep their existing implementation.

## Measured development stages

The first trial handled same-sign first-form coefficients at nearby quanta. It
improved eligible native probes 53–65%, but added 17–32% to several sign, far-gap
and special-value fallback probes. That version was not accepted as the final
change; its source and six-pair records are retained as bounded-*.

The next trial handled all signs, zeros and quantum gaps for finite word
coefficients. It improved those probes 42–65%; special probes still cost up to
16.5%. Its six original-application pairs passed every golden, with median-time
changes of -1.8% euro, -5.8% federal, -3.8% California, -0.2% North Carolina and
+1.2% telco. Those compiler-only diagnostics are preserved as finite-*.

Adding kind/sign decisions made the selected special-value probes 65–79% faster,
but added 15–19% for canonical second-form decimal64 coefficients. Decoding that
form directly removed the regression: those same probes improved about 63%.
The final candidate additionally gained 63–65% on uniform raw decimal64 inputs;
raw decimal128 fallback probes cost about 3–5% more. Final coherent numbers,
including every row and allocations, appear below. These are explicit tradeoffs,
not allowances deducted from application timings.

A test setup initially included decimal128-only fixtures at decimal64 precision;
it now uses the shared corpus's precision rule. An initial signed mask literal
conversion failed compilation and was replaced with the existing variable-mask
idiom. The expanded builder initially created a condition after ending its SSA
block; that compiler panic was fixed by constructing conditions first, and the
fixed compiler was rebuilt with the saved baseline compiler. No timing came from
that broken candidate. AMD64 v3/v4 correctly select MULXQ where earlier targets
use MULQ; the codegen test now accepts the existing MULX?Q convention. Diagnostic
and corrected logs remain archived.

## Correctness and enforcement

TestOperatorCompareReference compares all six operators with the independent
big.Int model. It covers both widths, all sign/exponent/special prefixes,
arbitrary encodings, dense word coefficients at nearby and arbitrary quanta,
zero signs, precision boundaries, gaps 19/20 and exact aligned equality.
The same expanded corpus passes before the change with the saved baseline
compiler. Separate source-order tests cover both fast and fallback results.
The normal enabled internal/bid suite enforces these tests.

ARM64 and AMD64 codegen checks require exact wide multiplication. Decimal64
must not call its runtime comparison helper; decimal128 must retain its guarded
fallback. Native execution in this report is ARM64. AMD64 evidence is codegen,
not a native performance measurement.

<!-- validation:start -->
All nine coherent gates pass: enabled package tests, independent long operator
references, long kernel/operator comparisons, runtime decimal tests, language
and ARM64/AMD64 codegen, experiment-off packages, scoped rounding intrinsic
disabling, published vectors and the unchanged 221-row ratchet. Published
vectors report 114,915 passing, zero failing and 111,327 outside-scope cases.

The first ratchet invocation failed 25 rows, including an unchanged float64
control. The saved baseline and provisional candidate each then passed all
221 rows. A fresh invocation through the coherent rebuilt toolchain also
passed. No source, baseline, threshold, retry count or acceptance rule changed.
The initial failure and all three diagnostic/recheck logs are retained; the
transient cause was not established.
<!-- validation:end -->

The unrelated global all-packages intrinsics-off startup crash remains 🎯T8.
Scoped disabling of function intrinsics is an integration check for the prior
rounding work; it does not turn off decimal operator SSA lowering. It must not
be described as a forced comparison-fallback test. Comparison fallbacks are
exercised by raw/wide encodings and checked against the independent reference.

## Native operator probes

Six complete alternating before/after invocations use identical rotating probe
source and 150 ms per row. Equality and less-than cover representative operand
classes; correctness tests cover all six operators. Raw probes use a fixed seed
and 1,024 uniform raw pairs per width, preserving broad fallback exposure.
All measured rows allocate zero. Negative changes mean less time.

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| decimal128/far/eq | 3.98 | 1.67 | -58.2% |
| decimal128/far/lt | 4.03 | 1.76 | -55.8% |
| decimal128/nearby/eq | 4.08 | 2.05 | -49.7% |
| decimal128/nearby/lt | 4.11 | 2.50 | -39.2% |
| decimal128/sameQuantum/eq | 3.92 | 1.53 | -60.6% |
| decimal128/sameQuantum/lt | 3.91 | 1.68 | -56.2% |
| decimal128/signs/eq | 3.19 | 1.31 | -58.8% |
| decimal128/signs/lt | 3.28 | 1.41 | -57.3% |
| decimal128/special/eq | 4.33 | 1.24 | -71.0% |
| decimal128/special/lt | 4.27 | 1.48 | -65.6% |
| decimal128/wide/eq | 6.92 | 7.44 | +6.9% |
| decimal128/wide/lt | 7.17 | 7.36 | +1.2% |
| decimal64/far/eq | 3.84 | 1.53 | -60.4% |
| decimal64/far/lt | 3.73 | 1.61 | -57.1% |
| decimal64/nearby/eq | 4.06 | 1.77 | -55.3% |
| decimal64/nearby/lt | 3.96 | 2.13 | -46.3% |
| decimal64/sameQuantum/eq | 3.91 | 1.32 | -65.7% |
| decimal64/sameQuantum/lt | 3.69 | 1.45 | -61.0% |
| decimal64/signs/eq | 3.13 | 1.17 | -62.2% |
| decimal64/signs/lt | 2.96 | 1.23 | -58.1% |
| decimal64/special/eq | 4.39 | 0.97 | -77.6% |
| decimal64/special/lt | 4.70 | 1.21 | -74.4% |
| decimal64/wide/eq | 7.71 | 2.67 | -66.3% |
| decimal64/wide/lt | 7.48 | 2.86 | -60.7% |
| Raw/decimal128/eq | 7.31 | 7.36 | +0.5% |
| Raw/decimal128/lt | 7.13 | 7.52 | +6.4% |
| Raw/decimal64/eq | 6.04 | 2.17 | -63.5% |
| Raw/decimal64/lt | 6.32 | 2.21 | -65.3% |
<!-- primitive:end -->

The decimal64 wide row uses canonical 16-digit second-form coefficients; the
decimal128 wide row uses full 34-digit coefficients. They are different paths.
The special row uses zero-high-payload NaNs and infinities; raw decimal128 rows
also cover high-payload special encodings that retain the fallback.

## Paired applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -1.48% | -0.93% |
| tax-fed | -3.80% | -5.04% |
| tax-ca | -4.59% | -3.61% |
| tax-nc | +0.82% | +0.08% |
| telco | +1.83% | +0.74% |
<!-- paired:end -->

Each cell is the median of six paired percentage changes. Both executables
pass nine original goldens before timing; telco also checks its output SHA-256
and published control totals. These process-level diagnostics do not replace
the full runner's clock checks. Final pairs use identical benchmark source
0e2b03c with saved coherent 80f1e49174 and rebuilt a3fcc308bb compilers. The earlier
finite-only diagnostic used the prior saved baseline applications at f1bbc510e8;
the only adapter difference is a removed inline-test exemption, with identical
operation/workload source. The full historical cohort remains pinned to its
actual measured revision f1bbc510e8.

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -4.6% | -7.9% to 2.8% |
| Mul | 9.5% | -2.1% to 18.3% |
| Quantize | 1.8% | -1.0% to 5.7% |
| Integral | 7.6% | -7.8% to 18.9% |
| Format | 8.8% | 5.3% to 14.3% |
| Format/fixed | 10.1% | 9.4% to 12.7% |
| Format/full34 | 5.9% | 1.1% to 12.0% |
| Format/largeFixed | 30.2% | 24.1% to 34.0% |
| Format/smallExponent | 24.3% | 13.4% to 30.7% |
| Format/positiveQuantum | 26.3% | 22.7% to 34.7% |
| Format/paddedExponent | 35.9% | 30.4% to 39.1% |
<!-- adapter:end -->

These premiums come from six complete matching-operand invocations. Negative
premiums are measurement/layout effects, not arithmetic removed by wrapping.
The adapter implementation and its inline enforcement remain unchanged.

## Remaining cost

Fresh original-application profiles pass their output goldens. String conversion,
including the benchmark notation adapter and string allocation, accounts for
53.4% of euro and 43.6% of federal-tax samples within the timed harness.
Those shares divide String's cumulative samples by BestOf's cumulative samples,
not by the whole process: euro is 1.25/2.34 seconds and federal is 4.70/10.79.
The profiles, entrypoint-only overlays, source diffs and provenance are archived
under evidence/profiles. Instrumented timings are diagnostic, never headline
application measurements.

The next original Go investigation should target the coefficient-to-text path
and repeated buffer copies/initialization while preserving all format verbs,
rounding, signed zeros and quantum. Any attempt must improve the original
applications, not merely an isolated digit loop. Earlier pair-digit and direct-
destination trials were rejected; their failure remains relevant. The adapter's
remaining 5.9–35.9% formatting premiums must stay visible and included in the
library comparison. Useful Go work remains before handwritten assembly.

## Code size, reproduction and residue

<!-- size:start -->
| Application | Before text bytes | After text bytes | Text growth |
|---|---:|---:|---:|
| euro | 659,124 | 661,028 | +0.29% |
| tax-ca | 676,612 | 684,276 | +1.13% |
| tax-fed | 744,420 | 778,724 | +4.61% |
| tax-nc | 693,204 | 702,788 | +1.38% |
| telco | 654,004 | 656,164 | +0.33% |

Text counts sum T/t symbols from go tool nm -size. Native comparison code is
larger because it includes several paths in the caller; wider decimal128
comparisons also retain a helper. See evidence/application-sizes.json for complete file
sizes. These costs are reported alongside speed, not hidden by the arithmetic
probe gains.
<!-- size:end -->

The test helpers returning all six comparison results grow from 160 to 3,408
text bytes for decimal64 and from 256 to 2,928 for decimal128. These are six-
operator test functions, not per-operator sizes. Final disassemblies and symbol
counts are retained. The original applications' text growth is 0.29–4.61%,
largest in federal tax; reducing duplicated guards is a future compiler avenue.

The compiler bundle requires 80f1e49174e1212a4d290c02ffa3a07a2fad8487; the patch
is included for review. The results bundle requires
0e2b03c2fbc0bfe2da6293e7ba13cccae5abf26d, the measured benchmark revision,
and contains results commit db46d69e8c0d3e48ed9534e31867c011ed69bfb6.
Both bundles are verified in their matching repositories. phase.json pins the
cohorts and machine.json records fresh host probes. Build the compiler with
src/make.bash and GOEXPERIMENT=''; use GOEXPERIMENT=decimal, GOWORK=off,
GOTOOLCHAIN=local, CGO_ENABLED=0 and the fork first in PATH for tests/apps.
summarize.mjs regenerates the tables and before/after chart using phase.json;
evidence/relative-chart.py regenerates the library comparison chart.

No performance changes are pushed or deployed. Further original Go/compiler
optimization, richer SSA facts, ARM64 assembly and native AMD64 execution remain
open. Risk/power and banking/logarithm/compound remain unsupported. Real POWER
and s390x hardware work are separate. 🎯T6 remains open.
