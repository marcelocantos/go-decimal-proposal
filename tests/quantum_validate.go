// Package tests contains end-to-end validation for the decimal64/decimal128
// toolchain, covering quantum preservation from source literals through
// arithmetic and formatting.
package main

import (
	"fmt"
	"math"
	"os"
	"strings"
)

var failures int

func check(name, got, want string) {
	got = strings.TrimSpace(got)
	want = strings.TrimSpace(want)
	if got != want {
		fmt.Fprintf(os.Stderr, "FAIL %s: got %q, want %q\n", name, got, want)
		failures++
	} else {
		fmt.Printf("ok   %s\n", name)
	}
}

func main() {
	// 1. Literal quantum preservation: decimal64(1.50) should keep 3 sig digits.
	d := decimal64(1.50)
	check("literal quantum 1.50",
		fmt.Sprintf("%#g", d), "1.50")

	// 2. Literal quantum: decimal64(1.20) should keep 3 sig digits.
	check("literal quantum 1.20",
		fmt.Sprintf("%#g", decimal64(1.20)), "1.20")

	// 3. Multiplication quantum propagation: 1.50 * 1.20 adds quanta → 4 digits.
	product := decimal64(1.50) * decimal64(1.20)
	check("mul quantum 1.50*1.20 %%#g",
		fmt.Sprintf("%#g", product), "1.8000")

	// 4. Same with %#f.
	check("mul quantum 1.50*1.20 %%#f",
		fmt.Sprintf("%#f", product), "1.8000")

	// 5. Without # flag, trailing zeros are stripped.
	check("mul 1.50*1.20 %%g",
		fmt.Sprintf("%g", product), "1.8")

	// 6. Verify BID64 encoding directly: coeff=18000, exp=-4.
	bits := math.Decimal64bits(product)
	exp := int((bits>>53)&0x3FF) - 398
	coeff := bits & ((1 << 53) - 1)
	check("bid64 coeff", fmt.Sprintf("%d", coeff), "18000")
	check("bid64 exp", fmt.Sprintf("%d", exp), "-4")

	// 7. Widening to decimal128 preserves quantum.
	d128 := decimal128(product)
	check("widen %%#g",
		fmt.Sprintf("%#g", d128), "1.8000")

	// 8. Addition quantum propagation: max quantum rule.
	// decimal64(1.5) + decimal64(0.20) = 1.70 (2 decimal places from 0.20).
	sum := decimal64(1.5) + decimal64(0.20)
	check("add quantum 1.5+0.20 %%#g",
		fmt.Sprintf("%#g", sum), "1.70")

	// 9. Integer literal quantum: decimal64(42) has no decimal places.
	check("integer quantum 42",
		fmt.Sprintf("%#g", decimal64(42)), "42")

	// 10. Named constant quantum preservation.
	const price = 9.99
	var p decimal64 = price
	check("named const quantum",
		fmt.Sprintf("%#g", p), "9.99")

	// 11. Bare number in expression: amt * 0.05
	var amt decimal64 = 100
	tax := amt * 0.05
	check("bare number amt*0.05 %%#g",
		fmt.Sprintf("%#g", tax), "5.00")

	// 12. Basic arithmetic correctness.
	check("0.1+0.2",
		fmt.Sprintf("%g", decimal64(0.1)+decimal64(0.2)), "0.3")

	// 13. NaN and Inf formatting.
	nan := math.Decimal64frombits(0x7c00000000000000)
	check("NaN", fmt.Sprintf("%g", nan), "NaN")

	inf := math.Decimal64frombits(0x7800000000000000)
	check("+Inf", fmt.Sprintf("%g", inf), "+Inf")

	if failures > 0 {
		fmt.Fprintf(os.Stderr, "\n%d test(s) FAILED\n", failures)
		os.Exit(1)
	}
	fmt.Printf("\nall %d tests passed\n", 13)
}
