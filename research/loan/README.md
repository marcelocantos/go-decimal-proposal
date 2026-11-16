# Loan schedule: three decimal APIs

The design document's [example](../../design/19787-decimal.md#an-example)
computes a fixed-rate loan schedule three ways:

| Directory | Decimal type |
|---|---|
| `builtin` | the proposal's built-in `decimal128`, run with the fork |
| `shopspring` | [`github.com/shopspring/decimal`](https://github.com/shopspring/decimal) v1.6.0 |
| `stdlib` | the `math/decimal` package of [#82668](https://go.dev/issue/82668), from patchset 7 of [CL 855581](https://go.dev/cl/855581) |

Each `Schedule` takes a principal, an annual rate and a term in months, and
returns the balance after each monthly payment. Each `main` prints the
schedule for $300,000.00 at 6.25% over 360 months, one `month balance` line
per payment.

## One policy, three implementations

The three follow one rounding policy, step for step:

1. the monthly rate is the annual rate / 12, to 12 places;
2. the growth factor (1+r)^months is carried to 12 places, rounding after
   each month's multiplication;
3. the annuity factor r×f/(f−1) is taken to 12 places;
4. the payment, principal × annuity factor, is rounded to cents;
5. each month's interest, balance × annual rate / 12, is rounded to cents;
6. every rounding is to nearest with ties to even, IEEE 754's default and
   the operators' own rounding, and the last payment clears the balance.

#82668's `Round` and `Quo` with `ToNearestEven`, and the fork's
`decimal.Quantize` and `decimal.QuoQuantize` with `ToNearestEven`, each
perform one of these roundings in one step. So does shopspring's
`RoundBank`, but shopspring has no division that rounds once to even: its
`DivRound` rounds ties away from zero, and `Div` followed by `RoundBank`
rounds twice. Its version adds `divRoundBank`, which divides with `QuoRem`
and rounds the remainder to even itself. Every other operation is exact: always in the two
arbitrary-precision libraries, and in `decimal128` for a principal of at
most 10,000,000.00, a positive annual rate of at most 0.25 with four places
and at most 480 months, where no product needs more than 29 of its 34
digits. So the three
compute the same values by construction, not by coincidence.

```sh
FORK=$HOME/go-decimal ./run.sh
```

`run.sh` copies the CL's package into `stdlib/decimal` (ignored by git), runs
all three programs and fails unless their output is identical. It prints:

```
all three schedules agree: 360 balances, last 360 0.00
```

The schedule was also checked against the same policy computed step by step
in exact rational arithmetic with Python's `fractions`: the monthly rate is
0.005208333333, the payment $1,847.15, and every balance matches. Two
months' interest is exactly half a cent (months 21 and 223), and goes to the
even cent.

An earlier version of this example used ties away from zero, the one mode in
which shopspring divides with a single rounding. That choice suited the
library rather than the problem, and hid the gap above.

## Why the policy has to be stated

Left to their defaults the three round differently: shopspring's `Div` keeps
16 places unless a package variable says otherwise, #82668's `Quo` takes a
scale on every call, and `decimal128`'s operators round to 34 significant
digits. A division followed by quantizing rounds twice, and the first
rounding can move a quotient onto the tie the second decides: in
`decimal64`, `2.009999999999999 / 2` rounds to `1.005000000000000`, which
quantizes half up to `1.01`, where the exact quotient rounds to `1.00`.
`decimal.QuoQuantize` divides and rounds once, as shopspring's `DivRound`
and #82668's `Quo` do.
