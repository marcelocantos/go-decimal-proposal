# Bounded reciprocal for wide decimal text

Original Go change 082f0305dd29cbefbc22deedc336eef078a75e8c replaces general
128-by-64 division by 10^19 in decimal128 text conversion with multiplication
and at most one correction. Small coefficients keep a direct word path. The
complete toolchain is rebuilt from this clean revision. Arithmetic operators,
public APIs and the benchmark adapter are unchanged. No competitor source was
inspected or copied, and no assembly was handwritten.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 791.4 | 812.5 | 2.7% more time | 850.3 | 2,379.7 |
| Federal tax | 2,171.1 | 2,195.5 | 1.1% more time | 2,394.4 | 9,567.2 |
| California tax | 437.2 | 456.9 | 4.5% more time | 429.5 | 1,874.5 |
| North Carolina tax | 745.5 | 748.6 | 0.4% more time | 748.3 | 3,049.8 |
| Telco | 35.0 | 35.2 | 0.5% more time | 82.4 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four complete
accepted runs use the original workloads, dependencies, datasets, output goldens
and clock checks. The historical baseline is not simultaneous; shared-host and
reference-library changes limit attribution. Six alternating application pairs
provide a nearer comparison. Adapter costs remain in every application time.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

<!-- conclusion:start -->
Euro uses 4.4% less time than Miguel; Federal tax uses 8.3% less time than Miguel; California tax uses 6.4% more time than Miguel; North Carolina tax is effectively tied with Miguel (0.04% more time); Telco uses 57.3% less time than Miguel.

Four complete invocations passed every original output and timing gate.
One complete invocation was excluded by unchanged clock checks and remain archived.
This is not an across-the-board performance lead. Small cohort differences
remain uncertain on the shared host.

All five POC cohort means are 0.4–4.5% slower than the preceding cohort;
reference-library times also shifted. The improved relative standings therefore
do not establish an application-wide gain from this change. The alternating
pairs support euro and federal improvements but show California and North
Carolina costs. This pass deliberately retains the wide-conversion improvement
with those application tradeoffs; the objective remains open.
<!-- conclusion:end -->

## Exactness argument

Let D = 10^19, B = 2^128 and N be the canonical coefficient, 0 <= N < 10^34.
The reciprocal R = floor(B/D) has high word one because 2^63 < D < 2^64.
Its low word is a compile-time integer expression, not a fitted constant.
Two wide products and two carry additions compute q0 = floor(N*R/B).

Since 0 <= N/D - N*R/B < N/B < 1, q0 is either the exact quotient or one
too small. Also q0 < 10^15, so it fits a word. The tentative remainder is
nonnegative and satisfies

    N - q0*D < D + N*D/B < 10,000,293,873,587,705,572 < 2^64.

Therefore low-word multiplication and subtraction recover the entire remainder,
even when q0*D exceeds 64 bits. If the remainder is at least D, increment q0
and subtract D once. There is no repeated correction or rounding. A coefficient
that already fits a word has quotient zero or one because 2^64 < 2*D.
The exact integer bound and reciprocal are recorded in evidence/proof.json.

Both production call sites obtain canonical finite coefficients from the
existing decoder; noncanonical encodings become zero before this helper.
Sign, quantum, NaN/infinity spelling and every subsequent layout decision are
unchanged. The existing independent digit oracle checks arbitrary encodings as
well as finite values, so this precondition is exercised through public paths.

## Development evidence

The first implementation used a wider tentative remainder and three wide
multiplications. It passed fresh references and improved the wide digit probe
18.6%, but application changes were mixed. The second used the tighter bound
and split the common guard from the wide helper. Compiler diagnostics show
both functions exceeded the inline budget (84 and 87 versus 80), adding a call.
The baseline helper already exceeded the budget too, at 92. No budget was raised.

The retained third version keeps the tighter arithmetic in one function. Native
ARM64 disassembly shows a leaf with no calls or stack frame. Its development
wide-digit probe improves 16.2%, mixed decimal128 digit extraction 12.4% and
mixed Append128 5.5%. Six application pairs show best-sample changes of -2.59%
euro, +0.25% federal, +1.54% California, -1.64% North Carolina and +0.06% telco;
median-sample changes are -2.84%, -0.59%, +2.30%, -0.83% and -0.59% respectively.
The possible California cost is retained, not dismissed. These development
timings are separate from the final coherent measurements below.

All three patches, tests, compiler diagnostics and paired measurements remain
in evidence. A test-fixture build error was fixed before any timing. Failed
and superseded trials were not substituted into the final cohort.

## Correctness and enforcement

TestUnpackDigitsSplitBoundaries runs in the normal internal/bid suite. It checks
exact chunk multiples, adjacent remainders, powers-of-two/ten quotient boundaries,
both sides of 2^64 and the maximum coefficient, with both signs and three
quanta. Expected digits come from independent big.Int conversion. Exact wide
multiples exercise the estimate correction; other cases exercise product carries.
The existing random decoder/text oracle, source-generation checks and published
vector gate remain active.

<!-- validation:start -->
All ten gates pass on the final coherently rebuilt toolchain: affected enabled
packages; fresh million-case digit
references per width (seed 619); fresh million-case Append references per width
(seed 631); runtime decimal tests; language/ARM64/AMD64 codegen; experiment-off
packages; explicit strconv formatting, carry and round-trip tests; published
vectors; fresh long independent compiled comparison and rounding references
(seed 641); and the unchanged 221-row performance ratchet. Published vectors
report 114,915 passing, zero failing and 111,327 skipped outside the supported
kernel scope. The prior baseline, slack, band, sample count and retry policy
are unchanged. The new independent chunk-boundary test is enforced by
the normal internal/bid suite.
<!-- validation:end -->

Native measurements are ARM64. AMD64 code-generation checks do not constitute
native AMD64 execution. The global all-intrinsics-off debug-mode issue remains T8.

## Native probes

Six alternating before/after invocations retain 37 mixed kernel, decoder-class
and direct/adapter rows. Decimal64 and float text rows are controls. Allocated
bytes and allocation counts must remain unchanged in every pair.

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| AdapterCost/Add/direct | 1.12 | 1.14 | +0.7% |
| AdapterCost/Add/wrapper | 1.12 | 1.17 | +2.0% |
| AdapterCost/Format/GDAAdapter | 17.74 | 18.20 | +1.9% |
| AdapterCost/Format/native | 16.01 | 15.93 | -1.1% |
| AdapterCost/Integral/direct | 0.76 | 0.70 | -4.9% |
| AdapterCost/Integral/wrapper | 0.77 | 0.72 | -8.5% |
| AdapterCost/Mul/direct | 0.71 | 0.74 | +1.1% |
| AdapterCost/Mul/wrapper | 0.70 | 0.74 | +6.3% |
| AdapterCost/Quantize/direct | 0.60 | 0.59 | -1.8% |
| AdapterCost/Quantize/wrapper | 0.63 | 0.62 | -0.8% |
| AdapterFormatCases/fixed/GDAAdapter | 17.82 | 17.98 | +0.8% |
| AdapterFormatCases/fixed/native | 15.98 | 16.02 | +0.4% |
| AdapterFormatCases/full34/GDAAdapter | 34.02 | 32.28 | -6.5% |
| AdapterFormatCases/full34/native | 32.45 | 29.61 | -7.4% |
| AdapterFormatCases/largeFixed/GDAAdapter | 33.31 | 31.66 | -5.9% |
| AdapterFormatCases/largeFixed/native | 25.80 | 23.83 | -6.6% |
| AdapterFormatCases/paddedExponent/GDAAdapter | 20.79 | 20.49 | -1.6% |
| AdapterFormatCases/paddedExponent/native | 14.83 | 14.31 | -1.5% |
| AdapterFormatCases/positiveQuantum/GDAAdapter | 19.62 | 19.34 | -1.0% |
| AdapterFormatCases/positiveQuantum/native | 14.40 | 14.63 | +0.9% |
| AdapterFormatCases/smallExponent/GDAAdapter | 17.93 | 17.85 | -0.8% |
| AdapterFormatCases/smallExponent/native | 14.88 | 14.80 | -2.0% |
| Kernel/Append/128/mixed | 17.55 | 16.58 | -5.0% |
| Kernel/Append/64/mixed | 12.43 | 12.13 | -2.0% |
| Kernel/Append/float64/mixed | 24.05 | 25.23 | +3.5% |
| Kernel/UnpackDigits/128/mixed | 11.06 | 9.88 | -10.7% |
| Kernel/UnpackDigits/64/mixed | 5.16 | 5.08 | -0.5% |
| UnpackDigitsCases/decimal128/raw | 17.77 | 15.36 | -13.2% |
| UnpackDigitsCases/decimal128/special | 2.14 | 2.41 | +14.2% |
| UnpackDigitsCases/decimal128/wide | 20.99 | 17.45 | -17.5% |
| UnpackDigitsCases/decimal128/word | 7.03 | 7.06 | +0.3% |
| UnpackDigitsCases/decimal128/zero | 2.05 | 2.14 | +6.3% |
| UnpackDigitsCases/decimal64/raw | 9.32 | 9.30 | +0.7% |
| UnpackDigitsCases/decimal64/special | 1.99 | 1.98 | +0.0% |
| UnpackDigitsCases/decimal64/wide | 10.41 | 10.46 | -0.0% |
| UnpackDigitsCases/decimal64/word | 6.12 | 6.19 | +1.2% |
| UnpackDigitsCases/decimal64/zero | 1.93 | 1.95 | +0.4% |
<!-- primitive:end -->

<!-- word:start -->
| Append128 word class | Median paired change | Range |
|---|---:|---:|
| large | -4.97% | -8.40% to -1.49% |
| small | -0.58% | -3.03% to +3.69% |

These two additional six-pair diagnostics use the same final compiler for both
binaries. The baseline coefficient source overlay is verified byte-for-byte
against 4c3fdc578b. Both binaries pass the independent split-boundary test
before timing; bytes and allocation counts are unchanged. Small-word inputs
lie below 10^19, large-word inputs near 2^64. The original 221-row ratchet
and application protocol are unchanged.
<!-- word:end -->

## Applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -6.59% | -2.11% |
| tax-fed | -0.90% | -2.08% |
| tax-ca | +2.54% | +4.43% |
| tax-nc | +3.14% | +1.28% |
| telco | +0.01% | +0.22% |
<!-- paired:end -->

These are medians of six paired percentage changes. Every executable passes
nine original output goldens before timing; telco checks the published digest
and totals. Diagnostics do not replace the complete runner's clock gate.
Baseline binaries use coherent 4c3fdc578b and benchmark 2d46669041. Candidate
benchmark source bc0efce902 changes only recorded results, so executable source
is identical. No wrapper allowance is subtracted.

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 3.3% | -3.5% to 8.7% |
| Mul | 1.7% | -4.8% to 13.5% |
| Quantize | 5.2% | 2.7% to 8.1% |
| Integral | -1.9% | -6.3% to 10.7% |
| Format | 14.6% | 9.3% to 16.9% |
| Format/fixed | 11.5% | 9.7% to 16.9% |
| Format/full34 | 8.8% | 5.6% to 11.5% |
| Format/largeFixed | 31.1% | 24.5% to 35.9% |
| Format/smallExponent | 19.7% | 17.7% to 26.1% |
| Format/positiveQuantum | 33.6% | 30.2% to 37.8% |
| Format/paddedExponent | 43.1% | 42.4% to 47.8% |
<!-- adapter:end -->

Adapter percentages use the same six final invocations. Negative premiums can
reflect layout or measurement effects rather than removed work.

## Code size and profiles

<!-- size:start -->
| Application | Before text bytes | After text bytes | Text change |
|---|---:|---:|---:|
| euro | 661,172 | 661,220 | +0.01% |
| tax-ca | 684,420 | 684,468 | +0.01% |
| tax-fed | 778,868 | 778,916 | +0.01% |
| tax-nc | 702,932 | 702,980 | +0.01% |
| telco | 656,308 | 656,356 | +0.01% |

Text counts sum T/t symbols from go tool nm -size. Complete file sizes are
in evidence/application-sizes.json. Code and allocation costs remain part of the application comparison.
<!-- size:end -->

<!-- profile:start -->
Fresh golden-checked profiles put String conversion, including adaptation and
allocation, at 60.5% of euro and 39.1% of federal-tax timed
samples. These percentages divide String's cumulative samples by BestOf's
cumulative samples, not whole-process samples. Source overlays only wrap the
original entrypoints with runtime/pprof. Their diffs, provenance and raw profiles
are retained under evidence/profiles.
<!-- profile:end -->

A separate golden-checked California diagnostic compares the final compiler
with and without the coefficient-source change. String accounts for 56.8%
and 57.9% of timed samples; memmove accounts for 10.9% and 13.2%. The
all-node profiles record no samples in cSplit128. This sampling result does
not prove the helper is free or establish the cause of the application
regression. Instrumented totals are not substitutes for the uninstrumented
paired results. Common formatting, copying and allocation are the next
measured hotspots; the California regression remains unresolved.
See [profile summary](evidence/profiles/ca-summary.json) and the retained
raw profiles, overlays and complete node listings.

The final [ARM64 helper disassembly](evidence/after-split.asm) contains no
CALL or stack-pointer reference; [the baseline](evidence/before-split.asm)
is retained alongside it. This supports the leaf-function mechanism,
not an application-speedup claim.

The goal remains open. Remaining application losses, common formatting costs,
wide arithmetic and repeated guards still need original Go/compiler work before
assembly. Risk/power and banking/logarithm/compound remain unsupported. Native
AMD64, real POWER and s390x hardware work remain open. No performance changes
are pushed or deployed.

## Reproduction

phase.json pins both cohorts and machine.json records fresh host probes.
compiler.bundle requires 4c3fdc578b71df72dc1fe854d42a3ffc0cdd6bf5;
compiler.patch contains the exact diff. The results bundle requires measured
benchmark source bc0efce90228cfaa5fd90bd9e92c1ede9f2a8ae9 and contains results
commit 425e200995289f0c45ca46651ea5d8be2948c31c. Bundles are verified
in their matching repositories. Build with src/make.bash and GOEXPERIMENT='';
tests/applications use GOEXPERIMENT=decimal, GOWORK=off, GOTOOLCHAIN=local and
CGO_ENABLED=0, with the fork first in PATH and the shared default build cache.

summarize.mjs regenerates the cohort and adapter tables from phase.json;
evidence/relative-chart.py regenerates the library comparison. All attempts,
source patches, proofs, gates, overlays, profiles and size records are archived.
Profiles are diagnostic, never headline timings.
