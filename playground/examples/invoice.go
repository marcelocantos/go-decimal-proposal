package main

import "fmt"

func main() {
	type LineItem struct {
		Description string
		Price       decimal64
		Quantity    decimal64
	}

	items := []LineItem{
		{"Widget A", 19.99, 3},
		{"Widget B", 4.50, 12},
		{"Shipping", 7.95, 1},
	}

	taxRate := decimal64(0.0825)
	var subtotal decimal64
	for _, item := range items {
		subtotal += item.Price * item.Quantity
	}
	tax := subtotal * taxRate
	total := subtotal + tax

	fmt.Printf("Subtotal: $%6.2f\n", subtotal)
	fmt.Printf("Tax:      $%6.2f\n", tax)
	fmt.Printf("Total:    $%6.2f\n", total)
}
