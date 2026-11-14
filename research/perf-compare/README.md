# perf-compare: decimal128 implementations side by side

Measures the Go decimal fork's built-in `decimal128` (and its kernel,
`internal/bid`) against the other decimal128 implementations named in
golang/go#19787, on identical operations and operands, in one harness. It is
measurement only: no kernel code is changed. Feeds 🎯T13 and the proposal's
Performance section.

## Candidates

| impl (row name) | what | version |
|---|---|---|
| `fork` | built-in `decimal128` operators `+ - * / <` | fork `61de57f7d1` (branch `decimal`) |
| `fork-mathdecimal` | `math/decimal.FMA`, `math/decimal.Quantize` | same |
| `fork-strconv` | `strconv.ParseDecimal`, `strconv.AppendDecimal` (reused buffer) | same |
| `fork-strconv-string` | `strconv.FormatDecimal` (returns a new string) | same |
| `fork-fmt` | `fmt.Sprint(x)` | same |
| kernel (`bid.test`) | `internal/bid` rows of its own `BenchmarkKernel`, own operand classes | same |
| `decimal128-go` | github.com/migueldecimal128/decimal128-go | local clone `da6575c` (2026-11-12, its `main` at the run) |
| `bid754` | github.com/sky1core/bid754/bid754-go (pure-Go port of Intel libbid) | v0.2.0 |
| `intel-cgo`, `intel-cloop` | Intel RDFP Math Library v2.3 (xmake-mirror `ffca6d2`), clang -O2 | |
| `decquad-cgo`, `decquad-cloop` | decNumber 3.68 (ICU) decQuad, clang -O3 | |
| `shopspring` | github.com/shopspring/decimal (arbitrary precision) | v1.6.0 |
| `float64` | hardware binary64 | |
| `cgo-nop` | empty cgo call (`empty`) and a cgo call passing two 16-byte structs and returning one (`binary`) | |

`-cgo` rows make one cgo call per operation; `-cloop` rows run the whole loop
in C (one cgo call per benchmark), so `-cloop` is the C library's own cost.

## Operand sets

Defined once in `operands.go`. Every operand has four variants differing
only in the last coefficient digit; loops index them with `i&3` so nothing
can constant-fold.

- **money** (a): `1234.56` and `78.90`.
- **full** (b): `1234567890123456789012345678901234` and
  `9876543210987654321098765432109876E-4` (34 digits each, exponents 0 and −4).
- **far** (c): `1.23456789E+30` and `9.87654321E-30`.
- **pow10** (d): `123456.789 / 1000` (Div only).

Four variants of one pair are learned by a branch predictor, so those sets
show every branch on the operands' digits as if it were always predicted.
Two more sets (`drawn_test.go`) say what the operations cost on data
without a pattern: pools of 1024 random operand pairs, indexed by a
xorshift generator, so that no predictor can learn the order.

- **drawn-money**: amounts with two places and 3 to 9 digits, random signs.
- **drawn-full**: 34 random digits each, exponents 1 to 12 apart either way,
  random signs.

Add, Sub, Mul, Div and Less run on both, for the fork, decimal128-go,
bid754 and the two C libraries, whose loops draw from the same pools
inside C. Every row carries about 2 ns of the generator, the same for each
candidate.

Operations: Add, Sub, Mul, FMA (`x*y + y`), Quantize (`x` to quantum
`0.01`) on money/full/far; Div on all four; Less (`x < y`) on money/full;
Parse and Format on the `x` text of money/full.

`TestSameResults` checks that every IEEE candidate (fork, decimal128-go,
bid754, Intel, decQuad) returns the same decimal128, quantum included, for
every benchmarked operation and variant. shopspring and float64 are not
checked (different arithmetic; shopspring divides to 16 places).
`TestRandomAgreement` makes the same comparison on 3000 random operand
pairs of each of six shapes (money, money and a rate, full precision at
nearby and equal exponents, mixed lengths, far exponents) in seven
operations: 18,000 pairs with no mismatch at the measured tip.

## Rerun

Prerequisites:

```sh
# the fork toolchain, at the commit under test
git clone https://github.com/marcelocantos/go "$HOME/go-decimal" && (cd "$HOME/go-decimal/src" && CGO_ENABLED=0 GOTOOLCHAIN=local ./make.bash)
# Intel's library and decNumber, fetched and built into third_party/ (ignored by git)
./fetch-libs.sh
go install golang.org/x/perf/cmd/benchstat@latest
```

Then, from this directory:

```sh
FORK=$HOME/go-decimal . ./env.sh && CGO_ENABLED=1 go test -run TestSameResults .   # results agree
./run.sh 12 500ms          # 12 interleaved rounds; writes results/
benchstat -col /impl -row /set results/compare.txt
benchstat results/kernel.txt
```

`run.sh` builds `perfcompare.test` and the kernel's `bid.test`
(`go test -c ./internal/bid` in the fork tree) and, in each round, runs every
row of the first once and then the kernel rows once, so all candidates see
the same machine conditions. `results/uptime.txt` records the load before,
during and after.

## Results (2026-11-14, Apple M4 Max, macOS 26)

12 interleaved rounds, benchtime 500ms, with the fork at the pin,
61de57f7d1 (branch `decimal`), and decimal128-go at `da6575c`, the head
of its `main` on the day. No other builds or benchmarks were running;
the 1-minute load was 7.7–27.0 at the start of the rounds, from the
machine's resident daemons (`results/uptime.txt`). The previous run, at
43fbd4bf6d with decimal128-go at `fd4b1bb`, and earlier ones at the
fork's 32c1829380 on a loaded machine, at 760cdc9669, at 6e1004c73a, at
a26c7815c8 and at e5db2abe94 (load 8.0–9.9), are in this file's git
history; the chart in the proposal README uses the first one's fork
column as "before". No arithmetic changed between 43fbd4bf6d and
61de57f7d1, and the fork's rows moved by at most 3.5%. Of decimal128-go's
rows, two moved by more than 4%, both parsing: a money amount from 18.5
to 19.5 ns and 34 digits from 55.2 to 65.3.
`results/format-d8a1ae4a2b.txt` is a session of the formatting rows alone
at the previous pin.

Raw inputs: `results/compare.txt` (perfcompare.test), `results/kernel.txt`
(bid.test); `results/compare-byop.txt` is the first with names regrouped by
operation for benchstat. Tables: `results/tables.md` (from
`go run ./cmd/table results/bs-*.csv`), `results/kernel-benchstat.txt`.

The loop floor of this harness is the float64 row, about 0.44 ns. The
kernel's own benchmark documents a floor of about 0.3 ns; its rows use its
own operand classes (pools of 1024: `mixed` has random coefficient lengths
1–34 digits and exponents within ±4; Add/Sub `mixed` is 70% exponents
within 4, 20% spread over ±44, 10% equal; `far` is 1E+3000 + −1.5E−3000
rounded toward zero; Div `inexact` is two 34-digit coefficients, `exact` is
8.00/2, `widest` is 1/(34 nines); Parse `short` is "123.456", `long` is
"1234567890123456789012345678901234.5678"), so they compare with the rows
here only approximately.

The UW-Madison application benchmark is in `results/uw-madison-fork.md`
(the fork beside decimal128-go and bid754, under the fork toolchain) and
`results/uw-madison-arm64.md` (the earlier run of decimal128-go and bid754
alone under go1.27.3); both ran in a separate clone of that (GPL)
repository, and nothing from it is copied here but its output tables.

### Add

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 2% | 0 | 0.43 ± 0% | 0 | 0.45 ± 3% | 0 | — | — | — | — |
| fork | 0.67 ± 3% | 0 | 6.65 ± 1% | 0 | 4.26 ± 2% | 0 | 4.88 ± 3% | 0 | 11.9 ± 1% | 0 |
| decimal128-go | 1.23 ± 2% | 0 | 19.3 ± 3% | 0 | 8.89 ± 5% | 0 | 9.36 ± 2% | 0 | 44.3 ± 2% | 0 |
| bid754 | 12.4 ± 3% | 0 | 37.4 ± 3% | 0 | 13.8 ± 3% | 0 | 34.3 ± 1% | 0 | 64.5 ± 1% | 0 |
| intel-cgo | 23.1 ± 2% | 0 | 28.5 ± 2% | 0 | 23.8 ± 2% | 0 | — | — | — | — |
| intel-cloop | 5.88 ± 3% | 0 | 11.3 ± 1% | 0 | 6.35 ± 1% | 0 | 24.7 ± 2% | 0 | 33.5 ± 2% | 0 |
| decquad-cgo | 27.6 ± 2% | 0 | 62.0 ± 1% | 0 | 46.8 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 7.82 ± 2% | 0 | 31.7 ± 1% | 0 | 26.4 ± 3% | 0 | 28.9 ± 2% | 0 | 51.7 ± 1% | 0 |
| shopspring | 21.9 ± 3% | 2 | 31.7 ± 2% | 2 | 36.4 ± 2% | 2 | — | — | — | — |

### Cgo

| impl | empty ns/op | allocs | binary ns/op | allocs |
|---|--:|--:|--:|--:|
| cgo-nop | 12.9 ± 1% | 0 | 21.4 ± 1% | 0 |

### Div

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | pow10 ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 2% | 0 | 0.43 ± 2% | 0 | 0.43 ± 3% | 0 | 0.44 ± 2% | 0 | — | — | — | — |
| fork | 8.11 ± 1% | 0 | 19.1 ± 3% | 0 | 8.29 ± 2% | 0 | 5.91 ± 3% | 0 | 13.1 ± 2% | 0 | 21.9 ± 2% | 0 |
| decimal128-go | 22.1 ± 1% | 0 | 32.0 ± 3% | 0 | 25.7 ± 3% | 0 | 10.3 ± 2% | 0 | 50.6 ± 1% | 0 | 61.6 ± 3% | 0 |
| bid754 | 156 ± 2% | 0 | 149 ± 2% | 0 | 160 ± 1% | 0 | 140 ± 1% | 0 | 166 ± 3% | 0 | 172 ± 1% | 0 |
| intel-cgo | 68.7 ± 1% | 0 | 55.9 ± 1% | 0 | 56.0 ± 2% | 0 | 69.8 ± 1% | 0 | — | — | — | — |
| intel-cloop | 34.0 ± 3% | 0 | 31.6 ± 5% | 0 | 31.9 ± 1% | 0 | 43.7 ± 3% | 0 | 39.8 ± 1% | 0 | 38.8 ± 1% | 0 |
| decquad-cgo | 85.0 ± 3% | 0 | 158 ± 2% | 0 | 78.7 ± 1% | 0 | 49.3 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 62.7 ± 2% | 0 | 120 ± 1% | 0 | 57.4 ± 1% | 0 | 30.8 ± 2% | 0 | 76.8 ± 3% | 0 | 188 ± 3% | 0 |
| shopspring | 85.7 ± 2% | 7 | 172 ± 3% | 8 | 100 ± 3% | 7 | 60.7 ± 2% | 4 | — | — | — | — |

### FMA

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 4.14 ± 2% | 0 | 10.5 ± 1% | 0 | 11.6 ± 2% | 0 |
| decimal128-go | 7.52 ± 3% | 0 | 37.8 ± 1% | 0 | 23.9 ± 3% | 0 |
| bid754 | 63.5 ± 3% | 0 | 152 ± 3% | 0 | 67.9 ± 2% | 0 |
| intel-cgo | 36.3 ± 2% | 0 | 68.7 ± 2% | 0 | 41.6 ± 2% | 0 |
| intel-cloop | 17.6 ± 3% | 0 | 46.9 ± 3% | 0 | 20.4 ± 2% | 0 |
| decquad-cgo | 51.3 ± 3% | 0 | 131 ± 2% | 0 | 68.8 ± 2% | 0 |
| decquad-cloop | 23.6 ± 4% | 0 | 97.2 ± 1% | 0 | 39.9 ± 3% | 0 |

### Fmt

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| fork-fmt | 33.6 ± 3% | 2 | 39.9 ± 4% | 2 |

### Format

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 28.2 ± 3% | 0 | 19.4 ± 7% | 0 |
| fork-strconv | 5.17 ± 2% | 0 | 9.81 ± 4% | 0 |
| fork-strconv-string | 11.1 ± 3% | 1 | 18.2 ± 3% | 1 |
| decimal128-go | 14.7 ± 3% | 1 | 32.0 ± 3% | 1 |
| bid754 | 20.2 ± 3% | 1 | 59.3 ± 3% | 1 |
| intel-cgo | 21.7 ± 3% | 0 | 42.4 ± 2% | 0 |
| intel-cloop | 5.07 ± 2% | 0 | 23.6 ± 0% | 0 |
| decquad-cgo | 23.0 ± 1% | 0 | 22.5 ± 1% | 0 |
| decquad-cloop | 6.32 ± 3% | 0 | 5.97 ± 2% | 0 |
| shopspring | 52.2 ± 1% | 2 | 79.6 ± 3% | 3 |

### Less

| impl | money ns/op | allocs | full ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 3% | 0 | 0.43 ± 0% | 0 | — | — | — | — |
| fork | 1.72 ± 3% | 0 | 3.73 ± 2% | 0 | 2.55 ± 2% | 0 | 5.41 ± 1% | 0 |
| decimal128-go | 5.70 ± 2% | 0 | 5.33 ± 2% | 0 | 14.3 ± 2% | 0 | 14.9 ± 1% | 0 |
| bid754 | 6.33 ± 1% | 0 | 11.3 ± 2% | 0 | 14.6 ± 4% | 0 | 22.5 ± 3% | 0 |
| intel-cgo | 20.1 ± 1% | 0 | 20.6 ± 2% | 0 | — | — | — | — |
| intel-cloop | 2.42 ± 2% | 0 | 4.00 ± 3% | 0 | 5.85 ± 2% | 0 | 9.25 ± 1% | 0 |
| decquad-cgo | 28.8 ± 2% | 0 | 26.5 ± 3% | 0 | — | — | — | — |
| decquad-cloop | 8.39 ± 2% | 0 | 10.2 ± 2% | 0 | 17.1 ± 2% | 0 | 15.8 ± 2% | 0 |
| shopspring | 3.19 ± 3% | 0 | 20.1 ± 3% | 1 | — | — | — | — |

### Mul

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 2% | 0 | 0.43 ± 1% | 0 | 0.44 ± 2% | 0 | — | — | — | — |
| fork | 1.34 ± 2% | 0 | 7.86 ± 3% | 0 | 1.34 ± 2% | 0 | 2.23 ± 2% | 0 | 12.6 ± 2% | 0 |
| decimal128-go | 1.59 ± 1% | 0 | 29.5 ± 2% | 0 | 1.59 ± 1% | 0 | 3.63 ± 1% | 0 | 41.6 ± 2% | 0 |
| bid754 | 27.6 ± 2% | 0 | 125 ± 2% | 0 | 27.7 ± 1% | 0 | 40.7 ± 2% | 0 | 153 ± 1% | 0 |
| intel-cgo | 29.0 ± 1% | 0 | 50.7 ± 1% | 0 | 29.1 ± 2% | 0 | — | — | — | — |
| intel-cloop | 12.7 ± 2% | 0 | 29.5 ± 3% | 0 | 12.7 ± 2% | 0 | 23.0 ± 1% | 0 | 47.7 ± 4% | 0 |
| decquad-cgo | 32.3 ± 2% | 0 | 53.3 ± 1% | 0 | 41.8 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 12.6 ± 2% | 0 | 29.5 ± 3% | 0 | 14.5 ± 2% | 0 | 33.1 ± 1% | 0 | 52.7 ± 2% | 0 |
| shopspring | 22.6 ± 3% | 2 | 30.3 ± 3% | 2 | 23.1 ± 2% | 2 | — | — | — | — |

### Parse

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 12.6 ± 3% | 0 | 37.0 ± 1% | 0 |
| fork-strconv | 6.02 ± 3% | 0 | 16.4 ± 2% | 0 |
| decimal128-go | 19.5 ± 2% | 0 | 65.3 ± 2% | 0 |
| bid754 | 34.0 ± 2% | 0 | 84.2 ± 2% | 0 |
| intel-cgo | 25.1 ± 2% | 0 | 41.8 ± 1% | 0 |
| intel-cloop | 8.80 ± 2% | 0 | 25.4 ± 1% | 0 |
| decquad-cgo | 26.2 ± 1% | 0 | 35.1 ± 3% | 0 |
| decquad-cloop | 10.9 ± 3% | 0 | 18.8 ± 1% | 0 |
| shopspring | 29.9 ± 4% | 2 | 246 ± 2% | 4 |

### Quantize

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 0.82 ± 4% | 0 | 2.39 ± 2% | 0 | 3.33 ± 2% | 0 |
| decimal128-go | 1.67 ± 5% | 0 | 2.99 ± 3% | 0 | 5.51 ± 4% | 0 |
| bid754 | 23.3 ± 2% | 0 | 16.0 ± 3% | 0 | 23.1 ± 1% | 0 |
| intel-cgo | 22.1 ± 1% | 0 | 21.9 ± 0% | 0 | 21.9 ± 2% | 0 |
| intel-cloop | 3.19 ± 7% | 0 | 2.87 ± 5% | 0 | 3.16 ± 4% | 0 |
| decquad-cgo | 23.2 ± 2% | 0 | 25.1 ± 4% | 0 | 32.0 ± 2% | 0 |
| decquad-cloop | 5.05 ± 6% | 0 | 5.22 ± 1% | 0 | 9.68 ± 4% | 0 |

### Sub

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.44 ± 3% | 0 | 0.43 ± 2% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 1.04 ± 2% | 0 | 8.01 ± 3% | 0 | 4.37 ± 1% | 0 | 4.98 ± 2% | 0 | 12.6 ± 2% | 0 |
| decimal128-go | 1.90 ± 3% | 0 | 18.4 ± 2% | 0 | 12.4 ± 2% | 0 | 8.91 ± 2% | 0 | 44.6 ± 1% | 0 |
| bid754 | 14.3 ± 2% | 0 | 41.3 ± 1% | 0 | 15.8 ± 1% | 0 | 39.2 ± 3% | 0 | 67.0 ± 2% | 0 |
| intel-cgo | 23.3 ± 2% | 0 | 30.3 ± 2% | 0 | 24.6 ± 1% | 0 | — | — | — | — |
| intel-cloop | 6.18 ± 2% | 0 | 12.8 ± 3% | 0 | 6.67 ± 2% | 0 | 25.2 ± 3% | 0 | 34.4 ± 2% | 0 |
| decquad-cgo | 46.8 ± 1% | 0 | 75.9 ± 2% | 0 | 56.1 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 20.2 ± 3% | 0 | 41.4 ± 3% | 0 | 33.2 ± 1% | 0 | 31.1 ± 3% | 0 | 54.9 ± 2% | 0 |

