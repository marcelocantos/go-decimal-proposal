# Direct canonical decimal layout

Original Go change 4c3fdc578b71df72dc1fe854d42a3ffc0cdd6bf5 keeps canonical
decimal formatting in its caller and constructs rounding state only when an
explicit precision requires it. It removes a call and common-path state stores;
it does not change the formatting algorithm, arithmetic, public APIs or adapter.
No competitor implementation was inspected or copied, and no assembly was
handwritten. The complete toolchain is rebuilt from this clean revision.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 844.8 | 791.4 | 6.3% less time | 793.4 | 2,271.9 |
| California tax | 460.8 | 437.2 | 5.1% less time | 423.4 | 1,865.6 |
| North Carolina tax | 804.9 | 745.5 | 7.4% less time | 718.0 | 3,006.0 |
| Federal tax | 2,250.2 | 2,171.1 | 3.5% less time | 2,340.2 | 9,443.0 |
| Telco | 35.7 | 35.0 | 2.0% less time | 81.1 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four complete
accepted invocations use the original programs, dependencies, datasets, goldens
and timing checks. Historical before/after cohorts are not simultaneous;
shared-host and reference-library changes limit attribution. Six alternating
POC application pairs provide a nearer comparison. Adapter costs remain in all
application times, with no estimated allowance subtracted.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

<!-- conclusion:start -->
Euro uses 0.2% less time than Miguel; California tax uses 3.3% more time than Miguel; North Carolina tax uses 3.8% more time than Miguel; Federal tax uses 7.2% less time than Miguel; Telco uses 56.9% less time than Miguel.

Four complete invocations passed every original output and timing gate.
1 complete invocations were excluded by unchanged clock checks and remain archived.
This is not an across-the-board performance lead. Small cohort differences
remain uncertain on the shared host.
<!-- conclusion:end -->

Euro's sub-percent margin is effectively a tie at this sample size on a shared
host, not an established lead. The remaining losses are not treated as wins.

## Mechanism and semantics

Previously appendDecimal initialized a finite descriptor containing the digit
array, sign, count and exponent, then called appendCanonical for every negative
precision. The new path unpacks into a local array and keeps the other decoder
outputs in local variables. The single-use canonical layout is now in that
function. It retains every coefficient digit and the quantum, including signed
zeros, notation thresholds, exponent padding, unknown format verbs and explicit
fixed notation. Non-finite output still returns before finite layout.

Only nonnegative precision constructs the finite rounding descriptor. Its digit
field points to the same stack array; rounding and carry handling still mutate
that array through the existing code. The output buffer never doubles as the
digit array in the retained implementation. All fallback growth, fixed and
scientific layout helpers remain unchanged. This is explicit source structure,
so removing the call does not depend on the inliner's cost budget.

## Rejected borrowed-buffer experiment

The first trial put digits into spare output capacity for bounded canonical
forms. The maximum-size buffer leaves eight bytes before a full coefficient,
enough for signs, a decimal point and leading zeros. The independent tests and
allocation checks passed, but a final relocation was still needed to put output
immediately after the caller's prefix. Avoiding scratch initialization added
guards and a pointer without removing that relocation.

Six alternating application pairs show best-sample changes of +0.70% euro,
-0.32% federal, +3.67% California, +6.97% North Carolina and +2.69% telco;
median-sample changes are +1.01%, -1.53%, +1.95%, +3.63% and +1.78% respectively.
Several fixed formatting probes improve slightly, but the application costs do
not justify retaining this version. Its patch, tests, escape-analysis output and
all paired records are archived under evidence. The source was restored before
the second trial.

The retained direct-layout trial improves all five original applications:
best-sample paired medians are -2.55% euro, -2.02% federal, -4.49% California,
-2.79% North Carolina and -2.63% telco. Median-sample changes are -2.17%, -2.42%,
-4.57%, -2.53% and -2.25%. Every executable passes nine original output checks.
These development measurements are separate from the final coherent results.

## Correctness and enforcement

The new TestAppendDecimalCanonicalCapacity performs 66,000 checks spanning
every coefficient length in both widths, both signs, eleven exponent cases,
six format verbs, empty/nonempty prefixes and five capacity boundaries. It
checks a sentinel outside the exposed capacity. Expected strings come from
the existing independent big.Int formatter, not another call to the product.
It runs in the normal strconv test suite with the decimal experiment enabled.
Existing special-value, signed-zero, carry, random rounding, round-trip and
allocation tests remain active.

<!-- validation:start -->
All ten gates pass on the final coherently rebuilt toolchain: affected enabled
packages; fresh million-case digit
references per width (seed 577); fresh million-case Append references per width
(seed 587); runtime decimal tests; language/ARM64/AMD64 codegen; experiment-off
packages; explicit strconv formatting, carry and round-trip tests; published
vectors; fresh long independent compiled comparison and rounding references
(seed 593); and the unchanged 221-row performance ratchet. Published vectors
report 114,915 passing, zero failing and 111,327 skipped outside the supported
kernel scope. The prior baseline, slack, band, sample count and retry policy
are unchanged. The new independent canonical-capacity test is enforced by
the normal strconv suite.
<!-- validation:end -->

Native execution is ARM64. AMD64 code-generation checks are not native AMD64
execution. The existing global intrinsics-off debug-mode issue remains T8.

## Native and adapter probes

Six alternating before/after invocations retain all 37 rows: five mixed kernel
text probes, ten decoder classes and 22 direct/adapter probes. The kernel is
unchanged in this batch, so its rows are controls. Final results include any
costs as well as gains; allocation counts and byte counts must match baseline.

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| AdapterCost/Add/direct | 1.15 | 1.15 | +0.5% |
| AdapterCost/Add/wrapper | 1.16 | 1.13 | -0.1% |
| AdapterCost/Format/GDAAdapter | 19.98 | 17.77 | -11.0% |
| AdapterCost/Format/native | 16.98 | 15.89 | -6.4% |
| AdapterCost/Integral/direct | 0.74 | 0.75 | -1.1% |
| AdapterCost/Integral/wrapper | 0.69 | 0.78 | +9.8% |
| AdapterCost/Mul/direct | 0.73 | 0.72 | -3.3% |
| AdapterCost/Mul/wrapper | 0.75 | 0.72 | -7.4% |
| AdapterCost/Quantize/direct | 0.61 | 0.61 | -0.7% |
| AdapterCost/Quantize/wrapper | 0.63 | 0.62 | -0.9% |
| AdapterFormatCases/fixed/GDAAdapter | 20.10 | 18.20 | -11.6% |
| AdapterFormatCases/fixed/native | 17.01 | 16.12 | -5.5% |
| AdapterFormatCases/full34/GDAAdapter | 35.38 | 33.89 | -4.3% |
| AdapterFormatCases/full34/native | 33.21 | 32.12 | -4.3% |
| AdapterFormatCases/largeFixed/GDAAdapter | 33.31 | 33.17 | -0.1% |
| AdapterFormatCases/largeFixed/native | 26.19 | 25.38 | -3.2% |
| AdapterFormatCases/paddedExponent/GDAAdapter | 22.88 | 20.92 | -6.8% |
| AdapterFormatCases/paddedExponent/native | 15.39 | 14.85 | -3.2% |
| AdapterFormatCases/positiveQuantum/GDAAdapter | 20.48 | 19.52 | -4.7% |
| AdapterFormatCases/positiveQuantum/native | 15.00 | 14.80 | -0.4% |
| AdapterFormatCases/smallExponent/GDAAdapter | 19.69 | 17.91 | -8.2% |
| AdapterFormatCases/smallExponent/native | 15.61 | 15.02 | -3.5% |
| Kernel/Append/128/mixed | 17.47 | 17.67 | +1.2% |
| Kernel/Append/64/mixed | 12.39 | 12.51 | +1.9% |
| Kernel/Append/float64/mixed | 25.23 | 24.99 | +2.5% |
| Kernel/UnpackDigits/128/mixed | 11.07 | 11.23 | +1.4% |
| Kernel/UnpackDigits/64/mixed | 5.24 | 5.25 | +1.4% |
| UnpackDigitsCases/decimal128/raw | 17.73 | 17.73 | +0.8% |
| UnpackDigitsCases/decimal128/special | 2.12 | 2.18 | +1.9% |
| UnpackDigitsCases/decimal128/wide | 21.15 | 21.12 | -0.0% |
| UnpackDigitsCases/decimal128/word | 7.07 | 7.04 | -0.4% |
| UnpackDigitsCases/decimal128/zero | 2.01 | 2.03 | +0.3% |
| UnpackDigitsCases/decimal64/raw | 9.36 | 9.39 | +1.0% |
| UnpackDigitsCases/decimal64/special | 2.00 | 1.99 | -0.3% |
| UnpackDigitsCases/decimal64/wide | 10.53 | 10.61 | +0.5% |
| UnpackDigitsCases/decimal64/word | 6.17 | 6.21 | +0.9% |
| UnpackDigitsCases/decimal64/zero | 1.95 | 1.99 | +1.6% |
<!-- primitive:end -->

## Original applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -1.94% | -2.58% |
| tax-fed | -1.53% | -2.11% |
| tax-ca | -2.96% | -3.63% |
| tax-nc | -2.87% | -2.13% |
| telco | -2.83% | -2.62% |
<!-- paired:end -->

Each cell is the median of six paired percentage changes. Every executable
passes nine original output goldens before timing. Telco checks its published
digest and totals. These diagnostics do not replace the complete runner's clock
gate. Baseline binaries use coherent 8af808ccf2 and benchmark db46d69; candidate
source 2d46669041 changes only recorded results, so executable source is identical.

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 0.7% | -4.4% to 5.0% |
| Mul | 0.8% | -16.8% to 8.7% |
| Quantize | 3.8% | 0.8% to 8.5% |
| Integral | 5.0% | -3.3% to 11.0% |
| Format | 12.2% | 3.9% to 13.4% |
| Format/fixed | 12.7% | 10.9% to 16.0% |
| Format/full34 | 5.5% | 5.0% to 6.1% |
| Format/largeFixed | 32.8% | 29.3% to 37.7% |
| Format/smallExponent | 20.1% | 15.9% to 22.2% |
| Format/positiveQuantum | 31.8% | 28.5% to 33.0% |
| Format/paddedExponent | 42.1% | 37.3% to 43.2% |
<!-- adapter:end -->

These percentages use the same six final paired invocations. Negative costs
can reflect layout and measurement noise; no percentage is subtracted from
application times.

An additional six-pair check uses the existing five BenchmarkFormatDecimal64
rows, with both binaries built by the same final compiler. The baseline uses an
overlay verified byte-for-byte against the original 8af808ccf2 strconv source;
the candidate uses the retained source. Both pass the independent capacity and
allocation tests before timing. Integer improves 4.8%, Decimal 1.3% and NegExp
2.7%; Exp costs 1.4% more. Fixed3, an explicit-precision fallback, costs 3.3%
more (paired range -1.4% to +7.0%, five of six deltas positive). Allocations and
bytes are unchanged. This is an explicit retained tradeoff, not a universal
formatting speedup; raw probes and the overlay are archived in evidence.

## Size, profiles and remaining work

<!-- size:start -->
| Application | Before text bytes | After text bytes | Text change |
|---|---:|---:|---:|
| euro | 661,156 | 661,172 | +0.00% |
| tax-ca | 684,404 | 684,420 | +0.00% |
| tax-fed | 778,852 | 778,868 | +0.00% |
| tax-nc | 702,916 | 702,932 | +0.00% |
| telco | 656,292 | 656,308 | +0.00% |

Text counts sum T/t symbols from go tool nm -size. Complete file sizes are
in evidence/application-sizes.json. Code and allocation costs remain part of the application comparison.
<!-- size:end -->

Whole-program text grows by 16 bytes in each application. Disassembly confirms
the canonical helper call is gone. appendDecimal's own ARM64 frame grows from
176 to 256 bytes, so the direct layout is not a universal reduction in stack
space. The explicit-precision timing cost above is retained alongside this
structural tradeoff; the measurements do not isolate its cause.

<!-- profile:start -->
Fresh golden-checked profiles put String conversion, including adaptation and
allocation, at 65.3% of euro and 38.6% of federal-tax timed
samples. These percentages divide String's cumulative samples by BestOf's
cumulative samples, not whole-process samples. Source overlays only wrap the
original entrypoints with runtime/pprof. Their diffs, provenance and raw profiles
are retained under evidence/profiles.
<!-- profile:end -->

Formatting, wider coefficients and repeated compiler guards remain candidates
for original Go work. One concrete next experiment is the constant division by
10^19 used to split wide coefficients into printable chunks. The bounded
coefficient permits a reciprocal estimate and at most one correction, but the
proof, implementation and measurements are future work, not delivered gains.
Risk/power and banking/logarithm/compound remain
unsupported. ARM64 assembly and native AMD64 work have not started. Real POWER
and s390x hardware verification remain separate open work. T6 remains open;
no performance changes are pushed or deployed.

## Reproduction

phase.json pins both cohorts and machine.json records fresh host probes.
compiler.bundle requires 8af808ccf2b98a1b1216dd3037f54af10f719eb9; compiler.patch
contains the exact source diff. The results bundle requires the measured
benchmark source 2d46669041c9250eecb10d957657cea4b497bbc2. Bundles are verified in
their matching repositories; results are committed at
bc0efce90228cfaa5fd90bd9e92c1ede9f2a8ae9. Build the compiler with src/make.bash and
GOEXPERIMENT=''; tests and applications use GOEXPERIMENT=decimal, GOWORK=off,
GOTOOLCHAIN=local and CGO_ENABLED=0, with the fork first in PATH.

summarize.mjs regenerates cohort and adapter tables from phase.json.
evidence/relative-chart.py regenerates the library comparison. Raw timing
attempts, rejected trials, gate commands/logs, profile overlays, original golden
checks and native text sizes are retained. Profiles are diagnostic and never
headline timing measurements. No duplicate build cache was created.
