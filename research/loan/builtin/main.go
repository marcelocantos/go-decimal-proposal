// The loan schedule with the proposal's built-in decimal128.
package main

import (
	"fmt"
	"math/decimal"
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
func Schedule(principal, annualRate decimal128, months int) []decimal128 {
	const place, cent decimal128 = 1e-12, 0.01
	const mode = decimal.ToNearestAway
	r := decimal.QuoQuantize(annualRate, 12, place, mode)
	f := decimal128(1)
	for range months {
		f = decimal.QuantizeMode(f*(1+r), place, mode)
	}
	a := decimal.QuoQuantize(r*f, f-1, place, mode)
	payment := decimal.QuantizeMode(principal*a, cent, mode)

	balances := make([]decimal128, months)
	balance := principal
	for i := range balances {
		interest := decimal.QuoQuantize(balance*annualRate, 12, cent, mode)
		repaid := payment - interest
		if i == months-1 || repaid > balance {
			repaid = balance
		}
		balance -= repaid
		balances[i] = balance
	}
	return balances
}

func main() {
	for i, b := range Schedule(300000.00, 0.0625, 360) {
		fmt.Println(i+1, b)
	}
}
