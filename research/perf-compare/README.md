# perf-compare: decimal128 implementations side by side

Measures the Go decimal fork's built-in `decimal128` (and its kernel,
`internal/bid`) against the other decimal128 implementations named in
golang/go#19787, on identical operations and operands, in one harness. It is
measurement only: no kernel code is changed. Feeds 🎯T13 and the proposal's
Performance section.

## Candidates

| impl (row name) | what | version |
|---|---|---|
| `fork` | built-in `decimal128` operators `+ - * / <` | fork `e5db2abe94` (branch `decimal`) |
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

12 interleaved rounds, benchtime 500ms, with the fork at e5db2abe94
(branch `decimal`; the same tree as bf47bf8c7c on `perf/t13-final`) and
no other builds or benchmarks running: the 1-minute load was 8.0–9.9 at
the start of every round (`results/uptime.txt`). Earlier runs of this
harness, at the fork's 32c1829380 on a loaded machine, at 760cdc9669, at
6e1004c73a and at a26c7815c8, are in this file's git history; the chart in the proposal
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
| float64 | 0.43 ± 1% | 0 | 0.43 ± 1% | 0 | 0.44 ± 0% | 0 | — | — | — | — |
| fork | 0.67 ± 2% | 0 | 6.64 ± 2% | 0 | 4.25 ± 3% | 0 | 4.84 ± 1% | 0 | 11.9 ± 0% | 0 |
| decimal128-go | 1.24 ± 2% | 0 | 19.0 ± 1% | 0 | 8.70 ± 5% | 0 | 9.30 ± 1% | 0 | 44.7 ± 1% | 0 |
| bid754 | 12.5 ± 1% | 0 | 37.2 ± 2% | 0 | 13.7 ± 1% | 0 | 34.1 ± 1% | 0 | 64.6 ± 0% | 0 |
| intel-cgo | 23.0 ± 5% | 0 | 29.2 ± 1% | 0 | 24.0 ± 1% | 0 | — | — | — | — |
| intel-cloop | 5.80 ± 1% | 0 | 11.2 ± 1% | 0 | 6.33 ± 1% | 0 | 24.3 ± 2% | 0 | 33.6 ± 1% | 0 |
| decquad-cgo | 27.3 ± 0% | 0 | 61.9 ± 0% | 0 | 45.9 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 7.70 ± 1% | 0 | 31.7 ± 1% | 0 | 26.6 ± 1% | 0 | 28.8 ± 0% | 0 | 51.8 ± 0% | 0 |
| shopspring | 20.7 ± 1% | 2 | 32.0 ± 4% | 2 | 35.4 ± 4% | 2 | — | — | — | — |

### Cgo

| impl | empty ns/op | allocs | binary ns/op | allocs |
|---|--:|--:|--:|--:|
| cgo-nop | 13.1 ± 1% | 0 | 21.2 ± 3% | 0 |

### Div

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | pow10 ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 0% | 0 | 0.43 ± 2% | 0 | 0.43 ± 1% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 8.05 ± 1% | 0 | 18.9 ± 1% | 0 | 8.14 ± 1% | 0 | 5.81 ± 3% | 0 | 13.1 ± 1% | 0 | 22.0 ± 1% | 0 |
| decimal128-go | 22.2 ± 1% | 0 | 31.3 ± 4% | 0 | 25.6 ± 1% | 0 | 9.84 ± 1% | 0 | 50.6 ± 2% | 0 | 61.2 ± 1% | 0 |
| bid754 | 156 ± 1% | 0 | 149 ± 1% | 0 | 160 ± 1% | 0 | 139 ± 1% | 0 | 167 ± 1% | 0 | 172 ± 1% | 0 |
| intel-cgo | 69.1 ± 1% | 0 | 55.8 ± 1% | 0 | 55.8 ± 2% | 0 | 69.9 ± 3% | 0 | — | — | — | — |
| intel-cloop | 34.2 ± 1% | 0 | 31.6 ± 1% | 0 | 31.9 ± 2% | 0 | 43.9 ± 1% | 0 | 39.8 ± 1% | 0 | 38.8 ± 2% | 0 |
| decquad-cgo | 84.2 ± 0% | 0 | 158 ± 1% | 0 | 78.6 ± 1% | 0 | 49.2 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 61.4 ± 1% | 0 | 119 ± 1% | 0 | 57.1 ± 1% | 0 | 30.2 ± 2% | 0 | 77.1 ± 2% | 0 | 187 ± 3% | 0 |
| shopspring | 82.5 ± 2% | 7 | 170 ± 3% | 8 | 96.4 ± 2% | 7 | 58.7 ± 3% | 4 | — | — | — | — |

### FMA

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 4.12 ± 0% | 0 | 10.4 ± 2% | 0 | 11.7 ± 2% | 0 |
| decimal128-go | 7.47 ± 3% | 0 | 37.3 ± 1% | 0 | 24.2 ± 3% | 0 |
| bid754 | 63.5 ± 0% | 0 | 151 ± 2% | 0 | 67.7 ± 0% | 0 |
| intel-cgo | 35.9 ± 1% | 0 | 66.8 ± 3% | 0 | 40.8 ± 3% | 0 |
| intel-cloop | 17.5 ± 3% | 0 | 46.3 ± 3% | 0 | 19.6 ± 3% | 0 |
| decquad-cgo | 50.3 ± 1% | 0 | 130 ± 0% | 0 | 68.1 ± 1% | 0 |
| decquad-cloop | 23.6 ± 1% | 0 | 97.2 ± 1% | 0 | 39.7 ± 1% | 0 |

### Fmt

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| fork-fmt | 33.1 ± 1% | 2 | 41.1 ± 1% | 2 |

### Format

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 28.6 ± 2% | 0 | 19.3 ± 3% | 0 |
| fork-strconv | 5.75 ± 1% | 0 | 12.9 ± 1% | 0 |
| fork-strconv-string | 11.3 ± 2% | 1 | 20.4 ± 1% | 1 |
| decimal128-go | 14.3 ± 2% | 1 | 31.0 ± 2% | 1 |
| bid754 | 20.1 ± 1% | 1 | 58.0 ± 1% | 1 |
| intel-cgo | 21.5 ± 4% | 0 | 43.1 ± 2% | 0 |
| intel-cloop | 5.08 ± 1% | 0 | 23.8 ± 2% | 0 |
| decquad-cgo | 22.9 ± 1% | 0 | 22.1 ± 1% | 0 |
| decquad-cloop | 6.13 ± 4% | 0 | 5.95 ± 1% | 0 |
| shopspring | 51.9 ± 2% | 2 | 79.4 ± 2% | 3 |

### Less

| impl | money ns/op | allocs | full ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 0% | 0 | 0.43 ± 2% | 0 | — | — | — | — |
| fork | 1.73 ± 2% | 0 | 3.73 ± 2% | 0 | 2.55 ± 1% | 0 | 5.44 ± 1% | 0 |
| decimal128-go | 5.58 ± 2% | 0 | 5.22 ± 2% | 0 | 14.3 ± 1% | 0 | 14.9 ± 0% | 0 |
| bid754 | 6.38 ± 1% | 0 | 11.2 ± 1% | 0 | 14.5 ± 2% | 0 | 22.6 ± 1% | 0 |
| intel-cgo | 19.5 ± 2% | 0 | 20.6 ± 2% | 0 | — | — | — | — |
| intel-cloop | 2.39 ± 1% | 0 | 3.95 ± 2% | 0 | 5.85 ± 1% | 0 | 9.21 ± 1% | 0 |
| decquad-cgo | 28.5 ± 1% | 0 | 26.0 ± 2% | 0 | — | — | — | — |
| decquad-cloop | 8.41 ± 1% | 0 | 10.2 ± 2% | 0 | 17.1 ± 1% | 0 | 15.8 ± 1% | 0 |
| shopspring | 3.11 ± 4% | 0 | 19.6 ± 2% | 1 | — | — | — | — |

### Mul

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 1% | 0 | 0.43 ± 1% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 1.33 ± 0% | 0 | 7.90 ± 1% | 0 | 1.34 ± 1% | 0 | 2.22 ± 2% | 0 | 12.5 ± 1% | 0 |
| decimal128-go | 1.59 ± 0% | 0 | 28.5 ± 2% | 0 | 1.61 ± 1% | 0 | 3.65 ± 2% | 0 | 41.8 ± 1% | 0 |
| bid754 | 27.3 ± 2% | 0 | 125 ± 1% | 0 | 28.1 ± 2% | 0 | 40.0 ± 1% | 0 | 151 ± 1% | 0 |
| intel-cgo | 28.9 ± 4% | 0 | 50.5 ± 3% | 0 | 29.2 ± 1% | 0 | — | — | — | — |
| intel-cloop | 12.5 ± 3% | 0 | 29.6 ± 2% | 0 | 12.7 ± 2% | 0 | 22.9 ± 3% | 0 | 47.3 ± 1% | 0 |
| decquad-cgo | 32.5 ± 1% | 0 | 52.5 ± 2% | 0 | 41.6 ± 1% | 0 | — | — | — | — |
| decquad-cloop | 12.5 ± 2% | 0 | 29.5 ± 1% | 0 | 14.5 ± 2% | 0 | 32.5 ± 1% | 0 | 52.8 ± 0% | 0 |
| shopspring | 21.6 ± 1% | 2 | 29.9 ± 4% | 2 | 22.1 ± 4% | 2 | — | — | — | — |

### Parse

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 12.4 ± 1% | 0 | 36.4 ± 1% | 0 |
| fork-strconv | 5.99 ± 1% | 0 | 16.3 ± 1% | 0 |
| decimal128-go | 17.9 ± 2% | 0 | 54.7 ± 1% | 0 |
| bid754 | 33.9 ± 1% | 0 | 83.8 ± 1% | 0 |
| intel-cgo | 25.0 ± 2% | 0 | 41.9 ± 1% | 0 |
| intel-cloop | 8.78 ± 2% | 0 | 25.5 ± 1% | 0 |
| decquad-cgo | 26.0 ± 1% | 0 | 35.1 ± 1% | 0 |
| decquad-cloop | 10.7 ± 1% | 0 | 18.8 ± 1% | 0 |
| shopspring | 28.1 ± 4% | 2 | 239 ± 1% | 4 |

### Quantize

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 0.82 ± 1% | 0 | 2.36 ± 1% | 0 | 3.29 ± 3% | 0 |
| decimal128-go | 1.70 ± 4% | 0 | 3.06 ± 3% | 0 | 5.47 ± 5% | 0 |
| bid754 | 23.1 ± 1% | 0 | 16.0 ± 2% | 0 | 23.2 ± 1% | 0 |
| intel-cgo | 21.9 ± 2% | 0 | 21.7 ± 3% | 0 | 21.9 ± 2% | 0 |
| intel-cloop | 3.05 ± 3% | 0 | 2.86 ± 5% | 0 | 3.04 ± 3% | 0 |
| decquad-cgo | 23.5 ± 1% | 0 | 24.9 ± 1% | 0 | 32.0 ± 2% | 0 |
| decquad-cloop | 4.91 ± 5% | 0 | 5.22 ± 1% | 0 | 9.58 ± 0% | 0 |

### Sub

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | drawn-money ns/op | allocs | drawn-full ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.43 ± 0% | 0 | 0.43 ± 1% | 0 | 0.44 ± 1% | 0 | — | — | — | — |
| fork | 1.03 ± 1% | 0 | 7.99 ± 1% | 0 | 4.38 ± 1% | 0 | 4.97 ± 2% | 0 | 12.5 ± 0% | 0 |
| decimal128-go | 1.83 ± 1% | 0 | 18.4 ± 2% | 0 | 12.7 ± 2% | 0 | 8.98 ± 1% | 0 | 45.0 ± 1% | 0 |
| bid754 | 14.1 ± 1% | 0 | 41.5 ± 1% | 0 | 15.8 ± 0% | 0 | 38.1 ± 0% | 0 | 66.7 ± 2% | 0 |
| intel-cgo | 23.2 ± 2% | 0 | 30.6 ± 1% | 0 | 24.2 ± 1% | 0 | — | — | — | — |
| intel-cloop | 6.19 ± 2% | 0 | 12.8 ± 1% | 0 | 6.56 ± 2% | 0 | 25.2 ± 1% | 0 | 34.0 ± 2% | 0 |
| decquad-cgo | 46.4 ± 1% | 0 | 74.6 ± 1% | 0 | 55.4 ± 1% | 0 | — | — | — | — |
| decquad-cloop | 19.7 ± 1% | 0 | 41.0 ± 1% | 0 | 33.0 ± 1% | 0 | 30.9 ± 1% | 0 | 54.4 ± 1% | 0 |
