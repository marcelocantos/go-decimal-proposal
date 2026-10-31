package main

import "fmt"

func main() {
	// The killer example: 0.1 + 0.2
	var a decimal64 = 0.1
	var b decimal64 = 0.2
	fmt.Printf("0.1 + 0.2 = %v\n", a+b)
	fmt.Printf("0.1 + 0.2 == 0.3? %v\n", a+b == 0.3)

	// Compare with float64
	var fa float64 = 0.1
	var fb float64 = 0.2
	fmt.Printf("\nfloat64: 0.1 + 0.2 = %.20f\n", fa+fb)
	fmt.Printf("float64: 0.1 + 0.2 == 0.3? %v\n", fa+fb == 0.3)

	// Arithmetic
	var x decimal64 = 1.5
	var y decimal64 = 2.5
	fmt.Printf("\n1.5 + 2.5 = %v\n", x+y)
	fmt.Printf("1.5 * 2.5 = %v\n", x*y)
	fmt.Printf("1.5 / 2.5 = %v\n", x/y)

	// Conversions
	var i int64 = 42
	var d decimal64 = decimal64(i)
	fmt.Printf("\nint64(42) as decimal64: %v\n", d)
	fmt.Printf("back to int64: %v\n", int64(d))

	// Map with decimal64 keys
	m := map[decimal64]string{
		0.1: "one tenth",
		0.2: "two tenths",
		0.3: "three tenths",
	}
	fmt.Printf("\nm[0.1+0.2] = %q\n", m[a+b])
}
