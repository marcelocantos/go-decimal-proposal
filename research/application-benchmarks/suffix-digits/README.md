# Decimal digit buffers and decoding

Original Go changes at 843c59cf754d4e800c17b4222c92390548fae671 write
coefficient digits into the suffix of the caller's buffer and use that span
directly. Common word coefficients and non-finite values avoid a general
decoder call. Public formatting, quantum, signed zero and rounding behavior
are unchanged. No competitor implementation was inspected or copied; no
assembly was handwritten. The adapter is unchanged. The final measured fork is
8af808ccf2b98a1b1216dd3037f54af10f719eb9, which also fixes the compiler race
exposed during this batch.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 919.6 | 844.8 | 8.1% less time | 814.4 | 2,354.3 |
| Federal tax | 2,304.2 | 2,250.2 | 2.3% less time | 2,338.1 | 9,520.3 |
| California tax | 483.2 | 460.8 | 4.6% less time | 432.8 | 1,883.6 |
| North Carolina tax | 853.0 | 804.9 | 5.6% less time | 728.8 | 3,058.3 |
| Telco | 39.0 | 35.7 | 8.5% less time | 80.6 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four accepted full
invocations use the original programs, datasets, dependencies, goldens and clock
checks. The historical baseline cohort is not simultaneous. Shared-host and
control-library shifts limit attribution; the alternating application pairs
below provide stronger evidence for this change. No adapter allowance is
subtracted from application results.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

<!-- conclusion:start -->
Euro uses 3.7% more time than Miguel; Federal tax uses 3.8% less time than Miguel; California tax uses 6.5% more time than Miguel; North Carolina tax uses 10.4% more time than Miguel; Telco uses 55.7% less time than Miguel.

Four complete invocations passed every original output and timing gate.
No complete invocation was excluded by the timing checks.
This is not an across-the-board performance lead. Small cohort differences
remain uncertain on the shared host.
<!-- conclusion:end -->

## Mechanism and proof

The previous implementation extracted digits backwards into a temporary array,
then copied them to the start of a second buffer. The new writer starts at the
end of the supplied buffer and returns the number of digits. It requires no
preliminary digit-counting pass. The caller uses the suffix without moving it.
The long-coefficient path still splits at 10^19 and uses the original pair table;
the single-word path retains its scalar loop.

UnpackDigits64/128 are internal APIs. Their signature and digit count are
unchanged, but their documented placement is now the final n bytes. Every
consumer was updated; the independent reference test checks the digit string,
kind, sign, exponent and untouched prefix using arbitrary raw encodings.
The public Append/Format APIs still emit exactly the same text.

The existing unpackWord guard proves finite canonical first-form coefficients.
A word below 10^19 fits the scalar writer's 19-digit bound, and the biased
exponent becomes the original quantum by subtracting the format's bias. Zero
writes no digits and preserves its sign and quantum. Guard failures recognize
NaNs/infinities directly; remaining finite encodings use the original decoder,
including noncanonical encodings that denote zero. The kernel's maximum
coefficient proves every nonzero result fits its supplied precision buffer.

strconv consumes the suffix for both canonical and explicitly rounded output.
When rounding changes 9.99 to 10.0, the retained leading digits move to the
suffix before the trailing zero is dropped. The move may overlap, so it uses
Go's copy operation. The new carry test covers every retained length at both
precisions, both signs and several exponents against the independent big.Int
formatter. The existing randomized rounding suite remains unchanged.

## Development evidence

Six alternating pairs for the suffix-only stage improve mixed kernel text rows
about 5–9%. All original application goldens pass; paired median changes are
-2.68% euro, -1.75% federal, -1.48% California, -3.91% North Carolina and -6.11%
telco. Fixed adapter probes mostly erase the native formatting gain, so that
stage alone does not explain the final result.

Adding the word decoder improves the five paired application medians 3.3–6.4%
versus the original baseline, but dedicated rotating probes reveal 21–23% more
time for NaN/infinity extraction. That regression is not accepted silently:
direct non-finite decoding removes the extra call. Three diagnostic pairs then
show decimal64 specials roughly flat and decimal128 specials 8.8% faster;
wide decimal128 is 1.2% slower. The final source also removes the redundant
non-finite test after the proven-finite fallback decoder. Final coherent
measurements below supersede development timings.

All stages, original failures, patches and timing attempts are retained under
evidence. These stages are not simultaneous with one another; changes between
stage means cannot be attributed entirely to their code differences.

## Parallel compiler table declaration

The first full runner at 843c59cf75 failed during its multi-package, trimpath
build, before producing any application measurements. Parallel compiler workers
could both try to declare a synthesized power-of-ten table. The earlier
addition, comparison and rounding lowerings called StringData through a
per-function cache; that cache does not serialize a process-wide symbol's first
declaration. This is a latent bug in the earlier compiler work, exposed by the
new build rather than caused by decimal formatting.

The fix declares all three tables during serial compiler initialization on
ARM64/AMD64. Workers only reference already-declared symbols. Table bytes,
alignment and indexing are unchanged. Initialization also runs with the decimal
experiment off because the standard library uses decimal types internally.
Unused data is eligible for linker elimination; compile-time overhead was not
measured separately.

The permanent regression compiles 128 decimal functions with 64 workers in
each of 32 fresh compiler invocations, bypassing the build cache. It fails on
attempt 30 against the old compiler and passes all 32 after the fix. An earlier
standalone reproduction failed on attempt 8. A separate unit test checks all
three tables against big.Int powers in both byte orders and verifies serial
redeclaration does not duplicate them. The formerly failing runner build now
passes. These tests run in the normal ssagen suite; this batch then rebuilds the
whole toolchain and repeats its correctness and measurement sequence.

Raw red/green logs and the reproducer are under evidence/compiler-race.
Successful pre-fix gates and timing diagnostics remain under
evidence/before-race-fix. A green short suite had missed the race; the new
regression specifically exercises concurrent first use. It is a stress test,
not an exhaustive scheduler proof. Synthesized compiler globals must be declared
before parallel SSA; per-function memoization cannot provide that guarantee.

## Correctness gates

<!-- validation:start -->
All ten gates pass on the final coherently rebuilt toolchain: affected enabled
packages, including the parallel compiler regression; fresh million-case digit
references per width (seed 521); fresh million-case Append references per width
(seed 523); runtime decimal tests; language/ARM64/AMD64 codegen; experiment-off
packages; explicit strconv formatting, carry and round-trip tests; published
vectors; fresh long independent compiled comparison and rounding references
(seed 563); and the unchanged 221-row performance ratchet. Published vectors
report 114,915 passing, zero failing and 111,327 skipped outside the supported
kernel scope. The prior baseline, slack, band, sample count and retry policy
are unchanged. The earlier build failure and its regression evidence are
retained separately under compiler-race; see the diagnosis below.
<!-- validation:end -->

The unchanged internal/bid package suite enforces the independent suffix-buffer
contract and generated-source checks. The normal strconv suite enforces carry
placement, the independent randomized formatter, canonical notation, round trips
and allocations. The existing adapter gate still enforces inlineable arithmetic
and exact GDA notation. The standalone raw/word/special probes expose guard
tradeoffs; they do not replace the correctness oracle or the mixed API ratchet.
Native execution is ARM64. AMD64 codegen checks are not native AMD64 execution.

## Native and mixed probes

Six complete alternating before/after invocations cover 37 rows: five mixed
kernel text rows, ten rotating decoder classes and 22 direct/adapter probes.
All paired allocation counts and byte counts are unchanged. Negative deltas
mean less time. Baseline decoder probes are compiled from the original a3fcc308bb
sources plus the identical new benchmark; their original prefix-contract test
also passes a fresh million-case reference run. The baseline overlay is archived.

<!-- primitive:start -->
| Probe | Before ns | After ns | Median paired change |
|---|---:|---:|---:|
| AdapterCost/Add/direct | 1.13 | 1.12 | -0.1% |
| AdapterCost/Add/wrapper | 1.14 | 1.13 | -1.7% |
| AdapterCost/Format/GDAAdapter | 21.20 | 20.09 | -7.0% |
| AdapterCost/Format/native | 19.19 | 17.02 | -12.0% |
| AdapterCost/Integral/direct | 0.70 | 0.72 | +3.6% |
| AdapterCost/Integral/wrapper | 0.71 | 0.74 | +3.4% |
| AdapterCost/Mul/direct | 0.73 | 0.71 | -2.1% |
| AdapterCost/Mul/wrapper | 0.71 | 0.74 | +4.4% |
| AdapterCost/Quantize/direct | 0.59 | 0.60 | +1.1% |
| AdapterCost/Quantize/wrapper | 0.62 | 0.61 | +0.2% |
| AdapterFormatCases/fixed/GDAAdapter | 21.00 | 19.84 | -5.9% |
| AdapterFormatCases/fixed/native | 18.80 | 17.01 | -10.9% |
| AdapterFormatCases/full34/GDAAdapter | 37.47 | 36.06 | -3.7% |
| AdapterFormatCases/full34/native | 35.22 | 33.55 | -5.0% |
| AdapterFormatCases/largeFixed/GDAAdapter | 34.01 | 33.63 | -0.7% |
| AdapterFormatCases/largeFixed/native | 25.79 | 26.37 | +1.7% |
| AdapterFormatCases/paddedExponent/GDAAdapter | 23.70 | 22.41 | -5.4% |
| AdapterFormatCases/paddedExponent/native | 17.49 | 15.61 | -11.4% |
| AdapterFormatCases/positiveQuantum/GDAAdapter | 23.73 | 20.79 | -10.8% |
| AdapterFormatCases/positiveQuantum/native | 17.22 | 15.25 | -12.3% |
| AdapterFormatCases/smallExponent/GDAAdapter | 21.77 | 19.73 | -9.8% |
| AdapterFormatCases/smallExponent/native | 17.77 | 15.51 | -12.4% |
| Kernel/Append/128/mixed | 18.36 | 17.38 | -5.3% |
| Kernel/Append/64/mixed | 13.32 | 12.21 | -7.6% |
| Kernel/Append/float64/mixed | 24.30 | 24.66 | -1.1% |
| Kernel/UnpackDigits/128/mixed | 12.33 | 11.07 | -7.7% |
| Kernel/UnpackDigits/64/mixed | 6.25 | 5.22 | -16.5% |
| UnpackDigitsCases/decimal128/raw | 18.52 | 17.43 | -6.3% |
| UnpackDigitsCases/decimal128/special | 2.35 | 2.17 | -7.5% |
| UnpackDigitsCases/decimal128/wide | 21.66 | 21.24 | -0.7% |
| UnpackDigitsCases/decimal128/word | 8.31 | 7.04 | -15.6% |
| UnpackDigitsCases/decimal128/zero | 2.22 | 2.03 | -9.7% |
| UnpackDigitsCases/decimal64/raw | 10.91 | 9.33 | -14.3% |
| UnpackDigitsCases/decimal64/special | 2.01 | 1.98 | +0.7% |
| UnpackDigitsCases/decimal64/wide | 11.15 | 10.46 | -4.7% |
| UnpackDigitsCases/decimal64/word | 7.40 | 6.14 | -15.7% |
| UnpackDigitsCases/decimal64/zero | 2.28 | 1.99 | -12.5% |
<!-- primitive:end -->

The decimal64 wide case is a canonical 16-digit second-form coefficient;
decimal128 wide uses 34 digits. Special probes rotate signs and NaNs/infinities;
uniform raw probes also cover arbitrary payloads and noncanonical encodings.

## Original applications and adapter costs

<!-- paired:start -->
| Workload | Best-sample change | Median-sample change |
|---|---:|---:|
| euro | -5.66% | -3.80% |
| tax-fed | -2.71% | -1.09% |
| tax-ca | -2.67% | -4.37% |
| tax-nc | -4.73% | -4.78% |
| telco | -6.98% | -8.19% |
<!-- paired:end -->

Each cell is the median of six paired percentage changes. Every executable
passes nine original output goldens before timing; telco checks its published
output digest and totals. These diagnostics retain the original workload but
do not replace the full runner's clock checks. Saved baseline applications and
adapter probes were built at benchmark 0e2b03c with coherent a3fcc308bb. Current
benchmark db46d69 only adds recorded results: executable source is identical.
Final candidate binaries use the coherently rebuilt 8af808ccf2 toolchain.

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 0.7% | -0.5% to 2.8% |
| Mul | 2.8% | -9.5% to 12.7% |
| Quantize | 3.1% | 1.4% to 7.8% |
| Integral | 1.2% | -7.8% to 11.8% |
| Format | 18.1% | 12.3% to 20.4% |
| Format/fixed | 17.4% | 11.8% to 22.0% |
| Format/full34 | 7.4% | 5.5% to 9.5% |
| Format/largeFixed | 28.3% | 24.9% to 35.1% |
| Format/smallExponent | 25.9% | 17.2% to 30.9% |
| Format/positiveQuantum | 39.1% | 35.2% to 40.7% |
| Format/paddedExponent | 44.8% | 37.1% to 49.7% |
<!-- adapter:end -->

Adapter percentages are calculated from the same six final paired invocations.
Negative premiums reflect measurement/layout effects, not removed arithmetic.
They are never deducted from headline application results.

## Code size and remaining work

<!-- size:start -->
| Application | Before text bytes | After text bytes | Text change |
|---|---:|---:|---:|
| euro | 661,028 | 661,156 | +0.02% |
| tax-ca | 684,276 | 684,404 | +0.02% |
| tax-fed | 778,724 | 778,852 | +0.02% |
| tax-nc | 702,788 | 702,916 | +0.02% |
| telco | 656,164 | 656,292 | +0.02% |

Text counts sum T/t symbols from go tool nm -size. Complete file sizes are
in evidence/application-sizes.json. Fast paths add branches; their resulting
code and allocation costs remain part of the application comparison.
<!-- size:end -->

<!-- profile:start -->
Fresh golden-checked profiles put String conversion, including adaptation and
allocation, at 54.7% of euro and 39.6% of federal-tax timed
samples. These percentages divide String's cumulative samples by BestOf's
cumulative samples, not whole-process samples. Source overlays only wrap the
original entrypoints with runtime/pprof. Their diffs, provenance and raw profiles
are retained under evidence/profiles.
<!-- profile:end -->

A further original Go investigation is to write digits into spare output
capacity, avoiding another copy and a separate zeroed buffer. Before doing so,
prove overlap safety for signs, inserted decimal points and exponents, preserve
prefixes and handle reallocation. Earlier direct-write and digit-pair trials
show why instruction-count arguments alone are insufficient; acceptance still
requires the original varied workloads and gates.

Risk/power and banking/logarithm/compound remain unsupported. Richer compiler
facts, wider coefficients, useful remaining Go work, ARM64 assembly and native
AMD64 work remain open. Real POWER and s390x hardware verification remain
separate. The global all-intrinsics-off startup issue is tracked as T8.
T6 remains open. No performance changes are pushed or deployed.

## Reproduction

phase.json pins both cohorts, and machine.json contains fresh host probes.
The compiler bundle requires a3fcc308bb1442f20bf7db8ec6937d066f7fd020; the exact
patch is included. The results bundle requires
db46d69e8c0d3e48ed9534e31867c011ed69bfb6, the measured benchmark revision.
It contains results commit 2d46669041c9250eecb10d957657cea4b497bbc2; executable
benchmark source is unchanged. The compiler bundle contains both this batch's
formatting and table-declaration commits.
Both bundles are verified in their matching repositories. Build the compiler
with src/make.bash and GOEXPERIMENT=''. Tests/applications use GOEXPERIMENT=decimal,
GOWORK=off, GOTOOLCHAIN=local and CGO_ENABLED=0, with the fork first in PATH.

summarize.mjs regenerates cohort and adapter tables from the frozen phase.json;
evidence/relative-chart.py regenerates the library comparison. Raw runner records
retain historical rejected invocations; this final cohort has none. The first
pre-fix build failure produced no records and is archived in compiler-race.
The paired scripts, baseline overlay,
source patches, gate commands/logs, profiles and native sizes are archived under
evidence. Instrumented profiles are diagnostic, never headline timings.
