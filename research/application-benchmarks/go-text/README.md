# ARM64 Go text-conversion follow-up

The [second-pass profiles](../go-phase2/README.md) identify formatting work
in the supported euro and tax workloads. `strconv.(*finite).scan` now uses
the kernel's canonical text structure to locate the exponent and point, then
copies digit runs in bulk. A one-digit
scientific mantissa takes a short path. There is no handwritten assembly or
copied decimal-library implementation. The parser also accumulates its first
19 significant digits in a uint64, whose range holds them exactly, before
using the existing wide arithmetic. Rounding and sticky-digit handling are
unchanged.

The adapter, benchmark workload, input, golden files and dependencies are
unchanged. Formatting still reaches the public native Go API, and the complete
adapter cost remains in the application measurements.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,377.3 | 1,177.0 | 14.5% less time | 841.0 | 2,356.4 |
| Federal tax | 4,245.7 | 4,079.0 | 3.9% less time | 2,379.6 | 9,739.5 |
| North Carolina tax | 1,323.6 | 1,256.1 | 5.1% less time | 739.2 | 3,024.3 |
| California tax | 884.9 | 833.3 | 5.8% less time | 443.3 | 1,888.4 |
| Telco | 104.2 | 102.8 | 1.3% less time | 80.2 | Unsupported |
<!-- results:end -->

Cells are **compute nanoseconds per record; lower is better**, averaging the
runner's best-sample estimate from four accepted full invocations per revision.
The before data is the preceding report's complete after cohort, rather than
selected fastest rows. [measurements.json](measurements.json) retains all
attempts, original output gates, quantiles and clock cross-checks, including
any rejected invocation. This is shared-host exploratory evidence; four runs
are not a population confidence interval.

The unchanged library controls also vary between cohorts. The application
comparison does not separate each change's contribution from variation in
host timing; a small difference such as telco's is not an established gain.
One before invocation failed a Miguel federal-tax clock check and is archived
and excluded. All four final-revision invocations pass every original output
gate and clock check.

Risk/power and banking/logarithm/compound remain unsupported by the POC. The
library comparisons and their unsupported rows are preserved. Native AMD64,
real POWER and s390x hardware work remain open.

## Focused evidence

Six interleaved before/after repetitions exercise both native formatting and
the unchanged adapter over short fixed, full 34-digit, large fixed and three
exponent cases. The first bulk-copy trial regressed short exponent formatting;
the retained canonical one-digit path addresses that case. Raw samples and
benchstat summaries are under `evidence/`. These probes diagnose the change
and are separate from the application table.

The existing independent math/big rounding reference checks 20,000 coefficient
and exponent cases at each width with both `e` and `f` formatting. Additional
standing tests cover signs, zero quantum, notation boundaries, explicit
precision, NaNs and infinities. At formatting revision `f90197f3d3`, round-trip fuzzing completed
4,531,557 decimal128 and 4,969,745 decimal64 executions without failure.
Earlier trial logs remain separate from the retained candidate. Parser fuzzing
checks all rounding modes and both widths against the existing independent
reference; the retained parser completed 2,207,238 fuzz executions and the
published suite reports 114,915 passes, zero failures and 111,327 explicit skips.
The final rebuilt toolchain passes the short bid, decimal, strconv, reflect,
fmt and JSON suites, decimal runtime/language checks, experiment-off bid and
strconv tests, and the native adapter's existing cohort tests.

The existing broad performance/allocation ratchet initially failed its short
decimal128 parse row. A six-pair comparison of the preceding and formatting
revisions under the same compiler found no significant parsing difference.
The word-sized parser improves that measured path and the retained candidate
passes all 219 ratchet rows. Its provisional 20% band and 0.5 ns slack are
unchanged; this is a coarse regression check, not a claim of zero regressions.
The failure, diagnostic comparison, skipped wrong-directory invocation and
properly executed passing gate are all retained in the evidence.

The intermediate formatting-only application cohort at `f90197f3d3` is
preserved in [formatting-measurements.json](formatting-measurements.json).
It is separate from the final text-conversion comparison above.

## Adapter cost

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 1.9% | -2.3% to 10.4% |
| Mul | 1.4% | -5.2% to 48.6% |
| Quantize | 6.2% | 2.8% to 10.0% |
| Integral | 13.8% | 2.5% to 17.2% |
| Format | 8.3% | 5.6% to 9.4% |
| Format/fixed | 8.9% | 8.1% to 12.2% |
| Format/full34 | -2.4% | -4.7% to -0.5% |
| Format/largeFixed | 26.2% | 24.6% to 28.8% |
| Format/smallExponent | 24.8% | 21.6% to 32.3% |
| Format/positiveQuantum | 24.1% | 19.9% to 31.6% |
| Format/paddedExponent | 17.6% | 12.8% to 19.0% |
<!-- adapter:end -->

These are percentages from six adjacent direct/native and wrapper pairs at
the final revision, without subtracting any allowance from application times.
Add and multiply can inline; small negative costs can reflect code generation
and noise. Quantize has an extra call, integral rounding a mode dispatch, and
formatting adapts native text to GDA notation. The padded-exponent native
control includes Go's extra zero. Large-fixed formatting requests native `f`
notation to match the adapter's output.

## Revisions and reproduction

- Before fork: `b163d98ee43877dc052b3f74b3805528a7d2bb71`.
- After fork: `039d51109b6b43be4530820fb31abfc0c386a891`.
- Benchmark both times: `248fc8ef2967abc51e656bda20a62c4ea8d08019`.
- Same Apple M4 Max and runner settings as the second pass. The machine witness
  is copied in [machine.json](machine.json). No PGO or special optimization
  flags are used, and the compiler code generator is unchanged.

`kernel.patch` shows this incremental source change. `kernel.bundle` requires
the second-pass fork, supplied by its bundle; the first-pass benchmark bundle
already contains the unchanged benchmark revision. Use fresh checkouts at the
revisions above, build normally with `src/make.bash`, reuse the normal shared
Go cache, and put the corresponding fork's `bin` first in PATH with
`/usr/sbin` present. Run four complete invocations per revision:

```sh
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 go run ./cmd/bench -lib all
```

Retain any clock-flagged attempt and repeat the complete invocation until four
are accepted; the summary does not select the fastest invocation.

Regenerate the archived comparison with:

```sh
node ../summarize.mjs /path/to/benchmark /path/to/adapter-output.txt --phase /absolute/path/to/go-text/phase.json
```

For the adapter input file, compile its diagnostic test binary and run the
existing probe order six times, so each native/wrapper pair stays adjacent:

```sh
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 go test -tags go_decimal_poc ./internal/decimal -c -o /path/to/scratch/adapter.test
for run in 1 2 3 4 5 6; do
    /path/to/scratch/adapter.test -test.run '^$' -test.bench '^BenchmarkAdapter(Cost|FormatCases)' -test.benchmem -test.benchtime=150ms -test.count=1
done > /path/to/adapter-output.txt
```

[Open the comparison chart](comparison.html).
