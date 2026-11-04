package main

import (
	"fmt"
	"math/decimal"
)

func main() {
	// Business rounding is explicit: quantize to the cent.
	tax := decimal64(19.99) * 0.0825
	fmt.Println("tax:            ", tax)
	fmt.Println("to the cent:    ", decimal.Quantize(tax, 0.01))

	// Half a cent, rounded each way.
	half := decimal64(2.345)
	fmt.Println("half to even:   ", decimal.Quantize(half, 0.01))
	fmt.Println("half away:      ", decimal.QuantizeMode(half, 0.01, decimal.ToNearestAway))
	fmt.Println("toward zero:    ", decimal.QuantizeMode(half, 0.01, decimal.ToZero))

	// Reduce drops trailing zeros; Floor and Ceil work as for floats.
	fmt.Println("reduce 1.500:   ", decimal.Reduce(decimal64(1.500)))
	fmt.Println("floor, ceil:    ", decimal.Floor(decimal128(-2.5)), decimal.Ceil(decimal128(-2.5)))
}
