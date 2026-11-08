# Decimal compiler and arithmetic optimization plan

Make decimal arithmetic substantially faster through explicit compiler support,
proven exact arithmetic paths and simpler text conversion. Preserve the language
semantics and stored representation. Start on native ARM64, exhaust useful Go
and compiler changes before handwritten ARM64 assembly, then optimize on native
AMD64. This is the implementation plan for the existing performance target
🎯T6; its stages are local commits within that objective.

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
