package main

import "fmt"

func main() {
	usdToEur := decimal64(0.92)
	usdToGbp := decimal64(0.79)
	amount := decimal64(1000.00)

	fmt.Printf("$%.2f = €%.2f\n", amount, amount*usdToEur)
	fmt.Printf("$%.2f = £%.2f\n", amount, amount*usdToGbp)
}
