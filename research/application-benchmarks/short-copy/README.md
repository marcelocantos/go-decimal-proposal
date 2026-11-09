# Direct placement for short canonical decimals

The original Go change uses direct byte stores for short fixed-point spans in
strconv.AppendDecimal, avoiding two variable-size copy calls. It applies only
when the decimal point lies within the coefficient, the caller has sufficient
capacity, and the coefficient has at most nine digits. Longer spans retain the
existing bulk copies; other formatting and rounding paths remain unchanged.
No benchmark adapter or workload changed. No competitor implementation was read
or copied, and no assembly was handwritten.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 812.5 | 765.1 | 5.8% less time | 807.3 | 2,327.0 |
| Federal tax | 2,195.5 | 2,105.4 | 4.1% less time | 2,383.2 | 9,505.7 |
| California tax | 456.9 | 421.5 | 7.8% less time | 428.0 | 1,894.1 |
| North Carolina tax | 748.6 | 719.9 | 3.8% less time | 720.1 | 3,036.7 |
| Telco | 35.2 | 33.3 | 5.4% less time | 80.0 | Unsupported |
<!-- results:end -->

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

Times are compute nanoseconds per record, with adapter costs included. The
historical cohort is not simultaneous. Six alternating application pairs give
a closer before/after comparison, and unchanged decimal64/float probes are
controls. Neither microbenchmarks nor instrumented profiles replace the original
application runner and its output and clock gates.

## Development decisions

The unbounded byte-loop trial improved the short fixed-point probe about 13%
and California's paired median about 5%, but full-width formatting cost 20%
more and euro regressed. It was rejected. A separate trial removed duplicate
verb normalization; its results did not show a convincing benefit, and it too
was rejected.

A diagnostic sweep checks every coefficient length from two through 34 digits,
with two decimal-point placements inside canonical fixed notation. Three
alternating pairs favored direct placement through nine digits; at ten digits
one placement already regressed, and longer spans generally favored bulk copies.
The named nine-digit cutoff follows that measured crossover. It is a performance
choice, not a correctness bound or a claim of optimality on other architectures.
The matrix is diagnostic and does not alter the fixed acceptance protocol.

The bounded development trial improves the fixed-point native probe 14.8%,
while its full-width probe improves 4.4%. Application median-pair changes are
-1.97% euro, -5.20% federal, -8.54% California, -4.85% North Carolina and -3.83%
telco. All original goldens passed and all paired allocations were unchanged.
Final coherent measurements follow below; development timings are not substituted
into the final cohort.

## Correctness and final measurements

The loop copies exactly the same two nonoverlapping digit spans and decimal
point into a destination whose full size was already checked. It uses no unsafe
access, overstore, extra allocation or new public API. The existing independent
canonical-capacity test covers every coefficient length, both signs, notation
boundaries, all supported verbs plus an unknown verb, prefixes, buffer growth
and capacity sentinels. That test remains part of the normal strconv suite.

<!-- validation:start -->
All ten validation groups pass on the coherently rebuilt clean revision:
affected enabled packages; fresh million-case digit references per width
(seed 647); fresh million-case Append references per width (seed 653);
runtime decimal; language and ARM64/AMD64 code generation; experiment-off
packages; explicit formatting, carry, capacity and round-trip tests; published
vectors; long independent compiled comparison/rounding references (seed 659);
and the unchanged 221-row kernel performance ratchet. Published vectors report
114,915 passing, zero failing and 111,327 skipped outside the supported kernel
scope. No gate, slack, baseline, workload, dependency or output golden changed.
<!-- validation:end -->

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| AdapterCost/Add/direct | 1.15 | 1.09 | -2.6% |
| AdapterCost/Add/wrapper | 1.17 | 1.13 | -1.2% |
| AdapterCost/Format/GDAAdapter | 17.29 | 15.52 | -9.6% |
| AdapterCost/Format/native | 15.59 | 13.80 | -11.4% |
| AdapterCost/Integral/direct | 0.69 | 0.66 | -1.8% |
| AdapterCost/Integral/wrapper | 0.66 | 0.71 | +7.8% |
| AdapterCost/Mul/direct | 0.72 | 0.69 | -3.1% |
| AdapterCost/Mul/wrapper | 0.71 | 0.71 | +1.6% |
| AdapterCost/Quantize/direct | 0.59 | 0.58 | -0.6% |
| AdapterCost/Quantize/wrapper | 0.62 | 0.60 | -1.1% |
| AdapterFormatCases/fixed/GDAAdapter | 17.89 | 15.48 | -12.0% |
| AdapterFormatCases/fixed/native | 15.70 | 13.45 | -13.6% |
| AdapterFormatCases/full34/GDAAdapter | 33.00 | 30.60 | -5.2% |
| AdapterFormatCases/full34/native | 29.09 | 28.61 | -1.5% |
| AdapterFormatCases/largeFixed/GDAAdapter | 30.93 | 30.06 | -3.1% |
| AdapterFormatCases/largeFixed/native | 24.05 | 22.62 | -3.3% |
| AdapterFormatCases/paddedExponent/GDAAdapter | 20.31 | 19.86 | -3.9% |
| AdapterFormatCases/paddedExponent/native | 14.50 | 13.52 | -8.8% |
| AdapterFormatCases/positiveQuantum/GDAAdapter | 18.30 | 18.01 | -2.1% |
| AdapterFormatCases/positiveQuantum/native | 13.89 | 13.50 | -5.2% |
| AdapterFormatCases/smallExponent/GDAAdapter | 17.52 | 16.87 | -4.8% |
| AdapterFormatCases/smallExponent/native | 14.62 | 13.65 | -4.1% |
| Kernel/Append/128/mixed | 16.15 | 16.33 | +1.1% |
| Kernel/Append/64/mixed | 12.18 | 11.79 | -2.1% |
| Kernel/Append/float64/mixed | 24.81 | 23.69 | -3.8% |
| Kernel/UnpackDigits/128/mixed | 9.74 | 9.61 | -1.8% |
| Kernel/UnpackDigits/64/mixed | 5.14 | 5.13 | -0.2% |
| UnpackDigitsCases/decimal128/raw | 15.18 | 15.27 | -0.8% |
| UnpackDigitsCases/decimal128/special | 2.39 | 2.18 | -6.8% |
| UnpackDigitsCases/decimal128/wide | 17.45 | 17.35 | -0.9% |
| UnpackDigitsCases/decimal128/word | 7.12 | 6.90 | -2.2% |
| UnpackDigitsCases/decimal128/zero | 2.22 | 2.02 | -9.0% |
| UnpackDigitsCases/decimal64/raw | 9.49 | 9.10 | -2.5% |
| UnpackDigitsCases/decimal64/special | 1.99 | 1.95 | -0.9% |
| UnpackDigitsCases/decimal64/wide | 10.30 | 10.38 | -1.0% |
| UnpackDigitsCases/decimal64/word | 5.96 | 6.03 | +1.4% |
| UnpackDigitsCases/decimal64/zero | 1.95 | 1.92 | -2.1% |

Six alternating pairs; all paired byte and allocation counts are unchanged.
The kernel, decoder and float rows are controls: this source change is only
in strconv layout, so their movement is not credited to direct placement.
<!-- primitive:end -->

## Applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -1.17% | -2.51% |
| tax-fed | -2.67% | -6.35% |
| tax-ca | -8.48% | -8.40% |
| tax-nc | -4.10% | -6.71% |
| telco | -2.73% | -2.66% |

Medians of six alternating paired changes. Every binary passed nine original
output goldens; telco retains the original digest and totals. These diagnostics
do not replace the full runner clock gate. The application source is identical
between the pinned benchmark commits, which differ only in recorded results.
<!-- paired:end -->

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 2.0% | -3.9% to 6.5% |
| Mul | 5.0% | -6.1% to 11.5% |
| Quantize | 4.2% | -2.0% to 8.2% |
| Integral | 4.1% | -11.6% to 18.2% |
| Format | 14.4% | 8.8% to 24.4% |
| Format/fixed | 14.5% | 12.1% to 16.9% |
| Format/full34 | 7.1% | 5.1% to 9.5% |
| Format/largeFixed | 31.5% | 30.5% to 34.8% |
| Format/smallExponent | 23.6% | 20.8% to 28.6% |
| Format/positiveQuantum | 34.0% | 24.0% to 40.7% |
| Format/paddedExponent | 46.2% | 39.0% to 51.8% |
<!-- adapter:end -->

<!-- conclusion:start -->
Euro uses 5.24% less time than Miguel; Federal tax uses 11.66% less time than Miguel; California tax uses 1.53% less time than Miguel; North Carolina tax is effectively tied with Miguel (0.04% less time); Telco uses 58.37% less time than Miguel.

Four complete invocations passed every original output and timing gate.
There were 0 excluded complete invocations; all attempts remain archived.
California’s 1.53% lead is small, and North Carolina’s 0.04% gap is effectively
parity. These relative differences remain uncertain on the shared host. The original
unsupported scenarios remain outside these five supported-workload comparisons.
<!-- conclusion:end -->

The final full cohort reduces compute time from the preceding cohort by 5.84%
euro, 4.11% federal, 7.76% California, 3.84% North Carolina and 5.36% telco.
The nearer alternating pairs also improve all five workloads. Control timings
move too; in particular, this formatting change does not justify crediting every
movement in arithmetic-heavy telco to the byte stores.

## Wider formatting costs

The diagnostic length sweep reveals costs that the primary full-width probe
does not: direct AppendDecimal with a 31-digit coefficient and 15 fractional
digits costs 35.2% more; 32 digits with 16 fractional digits costs 32.9% more;
34 digits with 17 fractional digits costs 16.7% more. Their individual paired
samples are retained in [the complete length matrix](evidence/length-summary.json).
The nine-digit middle-point case also costs 2.4% more in this final matrix.
These are measured regressions, not dismissed as noise or hidden by application
gains. The primary allocating full34 probe uses a different decimal-point
placement and improves 1.5%; it is not evidence for all long-format cases.

The ARM64 disassemblies retain a 256-byte frame and the same digit-buffer stack
offset, but instruction layout and branch/return structure change. An additional
early-return trial reduced some costs but still regressed the 32-digit middle
point by 22.2%; it remains unretained, with no claims of application or full-gate
validation. It does not establish the regression's cause. This batch retains
the fully validated application and short-format gains as an explicit tradeoff.
The next investigation is the canonical formatter's shared control flow and
rounding-state footprint; no native AMD64 conclusion follows from these results.

## Profiles and code size

<!-- profile:start -->
Fresh California profiles use the same final compiler, with the baseline
formatting source supplied through a byte-verified overlay. Both pass the
original golden. String accounts for 57.6% before and
52.1% after of samples within the timed BestOf subtree;
memmove accounts for 10.7% and 7.9%.
These diagnostic samples and their total times do not replace uninstrumented
timings or establish the cause of the preceding reciprocal-split regression.
Raw CPU profiles, all-node listings, source overlays and provenance are retained.

The final three-pair length matrix repeats every coefficient length that can
contain an internal point (2–34 digits) against baseline source under the final compiler. It is separate from the
37-row primary probes and the unchanged 221-row acceptance ratchet. All matrix
allocations remain zero; capacity checks run before each timed invocation.
<!-- profile:end -->

<!-- size:start -->
| Application | Before text bytes | After text bytes | Change |
|---|---:|---:|---:|
| euro | 661,220 | 661,364 | +0.02% |
| tax-ca | 684,468 | 684,612 | +0.02% |
| tax-fed | 778,916 | 779,060 | +0.02% |
| tax-nc | 702,980 | 703,124 | +0.02% |
| telco | 656,356 | 656,500 | +0.02% |

Text sizes sum T/t symbols from go tool nm -size. Complete file sizes and
appendDecimal disassemblies are retained in evidence.
<!-- size:end -->

## Reproduction and residue

phase.json pins clean fork a8c82228ec485fbd13f8766a19e7c7a27b937781 and
measured benchmark source 425e200995289f0c45ca46651ea5d8be2948c31c. The verified
compiler.bundle requires baseline 082f0305dd29cbefbc22deedc336eef078a75e8c;
compiler.patch records its exact change. The verified benchmark-results.bundle
contains data commit b0b1e79ea58ac689d891df3190f6fe2839b14f9d and requires the
measured benchmark source. Build through src/make.bash with GOEXPERIMENT='';
tests and applications use GOEXPERIMENT=decimal, GOWORK=off, GOTOOLCHAIN=local,
CGO_ENABLED=0 and the shared default cache. summarize.mjs regenerates the cohort
and adapter tables from phase.json; evidence/relative-chart.py generates the
library comparison. All trials,
length diagnostics, original golden checks and raw samples are retained. Native
execution is ARM64. AMD64 code-generation checks do not establish native AMD64
performance. The nine-digit performance cutoff will need native AMD64 evaluation.
Risk/power and banking/logarithm/compound, real POWER and s390x hardware remain
open, as does the unrelated global intrinsics-off debug issue. The wider
performance objective remains open. No changes have been pushed or deployed.
