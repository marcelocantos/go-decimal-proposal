// A tour of the IEEE 754-2019 decimal operations that decimal64 and
// decimal128 support: the operators, the conversions, and the functions in
// math/decimal. Each line prints an operation and its result. The last
// section is the operations that the 2019 revision of the standard added.
package main

import (
	"fmt"
	"math/decimal"
	"strconv"
)

func main() {
	// Variables, not constants, where an operation must happen at run time:
	// constant expressions are exact and are checked by the compiler.
	zero := decimal64(0)
	negZero := -zero
	one := decimal64(1)
	inf := decimal.Inf[decimal64](1)
	nan := decimal.NaN[decimal64]()

	fmt.Println("--- Arithmetic (clause 5.4.1) ---")
	// Each operation rounds once, to nearest with ties to even. An exact
	// result keeps the quantum that clause 5.2 prefers, so trailing zeros
	// are not lost.
	a, b := decimal64(1.50), decimal64(1.25)
	fmt.Println("1.50 + 1.25 =", a+b)                          // the finer quantum of the two
	fmt.Println("1.50 - 1.25 =", a-b)                          // likewise
	fmt.Println("1.50 * 1.25 =", a*b)                          // the quanta multiply: 0.01 × 0.01
	fmt.Println("1.50 / 1.25 =", a/b)                          // exact: 1.2 at the exponent nearest the preferred 0
	fmt.Println("1 / 3 =", one/3)                              // inexact: 16 digits
	fmt.Println("1 / 3 =", decimal128(one)/3, "in decimal128") // 34 digits
	fmt.Println("2.5 * 4 + 0.1 with one rounding =", decimal.FMA[decimal64](2.5, 4, 0.1))
	fmt.Println("Remainder(7, 2) =", decimal.Remainder[decimal64](7, 2)) // 7 - 2×4
	fmt.Println("Mod(7, 2) =", decimal.Mod[decimal64](7, 2))             // 7 - 2×3, as Go's %

	fmt.Println("\n--- Comparisons (clause 5.11) ---")
	// Values compare, not encodings: 1.0 and 1.00 are equal, as are -0
	// and +0. A NaN is unordered: every comparison with it is false, but !=.
	fmt.Println("1.0 == 1.00:", decimal64(1.0) == 1.00)
	fmt.Println("-0 == +0:", negZero == zero)
	fmt.Println("NaN == NaN:", nan == nan, " NaN != NaN:", nan != nan)
	fmt.Println("NaN < 1:", nan < 1, " NaN > 1:", nan > 1, " NaN >= 1:", nan >= 1)
	fmt.Println("-Inf < -9.999999999999999E+384:", -inf < -9.999999999999999e384)

	fmt.Println("\n--- Conversions (clauses 5.4.2, 5.8, 5.12) ---")
	// Integers: an int64 of more than 16 digits rounds to decimal64, and
	// a decimal converts to an integer by truncation, as a float64 does.
	big := int64(12345678901234567) // 17 digits
	fmt.Println("decimal64(12345678901234567) =", decimal64(big))
	fmt.Println("decimal128(12345678901234567) =", decimal128(big))
	pos, neg := decimal64(2.75), decimal64(-2.75)
	fmt.Println("int64(2.75) =", int64(pos), " int64(-2.75) =", int64(neg))
	// Binary floating point: 0.1 is not exactly a float64, and the
	// conversion shows how far off it is.
	f := 0.1
	fmt.Println("decimal64(float64 0.1) =", decimal64(f))
	fmt.Println("decimal128(float64 0.1) =", decimal128(f))
	fmt.Println("float64(decimal64 0.1) =", float64(decimal64(0.1)))
	// Between the widths: widening is exact, narrowing rounds once.
	third := decimal128(one) / 3
	fmt.Println("decimal128(decimal64 1.50) =", decimal128(a))
	fmt.Println("decimal64(decimal128 1/3) =", decimal64(third))
	// Text: formatting keeps the quantum and parsing reads it back.
	s := strconv.FormatDecimal(decimal128(a), 'g', -1, 64)
	p, err := strconv.ParseDecimal("1.50", 64)
	fmt.Printf("FormatDecimal(1.50) = %q, ParseDecimal(\"1.50\") = %v, %v\n", s, decimal64(p), err)
	fmt.Printf("%%v %%.1f %%e of 1.50: %v %.1f %e\n", a, a, a)
	_, err = strconv.ParseDecimal("1e400", 64)
	fmt.Println("ParseDecimal(\"1e400\"):", err)

	fmt.Println("\n--- Quantize and SameQuantum (clauses 5.3.2, 5.7.3) ---")
	// Quantize gives x the exponent of y, rounding if it must.
	price := decimal64(2.675)
	cent := decimal64(0.01)
	fmt.Println("Quantize(2.675, 0.01) =", decimal.Quantize(price, cent)) // the tie goes to the even 8
	fmt.Println("Quantize(2.665, 0.01) =", decimal.Quantize[decimal64](2.665, cent))
	fmt.Println("Quantize(2, 0.01) =", decimal.Quantize[decimal64](2, cent))
	fmt.Println("SameQuantum(1.0, 1.00):", decimal.SameQuantum[decimal64](1.0, 1.00))
	fmt.Println("SameQuantum(2.17, 9.99):", decimal.SameQuantum[decimal64](2.17, 9.99))
	// QuantizeMode takes the rounding direction (clause 4.3) explicitly.
	for _, m := range []struct {
		name string
		mode decimal.RoundingMode
	}{
		{"ToNearestEven", decimal.ToNearestEven},
		{"ToNearestAway", decimal.ToNearestAway},
		{"ToZero", decimal.ToZero},
		{"ToPositiveInf", decimal.ToPositiveInf},
		{"ToNegativeInf", decimal.ToNegativeInf},
	} {
		fmt.Printf("QuantizeMode(-2.665, 0.01, %s) = %v\n", m.name, decimal.QuantizeMode[decimal64](-2.665, cent, m.mode))
	}

	fmt.Println("\n--- Rounding to an integer (clause 5.9) and the other functions ---")
	for _, x := range []decimal64{2.5, -2.5, 3.5} {
		fmt.Printf("x = %v: Trunc %v, Floor %v, Ceil %v, Round %v, RoundToEven %v\n", x,
			decimal.Trunc(x), decimal.Floor(x), decimal.Ceil(x), decimal.Round(x), decimal.RoundToEven(x))
	}
	fmt.Println("Reduce(1.500) =", decimal.Reduce[decimal64](1.500), " Reduce(100) =", decimal.Reduce[decimal64](100))
	fmt.Println("Abs(-1.50) =", decimal.Abs[decimal64](-1.50), " Copysign(1.50, -0) =", decimal.Copysign(a, negZero))
	fmt.Println("Dim(5, 3) =", decimal.Dim[decimal64](5, 3), " Dim(3, 5) =", decimal.Dim[decimal64](3, 5))
	fmt.Println("Signbit(-0):", decimal.Signbit(negZero), " IsNaN(NaN):", decimal.IsNaN(nan), " IsInf(-Inf, -1):", decimal.IsInf(-inf, -1))

	fmt.Println("\n--- min and max ---")
	fmt.Println("min(3, 2.5, 7) =", min(decimal64(3), 2.5, 7), " max(3, 2.5, 7) =", max(decimal64(3), 2.5, 7))
	fmt.Println("max(1.0, 1) =", max(decimal64(1.0), 1)) // equal values: the first

	fmt.Println("\n--- NaN propagation (clause 6.2) ---")
	// A NaN operand gives a NaN result, and the result carries the NaN's
	// payload (the integer it holds), as float64 arithmetic does.
	// Payload and NaNWithPayload are among the 2019 operations below.
	const tag = 42 // an arbitrary payload, to tell this NaN from others
	tagged := decimal.NaNWithPayload[decimal64](tag)
	fmt.Println("NaN + 1 =", tagged+1, " payload", decimal.Payload(tagged+1))
	fmt.Println("2 * NaN / 3 =", 2*tagged/3, " payload", decimal.Payload(2*tagged/3))
	fmt.Println("decimal128(NaN) payload", decimal.Payload(decimal128(tagged))) // widening keeps it
	fmt.Println("0 * Inf =", zero*inf, " payload", decimal.Payload(zero*inf))   // a new NaN has none

	fmt.Println("\n--- Signed zero and infinity (clauses 6.1, 6.3) ---")
	fmt.Println("1 / 0 =", one/zero, " -1 / 0 =", -one/zero, " 1 / -0 =", one/negZero)
	fmt.Println("-0 + -0 =", negZero+negZero, " -0 + 0 =", negZero+zero, " 0 * -1 =", zero*-one)
	fmt.Println("Inf + 1 =", inf+1, " Inf - Inf =", inf-inf, " 1 / Inf =", one/inf)

	fmt.Println("\n--- Overflow and underflow (clauses 7.4, 7.5) ---")
	const largest = 9.999999999999999e384 // the largest finite decimal64
	const smallest = 1e-398               // the smallest positive decimal64, a subnormal
	huge, tiny := decimal64(largest), decimal64(smallest)
	fmt.Println("9.999999999999999E+384 * 10 =", huge*10)          // overflows to Inf
	wide := decimal128(1e385)                                      // representable in decimal128 only
	fmt.Println("decimal64(decimal128 1E+385) =", decimal64(wide)) // narrowing overflows too
	fmt.Println("1E-383 / 10 =", decimal64(1e-383)/10)             // a subnormal: fewer digits, still exact
	fmt.Println("1E-398 / 2 =", tiny/2, " 1E-398 / 10 =", tiny/10) // halfway and below: round to 0

	// --- Added in IEEE 754-2019 ---
	fmt.Println("\n--- Added in IEEE 754-2019 ---")
	// minimum and maximum (clause 9.6), which Go's min and max are: a NaN
	// operand gives a NaN, and -0 is less than +0. IEEE 754-2008's minNum
	// and maxNum, which 2019 removed, returned the number.
	fmt.Println("min(NaN, 1) =", min(nan, one), " max(1, NaN) =", max(one, nan))
	fmt.Println("min(0, -0) =", min(zero, negZero), " max(-0, 0) =", max(negZero, zero))
	// quantum (clause 5.3.2): the value of one unit in the last digit.
	fmt.Println("Quantum(1.50) =", decimal.Quantum(a), " Quantum(-5E+3) =", decimal.Quantum[decimal64](-5e3))
	fmt.Println("Quantum(0.00) =", decimal.Quantum[decimal64](0.00), " Quantum(-Inf) =", decimal.Quantum(-inf))
	fmt.Println("Quantize(2.675, Quantum(0.01)) =", decimal.Quantize(price, decimal.Quantum(cent)))
	// getPayload, setPayload and setPayloadSignaling (clause 9.7).
	fmt.Println("Payload(NaNWithPayload(42)) =", decimal.Payload(decimal.NaNWithPayload[decimal64](tag)))
	fmt.Println("Payload(1.5) =", decimal.Payload[decimal64](1.5)) // not a NaN
	// A payload is an integer below 10^15 in decimal64 (10^33 in
	// decimal128), at any exponent; anything else gives +0.
	const maxPayload64 = 999999999999999 // 10^15 - 1
	fmt.Println("NaNWithPayload(4.2E+1) =", decimal.NaNWithPayload[decimal64](4.2e1),
		" payload", decimal.Payload(decimal.NaNWithPayload[decimal64](4.2e1)))
	fmt.Println("NaNWithPayload(10^15 - 1) payload", decimal.Payload(decimal.NaNWithPayload[decimal64](maxPayload64)))
	fmt.Println("NaNWithPayload(10^15) =", decimal.NaNWithPayload[decimal64](maxPayload64+1),
		" NaNWithPayload(4.2) =", decimal.NaNWithPayload[decimal64](4.2))
	fmt.Println("NaNWithPayload[decimal128](10^15) payload", decimal.Payload(decimal.NaNWithPayload[decimal128](maxPayload64+1)))
	// A signaling NaN carries its payload too, and arithmetic quiets it.
	signaling := decimal.SignalingNaNWithPayload[decimal64](tag)
	fmt.Println("SignalingNaNWithPayload(42) + 1 =", signaling+1, " payload", decimal.Payload(signaling+1))
}
