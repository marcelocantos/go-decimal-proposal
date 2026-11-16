// The loan schedule with github.com/shopspring/decimal.
package main

import (
	"fmt"

	"github.com/shopspring/decimal"
)

// Schedule returns the balance after each monthly payment of a fixed-rate
// loan. The payment and each month's interest are rounded to cents, half up,
// and the last payment clears the balance.
func Schedule(principal, annualRate decimal.Decimal, months int) []decimal.Decimal {
	one := decimal.NewFromInt(1)
	twelve := decimal.NewFromInt(12)
	r := annualRate.Div(twelve)
	f := one
	for range months {
		f = f.Mul(one.Add(r))
	}
	payment := principal.Mul(r).Mul(f).Div(f.Sub(one)).Round(2)

	balances := make([]decimal.Decimal, months)
	balance := principal
	for i := range balances {
		interest := balance.Mul(annualRate).Div(twelve).Round(2)
		repaid := payment.Sub(interest)
		if i == months-1 || repaid.GreaterThan(balance) {
			repaid = balance
		}
		balance = balance.Sub(repaid)
		balances[i] = balance
	}
	return balances
}

func main() {
	principal := decimal.RequireFromString("300000.00")
	rate := decimal.RequireFromString("0.0625")
	for i, b := range Schedule(principal, rate, 360) {
		fmt.Println(i+1, b.StringFixed(2))
	}
}
