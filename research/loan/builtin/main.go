// The loan schedule with the proposal's built-in decimal128.
package main

import (
	"fmt"
	"math/decimal"
)

// Schedule returns the balance after each monthly payment of a fixed-rate
// loan. The payment and each month's interest are rounded to cents, half up,
// and the last payment clears the balance.
func Schedule(principal, annualRate decimal128, months int) []decimal128 {
	const cent decimal128 = 0.01
	r := annualRate / 12
	f := decimal128(1)
	for range months {
		f *= 1 + r
	}
	payment := decimal.QuantizeMode(principal*r*f/(f-1), cent, decimal.ToNearestAway)

	balances := make([]decimal128, months)
	balance := principal
	for i := range balances {
		interest := decimal.QuantizeMode(balance*annualRate/12, cent, decimal.ToNearestAway)
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
