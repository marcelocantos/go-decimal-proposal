# Loan schedule: three decimal APIs

The design document's [example](../../design/19787-decimal.md#an-example)
computes a fixed-rate loan schedule three ways:

| Directory | Decimal type |
|---|---|
| `builtin` | the proposal's built-in `decimal128`, run with the fork |
| `shopspring` | [`github.com/shopspring/decimal`](https://github.com/shopspring/decimal) v1.6.0 |
| `stdlib` | the `math/decimal` package of [#82668](https://go.dev/issue/82668), from patchset 7 of [CL 855581](https://go.dev/cl/855581) |

Each `Schedule` takes a principal, an annual rate and a term in months, and
returns the balance after each monthly payment. The payment and each
month's interest are rounded to cents, half up, and the last payment clears
the balance. Each `main` prints the schedule for $300,000.00 at 6.25% over
360 months, one `month balance` line per payment.

```sh
FORK=$HOME/go-decimal ./run.sh
```

`run.sh` copies the CL's package into `stdlib/decimal` (ignored by git), runs
all three programs and fails unless their output is identical. It prints:

```
all three schedules agree: 360 balances, last 360 0.00
```

The schedule was also checked against Python's `fractions`, computing every
step in exact rational arithmetic: the payment is $1,847.15 and every balance
matches.

## A rounding trap all three share

The month's interest is `balance × annualRate / 12`. Computing it as
`balance × r`, with the monthly rate `r = annualRate / 12` already rounded,
changes the result in all three. At 6.25% the exact interest in cents is
`balance / 192`, which is a half cent whenever the balance in cents is 96
more than a multiple of 192. That happens twice in this schedule, the first
time in month 21. With a rounded `r` the product falls just short of the
tie:

- shopspring (`r` to 16 places) and #82668 (`r` to 34 places) round the
  interest down, and every later balance is a cent or more lower;
- `decimal128` rounds the product to 34 significant digits first, which lands
  exactly on the tie, and then rounds half up, so it gets the exact answer by
  double rounding.

No decimal type removes the need to decide where rounding happens.
