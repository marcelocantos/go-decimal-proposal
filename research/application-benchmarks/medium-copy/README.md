# Constant-size copies for medium decimal spans

This Go change keeps short canonical formatting's direct byte placement and
copies medium digit spans with constant-size head and tail operations. Existing
compiler lowering turns these into direct loads and stores. There is no new
compiler intrinsic, increased inline budget, unsafe access or handwritten
assembly. No competitor implementation was inspected or copied.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 765.1 | 762.8 | 0.3% less time | 821.8 | 2,369.4 |
| California tax | 421.5 | 409.0 | 3.0% less time | 432.3 | 1,872.3 |
| Federal tax | 2,105.4 | 2,124.2 | 0.9% more time | 2,361.3 | 9,741.2 |
| North Carolina tax | 719.9 | 729.4 | 1.3% more time | 717.4 | 3,034.5 |
| Telco | 33.3 | 33.5 | 0.6% more time | 81.4 | Unsupported |
<!-- results:end -->

Times are compute nanoseconds per record, with the full public-API adapter cost
included. Four accepted complete runs use the original runner, workloads,
dependencies, output goldens and clock checks. Historical cohorts are not
simultaneous; six alternating application pairs provide a closer comparison.
Small relative differences remain uncertain on the shared host.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

## Mechanism and correctness

For spans of 8–16 bytes, two eight-byte copies cover the head and tail. For
17–32 bytes, two sixteen-byte copies do the same. If a span has length n and
the constant chunk has length w, w <= n <= 2w: the intervals [0,w) and [n-w,n)
cover [0,n) without a gap. Any overlapping destination stores write identical
bytes from the same source positions. Both source ranges lie within the span,
and the destination is checked to have at least n bytes. The source coefficient
buffer and caller destination do not overlap. Other span lengths retain the
ordinary copy operation.

The helper has inline cost 63 under the unchanged budget of 80. Both call sites
inline. This is a property of the generated code, not a substitute for timings.
The independent canonical-capacity test now includes every interior decimal-point
position, every coefficient length for both widths, both signs, all supported
verbs and an unknown verb, prefixes, growing buffers and capacity sentinels.
Expected digits and placement still come from the independent reference.
The expanded test runs in the normal strconv suite and its existing CI path.

## Development evidence

Separating explicit-precision rounding state reduced the canonical formatter's
frame from 256 to 224 bytes, but did not address the long-value costs, so it
was rejected. Its existing precision probes and exact source are retained.
Four-byte and eight-byte copy loops also inlined but produced inconsistent
results and broad regressions; both were rejected.

The retained head-and-tail trial improves the 31-digit middle-point case 24.3%
and the 34-digit middle-point case 19.7% versus the preceding build. Short cases
are mostly near unchanged. In its six application pairs, median-sample changes
are -1.92% euro, -1.24% federal, -0.55% California, +0.19% North Carolina and
-0.79% telco. Federal's best-sample figure costs 1.61% more. All original goldens
pass and all paired allocations are unchanged. Final coherent measurements,
including a fresh comparison with the pre-short-copy revision, follow below.

## Final verification and native probes

<!-- validation:start -->
All ten validation groups pass on the coherently rebuilt clean revision:
affected enabled packages; fresh million-case digit references per width
(seed 673); fresh million-case Append references per width (seed 677);
runtime decimal; language and ARM64/AMD64 code generation; experiment-off
packages; explicit formatting, carry, capacity and round-trip tests; published
vectors; long independent compiled comparison/rounding references (seed 683);
and the unchanged 221-row kernel performance ratchet. Published vectors report
114,915 passing, zero failing and 111,327 skipped outside the supported kernel
scope. No gate, slack, baseline, workload, dependency or output golden changed.
<!-- validation:end -->

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| AdapterCost/Add/direct | 1.13 | 1.14 | +3.9% |
| AdapterCost/Add/wrapper | 1.13 | 1.14 | +1.3% |
| AdapterCost/Format/GDAAdapter | 15.55 | 16.02 | +1.6% |
| AdapterCost/Format/native | 13.79 | 13.72 | -1.0% |
| AdapterCost/Integral/direct | 0.69 | 0.67 | -1.3% |
| AdapterCost/Integral/wrapper | 0.72 | 0.73 | -0.2% |
| AdapterCost/Mul/direct | 0.68 | 0.67 | -0.8% |
| AdapterCost/Mul/wrapper | 0.74 | 0.76 | +3.0% |
| AdapterCost/Quantize/direct | 0.60 | 0.60 | -1.3% |
| AdapterCost/Quantize/wrapper | 0.62 | 0.62 | -0.2% |
| AdapterFormatCases/fixed/GDAAdapter | 15.99 | 15.61 | -0.6% |
| AdapterFormatCases/fixed/native | 13.70 | 13.62 | -0.6% |
| AdapterFormatCases/full34/GDAAdapter | 31.23 | 31.32 | -0.2% |
| AdapterFormatCases/full34/native | 29.05 | 29.44 | -0.8% |
| AdapterFormatCases/largeFixed/GDAAdapter | 30.82 | 30.54 | -1.2% |
| AdapterFormatCases/largeFixed/native | 23.55 | 23.12 | -2.5% |
| AdapterFormatCases/paddedExponent/GDAAdapter | 19.88 | 19.62 | -1.8% |
| AdapterFormatCases/paddedExponent/native | 13.80 | 13.82 | +0.6% |
| AdapterFormatCases/positiveQuantum/GDAAdapter | 18.43 | 18.21 | -0.5% |
| AdapterFormatCases/positiveQuantum/native | 13.83 | 13.79 | +1.5% |
| AdapterFormatCases/smallExponent/GDAAdapter | 17.37 | 16.89 | -2.0% |
| AdapterFormatCases/smallExponent/native | 14.02 | 13.91 | +0.5% |
| Kernel/Append/128/mixed | 16.68 | 16.47 | -2.1% |
| Kernel/Append/64/mixed | 12.08 | 12.00 | +0.1% |
| Kernel/Append/float64/mixed | 25.51 | 23.93 | -5.3% |
| Kernel/UnpackDigits/128/mixed | 9.93 | 9.81 | -1.0% |
| Kernel/UnpackDigits/64/mixed | 5.19 | 5.11 | +0.7% |
| UnpackDigitsCases/decimal128/raw | 15.42 | 15.25 | -0.5% |
| UnpackDigitsCases/decimal128/special | 2.26 | 2.24 | +0.3% |
| UnpackDigitsCases/decimal128/wide | 17.52 | 17.34 | -1.9% |
| UnpackDigitsCases/decimal128/word | 7.04 | 7.07 | +0.6% |
| UnpackDigitsCases/decimal128/zero | 2.05 | 2.02 | -2.4% |
| UnpackDigitsCases/decimal64/raw | 9.36 | 9.33 | -0.7% |
| UnpackDigitsCases/decimal64/special | 1.99 | 2.01 | +1.4% |
| UnpackDigitsCases/decimal64/wide | 10.48 | 10.52 | +0.1% |
| UnpackDigitsCases/decimal64/word | 6.13 | 6.17 | +0.3% |
| UnpackDigitsCases/decimal64/zero | 1.94 | 1.95 | +0.5% |

Six alternating pairs; all paired byte and allocation counts are unchanged.
The kernel, decoder and float rows are controls: this source change is only
in strconv layout, so their movement is not credited to direct placement.
<!-- primitive:end -->

## Wider point-placement and precision diagnostics

<!-- lengths:start -->
| Digits / fractional digits | Versus preceding build | Versus pre-short-copy build |
|---|---:|---:|
| 9 / 4 | -0.98% | -1.24% |
| 31 / 15 | -24.92% | -10.22% |
| 32 / 16 | -22.01% | -7.02% |
| 34 / 17 | -19.91% | -7.15% |

The largest positive median in the full matrix versus the preceding build is +5.10% at `BenchmarkCanonicalLength/8/drop4-16`.

The largest positive median in the full matrix versus the pre-short-copy build is +6.59% at `BenchmarkCanonicalLength/13/drop6-16`.

The three-revision diagnostic runs three balanced rotations of all 2–34 digit
lengths at two point placements. All source overlays are byte-for-byte git
snapshots under the same final compiler. All allocations are zero and the
expanded capacity oracle passes before every timed invocation. It does not
replace the original 37-row primary protocol or the 221-row ratchet. Full
rows, pair deltas and provenance are retained in evidence/length-summary.json
and evidence/length-provenance.json. Positive changes are costs, not omitted cases.
<!-- lengths:end -->

<!-- precision:start -->
| Existing formatting probe | Median paired change |
|---|---:|
| BenchmarkFormatDecimal64/Decimal-16 | +3.67% |
| BenchmarkFormatDecimal64/Exp-16 | +1.86% |
| BenchmarkFormatDecimal64/Fixed3-16 | +0.71% |
| BenchmarkFormatDecimal64/Integer-16 | +2.98% |
| BenchmarkFormatDecimal64/NegExp-16 | +2.50% |

Six alternating pairs of the existing decimal64 formatting probes, including
explicit precision Fixed3. Byte and allocation counts are unchanged. These
additional diagnostics remain separate from the fixed primary protocol.
<!-- precision:end -->

## Applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -1.48% | +0.28% |
| tax-fed | -1.80% | +3.03% |
| tax-ca | +0.12% | +1.47% |
| tax-nc | -0.23% | +0.26% |
| telco | -0.58% | -1.10% |

Medians of six alternating paired changes. Every binary passed nine original
output goldens; telco retains the original digest and totals. These diagnostics
do not replace the full runner clock gate. The application source is identical
between the pinned benchmark commits, which differ only in recorded results.
<!-- paired:end -->

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 1.8% | -7.1% to 7.0% |
| Mul | 13.4% | -4.5% to 20.5% |
| Quantize | 4.0% | -1.3% to 6.9% |
| Integral | 2.3% | -3.8% to 23.4% |
| Format | 15.0% | 8.0% to 22.4% |
| Format/fixed | 14.5% | 12.4% to 18.3% |
| Format/full34 | 7.7% | 2.9% to 12.5% |
| Format/largeFixed | 32.8% | 23.1% to 38.7% |
| Format/smallExponent | 21.6% | 20.8% to 28.0% |
| Format/positiveQuantum | 32.8% | 23.5% to 37.3% |
| Format/paddedExponent | 42.9% | 33.1% to 49.5% |
<!-- adapter:end -->

<!-- conclusion:start -->
Euro uses 7.17% less time than Miguel; California tax uses 5.38% less time than Miguel; Federal tax uses 10.04% less time than Miguel; North Carolina tax uses 1.67% more time than Miguel; Telco uses 58.87% less time than Miguel.

Four complete invocations passed every original output and timing gate.
There were 4 excluded complete invocations; all attempts remain archived.
Small relative differences remain uncertain on the shared host. The original
unsupported scenarios remain outside these five supported-workload comparisons.
<!-- conclusion:end -->

The full cohort changes versus the preceding build are -0.29% euro,
-2.95% California, +0.89% federal, +1.32% North Carolina and +0.56% telco.
The paired medians also show costs in several applications. These mixed results
do not establish a broad application speedup, and the four clock rejections
reinforce the shared-host limitation. The retained benefit is recovery of the
large long-span regressions, with smaller formatting and application costs
explicitly retained. The original performance objective is still open.

## Code size and diagnostic profile

<!-- size:start -->
| Application | Before text bytes | After text bytes | Change |
|---|---:|---:|---:|
| euro | 661,364 | 661,620 | +0.04% |
| tax-ca | 684,612 | 684,868 | +0.04% |
| tax-fed | 779,060 | 779,316 | +0.03% |
| tax-nc | 703,124 | 703,380 | +0.04% |
| telco | 656,500 | 656,756 | +0.04% |

Text sizes sum T/t symbols from go tool nm -size. Complete file sizes and
appendDecimal disassemblies are retained in evidence.
<!-- size:end -->

<!-- profile:start -->
For the formerly regressing 31-digit / 15-fractional-digit append, runtime.memmove
accounts for 3.2% of the benchmark subtree's CPU samples before and
0.0% after. These profiles verify execution of the targeted path; they
are diagnostics, not headline timing. Missing samples do not prove a function
has zero cost for other inputs. Source still retains general copy fallbacks.
The raw profiles and complete node listings are archived. Benchmark calibration
chooses different iteration counts, so total sampled seconds are not a speed
comparison. In this specific after-profile, writeDigits accounts for 2.17 of
3.74 timed seconds (58.0%); it is the next measured long-format hotspot.
The main formatter frame remains 256 bytes. Text grows 256 bytes per application;
complete executable file sizes are unchanged in this cohort.
<!-- profile:end -->

## Reproduction and remaining scope

phase.json pins clean fork 333e3ade3100fad323b7b57400c2340067ff055d and measured
benchmark source b0b1e79ea58ac689d891df3190f6fe2839b14f9d. The verified
compiler.bundle requires a8c82228ec485fbd13f8766a19e7c7a27b937781;
compiler.patch records the exact source and test diff. The verified
benchmark-results.bundle contains c166f9163b78d2c576beab20b41bd4903b177294 and
requires the measured benchmark source. Build with src/make.bash and
GOEXPERIMENT=''; tests/applications use GOEXPERIMENT=decimal, GOWORK=off,
GOTOOLCHAIN=local, CGO_ENABLED=0 and the shared default cache. summarize.mjs
regenerates the cohort and adapter tables from phase.json. Evidence includes
the balanced three-revision matrix, calibrated profile commands and chart script. All attempts
and rejected trials are retained. Native execution is ARM64; AMD64 code-generation
checks are not native AMD64 performance evidence. Risk/power and banking/logarithm/
compound, real POWER and s390x hardware, native AMD64, and the unrelated global
intrinsics-off debug issue remain open. The performance objective remains open.
No performance changes have been pushed or deployed.
