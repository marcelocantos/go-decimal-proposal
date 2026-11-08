# ARM64 compiler fast paths: zero predicates and exact addition

This local compiler milestone implements the first arithmetic paths in the
[optimization plan](../optimization-plan.md). Equality and inequality against
constant zero use integer SSA, including signed zero, different quantum and
finite noncanonical encodings. On ARM64 and AMD64, same-sign decimal128 operands
with a common quantum and uint64 coefficients add directly with carry. All
other additions reach the original runtime operation with their original
operands. Stored representations and the DPD path are unchanged.

The implementation is original Go compiler code; there is no handwritten
assembly or copied library implementation. Native ARM64 application results
below use the rebuilt compiler normally, without overlays or a tool wrapper.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,177.0 | 1,219.5 | 3.6% more time | 877.4 | 2,467.3 |
| Federal tax | 4,079.0 | 3,536.1 | 13.3% less time | 2,551.1 | 9,954.9 |
| California tax | 833.3 | 753.0 | 9.6% less time | 454.8 | 2,004.3 |
| North Carolina tax | 1,256.1 | 1,237.7 | 1.5% less time | 768.4 | 3,171.6 |
| Telco | 102.8 | 81.2 | 21.0% less time | 81.0 | Unsupported |
<!-- results:end -->

Cells are **compute nanoseconds per record; lower is better**, averaging the
original runner's best-sample estimate from four accepted complete invocations.
The before cohort is the complete final cohort of [the preceding text pass](../go-text/README.md),
not contemporaneous alternating application runs. Unchanged library controls
show the host variation between cohorts; small differences are exploratory.
Every timing attempt, output gate and clock cross-check is retained in
[measurements.json](measurements.json). No adapter allowance is subtracted.

One candidate invocation is excluded in full because the unchanged Miguel
risk benchmark's clock cross-check was 1.398 against the existing 1.25 limit.
Its output goldens passed. The complete rejected invocation is retained;
the limit and acceptance rule are unchanged.

Telco is now approximately level with Miguel in this sample, while the tax
and euro workloads still trail it. Euro's observed mean is higher than before;
the unchanged library controls also take more time in this cohort. This does
not establish either a causal euro regression or a universal speedup.

## Exactness and compiler integration

Equal stored high words establish a common sign and exponent. Requiring the
high coefficient to be zero and the encoding to be first-form establishes two
canonical finite word coefficients. Their sum is at most `2^65-2`, strictly
below the decimal128 coefficient limit, at an already representable exponent.
The compiler can therefore pack it exactly, preserving preferred quantum and
negative zero, without calling the general rounder. Other cases are untouched.
This compiler packing exception is documented in `ssagen/bid.go`; the kernel's
existing packing allowlist and rounding implementation remain unchanged.

Operands are evaluated before the guard. Only the fallback branch calls the
runtime; its memory and result join the fast branch through the normal SSA
machinery. The compiler emits integer operations directly, after ordinary
inlining, so this path does not depend on a helper fitting the inliner budget.

The zero predicates use the complete BID encoding rules. Oversized finite
coefficients denote zero, while NaNs and infinities do not. Decimal64's second
finite form can be canonical, so it has its own coefficient test. Numeric zero
recognition also handles a literal such as `0.00`; a test for all-zero storage
would miss it.

## Focused measurements and tradeoffs

Six alternating baseline/candidate repetitions of compiled native operators
give the following changes in median time:

| Probe | Time change |
|---|---:|
| Rotating fast addition inputs | 90.4% less |
| Dependent addition chain | 90.9% less |
| Mixed fast and fallback additions | 38.8% less |
| Rotating fallback additions | 3.2% more |
| Decimal128 comparison with constant zero | 71.8% less |

These are microbenchmarks, not application speedups. The rotating-input and
dependent-chain probes keep arithmetic in the loop; repeated invariant-input
probes are archived separately and do not supply the addition table. Every
reported probe allocates zero bytes. The fallback tax is retained explicitly:
the compiler must test eligibility before making the original call. Paired
fallback changes range from 0.3% to 7.5% more time. An earlier eager-boolean
guard had an 8.9% median tax; short-circuit guards reduce it and let the backend
use condition codes directly. Raw samples and calculations are in `evidence/`.

There is a code-size tradeoff. On ARM64, the isolated Add128 function grows
from 112 to 176 bytes; Zero128 grows from 80 to 128 bytes but becomes a leaf
with no stack frame. Disassembly is archived. Whole-program performance,
rather than the isolated instruction count, determines whether the change is
useful.

## Verification

The unchanged compiler passes the newly added independent tests before the
lowering is introduced. The retained candidate passes the independent math/big
addition reference, the independent zero decoder, and the existing operator
suite. Fresh long runs cover one million generated cases per operator plus
explicit encoding/carry boundaries; the independent addition sweep also covers
all 65,536 high prefixes. SSA consistency checks pass.

Permanent language tests cover operand order, loops, mixed fast/fallback
chains, named types, composite arguments/results, stack pressure, live pointers
and GC. Code-generation checks require call-free zero predicates on ARM64 and
AMD64, and direct add-with-carry plus the fallback call on ARM64. The existing
POWER instruction checks still pass. Direct compiler checks also pass for
386, ARM, RISC-V and s390x; these are compilation checks, not native hardware
verification.

The compiler/runtime/stdlib tests pass, including experiment-off checks. The
published kernel suite reports 114,915 passes, zero failures and 111,327 explicit
skips. Those vectors check the unchanged arithmetic kernel; compiled-operator
references separately cover the new compiler paths. The existing 219-row
performance/allocation ratchet passes with its unchanged limits. The fully
rebuilt toolchain passes the short decimal/stdlib suites, language/codegen checks
and native adapter tests. Logs distinguish candidate-tool experiments from the
final rebuilt toolchain.

An early codegen invocation on macOS did not exercise Linux-target assembly
checks. The recorded failing baseline and passing candidate checks use
`-all_codegen`; a separate accidentally broad invocation was interrupted and
does not count as evidence. Compiler-wrapper version mismatches are preserved
as setup failures, not passing verification.

## Adapter cost

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -0.7% | -3.5% to 0.0% |
| Mul | 0.4% | -4.2% to 5.5% |
| Quantize | 6.3% | 4.9% to 8.4% |
| Integral | 14.0% | -1.6% to 15.7% |
| Format | 10.1% | 7.7% to 19.0% |
| Format/fixed | 9.4% | 7.2% to 11.1% |
| Format/full34 | -3.4% | -7.1% to -0.2% |
| Format/largeFixed | 25.3% | 23.8% to 28.0% |
| Format/smallExponent | 25.3% | 17.6% to 27.1% |
| Format/positiveQuantum | 23.9% | 15.1% to 30.9% |
| Format/paddedExponent | 19.4% | 17.4% to 20.4% |
<!-- adapter:end -->

The six paired native/wrapper probes use identical operands and sinks. These
percentages are diagnostics, not deductions from application timings. The
existing Add adapter probe uses differing quanta and therefore measures the
fallback path in this milestone. Small negative deltas can reflect code
generation and timing variation. Native formatting still goes through the
public API; the GDA adapter's full work remains included.

## Reproduction and remaining work

- Before fork: `039d51109b6b43be4530820fb31abfc0c386a891`.
- After fork: `188fbaad1fd01dd795856c9e067611b252fcc888`.
- Before benchmark: `248fc8ef2967abc51e656bda20a62c4ea8d08019`.
- After benchmark: `8572fe39d24409ebd5955b738d4f3e7bf71c84ab`; executable source
  is unchanged from the before benchmark (intervening commits contain results).
- Same Apple M4 Max, macOS 27.2 build 26B123, 16 cores and 128 GiB RAM.
- `GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0`, with the
  rebuilt fork first in PATH and `/usr/sbin` present. No PGO or special flags
  are used for application measurements.

`compiler.bundle` requires the before fork from the preceding report's bundle;
`compiler.patch` contains this incremental change. Rebuild with `src/make.bash`
and run the unchanged `go run ./cmd/bench -lib all` four times. Retain rejected
clock-check invocations and repeat complete invocations until four pass. Run
`node ../summarize.mjs /path/to/benchmark /path/to/adapter-output.txt --phase
/absolute/path/to/phase.json` to regenerate the report data and chart.

`benchmark-results.bundle` preserves all five new invocations at result commit
`cab3e044d039804b2d77ae4a200c10c0b5151d67`; it requires benchmark revision
`8572fe39d24409ebd5955b738d4f3e7bf71c84ab` from the preceding results bundle.
An interrupted `-count=6` adapter run groups each probe's repetitions and is
diagnostic only. The adapter table uses `adapter-paired-costs.txt`, collected
by six complete invocations so each native/wrapper pair stays adjacent.

The motivating prototypes, operand census and profiling evidence are archived
under `analysis/`. They remain diagnostic evidence, not delivered speedups.
Diagnostic Go sources use a `.go.txt` suffix so ordinary proposal tests do not
try to compile them; restore `.go` when reproducing them with the decimal fork.
The reference model's semantic contract and finite corpora are the correctness
oracle; measurements do not establish performance on arbitrary workloads.

This is the zero-predicate and first exact-addition milestone. Nearby-exponent
addition, subtraction, multiplication, semantic SSA facts and further formatting
work remain in the plan. Useful Go/compiler ideas precede handwritten ARM64
assembly. Native AMD64 performance, unsupported risk/power and banking/logarithm/
compound functionality, and the separate real POWER/s390x hardware work remain
open. These changes are local and have not been pushed or deployed.
