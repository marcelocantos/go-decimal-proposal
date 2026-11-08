# Second-pass evidence

These are selected non-sensitive logs and raw timing samples from the native
Apple M4 Max. Application headline records are in `../measurements.json`.
Primitive probes and profiles are diagnostic evidence, not application timings.

- `phase2-decoder-interleaved-*`: six repetitions, alternating the frozen
  first-pass test binary and the candidate containing the word-sized shift
  and decoder changes. The selection covers both widths and float controls.
- `phase2-word-mul-interleaved-*`: six repetitions of the first small-factor
  multiply trial against the decoder candidate. Its exact-division regression
  prompted the carry-chain rewrite. This trial is not the retained source.
- `phase2-mul-chains-interleaved-*`: six repetitions comparing that retained
  multiply rewrite with the decoder candidate, over decimal128 operations.
- `*-benchstat.txt`: benchstat summaries of the corresponding raw samples.
- `phase2-*-oracle.log`: million-case exact-reference comparisons per selected
  operation/width. The logs record their test names and completion.
- `phase2-*-published.log`: original decTest, Intel readtest and FPgen accounting.
- `phase2-mul-chains-fuzz.log`: 20 seconds of `FuzzU128Mul`, four workers, run
  from `src/internal/bid` so the standard-library module is the main module.
- `phase2-rebuilt-*.log` and `phase2-make.log`: source-built toolchain checks.
- `phase2-{euro,fed}-after.cpu` and `*-profile.txt`: diagnostic CPU profiles
  of the unchanged workload functions. A temporary Go build overlay wraps
  only each program's main entry with pprof.StartCPUProfile/StopCPUProfile.
  The normal benchmark checkout and headline binaries are unchanged.
  Euro uses one compute sample of 50,000 passes; federal tax uses one sample
  of 2,000,000 passes. These long runs are for profiling, not headline timings.
  The original gated transcript matches byte-for-byte. Tax appends its original
  `compute-sink` marker in compute mode; that sole postlude is checked separately.
- `*-workload-profile.txt`: the same profile with a pprof focus on
  `internal/harness.BestOf`, retaining only sampled stacks in the timed loop.
  The unfiltered profile is also retained, including runtime/background work.
  These focused percentages are not a share of total application CPU.

The primitive binaries were built with the same first-pass compiler, with only
the standard-library source candidate changed. Interleaving alternates the
order of before/candidate on successive repetitions. Timings use 100 ms for
the decoder matrix and 150 ms for the multiply matrices. Six samples give weak
resolution; a reported non-significant difference does not prove equivalence.

The application comparison uses the unchanged runner and its original nine
golden gates per supported row. It contains two initial complete invocations
per revision, followed by alternating before/after invocations under the same
rebuilt compiler. Clean source revisions are switched, and the normal shared
Go cache is reused. All invocations and any clock rejection are retained.
