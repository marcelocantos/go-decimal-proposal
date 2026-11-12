# perf-compare: decimal128 implementations side by side

Measures the Go decimal fork's built-in `decimal128` (and its kernel,
`internal/bid`) against the other decimal128 implementations named in
golang/go#19787, on identical operations and operands, in one harness. It is
measurement only: no kernel code is changed. Feeds 🎯T13 and the proposal's
Performance section.

## Candidates

| impl (row name) | what | version |
|---|---|---|
| `fork` | built-in `decimal128` operators `+ - * / <` | fork `43fbd4bf6d` (branch `decimal`); the pin since, `a403f0b413`, changes no arithmetic |
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

## Results (2026-11-12, Apple M4 Max, macOS 26)

12 interleaved rounds, benchtime 500ms, with the fork at 43fbd4bf6d
(branch `decimal`; the same tree as 74ea5785c0 on `perf/t13-final`) and
no other builds or benchmarks running: the 1-minute load was 7.3–24.2 at
the start of the rounds, from the machine's resident daemons and a Time
Machine backup (`results/uptime.txt`). Earlier runs of this harness, at
the fork's 32c1829380 on a loaded machine, at 760cdc9669, at 6e1004c73a,
at a26c7815c8 and at e5db2abe94 (load 8.0–9.9), are in this file's git history; the chart in the proposal
README uses the first one's fork column as "before".
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
| float64 | 0.43 ± 2% | 0 | 0.44 ± 2% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 0.68 ± 3% | 0 | 6.66 ± 3% | 0 | 4.32 ± 3% | 0 | 5.00 ± 3% | 0 | 11.9 ± 1% | 0 |
| decimal128-go | 1.28 ± 2% | 0 | 18.8 ± 1% | 0 | 8.72 ± 3% | 0 | 9.60 ± 3% | 0 | 44.7 ± 3% | 0 |
| bid754 | 12.5 ± 3% | 0 | 37.6 ± 3% | 0 | 14.0 ± 3% | 0 | 34.1 ± 1% | 0 | 66.9 ± 3% | 0 |
| intel-cgo | 22.9 ± 3% | 0 | 28.7 ± 2% | 0 | 24.2 ± 2% | 0 | — | — | — | — |
| intel-cloop | 5.84 ± 2% | 0 | 11.5 ± 2% | 0 | 6.36 ± 2% | 0 | 24.2 ± 1% | 0 | 33.9 ± 2% | 0 |
| decquad-cgo | 27.3 ± 2% | 0 | 63.9 ± 2% | 0 | 45.9 ± 1% | 0 | — | — | — | — |
| decquad-cloop | 7.80 ± 2% | 0 | 32.3 ± 4% | 0 | 26.2 ± 1% | 0 | 28.7 ± 1% | 0 | 51.7 ± 1% | 0 |
| shopspring | 22.4 ± 6% | 2 | 31.6 ± 3% | 2 | 35.6 ± 3% | 2 | — | — | — | — |

### Cgo

| impl | empty ns/op | allocs | binary ns/op | allocs |
|---|--:|--:|--:|--:|
| cgo-nop | 13.2 ± 2% | 0 | 22.1 ± 2% | 0 |

### Div

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | pow10 ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 7% | 0 | 0.43 ± 2% | 0 | 0.44 ± 4% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 8.11 ± 1% | 0 | 19.0 ± 2% | 0 | 8.18 ± 1% | 0 | 5.91 ± 4% | 0 | 13.3 ± 2% | 0 | 22.0 ± 2% | 0 |
| decimal128-go | 22.2 ± 4% | 0 | 31.8 ± 4% | 0 | 25.3 ± 1% | 0 | 10.0 ± 2% | 0 | 51.1 ± 4% | 0 | 61.0 ± 5% | 0 |
| bid754 | 160 ± 3% | 0 | 151 ± 2% | 0 | 160 ± 3% | 0 | 142 ± 3% | 0 | 168 ± 3% | 0 | 174 ± 3% | 0 |
| intel-cgo | 69.7 ± 2% | 0 | 55.9 ± 1% | 0 | 56.0 ± 3% | 0 | 70.2 ± 3% | 0 | — | — | — | — |
| intel-cloop | 34.6 ± 2% | 0 | 31.6 ± 2% | 0 | 32.1 ± 1% | 0 | 44.0 ± 2% | 0 | 39.9 ± 2% | 0 | 38.8 ± 4% | 0 |
| decquad-cgo | 88.8 ± 2% | 0 | 159 ± 1% | 0 | 80.8 ± 3% | 0 | 49.1 ± 1% | 0 | — | — | — | — |
| decquad-cloop | 61.6 ± 1% | 0 | 120 ± 3% | 0 | 58.6 ± 3% | 0 | 30.0 ± 3% | 0 | 76.5 ± 1% | 0 | 186 ± 2% | 0 |
| shopspring | 82.9 ± 2% | 7 | 173 ± 3% | 8 | 96.9 ± 7% | 7 | 60.2 ± 6% | 4 | — | — | — | — |

### FMA

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 4.08 ± 1% | 0 | 10.4 ± 2% | 0 | 11.7 ± 4% | 0 |
| decimal128-go | 7.31 ± 2% | 0 | 37.9 ± 3% | 0 | 23.6 ± 2% | 0 |
| bid754 | 64.1 ± 4% | 0 | 155 ± 3% | 0 | 69.4 ± 4% | 0 |
| intel-cgo | 37.0 ± 3% | 0 | 69.2 ± 3% | 0 | 42.0 ± 4% | 0 |
| intel-cloop | 18.0 ± 4% | 0 | 46.7 ± 2% | 0 | 19.7 ± 2% | 0 |
| decquad-cgo | 50.2 ± 7% | 0 | 130 ± 1% | 0 | 68.7 ± 2% | 0 |
| decquad-cloop | 23.4 ± 2% | 0 | 96.8 ± 1% | 0 | 39.9 ± 1% | 0 |

### Fmt

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| fork-fmt | 33.8 ± 1% | 2 | 39.8 ± 2% | 2 |

### Format

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 27.9 ± 5% | 0 | 19.8 ± 2% | 0 |
| fork-strconv | 5.07 ± 2% | 0 | 10.0 ± 2% | 0 |
| fork-strconv-string | 11.5 ± 2% | 1 | 17.8 ± 5% | 1 |
| decimal128-go | 14.9 ± 4% | 1 | 30.9 ± 1% | 1 |
| bid754 | 20.4 ± 3% | 1 | 58.3 ± 1% | 1 |
| intel-cgo | 21.6 ± 3% | 0 | 43.5 ± 3% | 0 |
| intel-cloop | 5.08 ± 1% | 0 | 24.4 ± 2% | 0 |
| decquad-cgo | 22.8 ± 2% | 0 | 23.1 ± 2% | 0 |
| decquad-cloop | 6.21 ± 3% | 0 | 6.19 ± 4% | 0 |
| shopspring | 53.1 ± 3% | 2 | 77.9 ± 2% | 3 |

### Less

| impl | money ns/op | allocs | full ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.42 ± 1% | 0 | 0.43 ± 4% | 0 | — | — | — | — |
| fork | 1.71 ± 1% | 0 | 3.85 ± 3% | 0 | 2.53 ± 1% | 0 | 5.56 ± 2% | 0 |
| decimal128-go | 5.64 ± 2% | 0 | 5.42 ± 1% | 0 | 14.1 ± 2% | 0 | 15.0 ± 4% | 0 |
| bid754 | 6.47 ± 3% | 0 | 11.2 ± 1% | 0 | 14.4 ± 2% | 0 | 22.4 ± 2% | 0 |
| intel-cgo | 20.4 ± 3% | 0 | 20.5 ± 2% | 0 | — | — | — | — |
| intel-cloop | 2.41 ± 3% | 0 | 4.07 ± 2% | 0 | 5.96 ± 3% | 0 | 9.21 ± 1% | 0 |
| decquad-cgo | 28.4 ± 1% | 0 | 26.6 ± 4% | 0 | — | — | — | — |
| decquad-cloop | 8.31 ± 1% | 0 | 10.6 ± 4% | 0 | 17.6 ± 3% | 0 | 15.7 ± 1% | 0 |
| shopspring | 3.27 ± 5% | 0 | 20.7 ± 5% | 1 | — | — | — | — |

### Mul

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 1% | 0 | 0.43 ± 1% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 1.34 ± 3% | 0 | 7.98 ± 1% | 0 | 1.33 ± 2% | 0 | 2.21 ± 1% | 0 | 12.5 ± 1% | 0 |
| decimal128-go | 1.62 ± 2% | 0 | 30.1 ± 2% | 0 | 1.60 ± 1% | 0 | 3.65 ± 2% | 0 | 41.7 ± 1% | 0 |
| bid754 | 28.4 ± 4% | 0 | 125 ± 1% | 0 | 27.8 ± 1% | 0 | 41.4 ± 4% | 0 | 153 ± 2% | 0 |
| intel-cgo | 29.1 ± 4% | 0 | 50.2 ± 2% | 0 | 29.2 ± 2% | 0 | — | — | — | — |
| intel-cloop | 12.4 ± 4% | 0 | 29.4 ± 2% | 0 | 12.8 ± 2% | 0 | 23.7 ± 3% | 0 | 47.8 ± 3% | 0 |
| decquad-cgo | 32.5 ± 1% | 0 | 52.9 ± 2% | 0 | 41.8 ± 3% | 0 | — | — | — | — |
| decquad-cloop | 12.6 ± 1% | 0 | 29.9 ± 2% | 0 | 14.6 ± 2% | 0 | 32.6 ± 1% | 0 | 53.4 ± 3% | 0 |
| shopspring | 21.9 ± 8% | 2 | 30.9 ± 6% | 2 | 21.9 ± 11% | 2 | — | — | — | — |

### Parse

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 12.7 ± 3% | 0 | 37.4 ± 3% | 0 |
| fork-strconv | 6.21 ± 2% | 0 | 16.2 ± 2% | 0 |
| decimal128-go | 18.5 ± 2% | 0 | 55.2 ± 2% | 0 |
| bid754 | 33.8 ± 3% | 0 | 83.8 ± 1% | 0 |
| intel-cgo | 24.9 ± 1% | 0 | 42.7 ± 2% | 0 |
| intel-cloop | 8.74 ± 2% | 0 | 26.2 ± 2% | 0 |
| decquad-cgo | 26.2 ± 1% | 0 | 35.8 ± 2% | 0 |
| decquad-cloop | 10.9 ± 2% | 0 | 18.8 ± 3% | 0 |
| shopspring | 29.1 ± 6% | 2 | 236 ± 1% | 4 |

### Quantize

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 0.83 ± 4% | 0 | 2.42 ± 2% | 0 | 3.29 ± 2% | 0 |
| decimal128-go | 1.65 ± 3% | 0 | 2.95 ± 3% | 0 | 5.39 ± 2% | 0 |
| bid754 | 23.6 ± 3% | 0 | 15.9 ± 1% | 0 | 23.1 ± 2% | 0 |
| intel-cgo | 22.1 ± 2% | 0 | 21.8 ± 2% | 0 | 21.8 ± 2% | 0 |
| intel-cloop | 3.09 ± 1% | 0 | 2.87 ± 3% | 0 | 3.19 ± 5% | 0 |
| decquad-cgo | 23.5 ± 1% | 0 | 25.2 ± 3% | 0 | 32.3 ± 1% | 0 |
| decquad-cloop | 4.91 ± 4% | 0 | 5.41 ± 3% | 0 | 9.64 ± 2% | 0 |

### Sub

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 1% | 0 | 0.43 ± 1% | 0 | 0.44 ± 3% | 0 | — | — | — | — |
| fork | 1.03 ± 1% | 0 | 8.02 ± 1% | 0 | 4.46 ± 4% | 0 | 5.04 ± 1% | 0 | 12.5 ± 2% | 0 |
| decimal128-go | 1.89 ± 3% | 0 | 18.7 ± 2% | 0 | 12.5 ± 2% | 0 | 9.10 ± 3% | 0 | 45.4 ± 3% | 0 |
| bid754 | 14.7 ± 3% | 0 | 42.6 ± 2% | 0 | 15.6 ± 5% | 0 | 38.6 ± 1% | 0 | 68.1 ± 2% | 0 |
| intel-cgo | 23.6 ± 2% | 0 | 31.0 ± 2% | 0 | 24.2 ± 2% | 0 | — | — | — | — |
| intel-cloop | 6.23 ± 3% | 0 | 12.7 ± 3% | 0 | 6.64 ± 2% | 0 | 24.9 ± 1% | 0 | 33.9 ± 2% | 0 |
| decquad-cgo | 46.3 ± 2% | 0 | 74.4 ± 1% | 0 | 55.9 ± 4% | 0 | — | — | — | — |
| decquad-cloop | 19.7 ± 1% | 0 | 41.2 ± 2% | 0 | 33.7 ± 3% | 0 | 31.1 ± 2% | 0 | 53.9 ± 2% | 0 |

