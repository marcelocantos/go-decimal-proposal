# perf-compare: decimal128 implementations side by side

Measures the Go decimal fork's built-in `decimal128` (and its kernel,
`internal/bid`) against the other decimal128 implementations named in
golang/go#19787, on identical operations and operands, in one harness. It is
measurement only: no kernel code is changed. Feeds 🎯T13 and the proposal's
Performance section.

## Candidates

| impl (row name) | what | version |
|---|---|---|
| `fork` | built-in `decimal128` operators `+ - * / <` | fork `760cdc9669` (branch `perf/t13-final`) |
| `fork-mathdecimal` | `math/decimal.FMA`, `math/decimal.Quantize` | same |
| `fork-strconv` | `strconv.ParseDecimal`, `strconv.AppendDecimal` (reused buffer) | same |
| `fork-strconv-string` | `strconv.FormatDecimal` (returns a new string) | same |
| `fork-fmt` | `fmt.Sprint(x)` | same |
| kernel (`bid.test`) | `internal/bid` rows of its own `BenchmarkKernel`, own operand classes | same |
| `decimal128-go` | github.com/migueldecimal128/decimal128-go | local clone `fd4b1bb` |
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

## Results (2026-11-11, Apple M4 Max, macOS 26)

12 interleaved rounds, benchtime 500ms, with the fork at 6e1004c73a
(branch `perf/t13-final`, the tuned kernel) and no other builds or
benchmarks running: the 1-minute load was 4.5–8.3 at the start of every
round (`results/uptime.txt`). Earlier runs of this harness, at the fork's
32c1829380 on a loaded machine and at 760cdc9669 before the last tuning
pass, are in this file's git history; the chart in the proposal README uses
the first one's fork column as "before".

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
| float64 | 0.43 ± 2% | 0 | 0.43 ± 1% | 0 | 0.43 ± 3% | 0 | — | — | — | — |
| fork | 0.66 ± 1% | 0 | 6.58 ± 3% | 0 | 6.97 ± 2% | 0 | 4.85 ± 2% | 0 | 11.8 ± 2% | 0 |
| decimal128-go | 1.22 ± 1% | 0 | 18.8 ± 2% | 0 | 8.64 ± 2% | 0 | 9.20 ± 2% | 0 | 44.1 ± 4% | 0 |
| bid754 | 12.4 ± 3% | 0 | 37.2 ± 1% | 0 | 13.9 ± 3% | 0 | 33.8 ± 4% | 0 | 65.0 ± 6% | 0 |
| intel-cgo | 22.6 ± 3% | 0 | 27.9 ± 3% | 0 | 23.9 ± 2% | 0 | — | — | — | — |
| intel-cloop | 5.79 ± 1% | 0 | 11.3 ± 2% | 0 | 6.32 ± 3% | 0 | 24.1 ± 5% | 0 | 33.8 ± 3% | 0 |
| decquad-cgo | 27.3 ± 2% | 0 | 60.7 ± 3% | 0 | 46.6 ± 4% | 0 | — | — | — | — |
| decquad-cloop | 7.76 ± 2% | 0 | 31.8 ± 1% | 0 | 26.1 ± 1% | 0 | 28.4 ± 2% | 0 | 52.3 ± 4% | 0 |
| shopspring | 20.9 ± 8% | 2 | 31.2 ± 4% | 2 | 35.3 ± 3% | 2 | — | — | — | — |

### Cgo

| impl | empty ns/op | allocs | binary ns/op | allocs |
|---|--:|--:|--:|--:|
| cgo-nop | 13.0 ± 2% | 0 | 21.7 ± 4% | 0 |

### Div

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | pow10 ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 2% | 0 | 0.43 ± 3% | 0 | 0.43 ± 4% | 0 | 0.43 ± 5% | 0 | — | — | — | — |
| fork | 7.98 ± 2% | 0 | 20.0 ± 2% | 0 | 8.06 ± 2% | 0 | 5.70 ± 4% | 0 | 12.9 ± 1% | 0 | 22.8 ± 3% | 0 |
| decimal128-go | 22.1 ± 2% | 0 | 31.4 ± 1% | 0 | 25.5 ± 4% | 0 | 9.83 ± 1% | 0 | 50.5 ± 2% | 0 | 60.6 ± 1% | 0 |
| bid754 | 156 ± 2% | 0 | 147 ± 3% | 0 | 159 ± 4% | 0 | 138 ± 1% | 0 | 167 ± 3% | 0 | 172 ± 2% | 0 |
| intel-cgo | 68.4 ± 1% | 0 | 55.7 ± 2% | 0 | 55.7 ± 3% | 0 | 69.4 ± 3% | 0 | — | — | — | — |
| intel-cloop | 33.9 ± 4% | 0 | 31.4 ± 3% | 0 | 31.6 ± 7% | 0 | 43.6 ± 3% | 0 | 39.7 ± 4% | 0 | 38.6 ± 3% | 0 |
| decquad-cgo | 84.1 ± 3% | 0 | 156 ± 1% | 0 | 80.8 ± 4% | 0 | 49.1 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 61.4 ± 6% | 0 | 118 ± 2% | 0 | 58.9 ± 3% | 0 | 30.5 ± 5% | 0 | 77.1 ± 3% | 0 | 184 ± 2% | 0 |
| shopspring | 81.9 ± 7% | 7 | 168 ± 3% | 8 | 99.6 ± 5% | 7 | 59.4 ± 4% | 4 | — | — | — | — |

### FMA

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 4.08 ± 3% | 0 | 16.7 ± 3% | 0 | 10.9 ± 2% | 0 |
| decimal128-go | 7.21 ± 3% | 0 | 37.2 ± 2% | 0 | 23.8 ± 2% | 0 |
| bid754 | 62.9 ± 2% | 0 | 153 ± 3% | 0 | 67.5 ± 6% | 0 |
| intel-cgo | 36.0 ± 2% | 0 | 68.5 ± 3% | 0 | 40.8 ± 4% | 0 |
| intel-cloop | 17.6 ± 3% | 0 | 47.0 ± 3% | 0 | 19.6 ± 2% | 0 |
| decquad-cgo | 50.7 ± 1% | 0 | 130 ± 2% | 0 | 67.9 ± 1% | 0 |
| decquad-cloop | 23.7 ± 6% | 0 | 96.4 ± 3% | 0 | 39.4 ± 6% | 0 |

### Fmt

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| fork-fmt | 34.0 ± 2% | 2 | 51.7 ± 4% | 2 |

### Format

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 28.3 ± 3% | 0 | 19.5 ± 4% | 0 |
| fork-strconv | 6.56 ± 2% | 0 | 20.8 ± 1% | 0 |
| fork-strconv-string | 11.6 ± 5% | 1 | 28.9 ± 2% | 1 |
| decimal128-go | 14.7 ± 3% | 1 | 31.2 ± 2% | 1 |
| bid754 | 20.0 ± 2% | 1 | 58.1 ± 1% | 1 |
| intel-cgo | 21.8 ± 4% | 0 | 42.7 ± 2% | 0 |
| intel-cloop | 5.06 ± 2% | 0 | 23.7 ± 2% | 0 |
| decquad-cgo | 22.6 ± 2% | 0 | 22.5 ± 2% | 0 |
| decquad-cloop | 6.02 ± 5% | 0 | 6.16 ± 2% | 0 |
| shopspring | 52.5 ± 2% | 2 | 78.2 ± 3% | 3 |

### Less

| impl | money ns/op | allocs | full ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 1% | 0 | 0.43 ± 2% | 0 | — | — | — | — |
| fork | 1.74 ± 2% | 0 | 4.34 ± 4% | 0 | 2.53 ± 2% | 0 | 6.03 ± 1% | 0 |
| decimal128-go | 5.66 ± 3% | 0 | 5.37 ± 5% | 0 | 14.1 ± 2% | 0 | 14.7 ± 3% | 0 |
| bid754 | 6.35 ± 3% | 0 | 11.2 ± 2% | 0 | 14.3 ± 2% | 0 | 22.3 ± 7% | 0 |
| intel-cgo | 19.8 ± 2% | 0 | 20.5 ± 5% | 0 | — | — | — | — |
| intel-cloop | 2.43 ± 2% | 0 | 3.98 ± 3% | 0 | 5.77 ± 1% | 0 | 9.21 ± 5% | 0 |
| decquad-cgo | 28.4 ± 1% | 0 | 26.4 ± 5% | 0 | — | — | — | — |
| decquad-cloop | 8.34 ± 1% | 0 | 10.2 ± 4% | 0 | 16.9 ± 2% | 0 | 15.8 ± 2% | 0 |
| shopspring | 3.13 ± 4% | 0 | 19.4 ± 7% | 1 | — | — | — | — |

### Mul

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 2% | 0 | 0.42 ± 1% | 0 | 0.43 ± 4% | 0 | — | — | — | — |
| fork | 1.32 ± 3% | 0 | 8.80 ± 2% | 0 | 1.33 ± 1% | 0 | 2.20 ± 1% | 0 | 12.5 ± 6% | 0 |
| decimal128-go | 1.59 ± 2% | 0 | 28.8 ± 3% | 0 | 1.58 ± 1% | 0 | 3.62 ± 4% | 0 | 41.3 ± 2% | 0 |
| bid754 | 27.3 ± 3% | 0 | 123 ± 2% | 0 | 27.4 ± 1% | 0 | 40.1 ± 2% | 0 | 151 ± 1% | 0 |
| intel-cgo | 28.9 ± 4% | 0 | 49.8 ± 1% | 0 | 28.9 ± 1% | 0 | — | — | — | — |
| intel-cloop | 12.4 ± 3% | 0 | 29.2 ± 2% | 0 | 12.7 ± 2% | 0 | 22.9 ± 3% | 0 | 46.9 ± 1% | 0 |
| decquad-cgo | 32.4 ± 3% | 0 | 53.0 ± 2% | 0 | 41.9 ± 3% | 0 | — | — | — | — |
| decquad-cloop | 12.5 ± 2% | 0 | 29.5 ± 1% | 0 | 14.4 ± 3% | 0 | 32.6 ± 5% | 0 | 53.4 ± 3% | 0 |
| shopspring | 21.8 ± 6% | 2 | 30.2 ± 6% | 2 | 22.2 ± 5% | 2 | — | — | — | — |

### Parse

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 12.5 ± 3% | 0 | 36.8 ± 2% | 0 |
| fork-strconv | 6.02 ± 4% | 0 | 16.2 ± 2% | 0 |
| decimal128-go | 17.8 ± 2% | 0 | 54.5 ± 1% | 0 |
| bid754 | 33.8 ± 1% | 0 | 83.9 ± 3% | 0 |
| intel-cgo | 24.9 ± 2% | 0 | 41.3 ± 2% | 0 |
| intel-cloop | 8.88 ± 3% | 0 | 25.3 ± 3% | 0 |
| decquad-cgo | 26.0 ± 2% | 0 | 35.2 ± 4% | 0 |
| decquad-cloop | 10.8 ± 2% | 0 | 18.6 ± 4% | 0 |
| shopspring | 28.5 ± 5% | 2 | 244 ± 2% | 4 |

### Quantize

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 0.89 ± 1% | 0 | 3.73 ± 4% | 0 | 3.23 ± 3% | 0 |
| decimal128-go | 1.96 ± 5% | 0 | 3.26 ± 4% | 0 | 5.70 ± 1% | 0 |
| bid754 | 23.1 ± 2% | 0 | 15.8 ± 3% | 0 | 23.0 ± 2% | 0 |
| intel-cgo | 22.0 ± 2% | 0 | 21.6 ± 2% | 0 | 22.0 ± 2% | 0 |
| intel-cloop | 3.07 ± 3% | 0 | 2.83 ± 6% | 0 | 3.13 ± 6% | 0 |
| decquad-cgo | 23.2 ± 2% | 0 | 24.6 ± 4% | 0 | 31.7 ± 4% | 0 |
| decquad-cloop | 4.87 ± 4% | 0 | 5.15 ± 5% | 0 | 10.8 ± 6% | 0 |

### Sub

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 3% | 0 | 0.43 ± 1% | 0 | 0.44 ± 6% | 0 | — | — | — | — |
| fork | 1.02 ± 2% | 0 | 7.95 ± 2% | 0 | 7.27 ± 4% | 0 | 4.97 ± 4% | 0 | 12.5 ± 2% | 0 |
| decimal128-go | 1.86 ± 2% | 0 | 19.0 ± 4% | 0 | 12.4 ± 2% | 0 | 8.96 ± 1% | 0 | 44.8 ± 4% | 0 |
| bid754 | 14.3 ± 4% | 0 | 41.1 ± 5% | 0 | 15.9 ± 1% | 0 | 38.0 ± 2% | 0 | 66.9 ± 2% | 0 |
| intel-cgo | 23.0 ± 3% | 0 | 30.6 ± 4% | 0 | 24.3 ± 4% | 0 | — | — | — | — |
| intel-cloop | 6.18 ± 2% | 0 | 12.8 ± 2% | 0 | 6.61 ± 3% | 0 | 24.8 ± 3% | 0 | 34.1 ± 1% | 0 |
| decquad-cgo | 46.0 ± 5% | 0 | 74.1 ± 2% | 0 | 54.9 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 19.5 ± 6% | 0 | 40.3 ± 4% | 0 | 32.8 ± 2% | 0 | 30.9 ± 3% | 0 | 54.5 ± 2% | 0 |

