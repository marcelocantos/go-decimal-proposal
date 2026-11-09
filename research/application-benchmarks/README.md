# Application benchmarks: first ARM64 Go optimization pass

This measures the decimal proof of concept through
[Miguel's application benchmark framework](https://github.com/migueldecimal128/go-decimal128-app-benchmark)
on one Apple M4 Max. The POC remains experimental. These results describe the
implemented workloads, rather than general decimal performance or IEEE conformance.

The before/after comparison includes both original kernel/standard-library
optimizations and a less costly benchmark adapter. It does not attribute the
whole improvement to the kernel. The current library comparisons include the
remaining adapter cost, without subtracting an estimated allowance.

<!-- results:start -->
| Workload | POC before | POC after | Less compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 2,201.0 | 1,369.0 | 37.8% | 872.9 | 2,491.7 |
| Federal tax | 6,917.2 | 4,367.9 | 36.9% | 2,582.1 | 9,848.5 |
| California tax | 1,550.6 | 865.3 | 44.2% | 436.0 | 1,892.7 |
| North Carolina tax | 2,619.3 | 1,300.5 | 50.3% | 738.0 | 3,166.7 |
| Telco | 183.7 | 115.5 | 37.1% | 81.4 | Unsupported |
<!-- results:end -->

The table uses **compute nanoseconds per record; lower is better**. Each cell
averages the runner's best-sample estimate from two complete invocations.
Individual invocation values, sample quantiles, whole-process times and all
correctness records are retained in [measurements.json](measurements.json).
This was a shared machine under ordinary concurrent load; treat small differences
as exploratory. Two invocations do not establish a population confidence interval.

Risk management remains unsupported by the POC because it needs power. Banking
needs logarithm and compound interest. bid754 also lacks those operations and
the directed quantize that telco requires. They are explicit unsupported rows,
rather than missing or successful measurements.

## Revisions and protocol

- Original benchmark: `9986cf26cf26c47bf8e17dbf57114bc37f8d51a9`.
- Before: benchmark `6cc51751f01c92a3baf6edd7ba99b5040abdf10a`, fork
  `903d630330f7c9720783a8a48a44eb16323c7174`.
- After: benchmark `66320dac923596dfff313e982e6d49c64662d0dd`, fork
  `545bd7a4bea66888a9150936847114bc2bd71c34`.
- CPU: Apple M4 Max, 16 cores, 128 GiB RAM. macOS 27.2, build 26B123.
  [machine.json](machine.json) records the independent system probes. Raw runner
  CPU fields say `unknown` because the measurement PATH omitted `/usr/sbin`;
  those records are retained unchanged.
- Both toolchains are this fork's Go 1.28 development compiler; the after
  toolchain was rebuilt from its clean source revision. No compiler code-generation
  changes occur between the two fork revisions.
  Its stock bootstrap was Go 1.27.3 on darwin/arm64.
- Miguel dependency: `v0.0.0-20261106175456-073024a3ff99`; bid754-go: `v0.2.0`.
- `GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0`; no PGO or
  special compiler optimization flags.
- Runner defaults: nine whole runs per supported row, each checked against
  the original golden; interleaved libraries; three compute processes per row;
  adaptive batches of at least 100 microseconds and about 200 milliseconds of
  compute samples per process; clock cross-checks retained.
- Telco keeps the original million-call SHA-256 golden and published control
  totals. Its timed loop includes input decoding and formatting each output line.
- Workload source, input data, goldens, `go.mod` and `go.sum` are unchanged from
  the original benchmark. The additional telco `_test.go` is diagnostic only
  and is absent from application binaries.

The adapter uses a defined type over builtin `decimal128`, direct operators,
and public native decimal APIs. It has no interface dispatch or alternate
arithmetic engine. External libraries remain module dependencies; no library
implementation was copied into the fork or this report.

[Open the comparison chart](comparison.html). Its source data and generator
are included here; all timing attempts remain available for inspection.

## What changed

The native Go changes keep bounded exact coefficients on a short path inside
the common rounding routine, use native division for one-word dividends, avoid
a temporary allocation when producing canonical strings, reuse fixed-point text
that already matches the requested notation, and inline decimal128 packing.
Conversion from a 64-bit integer to decimal128 now encodes directly because
every such magnitude has at most 20 digits and fits exactly in 34 digits.
The proof is documented with the other exact packing exceptions and tested
against the independent reference model. There is no handwritten assembly.

The adapter's GDA string conversion now edits a native formatting buffer before
allocating its result. It removes exponent padding and relocates the decimal
point when GDA requires fixed notation. This avoids a second formatting pass
for large fixed-point values and a second allocation for padded exponents.
Boundary cases and 3,332 signed coefficient/exponent cohorts are checked against
the earlier arithmetic-based adapter.

## Adapter cost

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -1.2% | -4.2% to 10.4% |
| Mul | -0.8% | -2.2% to -0.2% |
| Quantize | 6.2% | 1.3% to 9.6% |
| Integral | 13.4% | 1.9% to 15.2% |
| Format | 9.4% | 5.0% to 13.4% |
| Format/fixed | 9.1% | 5.6% to 14.8% |
| Format/full34 | 4.9% | 2.0% to 46.2% |
| Format/largeFixed | 13.3% | -11.5% to 30.6% |
| Format/smallExponent | 17.2% | 7.3% to 25.3% |
| Format/positiveQuantum | 14.5% | -42.9% to 21.0% |
| Format/paddedExponent | 14.8% | 9.5% to 17.9% |
<!-- adapter:end -->

[adapter-costs.json](adapter-costs.json) retains six adjacent direct/adapter
pairs per probe and the median of their percentage ratios. Add and multiply wrappers inline; their small differences can
reflect register allocation and measurement noise. Quantize includes an extra
call. Integral rounding includes a mode dispatch. Formatting includes the GDA
notation adaptation; the padded-exponent native control has Go's extra zero,
and the large-fixed control explicitly requests native `f` notation so its
output matches the adapter's. These are per-input costs, not percentages to
subtract from whole-application timings.

Integer-conversion primitive probes approach the benchmark loop floor after
optimization. Their apparent percentage reduction is not an application
speedup and is excluded from the headline table.

## Correctness evidence and limits

The rebuilt after toolchain passes short `internal/bid`, `math/decimal`,
`strconv` and `reflect` suites, the decimal runtime tests and all eleven decimal
language test programs, including composite ABI, constants, encoding, quantum,
NaN, map and zero behavior. Fresh million-case checks per selected operation
and width compare against the existing independent exact reference model.
The published-vector runner reports 114,915 passes, zero failures and 111,327
explicit skips. Those skips retain the same accounting as the published suite;
arithmetic status flags are not checked where the operation returns no status.
This is not a claim of full IEEE conformance.

All accepted application rows pass all nine original output gates in each
invocation and pass the framework's compute clock cross-check. The summary
script rejects failed rows, missing repeated invocations or changed coverage.
One complete after invocation is retained but excluded from the comparison
because Miguel's California-tax clock ratio was 1.266, above the runner's 1.25
limit. Its correctness gates passed. A third complete invocation supplied the
second accepted repetition; all attempts and the rejection are archived.

This is the first Go pass. Remaining losses, additional Go opportunities,
ARM64 assembly experiments and native AMD64 measurements remain open.
A [second Go pass](go-phase2/README.md) holds the adapter fixed and preserves
its own measurements separately from this frozen first-pass comparison.
The subsequent [text-conversion pass](go-text/README.md) includes native text
changes and refreshed percentage measurements of adapter cost.
The [first compiler pass](compiler-fast-paths/README.md) adds direct zero
predicates and exact word addition, with four accepted full application runs,
independent compiled-operator references and the remaining fallback cost.
The [exact arithmetic compiler pass](compiler-arithmetic/README.md) extends
that work to multiplication and nearby-exponent addition/subtraction, with
four further correctness-gated native runs and refreshed adapter costs.
The [division and formatting pass](go-division-text/README.md) adds exact
power-of-ten division and shared coefficient digits, with four accepted
application runs and fresh adapter costs.
The [comparison pass](comparison-fast-paths/README.md) adds compiled ordered-zero
predicates and exact word comparisons, retaining four accepted application runs,
two timing rejections and measured fallback costs. All performance changes remain local.
The [bounded quantization pass](quantization/README.md) reduces repeated rounding
checks, with paired kernel gains, mixed application results and an explicitly
reported possible small California-tax regression.
The [compiler rounding pass](compiler-rounding/README.md) exposes constant quanta
and modes to guarded integer lowering. Four accepted application runs and six
alternating POC pairs establish a large telco gain; euro and tax workloads still
trail Miguel. Fallback costs, code size and remaining wrapper costs are explicit.
The [integral dispatch and formatting pass](integral-dispatch/README.md) removes
the five-way integral wrapper's inline barrier and streamlines canonical fixed
formatting. Four accepted runs improve euro/tax cohort times 2.9–8.6%; telco is
flat. Integral wrapper overhead is within noise. Miguel still leads euro and
taxes by 4.2–14.1%; the POC retains about 2.09 times its telco throughput.
The [compiler and arithmetic optimization plan](optimization-plan.md) sets out
the next stages, their correctness and measurement gates, and model selection.
All later raw runner records, including exploratory attempts, are also archived
in `benchmark-results.bundle` at benchmark commit `8572fe3`; it requires the
first-pass benchmark revision `248fc8e` and changes only recorded results.
The Windows desktop is reachable and has an AMD Ryzen 9 3900X (12 cores,
24 threads); it has neither Go on PATH nor WSL. No software was installed or
benchmark executed there during this pass.
Real POWER hardware verification and s390x hardware work are also open.

## Reproduction

The bundles preserve the exact local commits without requiring publication of
an unfinished performance branch. [kernel.patch](kernel.patch) provides a
reviewable cumulative diff. `kernel.bundle` requires the public fork commit
`903d630330`; `benchmark.bundle` requires the original benchmark commit
`9986cf2`. Fetch into fresh clones:

```sh
git -C /path/to/go-fork fetch /absolute/path/to/kernel.bundle refs/heads/perf/decimal-go-arm64
git -C /path/to/benchmark fetch /absolute/path/to/benchmark.bundle refs/heads/builtin-decimal-benchmark
```

Use separate fresh checkouts for before and after, at the revisions above, so
switching revisions cannot overwrite locally collected results. Build each
fork with its normal `src/make.bash` using an installed stock Go bootstrap,
then put that fork's `bin` first on `PATH`. Reuse the normal Go build cache.
From the corresponding benchmark checkout run the following command twice:

```sh
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 go run ./cmd/bench -lib all
```

The after adapter probes run with:

```sh
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 go test -tags go_decimal_poc ./internal/decimal -run '^$' -bench '^BenchmarkAdapter(Cost|FormatCases)' -benchmem -benchtime=150ms -count=6
```

The original runner writes its raw records and report in `results/`.
`summarize.mjs` regenerates this report's archived comparison from the frozen
measurement revisions. Deliberately update its revision selection to establish
a new baseline; it does not select the fastest invocation from later work.

```sh
node summarize.mjs /path/to/benchmark /path/to/adapter-benchmark-output.txt
```
