# Exact decimal128 multiplication and aligned addition in the compiler

This local milestone extends the integer SSA paths to multiplication and to
addition/subtraction of nearby-exponent word coefficients. The original
runtime handles all cases outside the proved exact bounds. The native ARM64
applications use the rebuilt compiler normally, without a tool wrapper.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,219.5 | 1,149.9 | 5.7% less time | 845.8 | 2,442.2 |
| Federal tax | 3,536.1 | 2,842.2 | 19.6% less time | 2,495.7 | 9,964.2 |
| California tax | 753.0 | 617.1 | 18.1% less time | 445.0 | 1,920.8 |
| North Carolina tax | 1,237.7 | 1,070.7 | 13.5% less time | 766.0 | 3,110.1 |
| Telco | 81.2 | 71.1 | 12.4% less time | 81.2 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. The table averages
the original runner's best-sample figure from four accepted complete
invocations. The baseline is the preceding compiler cohort, not a
contemporaneous alternating application run. Every attempted invocation is
retained, including clock-check rejections. No adapter allowance is subtracted.

All four new invocations passed every required golden-output and clock check;
none was excluded. The preceding baseline includes its previously documented
rejected invocation, retained as evidence. Library controls and shared-host
variation still limit causal precision, particularly for the smaller euro gain.

In this cohort telco takes 12.4% less compute time than Miguel. The POC still
takes 13.9% more time for federal tax, 35.9% more for euro conversion, 38.7%
more for California and 39.8% more for North Carolina. This is progress on the
supported workloads, not a claim to lead every library or metric.

## Exactness

Multiplication requires canonical finite uint64 coefficients, a full product
no larger than `10^34-1`, and an exponent sum in range. The resulting integer
product and preferred exponent are exact. Sign is XOR, including signed zero.
All other cases use the original operation.

Addition and subtraction retain the first same-sign/same-quantum path. For
different signs or quanta, two uint64 coefficients separated by at most 14
decimal places have a sum bounded by `(2^64-1)*(10^14+1) < 10^34`. Alignment,
addition and magnitude subtraction therefore lose no digits. The smaller
exponent is the preferred quantum; cancellation produces positive zero, while
same-sign zeros preserve their sign. Subtraction changes the effective sign
only inside the fast path, preserving original NaN operands for the fallback.

The compiler emits generic integer SSA, including multiply-high, carry and
borrow. It uses content-addressed immutable literal data for powers of ten.
The gap guard proves the load is in bounds. No handwritten assembly or other
library's implementation is used. Stored BID-XOR/DPD-XOR representations and
the POWER hardware lowering are unchanged.

## Primitive measurements

Six complete alternating invocations compare each stage with its predecessor.
The exact raw samples are in `evidence/`; these are diagnostics rather than
application speedups. General fallbacks include the cost of eligibility guards.

| Probe | Change in median time |
|---|---:|
| Exact multiplication hits | 75.5% less |
| Mixed multiplication inputs | 25.2% less |
| Multiplication fallbacks | 4.5% more |
| Existing same-sign/same-quantum addition hits | 0.1% less |
| Nearby-exponent addition | 75.5% less |
| Mixed addition inputs | 68.1% less |
| General addition fallbacks | 4.4% more |
| Same-quantum subtraction | 63.8% less |
| Nearby-exponent subtraction | 73.9% less |
| General subtraction fallbacks | 6.2% more |

All these probes allocate zero bytes. Multiplication compares the first
compiler milestone with commit `007a113fbb`; addition/subtraction compares that
commit with `2d026e3077`, using identical test source within each pair. These
experiments use candidate compiler binaries through a tool wrapper; the full
applications below use the normally installed rebuilt toolchain.

The older `Add128/miss` fixture now includes fast hits, so it is not labelled
as a fallback measurement. The new `general` fixture has wide coefficients
or large exponent gaps. All raw fixtures and results remain available. The
six paired general-subtraction changes range from 2.7% less to 17.9% more
time; the median-of-medians table should not imply noise-free precision.

An earlier multiplication guard evaluated both coefficient-bound tests
eagerly. In a separate direct six-pair comparison, short-circuiting the common
high-word case takes 16.7% less time for hits, 1.1% more for fallbacks, and
essentially unchanged time for mixed inputs. Both trials are retained; the
decision uses the direct comparison rather than unrelated baseline cohorts.

Generated code is larger: the isolated ARM64 `Add128` function grows from
176 to 416 bytes; `Sub128` is 432 bytes and `Mul128` is 288 bytes. Disassembly
is archived. The complete application results above include this tradeoff.

## Verification

The unchanged compiler passes the new independent references before each
stage. The retained candidates pass exact result-bit comparisons against the
independent math/big model, including all 65,536 high prefixes, coefficient
boundaries, signs, zeros, NaNs and exponent limits. The aligned test sweeps
every representable quantum at gaps 0, 1, 14 and 15, and samples fresh word
coefficients at gaps through 16. Fresh long runs exercise one million cases
per generated operator stream, alongside SSA consistency checks.

The rebuilt toolchain passes the long compiled-operator suite, the affected
short arithmetic/stdlib/compiler suites, decimal runtime tests, and the
experiment-off reflect/fmt/JSON/compiler suites. Permanent language tests
exercise argument order, loops, named types, composite arguments and results,
live pointers, GC, cancellation and mixtures of direct and fallback paths.
Codegen checks run with `-all_codegen`, so ARM64, AMD64 and POWER assertions
are actually inspected on this macOS host. They are compilation evidence,
not native AMD64 or POWER execution.

The arithmetic kernel is unchanged in this milestone. Its previously archived
114,915-pass published-vector result remains kernel evidence; it does not
stand in for the independent compiled-operator references above.

The existing 219-row performance/allocation ratchet also passes, with its
unchanged 20% band and 0.5 ns allowance. No baseline was loosened or replaced.

## Adapter cost

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | -0.8% | -2.7% to 1.5% |
| Mul | 7.8% | -1.4% to 10.6% |
| Quantize | 8.4% | 5.7% to 9.9% |
| Integral | 16.3% | 15.9% to 18.9% |
| Format | 9.3% | 8.3% to 11.4% |
| Format/fixed | 8.7% | 6.4% to 10.4% |
| Format/full34 | -1.5% | -3.0% to 0.5% |
| Format/largeFixed | 26.2% | 20.6% to 31.6% |
| Format/smallExponent | 25.1% | 13.9% to 28.6% |
| Format/positiveQuantum | 23.2% | 22.4% to 26.1% |
| Format/paddedExponent | 18.1% | 16.0% to 58.3% |
<!-- adapter:end -->

Each percentage comes from six complete paired native/adapter benchmark
invocations with identical operands and sinks. They are diagnostics, not
deductions from the application times. Small signed differences can reflect
code placement and timing variation; invariant-input probes also do not
replace the rotating-input operator measurements. The application adapter
continues to use public APIs and includes all GDA-format conversion work.

## Reproduction and remaining work

- Before fork: `188fbaad1fd01dd795856c9e067611b252fcc888`.
- After fork: `2d026e30771dcbf769e908298fd6bcc98ec91252`.
- Intermediate multiplication commit: `007a113fbbe429d54cf716ef80e484bbb041ab07`.
- Before benchmark: `8572fe39d24409ebd5955b738d4f3e7bf71c84ab`.
- After benchmark: `cab3e044d039804b2d77ae4a200c10c0b5151d67`.
- Benchmark executable source is unchanged from `248fc8ef2967abc51e656bda20a62c4ea8d08019`.
- Apple M4 Max, macOS 27.2 build 26B123, 16 cores, 128 GiB RAM.
- `GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0` with
  the rebuilt fork first in PATH and `/usr/sbin` present. No PGO or special
  application compiler flags.

The source bundle requires the before fork. Rebuild with `src/make.bash`, then
run `go run ./cmd/bench -lib all` until four complete invocations pass the
unchanged output and clock gates. Retain every rejected attempt. Run
`node ../summarize.mjs /path/to/benchmark /path/to/adapter-output.txt --phase
/absolute/path/to/phase.json` to regenerate the results and chart.

`benchmark-results.bundle` preserves the four new runs at result commit
`78a07018bee81099dd0f7badf13dbae6e37e6cdc` and requires benchmark commit
`cab3e044d039804b2d77ae4a200c10c0b5151d67`. The result commit changes no
executable source. Candidate compiler probes use `evidence/toolwrap.go.txt`
(restore the `.go` suffix to build it) and the source revisions specified in
the primitive section. The initial multiplication guard is preserved in
`evidence/mul-initial.patch`; logs distinguish it from the retained guard.

The work remains local. Simple division, quantization, retained semantic SSA
facts and further formatting work remain in the plan, ahead of handwritten
ARM64 assembly and native AMD64 measurement. Risk and banking functionality,
and separate real POWER/s390x hardware verification, remain open.
