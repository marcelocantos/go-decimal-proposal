package main

import "fmt"

func main() {
	price := decimal64(29.90)
	qty := decimal64(3)
	result := price * qty

	fmt.Printf("Price:  %#g\n", price)
	fmt.Printf("Qty:    %#g\n", qty)
	fmt.Printf("Total:  %#g\n", result)

	// Multiplication adds quanta:
	// 29.90 (2 dp) * 3 (0 dp) = ? dp

	// Addition takes the finer quantum:
	a := decimal64(1.5)
	b := decimal64(0.10)
	fmt.Printf("\n%#g + %#g = %#g\n", a, b, a+b)
}
