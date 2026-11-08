# Power-of-ten division and direct decimal formatting

This local ARM64 milestone specializes exact division by power-of-ten
coefficients and removes intermediate formatting and scanning in strconv.
The compiler, kernel and public formatter are rebuilt together at the recorded
revision. All implementation changes are original Go code; no handwritten
assembly or competing library implementation is used.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,149.9 | 1,009.3 | 12.2% less time | 852.2 | 2,503.9 |
| California tax | 617.1 | 580.7 | 5.9% less time | 458.7 | 1,992.5 |
| North Carolina tax | 1,070.7 | 1,001.2 | 6.5% less time | 764.6 | 3,240.7 |
| Federal tax | 2,842.2 | 2,807.9 | 1.2% less time | 2,532.1 | 10,150.7 |
| Telco | 71.1 | 68.1 | 4.3% less time | 81.6 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. The table averages
the original runner's best-sample figure from four accepted complete invocations.
The baseline is the preceding compiler arithmetic cohort, not contemporaneous
alternating application runs. Every attempt is retained, including any clock
check rejection. No adapter allowance is subtracted. Shared-host variation and
library controls limit causal precision, especially for small differences.

All four new invocations passed every output and timing gate; none was excluded.
The POC takes 16.6% less compute time than Miguel for telco in this cohort.
It still takes 10.9% more time for federal tax, 18.4% more for euro, 26.6% more
for California and 30.9% more for North Carolina. Federal tax's 1.2% observed
improvement over the preceding POC cohort is too small to separate confidently
from shared-host variation. The evidence does not establish leadership across
all workloads or metrics.

## Changes and exactness

Division by a coefficient 10^k uses the original numerator coefficient and
exponent difference minus k. It removes at most k trailing coefficient zeros
toward the preferred exponent. The existing central rounder handles all modes,
exponent limits and exceptional rounding. Zero and special operands retain
the existing paths.

Wide coefficients emit decimal digits in pairs. An initial implementation
crossed Go's inlining budget and hurt short coefficients; the retained version
keeps a separate small, inlineable word-digit loop. Splitting a canonical
128-bit coefficient at 10^19 now bypasses division when it fits the low chunk,
and uses the bounded one-word quotient otherwise.

The shared internal UnpackDigits API returns coefficient digits, sign and
quantum without choosing notation. strconv applies the requested notation and
precision once, including after quantization. This removes the former
format-and-rescan step. Signed zero, noncanonical input, NaN spelling, quantum
and precision remain unchanged. The benchmark adapter continues to use public
APIs and includes its GDA-format adjustment cost.

## Primitive evidence

Each retained stage has six alternating before/after binary invocations.
The source stages are:

- 5dbbd30c21092a43d0362a63f7c9917e60dc627b: simple division.
- 16ebcd7043699b82b94cfc68c11e9553abfdb2e7: wide digit pairs.
- 8aaa173c13b702e533aee8672f93981616e14d9a: coefficient splitting.
- cdb5b0c6f2a86c6f45abcd90024885ca0d22334b: shared digits and strconv consumer.

Raw measurements, intermediate alternatives and their logs are under [evidence](evidence/).
Summaries are stage-relative diagnostics, not application speedups.
Power-of-ten decimal128 division probes take 35.5–73.3% less time, with a
1.2% general-case difference within noise. Decimal64 division improves
28–41%, with a retained 2.8% general-case cost. The split digit-pair version
improves the mixed decimal128 append probe by 6.6%; coefficient splitting
reduces it another 6.1%. The final shared-digit consumer reduces full-width
native formatting by 28.1%, large fixed by 26.1% and scientific probes by
38.4–40.8%; short fixed improves 3.7%. Allocation counts are unchanged.
Earlier pair-generation alternatives and short-format regressions are retained
in the diagnostic record rather than discarded. The final
format comparison isolates the strconv consumer: its baseline binary contains
the new internal API but retains the old consumer.

## Validation

The final stage passes one million fresh-seed raw/canonical decoder comparisons
per decimal width, using the independent decoder and big.Int conversion. Both
widths' existing formatting, precision, quantum, roundtrip and allocation tests
pass, including independent precision references. Published vectors report
114,915 pass, zero fail and 111,327 intentionally unsupported/skipped cases.

The performance ratchet passes 221 rows. Only the two new API rows were added,
with eight recorded samples each; the prior 219 rows and limits are untouched.
The coherent rebuilt toolchain passes the affected kernel and standard-library
suites with the experiment enabled, and ordinary strconv/fmt/json with it off.
Detailed per-stage division, formatting and generation checks are preserved.
Fresh 15-second raw-encoding roundtrip fuzz runs pass for both widths (about
4.95 million decimal64 and 4.81 million decimal128 executions); see the logs
for exact counts. The initial fuzz invocation from outside the Go source module
was rejected by the tool and is retained alongside the successful module runs.

## Fresh profiles

The diagnostic overlays add only CPU-profile start/stop around each original
main. Euro and federal output match their original goldens; federal retains
its normal compute-sink postlude. The federal profile identifies remaining
ordered-comparison and formatting work. Euro's profile has substantial runtime
kevent/madvise samples outside the selected work loop, so its percentages are
not used as a precise CPU budget. Filtered listings retain the whole-profile
denominator. Exact settings, overlay source and raw profiles are archived;
none supplies the application headline numbers.

## Adapter costs

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 3.1% | -5.2% to 14.0% |
| Mul | -3.8% | -13.2% to 18.4% |
| Quantize | 6.9% | 2.8% to 13.3% |
| Integral | 17.0% | 14.2% to 20.5% |
| Format | 8.6% | -4.2% to 17.9% |
| Format/fixed | 12.6% | -0.3% to 16.3% |
| Format/full34 | 6.0% | 0.3% to 13.6% |
| Format/largeFixed | 29.2% | 24.6% to 43.3% |
| Format/smallExponent | 20.8% | 14.1% to 32.0% |
| Format/positiveQuantum | 34.7% | 29.6% to 38.8% |
| Format/paddedExponent | 35.1% | 23.9% to 37.1% |
<!-- adapter:end -->

Six complete native/adapter invocations use identical operands and sinks.
These percentages are diagnostics; they are not subtracted from application
measurements. Small signed deltas can reflect code layout and timing variation.

## Reproduction and remaining work

Use the exact revisions in phase.json and machine settings in machine.json.
The compiler source bundle requires the baseline fork. Rebuild with
src/make.bash, using GOEXPERIMENT='' for the compiler build itself. Put that
fork first in PATH, include /usr/sbin, and run the applications with
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0.

Run `go run ./cmd/bench -lib all` until four complete invocations pass the
unchanged golden-output and clock gates, retaining every rejected attempt.
The benchmark executable source remains unchanged from
248fc8ef2967abc51e656bda20a62c4ea8d08019. Regenerate this report using
`node ../summarize.mjs /path/to/benchmark /path/to/adapter-costs.txt --phase
/absolute/path/to/phase.json`.

The [compiler bundle](compiler.bundle) contains all four Go commits after
2d026e30771dcbf769e908298fd6bcc98ec91252; [compiler.patch](compiler.patch)
is their cumulative diff. The [results bundle](benchmark-results.bundle)
contains result commit 19fada66c5c2e6e2dcf82c637f928761cbd75642 and requires
benchmark commit 78a07018bee81099dd0f7badf13dbae6e37e6cdc. Both bundles
were verified in their corresponding repositories.

This work is local. Quantization, retained compiler facts, further useful Go
optimization, ARM64 assembly and native AMD64 measurements remain in the plan.
Risk/power and banking/logarithm/compound remain unsupported. Real POWER and
s390x hardware verification are separate open work.
