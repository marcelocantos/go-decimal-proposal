# Integral dispatch and canonical formatting

Two local changes build on the previous compiler-rounding milestone. Public
integral operations now expose their semantics early enough for a five-way
adapter dispatch to inline. Canonical fixed-point formatting uses one capacity
check for the complete result when the destination has room. The coherently
rebuilt production fork is 80f1e49174e1212a4d290c02ffa3a07a2fad8487.
This is original compiler and Go work; no competing implementation was inspected
and no handwritten assembly was added.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 944.7 | 900.4 | 4.7% less time | 826.4 | 2,398.8 |
| Federal tax | 2,530.8 | 2,458.2 | 2.9% less time | 2,359.1 | 9,526.9 |
| North Carolina tax | 923.0 | 843.5 | 8.6% less time | 755.9 | 3,057.3 |
| California tax | 530.8 | 496.2 | 6.5% less time | 434.9 | 1,896.0 |
| Telco | 37.9 | 38.0 | 0.2% more time | 79.3 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four accepted complete
invocations use the unchanged runner, original workloads, dependencies, output
goldens and clock checks. All attempts are retained. The earlier cohort is not
simultaneous; shared-host and control-library changes limit small differences.
No adapter allowance is subtracted from these measurements.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

<!-- conclusion:start -->
All four complete invocations pass, with no exclusions. Euro and tax compute
time falls 2.9–8.6% versus the previous cohort; telco changes by +0.2%, effectively
flat. The contemporaneous paired results below support the direction of the tax
improvements, with smaller or noisy differences on euro and telco.

Miguel still leads euro, federal tax, California and North Carolina: the POC
takes 8.9%, 4.2%, 14.1% and 11.6% more time, respectively. Telco takes 52.2% less
time than Miguel (2.09 times the throughput). This is progress toward the
performance target, not an overall lead. Control-library changes also affect
the size of the gap: compare the archived raw cohorts before attributing its
entire movement to this patch.
<!-- conclusion:end -->

## Removing the integral dispatch barrier

The adapter's five-way RoundToIntegral dispatch previously cost 261 against an
inliner budget of 80. A trial replacing the internal width predicate with a
constant sizeof comparison only reduced the cost to 221; it was rejected and
restored. Instead, the compiler recognizes the exact public generic shapes of
Trunc, Floor, Ceil, Round and RoundToEven for decimal64 and decimal128, on ARM64
and AMD64. The inliner now charges one intrinsic per public operation, so the
adapter dispatch costs 46 and inlines. A constant mode can eliminate the unused
branches without inflating the global inline budget.

The new entry points reuse the existing bounded integer SSA lowering. Their
fallback calls the typed portable helper directly, avoiding another generic
wrapper and duplicate guards. All source arguments are evaluated first; only
the unused generic dictionary is discarded. No rounding rules or representation
change. Named decimal types share the same shapes; unrelated generic functions
cannot match the exact package/name entries. DPD targets keep the portable path.

Codegen tests require integer division plus the typed fallback through a public
five-way dispatch, with no residual dispatch call. Independent reference tests
cover all five modes, both widths, raw encodings, dense bounded inputs, ties,
zeros, exponent boundaries, full-width coefficients and special values. Added
call-form tests cover named types, global function values, generic forwarding,
defer and goroutines. These tests run in the existing enabled test suites.

The early six-pair probe showed wrapped integral rounding taking 54.0% less time;
the paired wrapper premium fell from 113.8% to -2.2%, within measurement noise.
Those compiler-only measurements are diagnostic. The table below is fresh from
the coherent full rebuild; the headline application cohort also uses that build.

## Formatting evidence and tradeoff

Fresh CPU profiles of the unchanged euro and federal workloads put String at
approximately 59% and 42% of sampled time under BestOf, respectively. These
fractions are normalized to the timed-loop samples, not the whole-process total.
The short euro profile is coarse. Diagnostic overlays only surround the original
entrypoints with runtime/pprof; they do not supply headline timings. Profiles
were collected after the dispatch change with a compiler-only build still
reporting the prior toolchain version. Overlays and raw profiles are preserved.

The canonical formatter now appends integral digits directly for a zero quantum.
For a point inside the coefficient and enough destination capacity, it extends
the destination once and copies the two digit spans around the point. Growth,
leading zeros, scientific notation and explicit precision retain their existing
paths. Existing hand-written canonical fixtures now exercise every destination
capacity boundary, plus negative and full 34-digit coefficients. All affected
strconv tests pass.

A six-pair isolated formatting trial improved the native short fixed probe 8.1%
and its adapter 5.7%. Wide coefficients improved about 2%. Two exponent adapter
probes worsened 6.2% despite unchanged fallback code; this layout/noise-sensitive
cost is preserved, not omitted. Separate unchanged application binaries isolate
this formatting change after the dispatch improvement. Each passes nine original
goldens before six alternating compute pairs:

| Workload | Median paired minimum-time change | Median paired median-time change |
|---|---:|---:|
| Euro | -1.2% | -1.3% |
| Federal tax | -1.9% | -2.3% |
| California tax | -6.7% | -6.5% |
| North Carolina tax | -6.0% | -5.3% |
| Telco | +1.2% | +1.5% |

These diagnostics support retaining the formatting change for the tax gains,
with a possible small telco regression. They do not replace the runner's gates.

## Coherent validation

The complete toolchain was rebuilt with the experiment off for the compiler
itself. Tests and applications enable GOEXPERIMENT=decimal. Fresh long independent
public rounding tests use seed 307 after the rebuild, following seed 283 before
it. Short kernel, public API, strconv, reflect, fmt, JSON and compiler suites pass,
as do decimal runtime and language/ABI/GC/codegen tests. The codegen architecture
matrix passes; native execution is ARM64 only. Experiment-off standard-library
and compiler checks pass. Public rounding tests with intrinsics disabled only
in the tested package also pass.

Published vectors pass 114,915 cases with zero failures and the unchanged
111,327 explicit skips. The stricter
221-row allocation/performance ratchet passes without changing any limits.
The unrelated global all-packages intrinsics-off crash remains recorded as 🎯T8;
that known diagnostic was not rerun or represented as passing evidence.

## Adapter costs

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -3.1% | -10.1% to 9.5% |
| Mul | -1.6% | -12.3% to 6.3% |
| Quantize | 4.1% | -2.7% to 6.0% |
| Integral | 1.3% | -12.9% to 9.2% |
| Format | 9.8% | 2.0% to 11.5% |
| Format/fixed | 13.7% | 11.6% to 33.3% |
| Format/full34 | 6.0% | -5.4% to 9.2% |
| Format/largeFixed | 31.8% | 7.0% to 38.0% |
| Format/smallExponent | 25.1% | 20.9% to 31.1% |
| Format/positiveQuantum | 40.7% | 35.1% to 43.1% |
| Format/paddedExponent | 36.7% | 30.7% to 41.4% |
<!-- adapter:end -->

These are six complete matching-operand probe invocations, 150 ms per row.
Negative premiums reflect measurement and layout effects, not work removed by
a wrapper. Application timings include the adapter in full. Formatting retains
its GDA conversion work, including the native scientific-exponent convention.
The stale integral inline exemption was removed after the cohort was measured;
the existing TestWrappersInline gate passes and now requires it to inline. This
changes enforcement, not the timed implementation. The coherent integral
premium is 1.3%, versus 115.3% in the previous cohort; the wide range includes
zero, so the residual overhead is within measurement noise.

## Code size

Inlining a variable dispatch can expand the caller even when constant modes
collapse to one branch. Summed text-symbol sizes of the five unchanged
applications move by -0.05% to +0.05% for this batch. These are whole-program
symbol totals, not a claim that each individual helper shrank. Raw totals and
the measurement script are archived.

## Paired applications and reproduction

<!-- paired:start -->
| Workload | Median paired minimum-time change | Median paired median-time change |
|---|---:|---:|
| euro | -1.7% | -2.1% |
| tax-fed | -2.9% | -2.8% |
| tax-ca | -1.3% | -6.7% |
| tax-nc | -5.4% | -4.9% |
| telco | +0.5% | +1.2% |
<!-- paired:end -->

Saved before executables use the original coherent 5bfb7d29ae toolchain; after
executables use 80f1e49174. Original operation and workload source is unchanged.
Each passes nine original output goldens, then six alternating compute pairs.
Raw samples, small stdout/stderr, telco output SHA-256 and control-total checks
are preserved. No process from this session benchmarks concurrently.

phase.json freezes both source pairs; machine.json records fresh host probes.
The compiler bundle requires 5bfb7d29aefa175fd1afb2fc5a76b8d746964a9b and contains
690cafab4e plus 80f1e49174. The results bundle requires
f1bbc510e8bf3e5950a8e4c69904cb27839c5caf, the measured benchmark source revision.
The results bundle records 0e2b03c2fbc0bfe2da6293e7ba13cccae5abf26d.
The source patch is included for review. Rebuild with src/make.bash using the
installed Go bootstrap and GOEXPERIMENT=''; then use GOEXPERIMENT=decimal,
GOWORK=off, GOTOOLCHAIN=local, CGO_ENABLED=0 and the fork first in PATH.
The existing summarize.mjs regenerates the tables and before/after chart using
phase.json; evidence/relative-chart.py regenerates the library comparison chart.

This batch remains local. More original Go/compiler work, broader SSA facts,
wider-coefficient specialization, ARM64 assembly and native AMD64 execution
remain open. Risk/power and banking/logarithm/compound remain unsupported.
Real POWER and s390x hardware verification are separate open work. 🎯T6 is
not achieved by this milestone.
