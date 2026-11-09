package perfcompare

// TestSameResults checks that every IEEE 754 candidate computes the same
// decimal128, quantum included, as the fork on every benchmarked operation,
// so the rows time the same work. shopspring and float64 are not IEEE
// decimal128 and are not checked.

import (
	"encoding/binary"
	"math"
	"strconv"
	"testing"

	"perfcompare/decquad"
	"perfcompare/intelbid"

	md "github.com/migueldecimal128/decimal128-go"
	bid754 "github.com/sky1core/bid754/bid754-go"
)

type bits128 struct{ hi, lo uint64 }

func forkBits(d decimal128) bits128 { hi, lo := math.Decimal128bits(d); return bits128{hi, lo} }

func mdBits(d md.Decimal128) bits128 { hi, lo := d.BID128(); return bits128{hi, lo} }

func b7Bits(d bid754.Decimal128BID) bits128 {
	return bits128{binary.LittleEndian.Uint64(d[8:]), binary.LittleEndian.Uint64(d[:8])}
}

func ibBits(d intelbid.D) bits128 { return bits128{d[1], d[0]} }

// decQuad is DPD; compare it through its text, which keeps the quantum.
func dqBits(d decquad.D) bits128 { return forkBits(forkParse(decquad.Format(d))) }

func TestSameResults(t *testing.T) {
	type res struct {
		impl string
		b    bits128
	}
	check := func(op, set string, i int, want decimal128, got ...res) {
		t.Helper()
		w := forkBits(want)
		for _, g := range got {
			if g.b != w {
				t.Errorf("%s %s[%d]: %s gives %s, fork gives %s", op, set, i, g.impl,
					strconv.FormatDecimal(math.Decimal128frombits(g.b.hi, g.b.lo), 'g', -1, 128),
					strconv.FormatDecimal(want, 'g', -1, 128))
			}
		}
	}
	type binop struct {
		name string
		fork func(x, y decimal128) decimal128
		md   func(x, y md.Decimal128) md.Decimal128
		b7   func(x, y bid754.Decimal128BID) bid754.Decimal128BID
		ib   func(x, y intelbid.D) intelbid.D
		dq   func(x, y decquad.D) decquad.D
	}
	ops := []binop{
		{"Add", func(x, y decimal128) decimal128 { return x + y }, md.Decimal128.Add, bid754.Decimal128BID.Add, intelbid.Add, decquad.Add},
		{"Sub", func(x, y decimal128) decimal128 { return x - y }, md.Decimal128.Sub, bid754.Decimal128BID.Sub, intelbid.Sub, decquad.Sub},
		{"Mul", func(x, y decimal128) decimal128 { return x * y }, md.Decimal128.Mul, bid754.Decimal128BID.Mul, intelbid.Mul, decquad.Mul},
		{"FMA", func(x, y decimal128) decimal128 { return decimalFMA(x, y, y) },
			func(x, y md.Decimal128) md.Decimal128 { return y.FMA(x, y) },
			func(x, y bid754.Decimal128BID) bid754.Decimal128BID { r, _ := x.FMA(y, y); return r },
			func(x, y intelbid.D) intelbid.D { return intelbid.FMA(x, y, y) },
			func(x, y decquad.D) decquad.D { return decquad.FMA(x, y, y) }},
		{"Div", func(x, y decimal128) decimal128 { return x / y }, md.Decimal128.Quo, bid754.Decimal128BID.Div, intelbid.Div, decquad.Div},
	}
	run := func(op binop, s Set, ys [NVariants]string) {
		for i := range NVariants {
			x, y := s.X[i], ys[i]
			check(op.name, s.Name, i, op.fork(forkParse(x), forkParse(y)),
				res{"decimal128-go", mdBits(op.md(mdParse(x), mdParse(y)))},
				res{"bid754", b7Bits(op.b7(b7Parse(x), b7Parse(y)))},
				res{"intel", ibBits(op.ib(intelbid.Parse(x), intelbid.Parse(y)))},
				res{"decquad", dqBits(op.dq(decquad.Parse(x), decquad.Parse(y)))})
		}
	}
	for _, op := range ops {
		sets := Arith
		if op.name == "Div" {
			sets = Division
		}
		for _, s := range sets {
			run(op, s, s.Y)
		}
	}
	quantize := binop{"Quantize", decimalQuantize, md.Decimal128.Quantize, bid754.Decimal128BID.Quantize, intelbid.Quantize, decquad.Quantize}
	for _, s := range Arith {
		run(quantize, s, *fill(Quantum))
	}
	for _, s := range Compare {
		for i := range NVariants {
			x, y := s.X[i], s.Y[i]
			want := forkParse(x) < forkParse(y)
			b7, _ := b7Parse(x).QuietLess(b7Parse(y))
			for impl, got := range map[string]bool{
				"decimal128-go": mdParse(x).Less(mdParse(y)),
				"bid754":        b7,
				"intel":         intelbid.Less(intelbid.Parse(x), intelbid.Parse(y)),
				"decquad":       decquad.Less(decquad.Parse(x), decquad.Parse(y)),
			} {
				if got != want {
					t.Errorf("Less %s[%d]: %s gives %v, fork %v", s.Name, i, impl, got, want)
				}
			}
		}
	}
	// Parse: every parser gives the fork's bits; Format: every formatter's
	// text parses back to them. The texts themselves differ in style.
	for _, s := range Text {
		for i, x := range s.X {
			want := forkParse(x)
			check("Parse", s.Name, i, want,
				res{"decimal128-go", mdBits(mdParse(x))},
				res{"bid754", b7Bits(b7Parse(x))},
				res{"intel", ibBits(intelbid.Parse(x))},
				res{"decquad", dqBits(decquad.Parse(x))})
			check("Format", s.Name, i, want,
				res{"fork-strconv", forkBits(forkParse(strconv.FormatDecimal(want, 'g', -1, 128)))},
				res{"decimal128-go", forkBits(forkParse(mdParse(x).String()))},
				res{"bid754", forkBits(forkParse(b7Parse(x).String()))},
				res{"intel", forkBits(forkParse(intelbid.Format(intelbid.Parse(x))))})
			t.Logf("Format %s[%d]: fork %q decimal128-go %q bid754 %q intel %q decquad %q", s.Name, i,
				strconv.FormatDecimal(want, 'g', -1, 128), mdParse(x).String(), b7Parse(x).String(),
				intelbid.Format(intelbid.Parse(x)), decquad.Format(decquad.Parse(x)))
		}
	}
}
