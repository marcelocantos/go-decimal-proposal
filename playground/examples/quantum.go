package main

import "fmt"

func main() {
	price := decimal64(29.90)
	qty := decimal64(3)
	result := price * qty

	fmt.Printf("Price:  %v\n", price)
	fmt.Printf("Qty:    %v\n", qty)
	fmt.Printf("Total:  %v\n", result)

	// Multiplication adds quanta:
	// 29.90 (2 dp) * 3 (0 dp) = ? dp

	// Addition takes the finer quantum:
	a := decimal64(1.5)
	b := decimal64(0.10)
	fmt.Printf("\n%v + %v = %v\n", a, b, a+b)
}
