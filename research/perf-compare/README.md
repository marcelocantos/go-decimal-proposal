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

Operations: Add, Sub, Mul, FMA (`x*y + y`), Quantize (`x` to quantum
`0.01`) on money/full/far; Div on all four; Less (`x < y`) on money/full;
Parse and Format on the `x` text of money/full.

`TestSameResults` checks that every IEEE candidate (fork, decimal128-go,
bid754, Intel, decQuad) returns the same decimal128, quantum included, for
every benchmarked operation and variant. shopspring and float64 are not
checked (different arithmetic; shopspring divides to 16 places).

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

## Results (2026-11-10, Apple M4 Max, macOS 26)

12 interleaved rounds, benchtime 500ms, with the fork at 760cdc9669
(branch `perf/t13-final`, the tuned kernel) and no other builds or
benchmarks running: the 1-minute load was 5.8–6.6 at the start of every
round (`results/uptime.txt`). The previous run of this harness, at the fork's
32c1829380 on a loaded machine, is in this file's git history; the chart in
the proposal README uses its fork column as "before".

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

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| float64 | 0.45 ± 20% | 0 | 0.44 ± 24% | 0 | 0.44 ± 2% | 0 |
| fork | 9.20 ± 26% | 0 | 26.8 ± 17% | 0 | 26.8 ± 11% | 0 |
| decimal128-go | 1.27 ± 39% | 0 | 19.2 ± 15% | 0 | 8.76 ± 4% | 0 |
| bid754 | 12.5 ± 24% | 0 | 39.2 ± 6% | 0 | 14.2 ± 2% | 0 |
| intel-cgo | 23.3 ± 29% | 0 | 29.4 ± 18% | 0 | 24.9 ± 2% | 0 |
| intel-cloop | 5.71 ± 19% | 0 | 11.9 ± 6% | 0 | 6.16 ± 3% | 0 |
| decquad-cgo | 28.7 ± 22% | 0 | 61.8 ± 19% | 0 | 46.7 ± 10% | 0 |
| decquad-cloop | 8.14 ± 20% | 0 | 32.5 ± 6% | 0 | 27.2 ± 9% | 0 |
| shopspring | 26.9 ± 90% | 2 | 32.1 ± 65% | 2 | 36.4 ± 54% | 2 |

### Sub

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| float64 | 0.45 ± 10% | 0 | 0.45 ± 4% | 0 | 0.43 ± 8% | 0 |
| fork | 9.87 ± 8% | 0 | 27.9 ± 8% | 0 | 28.4 ± 9% | 0 |
| decimal128-go | 2.02 ± 9% | 0 | 18.8 ± 6% | 0 | 12.5 ± 3% | 0 |
| bid754 | 14.5 ± 8% | 0 | 42.0 ± 4% | 0 | 15.8 ± 2% | 0 |
| intel-cgo | 24.1 ± 11% | 0 | 30.0 ± 3% | 0 | 24.5 ± 18% | 0 |
| intel-cloop | 5.98 ± 4% | 0 | 12.8 ± 2% | 0 | 6.45 ± 10% | 0 |
| decquad-cgo | 47.9 ± 11% | 0 | 77.1 ± 7% | 0 | 56.6 ± 4% | 0 |
| decquad-cloop | 20.2 ± 9% | 0 | 40.3 ± 2% | 0 | 32.6 ± 3% | 0 |

### Mul

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| float64 | 0.45 ± 7% | 0 | 0.43 ± 2% | 0 | 0.44 ± 15% | 0 |
| fork | 8.93 ± 8% | 0 | 40.9 ± 2% | 0 | 9.19 ± 12% | 0 |
| decimal128-go | 1.66 ± 6% | 0 | 30.5 ± 21% | 0 | 1.65 ± 26% | 0 |
| bid754 | 27.6 ± 2% | 0 | 127 ± 12% | 0 | 27.7 ± 20% | 0 |
| intel-cgo | 29.5 ± 3% | 0 | 51.3 ± 24% | 0 | 29.8 ± 21% | 0 |
| intel-cloop | 12.4 ± 2% | 0 | 29.9 ± 5% | 0 | 12.7 ± 4% | 0 |
| decquad-cgo | 32.9 ± 15% | 0 | 53.8 ± 1% | 0 | 42.9 ± 5% | 0 |
| decquad-cloop | 12.7 ± 9% | 0 | 29.7 ± 3% | 0 | 14.7 ± 3% | 0 |
| shopspring | 22.3 ± 28% | 2 | 29.5 ± 29% | 2 | 23.5 ± 97% | 2 |

### Div

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs | pow10 ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| float64 | 0.44 ± 63% | 0 | 0.45 ± 0% | 0 | 0.44 ± 2% | 0 | 0.43 ± 2% | 0 |
| fork | 27.9 ± 23% | 0 | 26.7 ± 2% | 0 | 26.0 ± 21% | 0 | 37.1 ± 2% | 0 |
| decimal128-go | 22.1 ± 20% | 0 | 32.9 ± 3% | 0 | 26.2 ± 12% | 0 | 9.95 ± 2% | 0 |
| bid754 | 157 ± 22% | 0 | 150 ± 9% | 0 | 161 ± 6% | 0 | 144 ± 3% | 0 |
| intel-cgo | 70.4 ± 12% | 0 | 56.5 ± 1% | 0 | 56.1 ± 27% | 0 | 71.3 ± 2% | 0 |
| intel-cloop | 34.7 ± 3% | 0 | 32.2 ± 3% | 0 | 32.7 ± 16% | 0 | 44.4 ± 11% | 0 |
| decquad-cgo | 85.7 ± 1% | 0 | 159 ± 3% | 0 | 80.6 ± 2% | 0 | 50.5 ± 2% | 0 |
| decquad-cloop | 62.2 ± 1% | 0 | 121 ± 1% | 0 | 57.8 ± 2% | 0 | 31.7 ± 5% | 0 |
| shopspring | 82.7 ± 7% | 7 | 175 ± 20% | 8 | 96.8 ± 6% | 7 | 60.8 ± 93% | 4 |

### FMA

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 16.8 ± 2% | 0 | 44.5 ± 3% | 0 | 30.8 ± 2% | 0 |
| decimal128-go | 7.43 ± 3% | 0 | 38.1 ± 4% | 0 | 23.9 ± 2% | 0 |
| bid754 | 64.9 ± 15% | 0 | 156 ± 3% | 0 | 68.2 ± 1% | 0 |
| intel-cgo | 36.3 ± 14% | 0 | 69.2 ± 2% | 0 | 41.6 ± 4% | 0 |
| intel-cloop | 17.5 ± 11% | 0 | 47.2 ± 4% | 0 | 20.2 ± 2% | 0 |
| decquad-cgo | 52.0 ± 9% | 0 | 131 ± 2% | 0 | 69.3 ± 1% | 0 |
| decquad-cloop | 24.0 ± 4% | 0 | 98.5 ± 1% | 0 | 40.2 ± 3% | 0 |

### Quantize

| impl | money ns/op | allocs | full ns/op | allocs | far ns/op | allocs |
|---|--:|--:|--:|--:|--:|--:|
| fork-mathdecimal | 9.78 ± 5% | 0 | 7.11 ± 4% | 0 | 11.6 ± 2% | 0 |
| decimal128-go | 1.70 ± 7% | 0 | 2.97 ± 8% | 0 | 5.44 ± 2% | 0 |
| bid754 | 23.4 ± 4% | 0 | 16.2 ± 4% | 0 | 24.0 ± 2% | 0 |
| intel-cgo | 22.3 ± 3% | 0 | 22.2 ± 13% | 0 | 22.2 ± 3% | 0 |
| intel-cloop | 3.39 ± 4% | 0 | 3.09 ± 9% | 0 | 3.37 ± 6% | 0 |
| decquad-cgo | 23.9 ± 2% | 0 | 25.3 ± 3% | 0 | 31.4 ± 4% | 0 |
| decquad-cloop | 4.86 ± 7% | 0 | 5.29 ± 1% | 0 | 9.61 ± 1% | 0 |

### Less

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 0.44 ± 2% | 0 | 0.45 ± 9% | 0 |
| fork | 6.58 ± 7% | 0 | 7.33 ± 6% | 0 |
| decimal128-go | 5.79 ± 4% | 0 | 5.41 ± 2% | 0 |
| bid754 | 6.59 ± 6% | 0 | 11.0 ± 4% | 0 |
| intel-cgo | 20.3 ± 3% | 0 | 20.7 ± 9% | 0 |
| intel-cloop | 2.43 ± 6% | 0 | 4.10 ± 27% | 0 |
| decquad-cgo | 29.2 ± 36% | 0 | 27.2 ± 22% | 0 |
| decquad-cloop | 8.53 ± 29% | 0 | 10.6 ± 24% | 0 |
| shopspring | 3.36 ± 24% | 0 | 19.5 ± 176% | 1 |

### Parse

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 13.1 ± 31% | 0 | 37.3 ± 6% | 0 |
| fork-strconv | 17.7 ± 5% | 0 | 87.1 ± 4% | 0 |
| decimal128-go | 18.6 ± 3% | 0 | 56.3 ± 23% | 0 |
| bid754 | 34.9 ± 4% | 0 | 87.4 ± 19% | 0 |
| intel-cgo | 25.9 ± 3% | 0 | 42.4 ± 3% | 0 |
| intel-cloop | 9.02 ± 7% | 0 | 25.8 ± 2% | 0 |
| decquad-cgo | 26.8 ± 3% | 0 | 35.9 ± 3% | 0 |
| decquad-cloop | 11.0 ± 3% | 0 | 19.2 ± 4% | 0 |
| shopspring | 30.3 ± 24% | 2 | 246 ± 2% | 4 |

### Format

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| float64 | 27.4 ± 5% | 0 | 19.1 ± 8% | 0 |
| fork-strconv | 27.8 ± 2% | 0 | 66.9 ± 10% | 0 |
| fork-strconv-string | 42.3 ± 2% | 2 | 88.2 ± 3% | 2 |
| decimal128-go | 14.6 ± 1% | 1 | 32.0 ± 4% | 1 |
| bid754 | 20.2 ± 2% | 1 | 59.3 ± 3% | 1 |
| intel-cgo | 22.1 ± 4% | 0 | 43.6 ± 2% | 0 |
| intel-cloop | 5.24 ± 9% | 0 | 24.4 ± 6% | 0 |
| decquad-cgo | 23.6 ± 11% | 0 | 22.5 ± 5% | 0 |
| decquad-cloop | 6.63 ± 4% | 0 | 6.00 ± 32% | 0 |
| shopspring | 52.6 ± 6% | 2 | 82.7 ± 5% | 3 |

### Fmt

| impl | money ns/op | allocs | full ns/op | allocs |
|---|--:|--:|--:|--:|
| fork-fmt | 61.8 ± 3% | 2 | 98.9 ± 10% | 2 |

### Cgo

| impl | empty ns/op | allocs | binary ns/op | allocs |
|---|--:|--:|--:|--:|
| cgo-nop | 13.2 ± 4% | 0 | 21.8 ± 3% | 0 |

