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
// rounding is to nearest, ties to even; and the last payment clears the
// balance.
// For a principal of at most 10,000,000.00, a positive annual rate of at
// most 0.25 with four places and at most 480 months, every product is exact
// in decimal128, so each step is one exact operation and at most one
// rounding.
func Schedule(principal, annualRate decimal128, months int) []decimal128 {
	const place, cent decimal128 = 1e-12, 0.01
	const even = decimal.ToNearestEven
	r := decimal.QuoQuantize(annualRate, 12, place, even)
	f := decimal128(1)
	for range months {
		f = decimal.Quantize(f*(1+r), place)
	}
	a := decimal.QuoQuantize(r*f, f-1, place, even)
	payment := decimal.Quantize(principal*a, cent)

	balances := make([]decimal128, months)
	balance := principal
	for i := range balances {
		interest := decimal.QuoQuantize(balance*annualRate, 12, cent, even)
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
