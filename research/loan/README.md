# Loan schedule: the built-in type against two libraries

The design document's [example](../../design/19787-decimal.md#an-example)
computes a fixed-rate loan schedule three ways:

| Directory | Decimal type |
|---|---|
| `builtin` | the proposal's built-in `decimal128`, run with the fork |
| `shopspring` | [`github.com/shopspring/decimal`](https://github.com/shopspring/decimal) v1.6.0 |
| `stdlib` | the `math/decimal` package of [#82668](https://go.dev/issue/82668), from patchset 7 of [CL 855581](https://go.dev/cl/855581) |

Each `Schedule` takes a principal, an annual rate and a term in months, and
returns the balance after each monthly payment. The business rule is that
the payment and each month's interest are rounded to cents, to nearest with
ties to even, and that the last payment clears the balance. Each `main`
prints the schedule for $300,000.00 at 6.25% over 360 months, one
`month balance` line per payment.

## What each version is

- **`builtin`** is the algorithm as one would write it with the built-in
  type: the formula as written on paper, intermediates at `decimal128`'s
  34 digits, and the two roundings the rule asks for, each one
  `decimal.QuoQuantize` (divide and round once to the cent).
- **`stdlib`** is the same algorithm with #82668's package. Its division
  needs a scale; the monthly rate keeps 34 places, to match `decimal128`.
  Its multiplication is exact, so the growth factor ends the loop with
  12,240 decimal places. `Quo` rounds once in a stated mode.
- **`shopspring`** is the same algorithm with shopspring/decimal, with the
  same 34-place rate and the same 12,240-place growth factor. shopspring has
  no division that rounds once to even: `DivRound` rounds ties away from
  zero, and `Div` followed by `RoundBank` rounds twice, the first time to 16
  places. The version adds `divRoundBank`, which divides with `QuoRem` and
  rounds the remainder itself.

```sh
FORK=$HOME/go-decimal ./run.sh
```

`run.sh` copies the CL's package into `stdlib/decimal` (ignored by git), runs
all three programs and fails unless their output is identical. It prints:

```
all three schedules agree: 360 balances, last 360 0.00
```

The `decimal128` schedule was also checked against the computation in exact
rational arithmetic with Python's `fractions`, with the monthly rate never
rounded: the payment is $1,847.15 and every balance matches. Two months'
interest is exactly half a cent (months 21 and 223), and goes to the even
cent. `divRoundBank` was checked against exact rounding on 200,000 signed
cases, a third of them ties.

## History

Earlier versions of this example made the three compute identical values by
construction, under a policy that rounded the rate and the growth factor to
12 places, first with ties away from zero and then with ties to even. Ties
away from zero was the one mode in which shopspring divides with a single
rounding, so it suited the library and hid its gap; and the 12-place steps
were there for the libraries' sake, not something `decimal128` code would
contain. The current version shows each type as it would be used.
