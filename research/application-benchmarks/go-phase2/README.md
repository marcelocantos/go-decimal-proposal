# Application benchmarks: second ARM64 Go pass

This compares another native Go optimization pass on the Apple M4 Max. The
benchmark adapter, application source, inputs, goldens and library dependencies
are identical before and after. The POC remains experimental; this measures
the supported workloads rather than general decimal performance.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,290.0 | 1,377.3 | 6.8% more time | 885.8 | 2,500.7 |
| Federal tax | 4,242.1 | 4,245.7 | 0.1% more time | 2,566.1 | 10,148.2 |
| California tax | 876.0 | 884.9 | 1.0% more time | 460.9 | 2,018.0 |
| North Carolina tax | 1,272.7 | 1,323.6 | 4.0% more time | 787.1 | 3,212.5 |
| Telco | 113.2 | 104.2 | 8.0% less time | 81.5 | Unsupported |
<!-- results:end -->

The table uses **compute nanoseconds per record; lower is better**. Cells
average the runner's best-sample estimate from four complete accepted invocations.
[measurements.json](measurements.json) retains every selected timing attempt,
including any clock-check rejection, output gates, quantiles and process times.
This is a shared machine; small differences are exploratory, and four invocations
do not establish a population confidence interval.

The retained absolute measurements are mixed: telco takes about 8% less time;
the other means range from approximately unchanged to 7% more time. The
unchanged libraries also shift between the before/after groups. This does not
establish a broad application speedup or isolate host variation from code
effects. Further profiling and controlled experiments remain necessary.

The POC's risk/power and banking/logarithm/compound workloads remain unsupported.
bid754 also lacks those operations and telco's directed quantize. Unsupported
rows remain in the evidence. Native AMD64, real POWER and s390x hardware work
remain open.

## What changed

These changes use original Go code, without handwritten assembly:

- Decimal128 digit shifts use the existing uint64 primitive when the coefficient
  fits one word, including 20-digit values that exceed decimal64 precision.
- Decimal128 decoding checks the canonical finite form first. Quantum operations
  decode only kind and exponent when sign and coefficient are unused.
- A product of two one-word factors uses one exact wide multiply. The full
  128-by-128 product accumulates cross terms in two carry chains, allowing the
  ARM64 compiler to use carry instructions without duplicate additions.

The [first pass](../README.md) includes adapter improvements. This pass holds
that adapter fixed, so its before/after deltas measure the Go changes. The
library comparison still includes the adapter's cost without subtracting an
estimate. The earlier [paired adapter probes](../adapter-costs.json) document
its input-specific percentage overhead; they are not a correction to these
application figures. External libraries remain dependencies. Their
implementation code was not copied.

## Revisions and protocol

- Benchmark before and after: `248fc8ef2967abc51e656bda20a62c4ea8d08019`;
  its executable source is unchanged from `66320dac923596dfff313e982e6d49c64662d0dd`.
- Fork before: `545bd7a4bea66888a9150936847114bc2bd71c34`.
- Fork after: `b163d98ee43877dc052b3f74b3805528a7d2bb71`.
- Apple M4 Max, 16 cores, 128 GiB, macOS 27.2 (26B123).
  [machine.json](machine.json) records the system probes. The runner's PATH
  includes `/usr/sbin`, so its CPU metadata identifies this machine.
- Both fork toolchains are built from clean source with the normal
  `src/make.bash` and stock Go 1.27.3 bootstrap. This pass changes no compiler
  code generation. Additional alternating runs hold the rebuilt compiler
  binary fixed while switching the clean standard-library source revision.
  No PGO or special optimization flags are used.
- `GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0`.
- Miguel: `v0.0.0-20261106175456-073024a3ff99`; bid754-go: `v0.2.0`.
- Unchanged runner defaults: nine golden-gated whole runs per supported row,
  interleaved libraries, three compute processes per row, adaptive batches
  lasting at least 100 microseconds, and about 200 milliseconds of compute
  samples per process. Clock cross-checks remain enabled.
- Telco uses the original million-call input, SHA-256 golden and control totals.
  Its timed workload includes input decoding and output formatting.

## Correctness and focused measurements

The complete encoding-prefix sweep also checks the partial decoder through
public Quantum and SameQuantum operations. The existing math/big tests cover
all wide-multiply edge pairs, including full uint64 factors and wide carries.
Fresh fuzzing and million-case exact-reference checks supplement those standing
tests. The rebuilt toolchain passes short internal/bid, math/decimal, strconv
and reflect suites, decimal runtime checks, all eleven decimal language
programs, and experiment-off internal/bid and strconv tests. Wide-multiply
fuzzing completed 3,742,471 executions without failure. Fresh million-case
checks per selected operation and width use independent exact-reference models
(seeds 73, 79 and 83). The published runner reports 114,915 passes, zero failures
and 111,327 explicit skips. Those skips retain their existing reasons and
counts; this does not claim full IEEE conformance.

The initial two application invocations per revision gave mixed results, and
the unchanged libraries also shifted between those runs. Additional invocations
alternate the clean source revisions under the same compiler to investigate
host variation. The summary requires four accepted invocations per revision;
the first pair is retained, rather than replaced with later timings. A baseline
banking control and an after federal-tax control failed the runner's clock
cross-check, while passing their output gates. Those entire invocations are
archived and excluded, and the next alternating pair supplies replacements.

The interleaved primitive comparisons are diagnostic evidence, separate from
the application table. The first multiply-only trial regressed an exact-division
probe; the retained carry-chain revision removes that measured regression.
Raw samples and summaries are included under `evidence/`.

Fresh diagnostic profiles of euro conversion and federal tax retain both
unfiltered and timed-workload stack views. They point to formatting work,
including `strconv.(*finite).scan`, as a useful next Go opportunity. Division
is present in euro, but these profiles do not support calling it the dominant
cost. The profile entry wrapper changes no workload function, and its original
gated transcript is checked; the long profile runs are excluded from the table.
The [text-conversion follow-up](../go-text/README.md) records the resulting
formatter and parser work separately, with fresh full application runs.

## Reproduction

The adjacent first-pass report explains the upstream benchmark and build setup.
This phase's `kernel.bundle` contains commits after the first-pass fork;
`kernel.patch` shows that incremental diff. The first-pass `benchmark.bundle`
already contains the unchanged benchmark revision. Fetch these into fresh
clones and use separate checkouts for before and after, reusing the normal Go
build cache.

From the benchmark checkout, with the corresponding fork's `bin` first in PATH
and `/usr/sbin` present, run four complete invocations per revision, including
alternating the revisions for the final two repetitions:

```sh
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 go run ./cmd/bench -lib all
```

Regenerate this phase without changing the frozen first-pass comparison:

```sh
node ../summarize.mjs /path/to/benchmark --phase /absolute/path/to/go-phase2/phase.json
```

[Open the comparison chart](comparison.html).
