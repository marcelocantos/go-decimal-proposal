package perfcompare

// The drawn sets: operands of one kind whose digits, signs and order have no
// pattern, drawn from a pool of 1024 pairs by a generator instead of walked.
//
// The four variants of each set in operands.go repeat, and a repeating
// operand trains the branch predictor on the operand: every branch a
// candidate takes on the digits is then predicted, and the row shows the
// operation as it runs on one value, over and over. Real operands do not
// repeat. A drawn row shows what the operation costs when the rounding
// direction, the carries, the digit counts within one kind and the order
// of the operands are as unpredictable as they are in data. The generator
// is a chain from each iteration to the next, about 1.5 ns that every
// candidate's row includes alike; the C loops draw the same way.

import (
	"math/rand"
	"strconv"
	"testing"

	"perfcompare/decquad"
	"perfcompare/intelbid"

	md "github.com/migueldecimal128/decimal128-go"
	bid754 "github.com/sky1core/bid754/bid754-go"
)

// DrawnN is the number of operand pairs in a drawn pool. It is a power of
// two, and the pools of every candidate fit the first-level cache together.
const DrawnN = 1024

// drawnSets are the kinds of pair: full precision at nearby exponents, and
// money.
var drawnSets = []struct {
	name, desc string
	gen        func(r *rand.Rand) (string, string)
}{
	{"drawn-full", "34 digits each, exponents 1 to 12 apart either way, signs at random",
		func(r *rand.Rand) (string, string) {
			e := r.Intn(20) - 10
			x := randSign(r) + randDigits(r, 34) + "E" + strconv.Itoa(e)
			y := randSign(r) + randDigits(r, 34) + "E" + strconv.Itoa(e-1-r.Intn(12))
			if r.Intn(2) == 0 {
				x, y = y, x
			}
			return x, y
		}},
	{"drawn-money", "amounts of 3 to 9 digits with two places, signs at random",
		func(r *rand.Rand) (string, string) {
			return randSign(r) + randDigits(r, 3+r.Intn(7)) + "E-2", randSign(r) + randDigits(r, 3+r.Intn(7)) + "E-2"
		}},
}

func drawnPool[T any](xs, ys []string, parse func(string) T) (px, py []T) {
	for i := range xs {
		px, py = append(px, parse(xs[i])), append(py, parse(ys[i]))
	}
	return px, py
}

// loop2d is loop2 over a drawn pool: the pair is chosen by one step of
// Marsaglia's 64-bit xorshift generator.
func loop2d[A, R any](b *testing.B, xs, ys []A, f func(x, y A) R) {
	var s R
	r := uint64(88172645463325252)
	for i := 0; i < b.N; i++ {
		r ^= r << 13
		r ^= r >> 7
		r ^= r << 17
		j := r >> 32 & (DrawnN - 1)
		s = f(xs[j], ys[j])
	}
	sinkAny = s
}

func init() {
	for _, set := range drawnSets {
		r := rand.New(rand.NewSource(20261110))
		var sx, sy []string
		for range DrawnN {
			x, y := set.gen(r)
			sx, sy = append(sx, x), append(sy, y)
		}
		name := set.name
		{
			xs, ys := drawnPool(sx, sy, forkParse)
			reg("Add", name, "fork", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x + y }) })
			reg("Sub", name, "fork", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x - y }) })
			reg("Mul", name, "fork", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x * y }) })
			reg("Div", name, "fork", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x / y }) })
			reg("Less", name, "fork", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) bool { return x < y }) })
		}
		{
			xs, ys := drawnPool(sx, sy, mdParse)
			reg("Add", name, "decimal128-go", func(b *testing.B) { loop2d(b, xs, ys, md.Decimal128.Add) })
			reg("Sub", name, "decimal128-go", func(b *testing.B) { loop2d(b, xs, ys, md.Decimal128.Sub) })
			reg("Mul", name, "decimal128-go", func(b *testing.B) { loop2d(b, xs, ys, md.Decimal128.Mul) })
			reg("Div", name, "decimal128-go", func(b *testing.B) { loop2d(b, xs, ys, md.Decimal128.Quo) })
			reg("Less", name, "decimal128-go", func(b *testing.B) { loop2d(b, xs, ys, md.Decimal128.Less) })
		}
		{
			xs, ys := drawnPool(sx, sy, b7Parse)
			reg("Add", name, "bid754", func(b *testing.B) { loop2d(b, xs, ys, bid754.Decimal128BID.Add) })
			reg("Sub", name, "bid754", func(b *testing.B) { loop2d(b, xs, ys, bid754.Decimal128BID.Sub) })
			reg("Mul", name, "bid754", func(b *testing.B) { loop2d(b, xs, ys, bid754.Decimal128BID.Mul) })
			reg("Div", name, "bid754", func(b *testing.B) { loop2d(b, xs, ys, bid754.Decimal128BID.Div) })
			reg("Less", name, "bid754", func(b *testing.B) {
				loop2d(b, xs, ys, func(x, y bid754.Decimal128BID) bool { r, _ := x.QuietLess(y); return r })
			})
		}
		{
			xs, ys := drawnPool(sx, sy, intelbid.Parse)
			reg("Add", name, "intel-cloop", func(b *testing.B) { intelbid.DrawnAdd(xs, ys, b.N) })
			reg("Sub", name, "intel-cloop", func(b *testing.B) { intelbid.DrawnSub(xs, ys, b.N) })
			reg("Mul", name, "intel-cloop", func(b *testing.B) { intelbid.DrawnMul(xs, ys, b.N) })
			reg("Div", name, "intel-cloop", func(b *testing.B) { intelbid.DrawnDiv(xs, ys, b.N) })
			reg("Less", name, "intel-cloop", func(b *testing.B) { intelbid.DrawnLess(xs, ys, b.N) })
		}
		{
			xs, ys := drawnPool(sx, sy, decquad.Parse)
			reg("Add", name, "decquad-cloop", func(b *testing.B) { decquad.DrawnAdd(xs, ys, b.N) })
			reg("Sub", name, "decquad-cloop", func(b *testing.B) { decquad.DrawnSub(xs, ys, b.N) })
			reg("Mul", name, "decquad-cloop", func(b *testing.B) { decquad.DrawnMul(xs, ys, b.N) })
			reg("Div", name, "decquad-cloop", func(b *testing.B) { decquad.DrawnDiv(xs, ys, b.N) })
			reg("Less", name, "decquad-cloop", func(b *testing.B) { decquad.DrawnLess(xs, ys, b.N) })
		}
	}
}
