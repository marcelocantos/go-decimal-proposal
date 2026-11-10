# UW-Madison application benchmarks: the fork's built-in decimal128

These results come from migueldecimal128's Go port of the UW-Madison decimal
application benchmarks (https://github.com/migueldecimal128/go-decimal128-app-benchmark,
GPL, commit `9986cf2`). The fork's built-in `decimal128` runs as a third
candidate beside miguel-decimal128-go and bid754. The harness and the adapter
stay in a scratch clone outside this repository. This file holds only the
results and a description of the method.

Machine: MacBook Pro M4 Max, darwin/arm64. Two measurements: the final one of
2026-11-10 (first section) and the earlier one of 2026-11-09 (the sections
after it, kept as the record of the pre-tuning pin and of the method).

## Final measurement (2026-11-10, fork `perf/t13-final` at 7262cd2876)

Three runner sessions, each building and timing four libraries interleaved:
two adapters over the built-in type, miguel-decimal128-go `073024a` and
bid754 `v0.2.0`. Every gated row passed (31 of 31 per session, 93 in all).
The 1-minute load was 7.3–7.8 at the start of each session and 7.6–7.8 at
its end; the sessions ran 00:56–00:59 UTC with no other builds or benchmarks
on the machine.

The two fork adapters differ only in `String`, the conversion to the
benchmark's GDA notation:

- `go-decimal-poc` (written in the fork's Codex performance session) formats
  with `strconv.AppendDecimal(…, 'G', -1, 128)` into a fixed 42-byte buffer,
  rewrites the exponent form in place, and allocates the result string once.
- `go-decimal` (this session's adapter, described under Setup below) formats
  with `'g'` into a 64-byte buffer, scans for `e`, parses the exponent with
  `strconv.Atoi`, re-lays the digits for the plain-notation cases, and
  allocates the string.

Compute time in ns per record, the three sessions and their median in bold:

| benchmark | go-decimal-poc | go-decimal | miguel-decimal128-go | bid754 |
|---|--:|--:|--:|--:|
| euro_conversion | 730.0 / 801.7 / 739.2 → **739.2** | 832.3 / 884.4 / 822.3 → **832.3** | 812.7 / 889.8 / 855.4 → **855.4** | 2363.3 / 2478.8 / 2353.3 → **2363.3** |
| tax_preparation fed | 2119.8 / 2065.3 / 2127.6 → **2119.8** | 2165.8 / 2284.2 / 2136.5 → **2165.8** | 2412.8 / 2301.0 / 2598.6 → **2412.8** | 9704.1 / 10333.4 / 9534.1 → **9704.1** |
| tax_preparation ca | 444.9 / 445.5 / 421.0 → **444.9** | 415.2 / 423.5 / 430.7 → **423.5** | 470.1 / 419.9 / 436.6 → **436.6** | 1936.7 / 1886.9 / 1934.8 → **1934.8** |
| tax_preparation nc | 755.0 / 735.3 / 770.8 → **755.0** | 786.3 / 742.9 / 776.5 → **776.5** | 786.5 / 728.8 / 715.8 → **728.8** | 3241.9 / 3026.5 / 3028.2 → **3028.2** |
| telco | 33.3 / 33.4 / 34.5 → **33.4** | 36.2 / 35.6 / 36.9 → **36.2** | 82.1 / 80.0 / 83.1 → **82.1** | not supported |

Ratios of medians, go-decimal-poc against the others and against the
pre-tuning pin (903d630330, from the earlier measurement below):

| benchmark | poc / miguel | poc / bid754 | pin / poc |
|---|--:|--:|--:|
| euro_conversion | 0.86 | 0.31 | 2.39 |
| tax fed | 0.88 | 0.22 | 2.56 |
| tax ca | 1.02 | 0.23 | 2.55 |
| tax nc | 1.04 | 0.25 | 2.30 |
| telco | 0.41 | — | 4.98 |

Session-to-session spread for one library is up to 10% (miguel's fed
2301–2599), so the tax ca and nc rows are ties; euro, fed and telco are not.
The two fork adapters differ by 3–12% on euro and fed and are within noise
elsewhere, which is the cost of `String` as the earlier profile below
predicted (the adapter's own scan and re-layout was 6–12% of the loop).

## Earlier measurement (2026-11-09, fork at f79bf54f87)

### Setup

- **Toolchain for every library in a run:** the runner calls whatever `go`
  is on PATH, with the environment it inherits, so every library is built by
  the same toolchain with `GOEXPERIMENT=decimal`.
  - Tuned: `/Users/marcelo/work/wt/gd-t13-final`, at worktree HEAD
    `f79bf54f87`. Its version string reads `go1.28-devel_7966459ac4`.
  - Pre-tuning pin: `/Users/marcelo/work/wt/gd-pin903`, at
    `903d630330`. Only the fork's adapter was run under it.
- **Harness change:** the clone's `go.mod` goes from `go 1.26.4` to
  `go 1.28`, because the predeclared `decimal128` needs go1.28. With that
  change, bid754 `v0.2.0` and miguel-decimal128-go `073024a` also build and
  pass under the fork toolchain. miguel-decimal128-go's package is named
  `decimal128`, but the harness already imports it under an alias, so the
  name doesn't collide with the built-in type.
- **Fork adapter:** a new `lib_go_decimal.go` behind the build tag
  `go_decimal`, with `!go_decimal` added to `nolib.go` and a row in the
  runner's `libraries` table. It uses operators (`+ - * /`, `-x`, `<`, `==`,
  `min`/`max`, `int64(x)`, `decimal128(n)`) and the public packages:
  - `math/decimal`: `Quantize`, `QuantizeMode`, `Trunc`, `Round`,
    `RoundToEven`, `Ceil`, `Floor`, `Signbit`, `IsInf`, `BID128frombits`.
  - `strconv`: `ParseDecimal` and `AppendDecimal`.

  It doesn't reach into internal/bid. It passes the harness's contract tests
  and wrapper-inlining test. `String` and `MustParse` are declared not
  inlined, as bid754's `String` is.
- **String form:** the harness requires the to-scientific-string. The
  adapter calls `strconv.AppendDecimal(…, 'g', -1, 128)` and then rewrites
  two things:
  - the exponent notation, `e+03` → `E+3`;
  - values whose leading digit is at 10^21 or above while the exponent is
    ≤ 0. The fork prints these in scientific form (`1.234…e+33`); the
    to-scientific-string prints them plain.

  This work is part of the fork's measured time, as the re-layout is for
  bid754.
- **Gates:** every row of every run passed its SHA256 or golden gate: 63 of
  63 gated rows across 9 runs. No result differed from the goldens.

### Compute time, ns per record

The harness's "compute" is the fastest sample over 3 processes of the
program's own timed loop, which covers the arithmetic and the in-memory
formatting of the output. The cells list runs 1 / 2 / 3, and the median of
the three is in bold. The three tuned runs build and measure all three
libraries interleaved in one runner session.

| benchmark | go-decimal (tuned) | miguel-decimal128-go | bid754 | go-decimal (pin 903d630) |
|---|--:|--:|--:|--:|
| euro_conversion | 827.7 / 876.7 / 865.4 → **865.4** | 792.1 / 868.1 / 813.3 → **813.3** | 2438.8 / 2412.9 / 2518.3 → **2438.8** | 1707.9 / 1765.4 / 1866.7 → **1765.4** |
| tax_preparation fed | 2161.3¹ / 2235.2 / 2142.6 → **2161.3** | 2359.1 / 2357.6 / 2363.4 → **2359.1** | 9708.4 / 9887.5 / 9784.1 → **9784.1** | 5418.8 / 5401.3 / 5473.7 → **5418.8** |
| tax_preparation ca | 426.2 / 416.7 / 445.5 → **426.2** | 436.7 / 429.7 / 436.4 → **436.4** | 1882.7 / 1878.9 / 1873.4 → **1878.9** | 1135.2 / 1125.0 / 1196.5 → **1135.2** |
| tax_preparation nc | 741.6 / 787.7 / 746.7 → **746.7** | 741.7 / 786.0 / 746.4 → **746.4** | 2989.0 / 3042.9 / 3042.9 → **3042.9** | 1738.7 / 1697.6 / 1850.6 → **1738.7** |
| telco | 36.8 / 35.8 / 36.3 → **36.3** | 81.8 / 81.3 / 83.5 → **81.8** | not supported² | 166.2 / 163.2 / 170.0 → **166.2** |

¹ The runner flagged this sample because its cross-check ratio was 1.35,
outside the 0.90–1.25 band. Its gate passed. The other two tuned fed runs
were within the band (1.07 and 1.19).
² bid754 can quantize only ties-to-even, and telco truncates its taxes.

Ratios of medians:

| benchmark | go-decimal / miguel | go-decimal / bid754 | pin / tuned |
|---|--:|--:|--:|
| euro_conversion | 1.06 | 0.35 | 2.04 |
| tax fed | 0.92 | 0.22 | 2.51 |
| tax ca | 0.98 | 0.23 | 2.66 |
| tax nc | 1.00 | 0.25 | 2.33 |
| telco | 0.44 | — | 4.58 |

### Load at each run

The runner waited for a 1-minute load average under 8 before starting each
run. Each run took about 30–55 s. The machine was coming down from a load
of 19 at the time.

| run | start (UTC) | load at start (1 / 5 / 15 min) | load at end |
|---|---|---|---|
| tuned 1 | 15:39:19 | 7.85 / 13.20 / 11.79 | 6.65 |
| tuned 2 | 15:40:12 | 6.65 / 12.02 / 11.43 | 7.14 |
| tuned 3 | 15:41:00 | 7.14 / 11.30 / 11.20 | 8.65 |
| pin 1 | 15:42:07 | 7.92 / 10.75 / 11.00 | 6.68 |
| pin 2 | 15:42:41 | 6.68 / 10.14 / 10.76 | 5.74 |
| pin 3 | 15:43:10 | 5.74 / 9.58 / 10.54 | 6.79 |

The pin runs came right after the tuned runs but in separate runner
sessions, so they were not interleaved with them. bid754 doesn't depend on
the fork's compiler work, and its numbers here are close to its go1.27.3
numbers in `uw-madison-arm64.md`. That suggests conditions were comparable.

## Benchmarks the fork cannot run

`math/decimal` has no transcendental functions:

- **risk_management:** needs `Decimal128.Pow`, and `Decimal128.PowInt` for
  integral exponents. `math/decimal` has neither.
- **banking:** needs `Decimal128.Log10` (mortgage term) and
  `Decimal128.Compound` ((1+r)^n). `math/decimal` has neither.

Unlike bid754, the fork runs telco, because `math/decimal.QuantizeMode` takes
a rounding direction (here `ToZero`).

## Formatting cost (pprof, toolchain of the earlier measurement)

Method: each app was built with a profiling hook in the scratch clone and
run in compute mode for 8 s under the CPU profiler. The denominator is the
cumulative time of the timed loop (`harness.BestOf`, or `main.main` for the
tax apps). "String" is the adapter's `Decimal128.String`. It splits into:

- the fork's formatter, `strconv.appendDecimal`;
- the result string's allocation, `runtime.slicebytetostring`;
- the rest: the adapter's scan for `e` and its re-layout.

| app | String / loop | fork formatter | string alloc | adapter scan + re-layout |
|---|--:|--:|--:|--:|
| euro_conversion | 62% | 34% | 17% | 11% |
| tax fed | 40% | 19% | 15% | 6% |
| tax ca | 52% | 21% | 24% | 7% |
| tax nc | 57% | 27% | 23% | 7% |
| telco | 70% | 37% | 21% | 12% |

Every library has to produce a `string` per formatted value, so the string
allocation is common to all three. The adapter's own work, 6–12% of the
loop, is the overhead that is specific to the fork: it comes from its 'g'
form differing from the to-scientific-string. A formatter that wrote the
to-scientific-string directly would remove most of that overhead.

## Residue

- The fork adapter's source lives only in the scratch clone,
  `/Users/marcelo/work/wt/.perf/cmp/app-bench-fork` (GPL harness). The raw
  run logs are in `/Users/marcelo/work/wt/.perf/cmp/app-bench-fork-runs`.
- The load gate checked only the 1-minute average at the start of each run.
  Tuned run 3 ended at 8.65.
