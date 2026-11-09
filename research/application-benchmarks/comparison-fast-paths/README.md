# Compiled zero comparisons and exact word comparisons

This local ARM64 milestone compiles ordered comparisons against known zero
into integer operations and speeds up general comparisons whose coefficients
fit a word. The source, installed compiler and standard library are rebuilt
together at a7505624ec71d0bdbc89e4f55652f904bea3801f. All changes are original
Go/compiler code; no handwritten assembly or competing implementation is used.

<!-- results:start -->
| Workload | POC before | POC after | Compute time | Miguel after | bid754 after |
|---|---:|---:|---:|---:|---:|
| Euro conversion | 1,009.3 | 903.5 | 10.5% less time | 799.9 | 2,266.5 |
| California tax | 580.7 | 527.7 | 9.1% less time | 428.6 | 1,859.4 |
| Federal tax | 2,807.9 | 2,483.8 | 11.5% less time | 2,319.1 | 9,461.2 |
| North Carolina tax | 1,001.2 | 899.8 | 10.1% less time | 722.1 | 3,046.3 |
| Telco | 68.1 | 65.9 | 3.1% less time | 79.8 | Unsupported |
<!-- results:end -->

Cells are compute nanoseconds per record; lower is better. The table averages
the unchanged runner's best-sample figure from four accepted complete
invocations. The baseline is the preceding division/text cohort, not
contemporaneous alternating application runs. All attempts are preserved;
a failed clock gate excludes its entire invocation. Library order is varied
within each invocation. No adapter allowance is subtracted. Shared-host
variation limits causal precision, especially for small differences.

All six complete attempts are retained: four passed every output and timing
gate, and two were excluded in full because Miguel's California-tax clock ratio
exceeded the unchanged limit. Every attempt passed its output checks.
The POC uses 17.4% less compute time than Miguel for telco in this cohort. It
still uses 7.1% more for federal tax, 13.0% more for euro, 23.1% more for
California and 24.6% more for North Carolina.

Miguel's euro/tax controls also improved by roughly 6–8% between cohorts.
Consequently the POC's observed 9–12% reductions are not clean causal estimates
of this batch. The alternating primitive probes provide stronger evidence for
the individual mechanisms. Telco's small before/after movement is particularly
hard to distinguish from shared-host variation. No claim of universal leadership
or population confidence follows from these four invocations.

## Mechanisms and semantics

The compiler recognizes ordered comparisons against literal zero and constant
SSA storage, including simple same-block locals. It combines the complete
zero predicate, sign and NaN classification using generic integer SSA.
Infinities order by sign; every ordered comparison with NaN is false. Both
signed zeros and noncanonical finite zero encodings compare as zero. Each
operand is evaluated once. Loads, phis and unresolved forward references are
not assumed constant. DPD continues through its existing path. This is a
narrow constant recognizer, not a general decimal fact-propagation optimizer.

The general comparison kernel first tries inline decoders for finite first-form
encodings whose coefficients fit uint64. Decimal64 first-form coefficients are
below 2^53, and decimal128 values with a zero high coefficient word are below
2^64, so these forms are canonical. Zero signs are normalized. For equal-sign
nonzero values, aligning exponents needs at most one exact 64-by-64 product.
A nonzero high product word decides ordering against the other word. A gap of
20 or more decides magnitude because 10^20 exceeds every uint64 coefficient.
The existing decoder and comparison remain the fallback for special, second-form
and wide encodings. No decimal rounding or digit counting is needed on the fast
path; the exponent bias cancels within each width.

## Primitive results and retained costs

Six complete alternating before/after binary invocations per stage are archived
under [evidence](evidence/). Direct zero-order probes take 74.3–77.6% less time
for decimal64 and 68.4–70.8% less for decimal128. Equality controls are within
0.4%. These isolated loop measurements are not application speedups.

The word-comparison kernel improves mixed Equal/Less/LessEqual/Compare probes
by 33.6–38.7% for decimal64 and 8.4–10.7% for decimal128. Selected same-, nearby-
and distant-exponent word probes improve 38.4–46.9% and 26.2–41.8%, respectively.
The kernel comparison isolates this change: both primitive binaries use the
same installed cdb5b0c6f2 compiler and the same test source.
The explicit fallback probes cost 7.1% more for decimal64 and 5.4% more for
decimal128. Allocation counts remain zero. These costs are retained and reported;
the change is not universally faster.

An earlier same-sign/same-quantum shortcut passed correctness but regressed
several decimal64 probes by 2.5–5.5%, with weak/noisy decimal128 gains. It was
removed before the retained word-comparison change. Its patch and every
measurement are archived in evidence/comparison-quantum.

## Correctness evidence

Independent compiled-operator references pass one million fresh raw encodings
per width, the prefix sweep and explicit boundary cases. The final constant
recognizer also checks reassigned local variables on both sides of a branch,
preventing an invalid zero fact from crossing a merge. Code-generation tests
require no general call for literal and simple-local zero comparisons on ARM64
and AMD64. AMD64 code generation is checked, not native AMD64 execution.

Fresh million-case kernel comparisons and Min/Max references pass, including
word boundaries, exponent gaps, signs, zero and general fallbacks. Published
vectors report 114,915 passes, zero failures and 111,327 explicit skips.
The unchanged 221-row performance ratchet passes. It also reports 43 rows
faster than the old baseline band; that baseline has not yet been refreshed
to lock the cumulative gains, and no limit was relaxed for this milestone. The fully rebuilt toolchain
passes the affected kernel/standard-library suites, decimal runtime and language
cases, and experiment-off compiler/ordinary API checks.

The initial compiler suite invocation used GOEXPERIMENT=decimal for a compiler
self-test, causing a tool-version mismatch. Its failed log is preserved alongside
the successful experiment-off compiler suite. The accepted final constant
recognizer uses the compiler's real OpConst64D opcode; its final fresh-seed
reference log supersedes the preliminary variant. No correctness failure is
hidden by selecting timing samples.

## Subsequent text experiments

Two additional original-Go trials were tested against the restored a7505624ec
baseline and rejected. Neither is in the compiler bundle or application results.
Each passes a fresh million-case digit reference per width and the affected
short suites, and has six complete alternating binary invocations with unchanged
operands and test source. All attempts, candidate patches and dispositions are
archived under evidence/word-digit-pairs and evidence/word-digit-direct.

The pair loop initially exceeded the inlining budget (cost 91). Emitting padded
pairs uniformly and removing the first padding byte reduced its cost to 63 and
restored inlining. However, mixed Append64 changed +0.6%, Append128 -1.4%, and
UnpackDigits64 +0.8%, with wide variation and a -4.2% float control. This did not
establish a useful broad gain; a scientific adapter probe regressed 4.3%.

A direct-write scalar loop counts digits once and avoids the temporary copy.
It remains inlineable (cost 61) and improves fixed-input native formatting
probes by 6.9–11.0%, but mixed decimal64 Append costs 13.8% more. All six paired
deltas on that row are regressions (+5.2% to +21.3%), while the float control
improves 3.3%. The original scalar temporary-buffer loop is restored exactly.
These results show why inlining and instruction-count arguments alone do not
establish an optimization; varied-input and fixed-input consumers can differ.

## Adapter costs

<!-- adapter:start -->
| Probe | Median extra time | Range of six paired deltas |
|---|---:|---:|
| Add | 0.1% | -2.5% to 12.5% |
| Mul | 3.7% | -5.4% to 12.2% |
| Quantize | 6.1% | 4.0% to 18.6% |
| Integral | 14.7% | 13.0% to 17.9% |
| Format | 9.2% | 7.8% to 11.1% |
| Format/fixed | 8.2% | 5.2% to 9.4% |
| Format/full34 | 5.3% | 4.2% to 8.0% |
| Format/largeFixed | 30.1% | 5.7% to 32.1% |
| Format/smallExponent | 24.4% | 16.5% to 28.2% |
| Format/positiveQuantum | 33.7% | 29.3% to 39.5% |
| Format/paddedExponent | 34.6% | 32.6% to 42.9% |
<!-- adapter:end -->

These are medians of six paired percentage costs from six complete native/adapter
binary invocations with matching operands and sinks. Small signed differences
can reflect layout or measurement noise. They are diagnostics and are not
subtracted from application times. The application adapter is unchanged.

## Reproduction and provenance

Exact revisions and machine probes are in phase.json and machine.json.
The compiler commits are 49b2bc70094769cb16313976e27db7a7fc4da761 (ordered zero),
c5fe41d65cce97df2f01edd6b8e5d7f492e7e8f9 (word comparisons), and
a7505624ec71d0bdbc89e4f55652f904bea3801f (constant SSA zero).
The compiler bundle requires cdb5b0c6f2a86c6f45abcd90024885ca0d22334b;
the cumulative patch is also included. The results bundle contains
984d63bbacfbed3dab8b0a3af285d9f1a6d87b00 and requires benchmark commit
19fada66c5c2e6e2dcf82c637f928761cbd75642. Both bundles were verified in their
matching repositories. Rebuild using src/make.bash with
GOEXPERIMENT='' for the compiler tools themselves.

Place the rebuilt fork first in PATH, including /usr/sbin. Use
GOEXPERIMENT=decimal GOWORK=off GOTOOLCHAIN=local CGO_ENABLED=0 and run
`go run ./cmd/bench -lib all` until four complete invocations pass every unchanged
output and timing gate. Preserve rejected invocations. Executable benchmark
source is unchanged from 248fc8ef2967abc51e656bda20a62c4ea8d08019.
Regenerate with `node ../summarize.mjs /path/to/benchmark /path/to/adapter.txt
--phase /absolute/path/to/phase.json`.

This batch remains local. Further Go work, richer compiler facts, ARM64 assembly
and native AMD64 measurements remain open. Risk/power and banking/logarithm/
compound are unsupported; real POWER and s390x hardware work are separate.
