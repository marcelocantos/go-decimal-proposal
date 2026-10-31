package main

import "fmt"

func main() {
	a, b := 0.1, 0.2
	fmt.Println("Binary: ", a+b)

	da, db := decimal64(0.1), decimal64(0.2)
	fmt.Println("Decimal:", da+db)
}
