# UW-Madison application benchmarks: the fork's built-in decimal128

These results come from migueldecimal128's Go port of the UW-Madison decimal
application benchmarks (https://github.com/migueldecimal128/go-decimal128-app-benchmark,
GPL, commit `9986cf2`). The fork's built-in `decimal128` runs as a third
candidate beside miguel-decimal128-go and bid754. The harness and the adapter
stay in a scratch clone outside this repository. This file holds only the
results and a description of the method.

Machine: MacBook Pro M4 Max, darwin/arm64. Six measurements: the one at
the pin, a403f0b413, of 2026-11-13 (first section), which is the first
with all seven benchmarks; the one at the pin before it, 43fbd4bf6d, of
2026-11-12; the one at e5db2abe94, the same day; the one after the last tuning
pass, of 2026-11-11, the one of 2026-11-10 before that pass, and the
earlier one of 2026-11-09 (kept as the record of the pre-tuning pin and
of the method).

## Measurement at the pin (2026-11-13, fork `decimal` at a403f0b413)

Three runner sessions, each building and timing four libraries
interleaved, as in the measurements below. Every golden check passed (25
per session, 75 of 75). The 1-minute load was 10.1–10.9 at the start of
each session; a test run under emulation held one of the machine's sixteen
cores throughout.

Two things differ from the earlier measurements:

- **All seven benchmarks run.** `math/decimal` has `Pown`, `Pow`,
  `Compound` and `Log10` since this pin, so the adapters call them and
  banking and risk management run. The adapters also read the harness's
  BID words with `math/decimal.BID128frombits`, since `math`'s bits
  functions return the stored words.
- **decimal128-go is at `4c57d3c`** (2026-11-11), 18 commits past the
  `073024a` that the harness pins and the earlier measurements used. The
  harness is otherwise at `9986cf2`.

Compute time, ns per record: the three sessions and their median.

| app | built-in, `go-decimal-poc` adapter | built-in, `go-decimal` adapter | miguel-decimal128-go | bid754 |
|---|---|---|---|---|
| euro_conversion | 738.5 / 733.8 / 733.3 → **733.8** | 758.1 / 747.5 / 765.6 → **758.1** | 876.0 / 874.4 / 881.5 → **876.0** | 2467.9 / 2470.4 / 2454.2 → **2467.9** |
| tax_preparation fed | 2050.2 / 2057.8 / 2067.7 → **2057.8** | 2167.6 / 2217.2 / 2195.7 → **2195.7** | 2592.9 / 2632.7 / 2591.9 → **2592.9** | 10541.7 / 10595.9 / 10604.2 → **10595.9** |
| tax_preparation ca | 417.8 / 403.5 / 410.0 → **410.0** | 415.5 / 417.0 / 425.0 → **417.0** | 471.7 / 467.2 / 476.2 → **471.7** | 2088.5 / 2072.7 / 2102.0 → **2088.5** |
| tax_preparation nc | 652.4 / 651.0 / 651.8 → **651.8** | 672.0 / 669.4 / 666.4 → **669.4** | 806.9 / 802.8 / 817.2 → **806.9** | 3340.3 / 3341.7 / 3337.4 → **3340.3** |
| banking | 794.4 / 802.0 / 788.7 → **794.4** | 792.4 / 822.0 / 804.8 → **804.8** | 891.7 / 877.2 / 876.9 → **877.2** | not supported |
| risk_management | 10541.6 / 10520.8 / 10454.2 → **10520.8** | 10704.1 / 10729.2 / 10587.5 → **10704.1** | 14412.5 / 14608.4 / 14406.2 → **14412.5** | not supported |
| telco | 28.2 / 28.4 / 28.6 → **28.4** | 28.3 / 28.2 / 29.0 → **28.3** | 83.0 / 83.1 / 82.2 → **83.0** | not supported |

Ratios of the medians (the `go-decimal-poc` adapter; below 1 is faster),
with those at 43fbd4bf6d in brackets where there are any:

| app | built-in / decimal128-go | built-in / bid754 |
|---|--:|--:|
| euro_conversion | 0.84 (0.82) | 0.30 (0.29) |
| tax_preparation fed | 0.79 (0.78) | 0.19 (0.19) |
| tax_preparation ca | 0.87 (0.89) | 0.20 (0.20) |
| tax_preparation nc | 0.81 (0.85) | 0.20 (0.20) |
| banking | 0.91 | |
| risk_management | 0.73 | |
| telco | 0.34 (0.35) | |

No arithmetic changed between 43fbd4bf6d and this pin, so the movement in
the five benchmarks that ran before is the spread of sessions and the
newer decimal128-go.

Banking was first run with `Compound` computed as the exponential of a
logarithm: 1,537 ns per record against decimal128-go's 842 in one session,
1.8 times slower. Integer powers by repeated squaring (fork b21ad86cee on
the working branch) brought it to the figure above. Risk management went
from 19,431 to about 10,500 with the same change. The functions are
otherwise untuned; `docs/performance.md` has their timings.

## Measurement at the previous pin (2026-11-12, fork `decimal` at 43fbd4bf6d)

Three runner sessions, each building and timing four libraries
interleaved, as in the measurements below. Every golden check passed (21
per session, 63 of 63; the sections below counted 19 per session). The
1-minute load was 9.8–10.8 at the start of each session.

Compute time, ns per record: the three sessions and their median.

| app | built-in, `go-decimal-poc` adapter | built-in, `go-decimal` adapter | miguel-decimal128-go | bid754 |
|---|---|---|---|---|
| euro_conversion | 724.4 / 709.0 / 729.2 → **724.4** | 754.8 / 758.1 / 754.0 → **754.8** | 872.7 / 887.9 / 885.0 → **885.0** | 2485.0 / 2513.3 / 2467.5 → **2485.0** |
| tax_preparation fed | 1949.8 / 1984.7 / 1940.1 → **1949.8** | 2176.5 / 2173.0 / 2170.1 → **2173.0** | 2499.0 / 2379.0 / 2599.4 → **2499.0** | 10058.3 / 9858.3 / 10075.0 → **10058.3** |
| tax_preparation ca | 392.2 / 412.3 / 407.4 → **407.4** | 408.6 / 399.2 / 425.7 → **408.6** | 440.8 / 469.7 / 457.6 → **457.6** | 2002.3 / 2072.3 / 2069.7 → **2069.7** |
| tax_preparation nc | 641.7 / 593.0 / 659.0 → **641.7** | 632.7 / 604.9 / 659.5 → **632.7** | 796.5 / 743.4 / 756.0 → **756.0** | 3140.2 / 3345.0 / 3095.8 → **3140.2** |
| telco | 28.5 / 28.7 / 27.7 → **28.5** | 28.4 / 28.3 / 28.1 → **28.3** | 81.5 / 81.2 / 83.9 → **81.5** | not supported |

Ratios of the medians (the `go-decimal-poc` adapter; below 1 is faster),
with those at e5db2abe94 in brackets:

| app | built-in / decimal128-go | built-in / bid754 |
|---|--:|--:|
| euro_conversion | 0.82 (0.82) | 0.29 (0.29) |
| tax_preparation fed | 0.78 (0.75) | 0.19 (0.19) |
| tax_preparation ca | 0.89 (0.88) | 0.20 (0.21) |
| tax_preparation nc | 0.85 (0.84) | 0.20 (0.20) |
| telco | 0.35 (0.35) | — |

The pin's three changes (formatting by four-digit table entries, a
128-bit quotient step in the remainder, the sign functions on the stored
word) do not show beyond the spread of three sessions here. An interleaved
comparison of the formatting change alone, against a control of the same
tree twice (spread 1.3%), measured these benchmarks 0.3 to 3% faster.

## Measurement at the pin before that (2026-11-12, fork `decimal` at e5db2abe94)

Three runner sessions, each building and timing four libraries
interleaved, as in the measurements below. Every gated row passed (57 of
57 across the three sessions). The 1-minute load was 8.8–9.7 at the start
of each session, about twice that of the next measurement below, and
every library reads several percent higher than there; the ratios are
what compare.

Compute time, ns per record: the three sessions and their median.

| app | built-in, `go-decimal-poc` adapter | built-in, `go-decimal` adapter | miguel-decimal128-go | bid754 |
|---|---|---|---|---|
| euro_conversion | 711.5 / 714.0 / 721.0 → **714.0** | 734.8 / 710.4 / 759.8 → **734.8** | 804.6 / 881.5 / 876.0 → **876.0** | 2460.8 / 2484.6 / 2470.0 → **2470.0** |
| tax_preparation fed | 1863.4 / 1944.5 / 1939.6 → **1939.6** | 1982.4 / 2008.2 / 2101.9 → **2008.2** | 2625.0 / 2425.0 / 2574.4 → **2574.4** | 9511.4 / 10595.8 / 10212.2 → **10212.2** |
| tax_preparation ca | 383.1 / 412.8 / 408.4 → **408.4** | 418.3 / 403.8 / 412.2 → **412.2** | 439.1 / 464.3 / 463.9 → **463.9** | 1887.4 / 2071.4 / 1932.4 → **1932.4** |
| tax_preparation nc | 615.6 / 654.6 / 633.9 → **633.9** | 626.8 / 643.1 / 674.4 → **643.1** | 781.4 / 758.8 / 739.7 → **758.8** | 3239.3 / 3141.7 / 3188.8 → **3188.8** |
| telco | 28.5 / 28.9 / 28.7 → **28.7** | 28.6 / 28.8 / 29.1 → **28.8** | 81.1 / 81.3 / 82.5 → **81.3** | not supported |

Ratios of the medians (the `go-decimal-poc` adapter; below 1 is faster),
with those of the measurement below in brackets:

| app | built-in / decimal128-go | built-in / bid754 |
|---|--:|--:|
| euro_conversion | 0.82 (0.79) | 0.29 (0.27) |
| tax_preparation fed | 0.75 (0.79) | 0.19 (0.20) |
| tax_preparation ca | 0.88 (0.85) | 0.21 (0.20) |
| tax_preparation nc | 0.84 (0.83) | 0.20 (0.20) |
| telco | 0.35 (0.35) | — |

A session at the pin before this one, a26c7815c8 (load 8.9–10.8, 57 of 57
gates), gave 724.0, 2048.5, 412.2, 654.0 and 28.7 for the built-in type
and 878.1, 2580.1, 460.6, 783.8 and 82.5 for miguel-decimal128-go: the
kernel's changes between the two pins, the quantize of a long coefficient
among them, show on the federal form, 0.79 to 0.75 of decimal128-go's
time, and nowhere else beyond the spread of the sessions.

## Measurement after the last tuning pass (2026-11-11, fork `perf/t13-final` at 6e1004c73a)

Three runner sessions, each building and timing four libraries interleaved,
as in the measurement below. Every gated row passed (57 of 57
across the three sessions). The 1-minute load was 4.00–4.91 at the start
of each session; the sessions ran 18:26–18:29 UTC on 2026-11-10 with no
other builds or benchmarks on the machine.

Compute time, ns per record: the three sessions and their median.

| app | built-in, `go-decimal-poc` adapter | built-in, `go-decimal` adapter | miguel-decimal128-go | bid754 |
|---|---|---|---|---|
| euro_conversion | 671.0 / 708.1 / 654.0 → **671.0** | 767.3 / 809.2 / 776.0 → **776.0** | 845.4 / 882.5 / 808.3 → **845.4** | 2288.3 / 2491.2 / 2462.9 → **2462.9** |
| tax_preparation fed | 1853.3 / 1873.4 / 2005.0 → **1873.4** | 2063.8 / 2043.3 / 2031.5 → **2043.3** | 2293.6 / 2421.6 / 2368.0 → **2368.0** | 9511.4 / 9439.4 / 9462.2 → **9462.2** |
| tax_preparation ca | 373.1 / 374.1 / 389.2 → **374.1** | 387.5 / 432.0 / 414.4 → **414.4** | 413.3 / 464.6 / 438.9 → **438.9** | 1860.1 / 1940.7 / 1879.6 → **1879.6** |
| tax_preparation nc | 627.7 / 594.2 / 606.6 → **606.6** | 634.9 / 662.4 / 628.4 → **634.9** | 755.9 / 703.0 / 727.8 → **727.8** | 2994.9 / 3006.3 / 3046.7 → **3006.3** |
| telco | 28.3 / 28.4 / 28.8 → **28.4** | 27.9 / 28.2 / 27.7 → **27.9** | 80.8 / 79.7 / 80.3 → **80.3** | not supported |

Ratios of the medians (the `go-decimal-poc` adapter; below 1 is faster):

| app | built-in / decimal128-go | built-in / bid754 |
|---|--:|--:|
| euro_conversion | 0.79 | 0.27 |
| tax_preparation fed | 0.79 | 0.20 |
| tax_preparation ca | 0.85 | 0.20 |
| tax_preparation nc | 0.83 | 0.20 |
| telco | 0.35 | — |

The last pass gave the kernel's division, addition and multiplication of
decimal128 a straight path each and found exact quotients without the long
division; against the measurement below, the built-in type's compute time
fell by 9% on euro conversion, 12% on federal tax, 16% and 20% on the two
state forms and 15% on telco, and it is now ahead of decimal128-go on all
five.

## Measurement of 2026-11-10 (fork `perf/t13-final` at 7262cd2876)

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

## Benchmarks the fork could not run before a403f0b413

Until that pin `math/decimal` had no powers or logarithms, so
risk_management (which needs `Decimal128.Pow`, and `Decimal128.PowInt`
for integral exponents) and banking (`Decimal128.Log10` for the mortgage
term and `Decimal128.Compound` for (1+r)^n) did not run, and the
measurements below this section's date have five benchmarks. They run
now: see the first section.

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
