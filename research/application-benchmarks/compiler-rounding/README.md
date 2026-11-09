# Compiler specialization of decimal rounding

The compiler now sees constant quanta and rounding modes through both generic
API layers. Concrete internal entry points lower bounded BID rounding to integer
SSA on ARM64 and AMD64, with the portable functions retained as guarded fallbacks.
The coherently rebuilt production revision is
5bfb7d29aefa175fd1afb2fc5a76b8d746964a9b. This is original compiler/Go work;
no competitor implementation was inspected and no assembly was handwritten.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 931.5 | 944.7 | 1.4% more time | 870.8 | 2,459.2 |
| Federal tax | 2,600.4 | 2,530.8 | 2.7% less time | 2,363.6 | 9,524.5 |
| California tax | 575.5 | 530.8 | 7.8% less time | 441.3 | 1,949.4 |
| North Carolina tax | 938.8 | 923.0 | 1.7% less time | 726.8 | 3,048.0 |
| Telco | 66.6 | 37.9 | 43.1% less time | 81.4 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. Four accepted complete
invocations use the unchanged runner, original goldens, workloads and timing
checks. All attempts are retained, including any whole-invocation rejection.
The older cohort is the prior bounded-kernel milestone, not simultaneous
measurements. Library controls and shared-host effects limit small differences.
Adapter overhead is included, with no estimated allowance subtracted.

[Current library comparison](relative.html) and [before/after comparison](comparison.html).

All four complete invocations passed every unchanged gate, with no exclusions.
Telco averages 37.9 ns/record versus Miguel's 81.4, using 53.4% less compute time
(2.15 times the throughput on this workload). Euro, federal tax, California and
North Carolina still take 8.5%, 7.1%, 20.3% and 27.0% more time than Miguel,
respectively. This does not establish an overall library performance lead.

## Why the constants now matter

The earlier generic wrappers called other generic functions whose size prevented
inlining. A constant mode or cent quantum could therefore disappear across a
call boundary. Small generic dispatches now call concrete typed entry points.
The compiler recognizes those calls and uses its normal SSA simplifications to
remove constant target decoding and unused mode selection. Codegen tests at the
public API enforce integer division plus the explicit fallback, rather than
relying on an inliner cost estimate.

The fast path accepts canonical first-form coefficients that fit a word. A
quantum match returns the original canonical encoding. Integral rounding also
preserves an already nonnegative quantum. Otherwise a guarded difference of
1–19 digits selects an immutable power of ten and uses exact unsigned quotient
and remainder. The remainder determines ties and directed rounding; dropping
at least one digit guarantees space for the increment. Sign and target quantum
are preserved, including signed zero. Invalid byte modes default to ties-even.
Every unproved case calls the original typed function with already evaluated
arguments. NaNs, infinities, noncanonical encodings, scaling to a finer quantum,
and full-width coefficients retain the portable path. DPD targets do not use
these intrinsics. The kernel still owns its shared general rounding algorithm;
the compiler implements a guarded equivalent for these bounded cases.

## Paired application diagnostic

Before editing production, the five supported POC application executables were
built using the original installed compiler. After executables use the coherent
new compiler. Workloads and adapters are identical. Each binary passes nine
original output checks, followed by six alternating compute pairs. The protocol
and script preserve every sample, stdout, small stderr transcripts, and verified
SHA-256s for telco's 6 MB stderr. Telco also checks the published control totals.
These fixed-process diagnostics do not replace the full runner's timing gates.

| Workload | Paired minimum-time change | Paired median-time change |
|---|---:|---:|
| euro | -2.2% | -1.6% |
| tax-fed | -0.6% | -2.9% |
| tax-ca | +0.7% | -2.6% |
| tax-nc | -0.9% | -2.3% |
| telco | -43.0% | -42.5% |

Each cell is the median of six paired percentage changes; negative is less
compute time. Telco's approximately 43% gain appears in both statistics. The
other workload shifts are small and do not establish wins on this shared host.
California's minimum statistic slightly worsens while its median improves.

## Correctness and measurement

Independent public-API reference tests exercise both widths, random raw bits,
dense bounded inputs, exponent/word/second-form boundaries, exact results, ties,
carries, signs, all modes and every invalid byte mode. Named decimal types and
source-order single evaluation are included. The same corpus passes before the
change. Fresh long runs use separate seeds before and after the coherent rebuild.
The test is part of the normal experiment-enabled internal/bid suite; public
codegen probes are part of the existing testdir suite.

Initial AMD64 checks caught unsupported boolean CondSelect lowering; the final
code selects integer increments instead and passes the architecture matrix.
The intrinsic inventory check initially rejected the new entries; its expected
table now explicitly permits exactly four entries on ARM64 and AMD64. Both
failed diagnostic logs are retained alongside the passing final gates.

The coherent rebuild passes short kernel/public API/strconv/reflect/fmt/JSON
and compiler suites, runtime decimal tests, decimal language/ABI/GC/codegen
tests, and experiment-off compiler/standard-library checks. Published vectors
pass 114,915 cases with zero failures and the unchanged 111,327 explicit skips.
The stricter 221-row allocation/performance ratchet passes with no limits changed.

Disabling intrinsics only in the tested package also passes the public rounding
references, exercising the portable route. The global all-package debug flag
segfaults both that test and an unrelated no-import println(42) control; this is
recorded separately as 🎯T8, not treated as passing evidence or attributed to a
new regression. An attempted prior-compiler control was invalidated by the
coherent rebuild's tool-version mismatch; its failed setup log is preserved.

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -1.1% | -5.4% to 2.7% |
| Mul | -5.7% | -16.0% to -2.6% |
| Quantize | 4.7% | 3.9% to 7.1% |
| Integral | 115.3% | 98.2% to 129.1% |
| Format | 8.5% | 6.1% to 11.9% |
| Format/fixed | 9.3% | 7.9% to 16.0% |
| Format/full34 | 5.6% | -0.2% to 6.9% |
| Format/largeFixed | 32.3% | 29.9% to 33.0% |
| Format/smallExponent | 22.9% | 14.6% to 31.5% |
| Format/positiveQuantum | 40.5% | 32.0% to 49.4% |
| Format/paddedExponent | 34.6% | 21.8% to 37.6% |
<!-- adapter:end -->

Adapter percentages are matching-operand measurements, not subtractions from
application time. The operation implementations and workload source are
unchanged. Quantize now inlines (compiler cost 56), so its stale exemption is
removed from the existing inline gate after measurements. Integral dispatch
still exceeds the inliner budget (cost 261 versus 80) across five public calls.
Its 115.3% extra cost is measured against the much faster native truncation;
it remains a material wrapper effect, with no allowance subtracted from the
application results. Negative Add/Mul deltas are measurement/layout variation,
not evidence that a wrapper removes arithmetic work.

## Primitive measurements

Six complete alternating before/after invocations use identical probe source,
matching operands and sinks, and 150 ms per row. The after binary is from the
coherent rebuild. All rows allocate zero. Negative changes mean less time.

| Public-API probe | Change in median time |
|---|---:|
| word/64 | -74.3% |
| word/128 | -76.6% |
| exact/64 | -69.7% |
| exact/128 | -68.0% |
| tie/64 | -74.6% |
| tie/128 | -77.3% |
| wide/64 | +5.8% |
| wide/128 | +2.7% |
| far/64 | +5.4% |
| far/128 | +5.1% |
| special/64 | -0.9% |
| special/128 | -5.8% |
| variable | -51.7% |
| wide | -5.2% |
| integralEven | -54.2% |
| integralTrunc | -53.4% |
| chain | -11.9% |

The probe called wide/64 or wide/128 scales a finite coefficient to a finer
quantum and therefore takes the fallback; Extended/wide uses a full 34-digit
coefficient. These are different cases. Retaining the fast path trades small
fallback costs (up to 5.8% here) and code size for the large bounded-path and
telco improvements. The earlier provisional rounds are also archived.

## Code size and tradeoffs

The fast path is emitted into callers, so it trades code size for removed calls.
The isolated cent-rounding functions grow from 96 to 224 bytes per width on
ARM64. Variable-mode functions grow from 96/112 bytes to 320 bytes; truncation
from 96 to 176 bytes. The five-operation integral probe grows from 240/304 to
944/1136 bytes. These are whole probe-function sizes, including stack checks
and fallback paths, not the size of one arithmetic instruction. Raw symbol
sizes and disassembly for both binaries are retained. Immutable power-of-ten
data are shared through content-addressed compiler literals.

## Reproduction and residue

phase.json pins both cohorts; machine.json records fresh host probes. The source
bundle requires 0dac3e159d06dcc9077ccb87ea3e2ba8a08e7268, the prior testdata-only
baseline refresh, whose production source is identical to 64fba7cf8b. The patch
is included for inspection. Build with src/make.bash and GOEXPERIMENT='' for
the compiler itself; use GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local
CGO_ENABLED=0 and the fork first in PATH for tests and applications.

The results bundle contains f1bbc510e8bf3e5950a8e4c69904cb27839c5caf and requires
28b644d2802b666a1a4f730d2196619821290cf6, the measured benchmark revision. It
contains the raw records and the later inline-exemption removal; all timed
operations remain unchanged. Both bundles are verified in their own repositories.
The existing summarize.mjs regenerates the cohort and adapter tables using this
report's phase.json. Diagnostic scripts and all raw attempts are in evidence/.

Performance changes remain local. Native execution is ARM64; AMD64 evidence is
code generation, not native measurements. Wider coefficient specialization,
richer SSA facts, further original Go work, ARM64 assembly and native AMD64
optimization remain open. Risk/power and banking/logarithm/compound are still
unsupported. Real POWER and s390x hardware verification are separate open work.
