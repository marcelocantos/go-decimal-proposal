package perfcompare

// TestRandomAgreement checks the fork against the other IEEE 754 candidates
// on operands with no pattern: thousands of random pairs of each shape,
// through every benchmarked operation. TestSameResults covers the four
// variants of each benchmark set; this covers what the sets do not, the
// rounding in both directions, ties, carries, cancellations and every
// digit length, on the paths that decide them from the operands' digits.

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"testing"

	"perfcompare/decquad"
	"perfcompare/intelbid"

)

func randDigits(r *rand.Rand, n int) string {
	var b strings.Builder
	b.WriteByte(byte('1' + r.Intn(9)))
	for i := 1; i < n; i++ {
		b.WriteByte(byte('0' + r.Intn(10)))
	}
	return b.String()
}

func randSign(r *rand.Rand) string {
	if r.Intn(2) == 0 {
		return "-"
	}
	return ""
}

// randomShapes are the kinds of operand pair the fork's own benchmarks
// draw: money, money and a rate, full precision at nearby and equal
// exponents, every length, and far apart.
var randomShapes = []struct {
	name string
	gen  func(r *rand.Rand) (string, string)
}{
	{"money", func(r *rand.Rand) (string, string) {
		return randSign(r) + randDigits(r, 1+r.Intn(9)) + "E-2", randSign(r) + randDigits(r, 1+r.Intn(9)) + "E-2"
	}},
	{"rate", func(r *rand.Rand) (string, string) {
		return randSign(r) + randDigits(r, 3+r.Intn(7)) + "E-2", randDigits(r, 5+r.Intn(3)) + "E-" + strconv.Itoa(4+r.Intn(3))
	}},
	{"full", func(r *rand.Rand) (string, string) {
		e := r.Intn(20) - 10
		x, y := randSign(r)+randDigits(r, 34)+"E"+strconv.Itoa(e), randSign(r)+randDigits(r, 34)+"E"+strconv.Itoa(e-r.Intn(13))
		if r.Intn(2) == 0 {
			x, y = y, x
		}
		return x, y
	}},
	{"varlen", func(r *rand.Rand) (string, string) {
		e := r.Intn(20) - 10
		return randSign(r) + randDigits(r, 1+r.Intn(34)) + "E" + strconv.Itoa(e), randSign(r) + randDigits(r, 1+r.Intn(34)) + "E" + strconv.Itoa(e+r.Intn(25)-12)
	}},
	{"far", func(r *rand.Rand) (string, string) {
		x, y := randSign(r)+randDigits(r, 1+r.Intn(34))+"E"+strconv.Itoa(20+r.Intn(10)), randSign(r)+randDigits(r, 1+r.Intn(34))+"E-"+strconv.Itoa(30+r.Intn(20))
		if r.Intn(2) == 0 {
			x, y = y, x
		}
		return x, y
	}},
	// Ties and their neighbours: an odd dividend over a power of two, and
	// sums whose discarded digits are 5 followed by zeros.
	{"ties", func(r *rand.Rand) (string, string) {
		if r.Intn(2) == 0 {
			x := randDigits(r, 1+r.Intn(33))
			x = x[:len(x)-1] + string("13579"[r.Intn(5)])
			return x, strconv.Itoa(1 << (1 + r.Intn(30)))
		}
		g := 1 + r.Intn(12)
		return randSign(r) + randDigits(r, 34), randSign(r) + randDigits(r, 34-g) + "5" + strings.Repeat("0", g-1) + "E-" + strconv.Itoa(g)
	}},
}

func isNaNBits(b bits128) bool { return b.hi&0x7c00000000000000 == 0x7c00000000000000 }

func TestRandomAgreement(t *testing.T) {
	const pairs = 3000
	type res struct {
		impl string
		b    bits128
	}
	mismatches := map[string]int{}
	check := func(op, shape, x, y string, want decimal128, got ...res) {
		t.Helper()
		w := forkBits(want)
		for _, g := range got {
			if g.b == w || isNaNBits(g.b) && isNaNBits(w) {
				continue
			}
			mismatches[g.impl]++
			if mismatches[g.impl] <= 5 {
				t.Errorf("%s %s(%s, %s): %s gives %s, fork gives %s", shape, op, x, y, g.impl,
					strconv.FormatDecimal(decimalFromBits(g.b), 'g', -1, 128), strconv.FormatDecimal(want, 'g', -1, 128))
			}
		}
	}
	quantum := "0.01"
	n := 0
	for _, shape := range randomShapes {
		r := rand.New(rand.NewSource(20261110))
		for range pairs {
			x, y := shape.gen(r)
			fx, fy := forkParse(x), forkParse(y)
			mx, my := mdParse(x), mdParse(y)
			bx, by := b7Parse(x), b7Parse(y)
			ix, iy := intelbid.Parse(x), intelbid.Parse(y)
			qx, qy := decquad.Parse(x), decquad.Parse(y)
			n++
			check("Add", shape.name, x, y, fx+fy, res{"decimal128-go", mdBits(mx.Add(my))}, res{"bid754", b7Bits(bx.Add(by))},
				res{"intel", ibBits(intelbid.Add(ix, iy))}, res{"decquad", dqBits(decquad.Add(qx, qy))})
			check("Sub", shape.name, x, y, fx-fy, res{"decimal128-go", mdBits(mx.Sub(my))}, res{"bid754", b7Bits(bx.Sub(by))},
				res{"intel", ibBits(intelbid.Sub(ix, iy))}, res{"decquad", dqBits(decquad.Sub(qx, qy))})
			check("Mul", shape.name, x, y, fx*fy, res{"decimal128-go", mdBits(mx.Mul(my))}, res{"bid754", b7Bits(bx.Mul(by))},
				res{"intel", ibBits(intelbid.Mul(ix, iy))}, res{"decquad", dqBits(decquad.Mul(qx, qy))})
			check("Div", shape.name, x, y, fx/fy, res{"decimal128-go", mdBits(mx.Quo(my))}, res{"bid754", b7Bits(bx.Div(by))},
				res{"intel", ibBits(intelbid.Div(ix, iy))}, res{"decquad", dqBits(decquad.Div(qx, qy))})
			b7fma, _ := bx.FMA(by, by)
			check("FMA", shape.name, x, y, decimalFMA(fx, fy, fy), res{"decimal128-go", mdBits(my.FMA(mx, my))}, res{"bid754", b7Bits(b7fma)},
				res{"intel", ibBits(intelbid.FMA(ix, iy, iy))}, res{"decquad", dqBits(decquad.FMA(qx, qy, qy))})
			check("Quantize", shape.name, x, quantum, decimalQuantize(fx, forkParse(quantum)),
				res{"decimal128-go", mdBits(mx.Quantize(mdParse(quantum)))}, res{"bid754", b7Bits(bx.Quantize(b7Parse(quantum)))},
				res{"intel", ibBits(intelbid.Quantize(ix, intelbid.Parse(quantum)))}, res{"decquad", dqBits(decquad.Quantize(qx, decquad.Parse(quantum)))})
			b7less, _ := bx.QuietLess(by)
			for impl, got := range map[string]bool{
				"decimal128-go": mx.Less(my), "bid754": b7less,
				"intel": intelbid.Less(ix, iy), "decquad": decquad.Less(qx, qy),
			} {
				if got != (fx < fy) {
					mismatches[impl]++
					if mismatches[impl] <= 5 {
						t.Errorf("%s Less(%s, %s): %s gives %v, fork %v", shape.name, x, y, impl, got, fx < fy)
					}
				}
			}
			// The text of the fork's result reads back to the same bits.
			for _, v := range []decimal128{fx, fy, fx + fy, fx / fy} {
				if back := forkParse(strconv.FormatDecimal(v, 'g', -1, 128)); forkBits(back) != forkBits(v) && !isNaNBits(forkBits(v)) {
					t.Errorf("%s: %s formats and parses back to %s", shape.name, fmt.Sprint(v), fmt.Sprint(back))
				}
			}
		}
	}
	t.Logf("%d pairs, 7 operations each; mismatches by candidate: %v", n, mismatches)
}
