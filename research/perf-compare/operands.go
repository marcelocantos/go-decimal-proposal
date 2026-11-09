// Package perfcompare benchmarks decimal128 implementations on identical
// operations and operands. The benchmarks are in the _test.go files, one per
// candidate; this file holds the operand sets they all share.
//
// Each set is a pair of operands x and y, given as text so that every
// candidate parses the same strings. Each operand comes in variants that
// differ only in the last digit of the coefficient, so that a benchmark
// loop can index the variants (i&3) and no candidate can fold a constant.
// The variants keep the class: same number of digits, same exponent, same
// signs, so the same path through each implementation.
package perfcompare

// NVariants is the number of variants of each operand; it is a power of two
// so that the loops index with i&(NVariants-1).
const NVariants = 4

// Set is one operand set.
type Set struct {
	Name string
	Desc string
	X, Y [NVariants]string
}

// Money is set (a), "typical money": two amounts with quantum -2 and a
// handful of digits.
var Money = Set{
	Name: "money",
	Desc: "1234.56 and 78.90 (quantum -2, 6 and 4 digits)",
	X:    [NVariants]string{"1234.56", "1234.57", "1234.58", "1234.59"},
	Y:    [NVariants]string{"78.90", "78.91", "78.92", "78.93"},
}

// Full is set (b), "full precision": two 34-digit coefficients whose
// exponents differ by 4, so the aligned sum is 38 digits and must round.
// It is the "OQ" pair of decimal128-go's own benchmarks.
var Full = Set{
	Name: "full",
	Desc: "1234567890123456789012345678901234 and 9876543210987654321098765432109876E-4 (34 digits each, exponents 0 and -4)",
	X: [NVariants]string{
		"1234567890123456789012345678901234",
		"1234567890123456789012345678901233",
		"1234567890123456789012345678901232",
		"1234567890123456789012345678901231",
	},
	Y: [NVariants]string{
		"9876543210987654321098765432109876E-4",
		"9876543210987654321098765432109877E-4",
		"9876543210987654321098765432109878E-4",
		"9876543210987654321098765432109879E-4",
	},
}

// Far is set (c), "far exponents": 9 digits each, exponents 60 apart, so
// in an addition y is swamped (the "FQ" pair of decimal128-go).
var Far = Set{
	Name: "far",
	Desc: "1.23456789E+30 and 9.87654321E-30 (9 digits each, exponents +22 and -38)",
	X:    [NVariants]string{"1.23456789E+30", "1.23456788E+30", "1.23456787E+30", "1.23456786E+30"},
	Y:    [NVariants]string{"9.87654321E-30", "9.87654322E-30", "9.87654323E-30", "9.87654324E-30"},
}

// Pow10 is set (d), "exact division by a power of ten": used only by Div.
// The quotient 123.456789 is exact.
var Pow10 = Set{
	Name: "pow10",
	Desc: "123456.789 / 1000 (exact quotient 123.456789)",
	X:    [NVariants]string{"123456.789", "123456.788", "123456.787", "123456.786"},
	Y:    [NVariants]string{"1000", "1000", "1000", "1000"},
}

// Quantum is the second operand of Quantize in every set: x is quantized to
// two places (ties to even).
const Quantum = "0.01"

// Arith is the sets of Add, Sub, Mul, FMA and Quantize. FMA computes
// x*y + y.
var Arith = []Set{Money, Full, Far}

// Division is the sets of Div.
var Division = []Set{Money, Full, Far, Pow10}

// Compare is the sets of Less (x < y).
var Compare = []Set{Money, Full}

// Text is the sets of Parse and Format, which use the x operands.
var Text = []Set{Money, Full}
