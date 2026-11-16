// The loan schedule with the math/decimal package proposed in
// https://go.dev/issue/82668, as implemented by https://go.dev/cl/855581.
// run.sh copies that package into ./decimal.
package main

import (
	"fmt"

	"loan/stdlib/decimal"
)

// Schedule returns the balance after each monthly payment of a fixed-rate
// loan. The rounding policy, the same in every version: the monthly rate is
// the annual rate / 12 to 12 places; the growth factor (1+r)^months is
// carried to 12 places; the annuity factor r×f/(f-1) is taken to 12
// places; the payment and each month's interest are rounded to cents; every
// rounding is half away from zero; and the last payment clears the balance.
// For a principal of at most 10,000,000.00, a positive annual rate of at
// most 0.25 with four places and at most 480 months, every product is exact
// in decimal128, so each step is one exact operation and at most one
// rounding.
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	const mode = decimal.ToNearestAway
	twelve := decimal.FromInt(12)
	r := annualRate.Quo(twelve, 12, mode)
	f := decimal.One
	for range months {
		f = f.Mul(decimal.One.Add(r)).Round(12, mode)
	}
	a := r.Mul(f).Quo(f.Sub(decimal.One), 12, mode)
	payment := principal.Mul(a).Round(2, mode)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := balance.Mul(annualRate).Quo(twelve, 2, mode)
		repaid := payment.Sub(interest)
		if i == months-1 || repaid.Greater(balance) {
			repaid = balance
		}
		balance = balance.Sub(repaid)
		balances[i] = balance
	}
	return balances
}

func main() {
	principal := decimal.MustParse("300000.00")
	rate := decimal.MustParse("0.0625")
	for i, b := range Schedule(principal, rate, 360) {
		fmt.Println(i+1, b)
	}
}
