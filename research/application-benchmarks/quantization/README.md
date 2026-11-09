# Bounded rounding for quantization

This local ARM64 milestone lets quantization and integral rounding use the
coefficient bounds they have already established. The shared rounding helper
removes repeated wide-value checks while preserving the existing digit
classification and rounding-mode decision. The installed toolchain is rebuilt
from clean fork 64fba7cf8b4a96d94056851d52fe316b7129316f. This is original Go
code; there is no handwritten assembly or competitor implementation.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 903.5 | 931.5 | 3.1% more time | 860.0 | 2,496.6 |
| Federal tax | 2,483.8 | 2,600.4 | 4.7% more time | 2,538.7 | 10,054.9 |
| California tax | 527.7 | 575.5 | 9.1% more time | 438.8 | 1,985.4 |
| North Carolina tax | 899.8 | 938.8 | 4.3% more time | 753.1 | 3,259.4 |
| Telco | 65.9 | 66.6 | 1.0% more time | 82.5 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. The table averages
the unchanged runner's best-sample figure from four accepted complete
invocations. The baseline is the previous comparison cohort, not concurrent
alternating before/after application runs. Every attempt is archived; a failed
clock or output gate excludes the entire invocation. No adapter allowance is
subtracted. Library controls and shared-host variation limit causal precision,
especially for small movements.

Five complete application attempts are retained: four accepted and one excluded
in full because Miguel's California-tax clock cross-check exceeded the unchanged
limit. Every output gate passed. This cohort does **not** demonstrate an
application speedup: POC means are 1.0–9.1% higher than in the previous cohort.
Library controls also moved; the POC remains 8.3% slower than Miguel on euro,
2.4% on federal tax, 31.2% on California and 24.7% on North Carolina, and uses
19.3% less compute time on telco. These are exploratory shared-host comparisons.

California's 9.1% before/after increase warranted a separate contemporaneous
check. The original tax-ca workload and adapter were compiled twice under the
same installed compiler, with an overlay restoring only the prior kernel
sources for the control. Nine original whole-output goldens pass per binary.
Six alternating compute pairs use the unchanged harness with 1000 samples and
400 passes/sample, preserving the original output golden plus its normal sink
postlude on every run. The median paired difference is +1.4% for both minimum
and per-process median time; minimum-time pair deltas range from -2.4% to +6.0%.
This is much smaller than the older-cohort difference, but a small regression
remains possible. It is not an application win or a replacement for the full
cohort. All sources, fixed settings, samples and gates are archived in
[evidence/ca-paired](evidence/ca-paired/). The improvement established by this
batch is in the paired kernel probes; overall application performance remains
mixed and unresolved at this scale.

## Mechanism and proof

Quantize decodes a canonical coefficient and an in-range target exponent. If
it must increase the coefficient, its existing scale and maximum-coefficient
checks establish that the result fits. RoundToIntegral likewise starts with a
canonical coefficient, and its exponent floor is zero. Both can therefore call
the bounded helper directly instead of reconstructing a wide value and proving
these same bounds again in the general rounder.

The helper preserves the exponent when it is already at or above the floor.
Otherwise it uses the existing exact digit shift and discarded-part class,
then the existing roundUp decision. Dropping at least one digit from a canonical
coefficient leaves room for an increment without exceeding the format's
precision. The result exponent is the floor, so no overflow or fold-down is
possible. Zero retains its sign and the operation's required quantum. NaNs,
infinities and quantization scaling overflow retain their existing dispatch.

The general rounder shares this same helper for its bounded right-shift case.
It derives Inexact and Underflow from the returned discarded class and original
magnitude, preserving conversion status. The shift count is clamped before
subtraction, so arbitrary negative int exponents cannot overflow. The central
rounding documentation and source-enforced packer allowlist now explicitly
include this helper. No second rounding-mode decision or public API is added.

## Primitive evidence and costs

A fresh profile of the unchanged mixed quantization/integral probes identified
work in round64/round128 and the repeated bound checks. The profile includes
binary-float controls and harness work; its percentages are diagnostic and do
not estimate application CPU shares.

Six complete alternating before/after binary invocations use the same installed
compiler and identical test source. Mixed quantization uses 5.8% less time for
decimal64 and 10.8% less for decimal128. Integral rounding uses 10.1% and 18.1%
less, respectively, with a -0.9% float control. Decimal128 fixed cases improve
10.0–22.7%; decimal64 cases vary from 10.8% less to 0.6% more time. The explicit
NaN decimal64 probe costs 9.6% more (paired median 7.2%), while its decimal128
counterpart improves 3.3%. The special-value dispatch is unchanged in source;
the exact code-layout mechanism for that cost is unresolved, so it is reported
rather than attributed to a proven cause.

General Round exact, inexact and subnormal probes remain within about 2% of the
baseline, except decimal64 wide which improves 5.3%. All 27 probes allocate
zero. These are isolated loop measurements, not application speedups.

## Correctness and validation

The new independent boundary corpus passes against both baseline and candidate:
coefficient powers and neighboring values, exponent limits, scaling overflow,
ties and carries, both signs, all five modes and invalid-mode default behavior.
Fresh million-case references per operation and width pass for Quantize,
RoundToIntegral and general Round, including conversion status. The affected
short suites and source-generation/packer invariants pass.

Published vectors report 114,915 passes, zero failures and 111,327 explicit
unsupported/skipped cases, with no corpus or acceptance-limit changes. Fresh
10-second raw-encoding fuzz runs pass 4,934,341 decimal64 and 4,612,337 decimal128
executions against the independent references. The original 221-row performance
gate passed, with 45 faster-than-band rows prompting a deliberate baseline
refresh. Eight complete new invocations retain every old and new sample, all
221 row names, the 20% band and 0.5 ns absolute slack. Minimum-based enforcement
therefore tightens 172 limits and leaves 49 unchanged; none becomes looser.
All samples allocate zero. The full refreshed ratchet, row-shape check and API
coverage check pass. Protocol, raw samples, per-row limit proof and gate output
are in [evidence/baseline-refresh](evidence/baseline-refresh/).

The coherent rebuilt toolchain passes internal/bid, math/decimal, strconv,
reflect, fmt and encoding/json; the decimal runtime suite and language/codegen
suite; and experiment-off compiler/ordinary standard-library checks. Native
execution is ARM64. AMD64 code generation is checked, not native AMD64 execution.

## Adapter costs

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 0.2% | -6.4% to 3.5% |
| Mul | 2.6% | -4.9% to 13.8% |
| Quantize | 9.2% | 6.3% to 11.2% |
| Integral | 19.9% | 15.9% to 23.1% |
| Format | 9.9% | 6.8% to 14.9% |
| Format/fixed | 9.9% | 7.7% to 30.6% |
| Format/full34 | 5.9% | 3.3% to 6.6% |
| Format/largeFixed | 30.5% | 29.4% to 32.5% |
| Format/smallExponent | 22.0% | 13.4% to 24.6% |
| Format/positiveQuantum | 35.8% | 28.8% to 48.7% |
| Format/paddedExponent | 30.2% | 26.0% to 38.5% |
<!-- adapter:end -->

Six complete native/adapter invocations use matching operands and sinks.
Percentages are paired costs, not allowances subtracted from application time.
The benchmark adapter and executable workload source are unchanged.

## Reproduction and residue

Exact fork and benchmark revisions are in phase.json; system probes are in
machine.json. The compiler bundle requires a7505624ec71d0bdbc89e4f55652f904bea3801f,
and its cumulative patch is included. Its head is
0dac3e159d06dcc9077ccb87ea3e2ba8a08e7268, whose only change after the measured
production revision 64fba7cf8b is the performance-baseline testdata. Application
and adapter measurements remain pinned to that unchanged production source. Rebuild with src/make.bash, using
GOEXPERIMENT='' for the compiler build itself. Put that fork first in PATH,
including /usr/sbin. Run with GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local
CGO_ENABLED=0. Execute `go run ./cmd/bench -lib all` until four complete invocations
pass every unchanged gate, preserving every rejection.

Benchmark executable source remains unchanged from
248fc8ef2967abc51e656bda20a62c4ea8d08019. The report is regenerated with
`node ../summarize.mjs /path/to/benchmark /path/to/adapter-costs.txt --phase
/absolute/path/to/phase.json`. The results bundle contains 28b644d2802b666a1a4f730d2196619821290cf6 and
requires 984d63bbacfbed3dab8b0a3af285d9f1a6d87b00. Both bundles are verified in
their matching repositories and preserve the local revisions without publishing
this unfinished performance branch.

Retaining the helper is an explicit local tradeoff: the paired kernel gains
are established, while the decimal64 NaN probe is slower and an application
regression of roughly 1–2% remains plausible. Future application measurements
must test this uncertainty rather than assume the kernel gains transfer.

This work is local. Compiler specialization for constant quantum and mode,
richer SSA facts, further useful Go work, ARM64 assembly and native AMD64 remain
open. Risk/power and banking/logarithm/compound are unsupported. Real POWER and
s390x hardware verification are separate open work.
