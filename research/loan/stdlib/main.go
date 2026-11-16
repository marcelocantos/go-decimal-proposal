// The loan schedule with the math/decimal package proposed in
// https://go.dev/issue/82668, as implemented by https://go.dev/cl/855581.
// run.sh copies that package into ./decimal.
package main

import (
	"fmt"

	"loan/stdlib/decimal"
)

// Schedule returns the balance after each monthly payment of a fixed-rate
// loan. The payment and each month's interest are rounded to cents, ties to
// even, and the last payment clears the balance.
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	const rateScale = 34 // places kept in the monthly rate
	const even = decimal.ToNearestEven
	twelve := decimal.FromInt(12)
	r := annualRate.Quo(twelve, rateScale, even)
	f := decimal.One
	for range months {
		f = f.Mul(decimal.One.Add(r))
	}
	payment := principal.Mul(r).Mul(f).Quo(f.Sub(decimal.One), 2, even)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := balance.Mul(annualRate).Quo(twelve, 2, even)
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
