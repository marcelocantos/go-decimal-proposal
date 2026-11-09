# Decimal compiler and arithmetic optimization plan

Make decimal arithmetic substantially faster through explicit compiler support,
proven exact arithmetic paths and simpler text conversion. Preserve the language
semantics and stored representation. Start on native ARM64, exhaust useful Go
and compiler changes before handwritten ARM64 assembly, then optimize on native
AMD64. This is the implementation plan for the existing performance target
🎯T6; its stages are local commits within that objective.

## Local progress through 2026-11-09

The coherent installed fork is 082f0305dd29cbefbc22deedc336eef078a75e8c.
Completed milestones cover direct zero predicates, exact word arithmetic,
power-of-ten division, shared digit formatting, ordered-zero comparisons,
a narrow constant-SSA zero recognizer, bounded kernel rounding, typed compiler
intrinsics, public integral dispatch, canonical fixed-point formatting and
general compiled comparisons, suffix digit buffers, fast coefficient decoding,
direct canonical layout and a bounded reciprocal for wide text splitting.
See the reports linked from [application benchmarks](README.md).

The preceding [integral dispatch report](integral-dispatch/README.md) preserves four
accepted complete application invocations with no exclusions, six alternating
POC application pairs, coherent correctness gates and fresh adapter costs.
Euro and tax cohort times fall 2.9–8.6% versus the prior compiler-rounding cohort;
telco is effectively flat (+0.2%). Miguel still leads euro and taxes by
4.2–14.1%; telco uses 52.2% less time (2.09 times the throughput). Shared-host
and reference-library shifts limit attribution of small cohort differences.
Paired tax medians improve 2.8–6.7%, while telco may cost about 1% more.
The stricter 221-row ratchet established at 0dac3e159d passes unchanged.

Both Quantize and the integral adapter now inline. Recognizing the five exact
public integral shapes reduces dispatch cost from 261 to 46, below the budget
of 80, without raising that budget. Fresh paired integral overhead is 1.3%
versus the previous cohort's 115.3%, within measurement noise. The stale inline
exemption is removed and the existing gate now enforces this property.

The preceding profiles identified formatting as the main remaining cost. The
canonical fixed-point change improves the short native formatting probe 8.1%,
but exponent adapter probes have mixed changes and formatting still has a
measured premium. The [compiled comparisons report](compiler-comparisons/README.md)
now covers all six decimal64 comparison operators entirely in integer SSA,
plus exact word-coefficient decimal128 paths. Wider decimal128 operands retain
the original fallback. Six alternating application pairs improve median federal
tax time 5.0% and California time 3.6%; euro improves 0.9%, North Carolina is
flat and telco costs 0.7% more. Decimal128 wide/raw fallback probes can cost up
to 6.9% more. All nine coherent gates pass, including the unchanged 221-row
ratchet; the initial ratchet failure and subsequent baseline/candidate/coherent
diagnostics are retained. Formatting, wider coefficients and richer SSA facts
remain concrete original Go/compiler targets. Do not subtract wrapper costs
from application results.
Four accepted full comparison runs now put the POC 4.9% ahead of Miguel in
federal compute time and at 2.12 times its telco throughput. Euro, California
and North Carolina remain 7.9%, 8.5% and 16.4% slower. Two complete invocations
were excluded by the original timing checks and retained. Fresh golden-checked
profiles put formatting, including adaptation and allocation, at 53.4% of euro
and 43.6% of federal timed-loop samples. Coefficient-to-text data movement and
duplicated comparison guards are the next concrete Go/compiler investigations.
Useful Go/compiler work is not exhausted; ARM64 assembly and native AMD64
execution have not started. No performance changes are published.

The latest [digit-buffer pass](suffix-digits/README.md) removes temporary digit
copies and bypasses general decoding for proven small coefficients and special
values. A dedicated guard probe exposed a special-value slowdown during
development; direct special decoding removes it. This batch also found and
fixed a latent compiler race affecting the earlier synthesized power tables.
Serial initialization now declares them before parallel SSA. The regression
fails against the old compiler and passes with the fix; all ten final coherent
gates pass, including the unchanged performance ratchet.

<!-- suffix-results:start -->
All four complete library runs pass with no exclusions. Versus the preceding
cohort, observed POC time falls 8.1% euro, 2.3% federal, 4.6% California, 5.6%
North Carolina and 8.5% telco. The six alternating pairs support smaller gains:
best-sample medians improve 2.7–7.0%; median-sample changes improve 1.1–8.2%.
Control-library shifts and shared-host variation still limit attribution.
Federal uses 3.8% less time than Miguel, and telco reaches 2.26 times its
throughput. Euro/California/North Carolina remain 3.7%/6.5%/10.4% slower.
Mixed Append64/128 improve 7.6%/5.3%, with unchanged allocations. Some isolated
probes regress; all 37 rows are retained. Text grows 128 bytes per application.
Golden-checked profiles still put String, including adaptation/allocation, at
54.7% of euro and 39.6% of federal timed samples. Results are committed locally
at benchmark 2d46669041, with measured source pinned to db46d69. No publication.
<!-- suffix-results:end -->

The [direct canonical layout pass](canonical-layout/README.md) tests that
spare-capacity hypothesis and rejects it: the final relocation is still needed,
while extra guards and a pointer cause application costs. Correctness and
allocation checks pass, and every measurement is retained. The accepted second
trial keeps the stack digit array but moves single-use canonical layout into
its caller, constructing rounding state only for explicit precision. This
removes a call and common-path descriptor stores without changing the layout
algorithm. Its 66,000 independent capacity/notation checks run in the normal
strconv suite; all ten coherent gates pass.

<!-- canonical-results:start -->
Four full application invocations pass; one whole invocation is excluded for
Miguel California's timing cross-check and retained. Observed cohort POC time
falls 6.3% euro, 3.5% federal, 5.1% California, 7.4% North Carolina and 2.0%
telco. Final alternating pairs support smaller gains of 1.5–3.0% on best samples
and 2.1–3.6% on median samples. Euro's measured 0.25% lead is effectively parity;
California/North Carolina still cost 3.3%/3.8% more than Miguel. Federal uses
7.2% less time and telco reaches 2.32 times the throughput. Whole-program text
grows 16 bytes per application. The common formatting probe improves 6.4% native
and 11.0% through the adapter, but a separate explicit-precision Fixed3 probe
costs 3.3% more; allocations are unchanged. appendDecimal's own frame grows
176 to 256 bytes after removing the canonical helper call. All costs are
retained. Fresh String profiles are 65.3% euro and 38.6% federal; they are
diagnostic, not headline timing. Results commit bc0efce902, measured source
2d46669041. All work remains local.
<!-- canonical-results:end -->

Further Go work should follow the remaining profile costs: formatting layout,
wide-coefficient arithmetic and repeated guards. Borrowing output capacity is
not an untested shortcut any more. The [wide text split pass](reciprocal-split/README.md)
now replaces division by 10^19 with an exact bounded reciprocal. The canonical
coefficient bound proves the tentative remainder fits one word, permitting
two wide multiplies and a low-word multiply with at most one correction.
An intermediate split helper failed to inline and added a call; the retained
single function is a leaf on ARM64. Independent boundary tests and fresh long
references pass, as do all ten coherent gates and the unchanged ratchet.

<!-- reciprocal-results:start -->
Final six-pair probes improve wide digit extraction 17.5%, mixed decimal128
digit extraction 10.7% and mixed Append128 5.0%; special/zero probes cost
14.2%/6.3% more, with unchanged allocations. Six alternating application
pairs show median-sample changes of euro -2.11%, federal -2.08%, California
+4.43%, North Carolina +1.28% and telco +0.22%. These costs are retained.
Four complete invocations passed every gate; a fifth failed bid754's California
clock cross-check and is excluded in full but archived. The cohort places euro
4.4% ahead of Miguel, federal 8.3% ahead, California 6.4% behind, North Carolina
effectively tied and telco at 2.34 times the throughput. However, all five POC
absolute means are slower than the preceding cohort and reference timings also
shifted: the relative positions cannot be credited entirely to this change.
Fresh California diagnostics put String at about 57% of timed samples and
memmove at 11–13%; they do not identify the regression's cause. Investigate
common formatting/copying/allocation and that unresolved cost next. The bounded
wide-conversion gain is retained as an explicit tradeoff, not an application-wide
win. Results commit 425e200995, measured source bc0efce902. All work is local.
<!-- reciprocal-results:end -->

Further work must follow the remaining application/profile costs, preserving
the original gates and reporting regressions and controls. Instruction-count
arguments and hoped-for inlining are insufficient acceptance evidence.

A global all-packages intrinsics-disable diagnostic also crashes a no-import
println(42) control. Scoped disabling in the public-API test package passes;
the unrelated global debug-mode contract is recorded as 🎯T8 for separate
diagnosis. Risk/power and banking/logarithm/compound remain unsupported, and
real POWER/s390x hardware verification remains separate open work.

## Starting point

- Fork: `039d51109b6b43be4530820fb31abfc0c386a891`, branch
  `perf/decimal-go-arm64`, checkout `/Users/marcelo/work/wt/gd-survey`.
- Benchmark: `8572fe39d24409ebd5955b738d4f3e7bf71c84ab`, branch
  `builtin-decimal-benchmark`. Its executable source is unchanged from
  `248fc8ef2967abc51e656bda20a62c4ea8d08019`.
- Latest complete application comparison: [Go text pass](go-text/README.md).
- Analysis and diagnostic evidence:
  `/Users/marcelo/.cache/codex-decimal-app-bench/astra-analysis/`.
  Preserve `analysis.json`, `probes_test.go`, `correctness-final.log`,
  `interleaved-final.txt`, `summary.json`, the census records and output gates,
  and the current CPU profiles. Archive the necessary source and raw evidence
  with the first implementation report; scratch paths are not publication links.

The prototypes demonstrate opportunities, not delivered application speedups.
They use the existing kernel as their differential reference. Production changes
must also pass the independent arithmetic references and the published vectors.
The operand census covers selected methods in the original gated passes;
formatting counts include untimed output and must not be treated as timed CPU
shares. Profiles are diagnostic and separate from headline measurements.

## Model and working method

Use **GPT-6 Astra with high reasoning** for implementation, numerical proofs,
compiler integration and investigation of failures. Use extra-high reasoning
for the initial lowering design, difficult rounding proofs and final semantic
review when the added latency is worthwhile. Keep one implementation owner
across the interacting compiler changes; this plan does not initiate delegates.

This is a task-specific recommendation: the difficult decisions concern exact
semantics, control flow, compiler facts and the validity of measurements.
[OpenAI's Astra documentation](https://developers.openai.com/api/docs/models/gpt-6-astra)
positions it for demanding reasoning and coding and documents the high and
extra-high reasoning settings. [GPT-6.1 Sol](https://developers.openai.com/api/docs/models)
is a lower-cost alternative for bounded implementation or reporting tasks after
the design is settled. There is no project-specific model comparison proving
one model's advantage here. Tests and measurements decide whether work is accepted.

## Architectural decisions

1. Give decimal arithmetic explicit compiler support. Ordinary inlining is not
   an acceptance condition: software decimal operators currently become runtime
   calls after the inliner, and moving a helper earlier does not guarantee that
   its body fits the inlining budget.
2. Build fast paths from generic integer SSA operations so the existing backend
   performs instruction selection, scheduling and register allocation. Begin
   with narrow predicates and guarded operations during SSA construction; retain
   richer decimal operations through optimization when the later fact analysis
   is ready. Do not put a complete arithmetic implementation into the final
   machine-code emitter.
3. Retain the current kernel for general cases. A failed guard must reach the
   original operation with its original operands. Define control-flow joins,
   memory tokens, result tuples and ABI behavior before implementing guarded calls.
   Never evaluate a fallback eagerly and then select between two results.
4. Keep stored BID-XOR and DPD-XOR unchanged. Compiler facts and temporary
   register representations are internal; bits functions continue to expose
   exact stored words. Unknown inputs and loads cannot be assumed canonical.
5. Preserve rounding at every original operation, preferred quantum, signed
   zeros, noncanonical encodings and NaN propagation. Exact paths need explicit
   representability proofs. Update the named packing exceptions and their
   enforcement deliberately; keep general rounding centralized.
6. Use original implementations. Other libraries are external benchmark
   dependencies, never implementation references. Keep the original workload,
   input, golden files and dependency versions fixed for comparisons.
7. Declare synthesized global compiler data in serial initialization before
   parallel SSA. A per-function cache cannot serialize global first use. Preserve
   table contents and byte order, test concurrent compilation through the real
   compiler, and retain a failing-old/passing-new reproducer.

## Implementation sequence

### 1. Establish the compiler gate and measurement baseline

Inspect the current SSA construction and lowering order, including the existing
DPD hardware path, decimal128 decomposition and prior composite ABI fix. Record
where guarded calls can be introduced safely and where later semantic operations
must be expanded. Check evaluation order and memory handling explicitly.

Promote the diagnostic cases into permanent tests in the appropriate compiler
and arithmetic suites. Add generated-program coverage of operands with side
effects, register pressure, branches, loops, spills, composite arguments and
returns, and an operation falling back after preceding fast operations. Run
these through the native compiler, not only by calling a kernel helper.

Freeze the baseline revision, corpus, primitive probe order and application
runner settings before measuring a candidate. Verify that the existing oracle
and performance gates are active; preserve all attempts and existing limits.

**Exit evidence:** the unchanged baseline passes the new compiler cases, and a
written lowering design identifies the fallback and memory-SSA contract. Existing
passing evidence need not be rerun merely because it already passed.

### 2. Compile zero predicates directly

Implement decimal equality and inequality against constant zero using complete
encoding predicates. Cover positive and negative zeros at every quantum,
noncanonical finite encodings, infinities and NaNs. Start with BID decimal128
on ARM64; handle decimal64's two finite encoding forms separately. Keep the DPD
path correct without applying BID masks to it.

Recognize the operation in compiler lowering so performance does not depend on
an inlining heuristic. Evaluate source operands once and preserve their side
effects. Keep arbitrary two-operand equality and ordering on the existing path
until separately optimized.

**Exit evidence:** independent/reference correctness, generated-program tests,
and disassembly showing no general comparison call for these predicates. Measure
both zero and nonzero inputs, unusual encodings and the tax workloads.

### 3. Compile exact addition and subtraction paths

Start with same-sign, same-exponent decimal128 operands whose coefficients fit
in uint64. Their sum is at most `2^65-2`, so it always fits decimal128 at the
preferred exponent. Guard classification and coefficient width, add with carry,
and construct the exact result without general rounding.

Extend to nearby exponents when measurements justify the additional guard:
for two uint64 coefficients and a gap at most 14, the aligned same-sign sum is
at most `(2^64-1)*(10^14+1)`, strictly below `10^34`. Align using integer
arithmetic and retain the lower exponent. Consider full-width same-exponent
addition next, with a checked coefficient bound.

Add opposite-sign addition and subtraction only after specifying cancellation,
borrow and signed-zero behavior. Do not reuse the decimal128 headroom proof for
decimal64; its coefficient limit requires separate checks.

**Exit evidence:** bit-exact results on boundary and random inputs, original
application gates, and code generation with calls confined to fallback paths.
Measure fast hits, misses, mixed branch patterns and dependent accumulation.
The scratch wrapper's slower miss case is a specific regression to avoid or
resolve, not a cost to hide in aggregate results.

### 4. Specialize multiplication, quantization and simple division

Use exact word products when the coefficient is at most `10^34-1` and the sum
of exponents is in range. Constant multipliers can supply stronger bounds that
remove runtime checks. Treat zero and out-of-range exponent sums correctly.

Recognize constant quantum and rounding mode in quantize and integral operations.
Avoid reconstructing and decoding the target quantum on each call; use bounded
integer division and exact remainder classification where applicable. Preserve
the general path for wide coefficients and exceptional results.

Specialize division by coefficient 1 and powers of ten before general reciprocal
work. Preserve preferred quantum: dividing coefficient `c` by `10^k` strips only
`min(k, trailingDecimalZeros(c))` coefficient zeros before selecting the result
exponent. Zero, exponent limits and specials need their own handling. Any further
reciprocal algorithm requires an exact residual and a proved correction bound.

**Exit evidence:** independent references and published cases cover ties, directed
modes, carry after rounding, underflow, overflow and exact cohorts. Separate
multiply-then-quantize remains two semantic rounding operations. Measure telco
and euro alongside broad primitives and fallback cases.

### 5. Retain decimal operations and facts through optimization

Build on the established fast paths: introduce semantic decimal SSA operations
incrementally and a defined expansion point before machine-specific lowering.
Track finite/canonical status, known quantum, sign and coefficient bounds only
where producers and control flow prove them. Treat joins and fallback results
conservatively. Specify the memory-token and call-expansion behavior explicitly;
do not remove runtime-call memory edges by assertion.

Use those facts to eliminate repeated guards, constant decoding and unnecessary
packing/unpacking. Investigate keeping coefficients and scale information live
across short arithmetic sequences. Materialize the specified representation at
observable boundaries, preserving every operation's rounded result and quantum.
Measure register pressure and spills as well as instruction count.

**Exit evidence:** representative sequences show concrete removed work and lower
native execution cost, with unchanged observable bits and evaluation order.
Keep this stage incremental; a generic optimizer rewrite is not a prerequisite
for retaining successful earlier compiler paths.

### 6. Simplify text conversion and finish useful Go optimization

Share numeric coefficient-to-digits extraction between the kernel and strconv.
Apply each formatting policy once, avoiding construction and rescanning of an
intermediate notation. Preserve Go's format verbs, explicit precision, quantum,
special spelling and existing short fixed-point bypass. Generate digits in pairs
or larger groups when measured beneficial.

Keep the application adapter on public native APIs and include its full cost.
A public GDA-formatting API would be a separate API decision; do not substitute
an internal-only shortcut and call that a native application result.

Reprofile the resulting binaries, then pursue remaining useful original Go
changes in division, comparison and general arithmetic. This text stage can be
interleaved with compiler stages at a clean commit boundary; do not run competing
measurements concurrently.

**Exit evidence:** all formatting modes and boundary cohorts pass the existing
independent reference and round-trip tests; allocation counts and complete euro
and tax results show the effect. Record investigated Go alternatives and their
outcomes before proceeding to assembly.

### 7. Optimize remaining ARM64 machine code

After useful Go and compiler opportunities have been tested, inspect profiles
and generated instructions for remaining hotspots. Prefer an architecture rewrite
or intrinsic when it integrates better with register allocation; use handwritten
assembly where it provides a measured advantage.

Start with operations still behind the other libraries. Already-leading paths
remain eligible afterward. Preserve a tested portable fallback, calling
conventions and stack/safe-point requirements. Avoid assembly that merely saves
instructions locally while adding expensive calls at the application boundary.

**Exit evidence:** correctness gates and native application measurements validate
each retained change, with generated code and fallback costs archived.

### 8. Measure and optimize on native AMD64

After the ARM64 work, establish a task-local toolchain on the reachable Windows
Ryzen 9 3900X host, preserving its existing setup. Do not assume WSL or Go is
installed. Verify the environment and native execution before measuring.

Repeat the frozen correctness and application protocol on that machine. Reuse
portable compiler and Go improvements first; introduce AMD64-specific lowering
or assembly only for measured remaining gaps. Emulated runs may check behavior
but never count as native performance evidence.

**Exit evidence:** a separately reproducible native AMD64 report, followed by a
final ARM64 regression check if shared code changed during AMD64 work.

## Acceptance protocol for every retained change

- Run focused independent arithmetic/reference tests first, then the affected
  compiler/runtime/stdlib suites and the relevant published vectors. Broader
  changes require both decimal widths, all supported modes, experiment enabled
  and disabled, and generated source consistency.
- Exercise fast and fallback paths through compiled programs. Preserve argument
  evaluation, composite ABI, GC/safe-point correctness, quantum and exact stored
  bits. Build unaffected targets to catch accidental backend coupling; emulation
  is explicitly separate from real hardware verification.
- Keep the existing performance/allocation ratchet and its limits unchanged.
  Skipped tests are not passing evidence. Fix new reproducible regressions or
  leave the candidate unretained; record an intentional tradeoff explicitly.
- Use six interleaved primitive repetitions with matching operands and sinks,
  including dependent chains and mixed cases. Record allocation counts, code
  size, relevant disassembly and adapter cost in percentages.
- For application milestones, use the original runner and all its original
  output gates. Collect four accepted complete invocations per revision, retain
  every attempt, and exclude an entire invocation when a supported clock check
  fails. Use a predetermined alternating before/after order where practical;
  never select the fastest subset or subtract estimated adapter overhead.
- Use the shared Go cache and keep captures, profiles and exploratory artifacts
  in scratch. Run CPU-heavy measurements without competing work from this
  session. Archive exact revisions, settings, raw samples and source bundles
  with each accepted application report.

## Completion and delivery

The objective remains to beat the compared libraries across supported metrics,
but no prototype ratio establishes that outcome. Report wins, losses,
allocation/code-size tradeoffs, unsupported operations and hardware residue.
Risk/power and banking/logarithm/compound need functionality beyond this
optimization sequence and remain explicit open scope. Real POWER and s390x
hardware verification also remain open.

Commit coherent, verified stages locally on the existing performance branch and
update the evidence and target context with the relevant work. This planning
request does not initiate implementation, a model switch, delegates, a push or
a deployment. The previously deployed compiler/playground bug-fix batch remains
separate. Any later authorized publication follows the normal delivery workflow;
local completion does not require inventing another release target.
