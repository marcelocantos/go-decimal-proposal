# Performance of the built-in decimal types

State at the fork's `decimal` branch,
[d8a1ae4a2b](https://github.com/marcelocantos/go/commit/d8a1ae4a2b), the
commit the playground is pinned to, on 2026-11-11.

This document has two parts. The first says what the decimal types cost
today: through the operators, in the kernel, against other libraries, in
text conversion and in whole applications. The second says how the
implementation got there between 2026-11-08 and 2026-11-11: what each pass
changed, what it measured, what was tried and rejected, and what was
learned that applies beyond this code.

The README's [Performance](../README.md#performance) section is the short
form. The mechanisms are documented beside the code, in the kernel's
[`doc.go`](https://github.com/marcelocantos/go/blob/d8a1ae4a2b/src/internal/bid/doc.go)
(sections "Inline fast paths" to "No assembly"). The raw measurements are
in [`research/perf-compare/results`](../research/perf-compare/results) and
in the kernel's benchmark baselines.

## Summary

- Arithmetic on money amounts compiles to inline integer code. `+` takes
  0.7 ns, `×` 1.4 ns, `<` 1.8 ns. `float64` takes 0.4 ns in the same loop.
- Arithmetic on two 34-digit `decimal128` values takes about 10 ns for
  `+` and `×` and about 21 ns for `/`. Before the work these took 27, 37
  and 34 ns.
- Against decimal128-go, bid754, Intel's C library and decNumber's
  decQuad, the built-in type is the fastest of the five on every
  random-operand row, by 1.5 to 3.3 times over the next candidate, and on
  all but five of the twenty fixed-operand rows.
- Parsing a money amount takes 6 ns and formatting one 6 ns. `float64`
  takes 12 and 25 ns.
- On the UW-Madison application benchmarks the built-in type is 2.6 to 3
  times faster than it was on the business workloads and 5.9 times on
  telco, and ahead of decimal128-go on all five.
- No operation allocates. The implementation is pure Go with no assembly.
  No result bit changed: every commit passed the `math/big` oracle and
  114,915 published test vectors with no failure.

## Part 1: where it stands

### How to read the figures

All timings are from one machine unless a section says otherwise: an Apple
M4 Max (macOS 26, darwin/arm64). Unless a table says otherwise, each figure
is the median of 12 rounds in which the things being compared are
interleaved, so that drift in the machine's load falls on all of them
alike. The 1-minute load during the
sessions is stated with each table; the machine's resident daemons hold it
between 4 and 10, and single-threaded benchmarks on the remaining cores do
not contend with them.

Two kinds of operand set appear, and the difference matters more than any
other detail of method.

**Fixed operands** are a few variants of one operand pair, repeated. A
branch predictor learns them, so every branch on the operands' digits is
predicted. These rows show the shortest time an operation can take.

**Drawn operands** come from a pool of random pairs in an order no
predictor can learn. Each data-dependent branch is then a coin toss. These
rows show what data without a pattern costs. The same code can take two to
three times as long as on fixed operands. This applies to every library
measured, and the others lose more on drawn operands than the built-in
type does.

Some figures are not times but counts: instructions retired and processor
cycles per operation, read from the processor's counters. A count does not
move with the machine's load, so it decides a comparison that a timing
leaves in doubt.

### Through the operators

This is what a Go program pays. The compiler lowers `+`, `-`, `×` and the
comparisons on word-sized coefficients of one quantum to inline integer
code, so money values never reach the kernel. For other operands it calls
the kernel's entries directly, with no runtime function in between.

"Before" is the pin at the start of the work,
[903d630330](https://github.com/marcelocantos/go/commit/903d630330).
"Now" is the tuned kernel on identical operands, same machine, same
session (load 5.2 to 8.6).

| `decimal128` operation, fixed operands | Before | Now |
|---|--:|--:|
| `+`, money amounts | 9.1 ns | 0.72 ns |
| `×`, money amounts | 9.5 ns | 1.44 ns |
| `/`, money amounts | 36.1 ns | 10.0 ns |
| `<`, money amounts | 7.3 ns | 1.79 ns |
| `+`, two 34-digit values | 27.3 ns | 10.2 ns |
| `×`, two 34-digit values | 36.6 ns | 10.6 ns |
| `/`, two 34-digit values | 33.7 ns | 22.1 ns |
| `+`, exponents 60 apart | 25.2 ns | 7.7 ns |

The geometric mean of these rows fell by 70%. The operator path costs
within 1 ns of a direct kernel call on the same operands.

The 34-digit division was measured before its last change. That change
removed 26 instructions and about 5% of its cycles on a fixed pair (76.5
to 72.3 cycles in the kernel).

### In the kernel

The kernel is `internal/bid`. Its benchmark has 244 rows, one or more for
every exported function, and a baseline file per platform that a ratchet
test compares against. The table below is the kernel called directly,
without the compiler's inline paths, so its money rows are slower than the
operators' above. Every row includes a loop floor of about 0.3 ns.

| Kernel function | decimal64 before → now | decimal128 before → now | float64 |
|---|---|---|---|
| Add | 11.4 → 5.9 ns | 17.1 → 6.3 ns | 0.98 ns |
| Add, exponents far apart | 11.0 → 6.6 ns | 20.0 → 8.2 ns | |
| Multiply | 11.1 → 6.4 ns | 22.6 → 6.9 ns | 0.94 ns |
| Divide, 34-digit quotient | 11.4 → 8.4 ns | 32.6 → 20.7 ns | 0.92 ns |
| Divide, exact quotient | 12.1 → 8.3 ns | 31.8 → 4.1 ns | |
| Fused multiply-add | 17.4 → 11.3 ns | 31.3 → 20.5 ns | 1.29 ns |
| Quantize | 10.3 → 4.6 ns | 17.3 → 6.4 ns | |
| Less than | 7.4 → 4.4 ns | 9.2 → 5.8 ns | 1.03 ns |
| Convert from `float64`, typical | 12.3 → 8.8 ns | 20.8 → 11.9 ns | |
| Convert from `float64`, largest value | 395 → 9.3 ns | 411 → 12.6 ns | |
| Parse, short string | 20.3 → 4.7 ns | 16.3 → 5.1 ns | 13.0 ns |
| Format to a buffer | 13.4 → 10.2 ns | 22.6 → 11.3 ns | 25.2 ns |

Over the 219 rows the two trees share, both widths, the geometric mean
fell by 31%. The largest moves were on slow paths. Converting the largest
`float64` fell from 411 ns to 13 ns. Parsing a 34-digit numeral fell from
106 ns to 27 ns. A `decimal128` division with an exact quotient fell from
32 ns to 4 ns.

The current baselines are
[`bench_baseline_darwin_arm64.txt`](https://github.com/marcelocantos/go/blob/d8a1ae4a2b/src/internal/bid/testdata/bench_baseline_darwin_arm64.txt)
and
[`bench_baseline_linux_amd64.txt`](https://github.com/marcelocantos/go/blob/d8a1ae4a2b/src/internal/bid/testdata/bench_baseline_linux_amd64.txt).
The format row above is from the darwin baseline (load 9 to 10); the rest
are from the quiet session.

### Against other implementations

The harness in [`research/perf-compare`](../research/perf-compare/README.md)
runs seven candidates on identical operands, after checking that every
IEEE candidate returns bit-identical results:

- the built-in type, through the public API (the operators, `math/decimal`
  and `strconv`), not the kernel directly;
- [decimal128-go](https://github.com/migueldecimal128/decimal128-go), pure
  Go;
- [bid754](https://github.com/sky1core/bid754), a pure-Go port of Intel's
  library;
- Intel's RDFP C library and decNumber's decQuad. Their columns are the
  libraries' own cost in a C loop, without the cgo transition, which adds
  13 to 21 ns per call;
- `shopspring/decimal` and `float64`, in the full results only.

All figures are ns per operation, load 4.5 to 8.3.

Fixed operands:

| Operand set | built-in | decimal128-go | bid754 | Intel C | decQuad C |
|---|--:|--:|--:|--:|--:|
| Add, `1234.56 + 78.90` | **0.66** | 1.22 | 12.4 | 5.8 | 7.8 |
| Add, two 34-digit coefficients | **6.6** | 18.8 | 37.2 | 11.3 | 31.8 |
| Add, exponents 60 apart | 7.0 | 8.6 | 13.9 | **6.3** | 26.1 |
| Subtract, money | **1.02** | 1.86 | 14.3 | 6.2 | 19.5 |
| Subtract, two 34-digit coefficients | **7.9** | 19.0 | 41.1 | 12.8 | 40.3 |
| Multiply, money | **1.32** | 1.59 | 27.3 | 12.4 | 12.5 |
| Multiply, two 34-digit coefficients | **8.8** | 28.8 | 123 | 29.2 | 29.5 |
| Divide, money | **8.0** | 22.1 | 156 | 33.9 | 61.4 |
| Divide, two 34-digit coefficients | **20.0** | 31.4 | 147 | 31.4 | 118 |
| Divide by 1000, exact | **5.7** | 9.8 | 138 | 43.6 | 30.5 |
| Fused multiply-add, money | **4.1** | 7.2 | 62.9 | 17.6 | 23.7 |
| Fused multiply-add, 34 digits | **16.7** | 37.2 | 153 | 47.0 | 96.4 |
| Quantize to 0.01, money | **0.89** | 1.96 | 23.1 | 3.1 | 4.9 |
| Quantize to 0.01, 34 digits (invalid, NaN) | 3.7 | 3.3 | 15.8 | **2.8** | 5.1 |
| Less than, money | **1.74** | 5.7 | 6.4 | 2.4 | 8.3 |
| Less than, 34 digits | 4.3 | 5.4 | 11.2 | **4.0** | 10.2 |
| Parse, money | **6.0** | 17.8 | 33.8 | 8.9 | 10.8 |
| Parse, 34 digits | **16.2** | 54.5 | 83.9 | 25.3 | 18.6 |
| Format to a buffer, money | 5.8 | 15.0 | 20.9 | **5.2** | 6.3 |
| Format to a buffer, 34 digits | 12.9 | 32.4 | 60.7 | 24.3 | **6.4** |

Drawn operands, pools of 1,024 random pairs. Every row carries about 2 ns
of the generator, the same for each candidate:

| Operands drawn at random | built-in | decimal128-go | bid754 | Intel C | decQuad C |
|---|--:|--:|--:|--:|--:|
| Add, amounts | **4.8** | 9.2 | 33.8 | 24.1 | 28.4 |
| Add, 34-digit values | **11.8** | 44.1 | 65.0 | 33.8 | 52.3 |
| Subtract, 34-digit values | **12.5** | 44.8 | 66.9 | 34.1 | 54.5 |
| Multiply, amounts | **2.2** | 3.6 | 40.1 | 22.9 | 32.6 |
| Multiply, 34-digit values | **12.5** | 41.3 | 151 | 46.9 | 53.4 |
| Divide, amounts | **12.9** | 50.5 | 167 | 39.7 | 77.1 |
| Divide, 34-digit values | **22.8** | 60.6 | 172 | 38.6 | 184 |
| Less than, amounts | **2.5** | 14.1 | 14.3 | 5.8 | 16.9 |
| Less than, 34-digit values | **6.0** | 14.7 | 22.3 | 9.2 | 15.8 |

The two formatting rows are from a session of their own at the pin
([`format-d8a1ae4a2b.txt`](../research/perf-compare/results/format-d8a1ae4a2b.txt),
load 10 to 13). The rest are from the session at 6e1004c73a
([`tables.md`](../research/perf-compare/results/tables.md)). No arithmetic
changed between the two but the division step noted above.

### Text

Parsing and formatting are 40 to 70% of the time in the application
benchmarks below, for every library, so they were tuned as hard as the
arithmetic.

| Through `strconv` | `decimal128` | `float64`, same text |
|---|--:|--:|
| Parse a money amount | 6.0 ns | 12.5 ns |
| Parse 34 digits | 16.2 ns | 36.8 ns |
| Format a money amount to a buffer | 5.8 ns | 25 to 28 ns |
| Format 34 digits to a buffer | 12.9 ns | 19 ns |
| Format a money amount to a new string | 11.5 ns, one allocation | |
| Format 34 digits to a new string | 21.5 ns, one allocation | |

The `float64` column parses the same strings and formats the nearest
`float64` to each value in its shortest form.

Formatting in instructions and cycles per call, before and after the last
change (a coefficient of nine digits or more written in place):

| Value | Before | Now |
|---|--:|--:|
| 34 digits, exponential | 665 instr, 80 cycles | 393 instr, 47 cycles |
| 34 digits, 18 before the point | 592, 73 | 408, 52 |
| 16 digits, two decimals | 419, 48 | 284, 30 |
| 11 digits, two decimals | 359, 39 | 284, 30 |
| 12 digits, an integer | 309, 34 | 284, 30 |
| 15 digits after `0.000` | 397, 51 | 280, 30 |
| Money amount | 185, 23.5 | 193, 21 |

A value of nine to sixteen digits now takes about 30 cycles whatever its
shape, and one of up to 34 digits 47 to 52.

### Applications

Kernel timings do not establish what a program pays. The UW-Madison
decimal application benchmarks, as ported to Go by migueldecimal128, run
invoice and tax rules through compiled code: parsing, arithmetic,
rounding, accumulation and formatting. The built-in type runs in them
through an adapter that uses only the operators, `math/decimal` and
`strconv`. The harness is GPL and stays in a separate clone; only results
are published
([`uw-madison-fork.md`](../research/perf-compare/results/uw-madison-fork.md)).

Compute time in ns per record, median of three sessions with all
libraries interleaved and every correctness gate passing:

| Benchmark | built-in | decimal128-go | bid754 | built-in, before tuning |
|---|--:|--:|--:|--:|
| Euro conversion | 671 | 845 | 2,463 | 1,765 |
| Tax, federal | 1,873 | 2,368 | 9,462 | 5,419 |
| Tax, CA | 374 | 439 | 1,880 | 1,135 |
| Tax, NC | 607 | 728 | 3,006 | 1,739 |
| Telco | 28.4 | 80.3 | not supported | 166 |

These were measured at 6e1004c73a on a quiet machine (load 4.0 to 4.9). A
rerun at the pin gave 705, 1,880, 387, 643 and 28.4 for the built-in type
and 858, 2,392, 456, 746 and 79.5 for decimal128-go, every gate passing.
The differences from the table are within the spread between sessions
(the three euro sessions of the table ran from 654 to 708), so the table
stands.

The risk-management and banking benchmarks of the suite need `Pow`,
`Log10` and compound interest. `math/decimal` does not provide them, and
those benchmarks were not run.

### linux/amd64

The CI bench job measures the kernel on GitHub's hosted runners. Runners
differ from one VM to the next, so absolute figures from two runs are
comparable only when the CPU model matches, and a change is judged by an
A/B job that builds both trees on one runner and interleaves them.

Kernel rows at 1395a73231 on an AMD EPYC 9V45 (4 vCPUs):

| `decimal128` | Fixed | Drawn |
|---|--:|--:|
| Add | 7.2 ns | 16.7 ns |
| Multiply | 9.1 ns | 14.7 ns |
| Divide | 26.4 ns | 27.4 ns |
| Divide, exact quotient | 6.2 ns | |
| Divide, money amounts | | 15.8 ns |
| Fused multiply-add | 23.4 ns | |
| Quantize | 6.5 ns | |
| Less than | 7.6 ns | 8.9 ns |
| Parse | 7.1 ns | |

`decimal64` on the same runner: add 5.0 ns, multiply 8.4, divide 10.3, FMA
13.1.

The previous baseline on the same CPU model had `decimal128` divide at
32.0 ns, money division drawn at random at 173.6 ns and 34-digit division
drawn at random at 122.6 ns.

Same-runner A/B results:

- The last arithmetic pass against its starting point (EPYC 7763): level
  over the fixed rows (geometric mean +0.3%). Multiplication fell 32%,
  addition 25%, exact division 64%, far-exponent FMA 55%. Comparisons rose
  15 to 20%, division by zero 36%.
- Long numerals parsed, the same two trees (EPYC 7763, 20 rounds): one
  fixed 38-digit string into `decimal64` rose 3.4%; strings drawn at
  random fell 8.6% for `decimal64` and 25% for `decimal128`.
- In-place formatting of long coefficients (EPYC 7763): mixed
  `decimal128` values fell 17% (35.6 to 29.5 ns), short values 22%, mixed
  `decimal64` values 5%. No formatting row rose.

### What an operation executes

On drawn operands, per operation, net of the loop:

| `decimal128` operation | Instructions | Cycles |
|---|--:|--:|
| amount / amount | 188 | 46 |
| 34 digits / amount | 173 | 32 |
| 34 digits / 34 digits | about 400 | about 80 |
| 34 digits + 34 digits | 207 | 27 |
| 34 digits × 34 digits | 203 | 42 |
| 34 digits × amount | 201 | 43 |

Instructions per cycle range from four to five on the divisions and
multiplications to more than seven on the addition, and to more than
eight in the formatters, where one call overlaps the next. A division is
a chain in which each step waits for the one before, and its cycle count
is the length of that chain, not the number of its instructions.

### Where it is not the fastest

Five fixed-operand rows have another library ahead:

| Row | built-in | Leader | Why |
|---|--:|--:|---|
| Format 34 digits | 12.9 ns | decQuad 6.4 | decQuad stores the coefficient as densely packed decimal: each ten bits are three digits by a table. A binary coefficient has to be divided. |
| Format money | 5.8 ns | Intel 5.2 | Intel writes `+123456E-2`, with no point to place. The built-in type writes `1234.56`. |
| Add, exponents 60 apart | 7.0 ns | Intel 6.3 | No step is avoidable; the difference is the pack's range checks and two guards. |
| Quantize 34 digits to 0.01 | 3.7 ns | Intel 2.8 | An error path that returns NaN: 79 instructions in a straight line. |
| Less than, 34 digits | 4.3 ns | Intel 4.0 | The comparison is branch-free. Intel's branches are predicted on a fixed pair. On drawn operands the built-in type takes 6.0 ns and Intel 9.2. |

Costs that were taken knowingly:

- **34-digit division on a fixed pair** was about 8% slower after its
  corrections became masks, then 5% faster again when its quotient steps
  went inline. On drawn operands the same change took it from 47.5 to
  21.7 ns.
- **Inexact division of one-word operands** pays about a tenth for the
  test that finds exact quotients. Exact quotients are the usual result
  of dividing an amount by a count, and they fell from 44 cycles to 14.
- **Sums of 34-digit values at one exponent or one apart** run about a
  sixth slower than they did midway through the work. They alternate
  between an exact and a rounded result and carry often. Three
  branch-free formulations were measured; each cost the other sums more
  than it gained here.
- **Comparisons on amd64 with repeating operands** take 7.6 ns against
  5.0 for the branching form, and 8.8 against 14.9 on drawn operands.
- **The kernel's exported `Add128` on far exponents** rose from 6.8 to
  8.2 ns. On amd64 and arm64 the operators bypass that entry.
- **Small rows on rare paths**: remainder at the widest exponent gap
  (175 to 193 ns), `decimal64` exact division (7.7 to 8.3 ns), division
  by zero on amd64 (+36%).

Compared with `float64`: money `+` is within 0.3 ns of the hardware add.
Everything else is slower than hardware binary arithmetic by the cost of
software: 3 to 4 times on money multiplication and comparison, 15 to 20
times on 34-digit addition and multiplication, and about 45 times on
34-digit division. Text conversion is faster than `float64`'s, because
decimal text converts to a decimal coefficient exactly: there is no
correctly rounded binary conversion and no shortest-digits search.

### Properties that hold throughout

- **No allocation.** `TestAllocs` asserts it for every exported kernel
  function, and every baseline row reports zero.
- **Pure Go.** No assembly, on any target. The same code runs on arm64,
  amd64, 386, arm, riscv64, s390x and ppc64le; its tests pass natively on
  arm64 and amd64 and under emulation on the rest.
- **Identical results.** The tuning changed no result bit. See
  [How the results were kept honest](#how-the-results-were-kept-honest).
- **No regression lands silently.** The ratchet test fails a row that
  exceeds its baseline by more than 10%, or that allocates.

## Part 2: how it got there

### Starting point

On 2026-11-08 the README said the kernel had not been profiled or tuned
for speed. The kernel had been rewritten for correctness: one generic
template for both widths, one rounding routine that every result passed
through, and a `math/big` oracle to check it. Its benchmark baselines
were provisional, taken at a machine load of 18 to 31.

At that pin a `decimal128` addition took 17 ns, a multiplication 22 ns, a
division 33 ns and a fused multiply-add 31 ns. Every operator went
through a runtime function into the kernel, so adding two money amounts
cost 9 ns. Nobody had compared the kernel with another implementation.

The owner's goal, set on 2026-11-09: decimal128 optimised to the maximum,
no stone left unturned.

### Timeline

| When | Fork commit | Pass | Headline result |
|---|---|---|---|
| 11-08 to 11-09 | 333e3ade31 | First pass, 31 commits | Add 17 → 13 ns, multiply 22 → 17 ns; first inline lowering in the compiler |
| 11-09 night | f79bf54f87 | Reciprocals, tables, structure | Kernel geometric mean −27%; float conversion 405 → 13 ns; long parse 102 → 27 ns |
| 11-10 03:00 | 6f5defe9ae | Inlinable money fronts; assembly evaluated | Kernel-API money add 2.6 → 0.6 ns |
| 11-10 morning | 760cdc9669 | Face-value rounding; inline subtraction; `all.bash` green | Far add 19.2 → 6.7 ns; operators −62% |
| 11-10 midday | a61e558f59 | Formatting, short parsing, division, four gap rows | Short parse 12.1 → 4.9 ns; inexact division 23.7 → 18.9 ns |
| 11-10 afternoon to 11-11 02:00 | 6e1004c73a | Re-analysis with processor counters | 34-digit add 21.6 → 10.2 ns, multiply 17.8 → 10.6 ns; operators −70% |
| 11-11 morning | 8d70355b35 | amd64 and cross-architecture verification; text and API decisions | Squashed into `decimal` |
| 11-11 09:16 | 14c7eacec3 | Division's quotient steps inline | 76.5 → 72.3 cycles; playground pin moved |
| 11-11 15:02 | d8a1ae4a2b | Long coefficients formatted in place | 34 digits 80 → 47 cycles; pin moved again |

The individual commits, 116 of them, are on the fork's
[`perf/t13-final`](https://github.com/marcelocantos/go/commits/perf/t13-final)
branch. The `decimal` branch carries the first 112 as one squashed commit
and the last four as they are.

### First pass: the obvious costs

The first pass was the work of a separate session (the Codex performance
branch). It took the costs a profile shows first:

- word arithmetic for small shifts of a `decimal128` coefficient, where
  the general code used 128-bit operations;
- decoding only the fields an operation needs;
- division of a coefficient by a power of ten without long division;
- direct formatting from the coefficient's digits in `strconv`, without
  temporary buffers;
- the first lowering in the compiler: zero tests, and addition,
  multiplication and comparison of exact word coefficients as integer
  SSA.

It also took the first application benchmark runs. At its end the
profile of multiplication and FMA was dominated by one thing: long
division of a 256-bit product to reduce it to 34 digits.

### Reciprocals and tables

The second pass removed hardware and long division from the hot paths.

- Reduction of a product by a power of ten multiplies by a precomputed
  reciprocal of that power, from one table at 128 bits.
- Division by a two-word divisor follows Möller and Granlund's division
  by a reciprocal.
- The digit count of a wide value is computed without a branch.
- Trailing zeros of a coefficient are stripped by modular inverses, not
  by dividing.
- Binary floats convert to decimal through a table with a fast path.
  The largest `float64` had taken 405 ns; it took 13 ns.
- The parser reads runs of eight digits in one step, by arithmetic on
  the lanes of a word. A 34-digit numeral fell from 102 ns to 27 ns.

Structure work in the same pass: word fast paths in add, multiply and
quantize; the common encoding decoded inline; an addend too small to
affect the result rounded without dividing.

Measured on a quiet machine against the pin, the kernel's geometric mean
had fallen 27% over 221 rows. The operators had fallen 60%. The first
side-by-side harness was built. It showed decimal128-go about 1 ns ahead
on money addition and quantize, and Intel's library 2 to 3 ns ahead on
far-exponent and two-word addition.

### The one-nanosecond call

That 1 ns was a function call. The kernel's money path was fast, but
reaching it cost a call the Go compiler would not inline: the exported
function exceeded the inliner's budget of 80.

The response was a small front on each exported operation. The front
decides word-sized operands of one quantum in place and calls the general
path otherwise. It fits the budget only because of a rule added to the
compiler's inliner: a call from `internal/bid` to its own general paths
is charged as a cheap call, the treatment the runtime already has for one
of its own hot paths. Without the rule the call alone costs 57 of the 80.
A test in the compiler fails if one of these functions stops inlining.

Kernel-direct money addition fell from 2.6 to 0.6 ns, quantize from 2.4
to 0.6 and less-than from 3.5 to 0.75, ahead of decimal128-go.

Assembly was evaluated in the same pass and rejected. A hand-written
128-bit multiply on arm64 measured 5.07 ns a product against 3.79 for the
inlined Go: an assembly function cannot be inlined, and the call costs
more than the two instructions it saves. On amd64, building with
`GOAMD64=v3` already yields MULX from the Go source.

### An exception to the one rounding routine

The kernel's contract was that every rounded result passes through one
routine, `roundW`, checked by a structural test. That generality had a
price on one path. When one addend is too small to change the other's
digits, the result is the larger operand, adjusted by at most one unit.
`roundW` nevertheless clamped, counted digits and shifted, all of which
leave such an input unchanged, and that cost more than the rounding.

A test for the case inside `roundW` slowed every other inexact rounding by
2 to 7%. So the case got a routine of its own, `roundFaceW`, as a named
exception: a proof of its input bounds in its comment, its own boundary
test, and an allowlist in the structural test naming its only callers.
Far-exponent addition fell from 8.6 to 6.7 ns in the kernel, and through
the operator from 25.7 to 8.7 against the pin.

Division later became the second caller. It scales the dividend so that
the quotient has exactly 34 digits and rounds at face value from the
remainder, where it had computed extra digits and sent them through
`roundW`. Inexact division fell from 23.7 to 18.9 ns.

In the same stretch the compiler gained inline subtraction of same-quantum
operands, and `all.bash` was made green with the experiment on and off.

### Text and the remaining gaps

Three independent passes followed, each on one stone.

**Short numerals.** A numeral of at most eight characters is parsed whole:
loaded into one word, the point found by a zero-byte test and removed by
a shift, the digits proved and read by lane arithmetic. Short parse fell
from 12.1 to 4.9 ns.

**Formatting.** The fixed nineteen-digit low word of a two-word
coefficient converts in chunks of eight digits. Mixed formatting fell
from 16.9 to 15.1 ns. The same chunking for every word was measured and
kept out: it cost mixed `decimal64` formatting 24%.

**Four rows where decimal128-go was ahead.** FMA on money, comparison of
34-digit values, quantize, and division by a power of ten. Each got a
specific fix: a word fast path in FMA, comparison by one scaled multiply
without digit counts, a table-wide quantize scale, and exact-quotient
stripping that tries the likely count first.

### Re-analysis: instructions, not arithmetic

At this point the kernel looked finished by profile. Every remaining
cost had a recorded reason. The owner asked for everything to be
analysed again from scratch, with licence to depart from earlier
decisions. Two measurements changed the picture.

**The processor's counters.** On macOS, `/usr/bin/time -l` reports
instructions retired and cycles for a process. A benchmark at a fixed
iteration count, less the same run at a count of one, gives both per
operation. A division of two money amounts retired 470 instructions at
more than six per cycle. Its arithmetic needs under 150. The time was set
by how many instructions ran, not by what was computed. The rest was the
general routine's glue:

- decoding in a form that serves every operand;
- calls to helpers too large to inline, each of which sends every live
  value through memory, because Go's calling convention keeps no register
  across a call;
- digit counts and comparisons at the width of the widest case;
- a rounding routine that begins by rediscovering what its caller knew.

A profile had not shown this, because the cost was spread evenly over
everything.

**Operands without a pattern.** Every benchmark so far had used fixed
operands or walked a pool in order. Drawn at random, the same division of
34-digit values took 47.5 ns where the fixed rows showed 18. The fixed
rows had been measuring branches that were always predicted.

Three changes followed.

*Decisions on digits are computed, not branched on.* The direction of a
rounding is an increment that is added. The class of a remainder against
a half is two borrows and a mask. The second half of a digit count is a
borrow. Quotient corrections are carries. Comparisons are borrows.
Decisions on the kind of operand stay branches: how many words, whether
exponents are far apart, whether a value is special. Those are the same
from one call to the next in a program that computes with one kind of
data, and a predicted branch lets the work after it start early.

*Straight paths.* Division, addition and multiplication of `decimal128`
each got a hand-written entry in front of the template's routine. The
entry takes finite operands in a round-to-nearest mode, computes the
result in one pass with as few calls as the arithmetic allows, and hands
everything else to the general routine unchanged. All three round the
same way: the value is biased by half the divisor, so the quotient comes
out rounded half up, and a zero remainder marks a tie.

| Drawn operands | Before: instr, cycles | After: instr, cycles |
|---|--:|--:|
| amount / amount | 505, 98.9 | 188, 46.2 |
| 34 digits / amount | 490, 81.0 | 173, 32.3 |
| 34 digits / 34 digits | 580, 88.6 | 425, 80.5 |
| 34 digits + 34 digits | 353, 55.1 | 207, 27.2 |
| 34 digits × 34 digits | 486, 62.0 | 203, 42.3 |
| 34 digits × amount | 442, 67.6 | 201, 42.9 |

*Exact quotients without long division.* A divisor divides a dividend
scaled by some power of ten exactly when its part prime to ten divides
the dividend. For one-word operands that test is a shift, a multiply and
one division instruction, and the exact quotient is one more division.
`1234.56 / 3.00` fell from 44 cycles to 14. The long division had found
the quotient to 34 digits and then searched it for trailing zeros.

The compiler changed with the kernel: it calls the kernel's entries
directly for add, multiply, divide, compare and quantize, and sends
one-word sums and products straight to the new entries. A runtime
function in between had cost a frame and a second call, 0.6 to 0.8 ns of
an addition's 9.

Short values also got their own formatter in this pass, `PutShort128`:
eight digits kept in a register, leading zeros dropped by a shift, the
point opened by another, stored as overlapping words. Nothing in it
branches on the value.

Against the state before this pass: 34-digit addition 21.6 to 10.2 ns,
multiplication 17.8 to 10.6, money division 20.1 to 10.0. On the
application benchmarks, 9 to 20% on top of the earlier passes.

### Verification on other machines, and three decisions

CI on linux/amd64 confirmed the gains and exposed the trade in the
comparisons, which the same-runner A/B then measured both ways (see
[linux/amd64](#linuxamd64)). One row, a long numeral parsed into
`decimal64`, read 19% slower. The two trees compile that scanner to
identical instructions. A dedicated A/B with drawn strings showed the row
was a fixed-operand and code-placement artefact: 3.4% on the fixed
string, and faster on drawn ones.

Three design questions the work had raised went to the owner and were
settled before the merge:

- the decimal types are an opt-in experiment, and the `math` bits
  functions return IEEE BID;
- the performance trade-offs listed above are kept, and documented;
- text output follows Go's float layout: `%v`, `%g`, `println` and
  `strconv`'s shortest form agree, with `float64`'s exponent thresholds.

The branch was then squashed into `decimal`.

### Two late stones

**Division's quotient steps.** The division of two-word operands called
a helper twice for its two quotient words. Written inline, the division
lost 26 instructions and about 5% of its cycles on a fixed pair. The
playground pin moved to that commit.

**Long coefficients formatted in place.** After the results were
published, the owner asked why decQuad led the 34-digit formatting row by
6.2 ns to 20.8. Part of the answer is structural and stays: decQuad's
encoding holds decimal digits. The rest was a digit-at-a-time writer for
the high word, fifteen dependent divisions. `PutLong128` replaced it:

- the coefficient is split once by a reciprocal of 10^16 and cut into
  lanes of eight digits;
- each lane converts through a table of the hundred two-digit pairs;
- the result is stored as whole overlapping words directly in the
  caller's buffer, with a store that would cross the end of its part
  redirected to a scratch buffer by a selected address.

The 34-digit row fell from 20.8 to 12.9 ns, an 11-digit amount from 39
cycles to 30. `decimal64` values of nine or more digits take the same
path.

### What was measured and rejected

Each of these was built and measured before it was dropped.

| Experiment | Result | Outcome |
|---|---|---|
| Assembly for the 128-bit multiply and the reciprocal step | 5.07 ns against 3.79 for inlined Go | Rejected: the call costs more than it saves |
| Eight-digit chunks for every word when formatting | Mixed `decimal64` +24%, small words +36% | Kept only for the fixed-length low word |
| A test for the face-value case inside `roundW` | Other inexact roundings +2 to 7% | A separate routine, as a named exception |
| A prologue in `roundW` for narrow sums | Target row not significant; wide rounding +12%; the oracle caught a wrong carry past the largest exponent | Reverted |
| Exchanging addition's operands by a mask | 1.4 ns faster on operands in no order; 0.7 slower in one order, 1.3 slower at nearly equal exponents | Left as a branch |
| Sum and difference formed together, chosen by sign | 1.8 ns faster on mixed signs; 1.5 slower on one sign | Left as a branch |
| Dividing always in addition, by one when nothing is dropped | A third slower on homogeneous operands | Left as branches |
| The carried sum computed beside the plain one | Worse on every shape: 25 → 52 cycles on full sums | Reverted |
| The reciprocal requested before the digit counts in division | A tenth slower: the longest chain started ninety instructions late | Order restored |
| A front for `Compare` out of line | Mixed rows +11 to 16% | `Compare`, `Min`, `Max` call the general path |
| The far-addition path inside the exported `Add128` | Inline cost 134 against a budget of 80 | Reverted |
| Branching comparisons on amd64 | 5.0 against 7.6 ns repeating, 14.9 against 8.8 drawn | Branch-free kept |
| Serial-multiply digit conversion in the long formatter | 68 cycles against 52 for the pair table, same instruction count | Pair table |
| Long form written to a private buffer and copied | 44 cycles against 30 in place, and against 39 for the code it replaced | Written in place |
| Digit count read from the converted word | 6.6 to 7.0 ns against 5.2 to 5.6 from the coefficient | Count from the coefficient |

### What was learned

These findings are not specific to decimal arithmetic.

1. **A benchmark that repeats its operands measures the branch
   predictor.** A pool of 4,096 pairs walked in order is learned. Draw
   operands in an order that cannot be learned, and keep both kinds of
   row.
2. **Count instructions.** A profile shows where time goes inside a
   function. It does not show that the whole function is three times the
   size its arithmetic needs. Instruction and cycle counts are also
   immune to machine load, which timings are not.
3. **Branch on the kind of data; compute on its digits.** A predicted
   branch is free and lets later work start early. A mispredicted branch
   late in an operation discards the start of the next one. But a
   computed decision makes everything after it wait, so a branch that
   resolves early, from signs or exponents, is often better left alone.
4. **A function that calls nothing spills nothing.** Go's calling
   convention saves no register across a call. On a hot path, a helper
   too large to inline is better written out in its caller.
5. **The order of the text is the order of the work.** On a long path
   the processor starts what it reads first. Write the longest dependency
   chain first.
6. **Latency and width are different limits.** Three multiplications in
   series made the formatter unable to overlap one call with the next.
   The same instruction count arranged one multiplication deep ran a
   quarter faster.
7. **Write in place.** A copy out of a buffer that was just written with
   overlapping stores waits on those stores. It cost more than the
   conversion it followed.
8. **A division instruction can beat a reciprocal.** For a divisor below
   2^32, four word divisions are a longer chain in a tenth of the
   instructions, and a fifth faster.
9. **The inliner's budget is a design constraint.** A bounds proof by an
   index mask fits where a clamp does not. A front must stay small enough
   to inline, or it costs every operand it refuses a second call.
10. **Hosted runners differ.** A change is judged on one runner with both
    trees interleaved. One row moved 19% between two builds whose code
    for it was identical.

### How the results were kept honest

Every commit that touched arithmetic passed, before it landed:

- `TestKernel`, a differential test of every operation against an exact
  `math/big` model, in its long mode;
- 4,397 conformance vectors written independently of the kernel;
- three published suites, 114,915 cases with no failure: decTest 22,183,
  Intel 58,064, FPgen 34,668;
- `TestAllocs` and the benchmark ratchet.

At the checkpoints, also:

- `all.bash` with the experiment on and off, and the code generation
  tests for every architecture;
- the kernel, `math/decimal`, `strconv` and runtime tests on 386, arm,
  riscv64, s390x, ppc64le and amd64 under emulation, 24 of 24;
- bit-for-bit agreement with decimal128-go, bid754, Intel's library and
  decQuad on 18,000 random operand pairs in seven operations.

Each new path came with a test against the general path it bypasses. For
the straight paths and the long formatter, mutations were applied to the
new code to confirm that the test fails. The long formatter's test
compares 266,170 encodings with the reference formatter and checks for
writes past the buffer.

The checks caught real faults during the work:

- the narrow-sum prologue packed a carry past the largest exponent where
  it should have overflowed;
- an older compiler crash in functions of more than 500 blocks that use
  both decimal widths;
- a `%g` prefix bug;
- a sign shift that was wrong on 32-bit targets;
- a code generation test that still expected the runtime functions on
  architectures the local gates did not build.

Baselines were retaken by their file's stated procedure after each pass,
with the machine's load recorded in the file.

### What is left

Nothing further is known that pays. The rows where another library leads
are explained [above](#where-it-is-not-the-fastest), and the trades are
recorded with their measurements.

Outside this work:

- Hardware decimal arithmetic on s390x and ppc64le is a later milestone
  ([design decision 10](../README.md#design-decisions)). The software
  kernel runs on both today.
- `decimal64` has no straight paths. Its arithmetic is word arithmetic
  throughout and did not show the same glue.
- `Pow` and `Log10` are not provided, so two of the application
  benchmarks cannot run.

## Where the record lives

| What | Where |
|---|---|
| Mechanisms, with proofs of bounds | [`internal/bid/doc.go`](https://github.com/marcelocantos/go/blob/d8a1ae4a2b/src/internal/bid/doc.go) |
| The commits, one per change | [`perf/t13-final`](https://github.com/marcelocantos/go/commits/perf/t13-final) |
| Kernel baselines and the ratchet | [`internal/bid/testdata`](https://github.com/marcelocantos/go/tree/d8a1ae4a2b/src/internal/bid/testdata) |
| Side-by-side harness and its results | [`research/perf-compare`](../research/perf-compare/README.md) |
| Application benchmark results | [`uw-madison-fork.md`](../research/perf-compare/results/uw-madison-fork.md) |
| The short form | [README, Performance](../README.md#performance) |
| The work's ledger entry | 🎯T13 in the fork's `bullseye.yaml` |
