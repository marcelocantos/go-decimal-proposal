// The loan schedule with github.com/shopspring/decimal.
package main

import (
	"fmt"

	"github.com/shopspring/decimal"
)

// Schedule returns the balance after each monthly payment of a fixed-rate
// loan. The rounding policy, the same in every version: the monthly rate is
// the annual rate / 12 to 12 places; the growth factor (1+r)^months is
// carried to 12 places; the annuity factor r×f/(f-1) is taken to 12
// places; the payment and each month's interest are rounded to cents; every
// rounding is to nearest, ties to even; and the last payment clears the
// balance.
// For a principal of at most 10,000,000.00, a positive annual rate of at
// most 0.25 with four places and at most 480 months, every product is exact
// in decimal128, so each step is one exact operation and at most one
// rounding.
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	one := decimal.NewFromInt(1)
	twelve := decimal.NewFromInt(12)
	r := divRoundBank(annualRate, twelve, 12)
	f := one
	for range months {
		f = f.Mul(one.Add(r)).RoundBank(12)
	}
	a := divRoundBank(r.Mul(f), f.Sub(one), 12)
	payment := principal.Mul(a).RoundBank(2)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := divRoundBank(balance.Mul(annualRate), twelve, 2)
		repaid := payment.Sub(interest)
		if i == months-1 || repaid.GreaterThan(balance) {
			repaid = balance
		}
		balance = balance.Sub(repaid)
		balances[i] = balance
	}
	return balances
}

// divRoundBank returns x / y rounded once to places decimal places, ties to
// even. DivRound rounds ties away from zero only, and Div followed by
// RoundBank rounds twice, the first time to 16 places.
func divRoundBank(x, y decimal.Decimal, places int32) decimal.Decimal {
	q, r := x.QuoRem(y, places)
	if r.IsZero() {
		return q
	}
	unit := decimal.New(1, -places)
	half := r.Abs().Add(r.Abs()).Cmp(y.Abs().Mul(unit))
	if half > 0 || half == 0 && q.Shift(places).BigInt().Bit(0) == 1 {
		if x.Sign() != y.Sign() {
			return q.Sub(unit)
		}
		return q.Add(unit)
	}
	return q
}

func main() {
	principal := decimal.RequireFromString("300000.00")
	rate := decimal.RequireFromString("0.0625")
	for i, b := range Schedule(principal, rate, 360) {
		fmt.Println(i+1, b.StringFixed(2))
	}
}
