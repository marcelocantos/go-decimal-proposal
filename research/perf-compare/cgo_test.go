package perfcompare

// The C candidates, Intel BID and decNumber's decQuad, through cgo. Each
// operation has two rows: -cgo makes one cgo call per operation, -cloop runs
// the loop in C (one cgo call per benchmark), so -cloop is the library's own
// cost and -cgo minus -cloop is the cgo transition. The cgo-nop rows measure
// the transition alone: an empty call, and a call that passes two 16-byte
// values and returns one, the shape of a binary operation.

import (
	"testing"

	"perfcompare/decquad"
	"perfcompare/intelbid"
)

func init() {
	reg("Cgo", "empty", "cgo-nop", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			intelbid.Nop()
		}
	})
	{
		xs, ys := conv(Money.X, intelbid.Parse), conv(Money.Y, intelbid.Parse)
		reg("Cgo", "binary", "cgo-nop", func(b *testing.B) { loop2(b, xs, ys, intelbid.Nop2) })
	}

	for _, s := range Arith {
		{
			xs, ys, q := conv(s.X, intelbid.Parse), conv(s.Y, intelbid.Parse), fill(intelbid.Parse(Quantum))
			reg("Add", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, ys, intelbid.Add) })
			reg("Add", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopAdd(xs, ys, b.N) })
			reg("Sub", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, ys, intelbid.Sub) })
			reg("Sub", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopSub(xs, ys, b.N) })
			reg("Mul", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, ys, intelbid.Mul) })
			reg("Mul", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopMul(xs, ys, b.N) })
			reg("FMA", s.Name, "intel-cgo", func(b *testing.B) {
				loop2(b, xs, ys, func(x, y intelbid.D) intelbid.D { return intelbid.FMA(x, y, y) })
			})
			reg("FMA", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopFMA(xs, ys, b.N) })
			reg("Quantize", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, q, intelbid.Quantize) })
			reg("Quantize", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopQuantize(xs, q, b.N) })
		}
		{
			xs, ys, q := conv(s.X, decquad.Parse), conv(s.Y, decquad.Parse), fill(decquad.Parse(Quantum))
			reg("Add", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, ys, decquad.Add) })
			reg("Add", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopAdd(xs, ys, b.N) })
			reg("Sub", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, ys, decquad.Sub) })
			reg("Sub", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopSub(xs, ys, b.N) })
			reg("Mul", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, ys, decquad.Mul) })
			reg("Mul", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopMul(xs, ys, b.N) })
			reg("FMA", s.Name, "decquad-cgo", func(b *testing.B) {
				loop2(b, xs, ys, func(x, y decquad.D) decquad.D { return decquad.FMA(x, y, y) })
			})
			reg("FMA", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopFMA(xs, ys, b.N) })
			reg("Quantize", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, q, decquad.Quantize) })
			reg("Quantize", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopQuantize(xs, q, b.N) })
		}
	}
	for _, s := range Division {
		{
			xs, ys := conv(s.X, intelbid.Parse), conv(s.Y, intelbid.Parse)
			reg("Div", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, ys, intelbid.Div) })
			reg("Div", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopDiv(xs, ys, b.N) })
		}
		{
			xs, ys := conv(s.X, decquad.Parse), conv(s.Y, decquad.Parse)
			reg("Div", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, ys, decquad.Div) })
			reg("Div", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopDiv(xs, ys, b.N) })
		}
	}
	for _, s := range Compare {
		{
			xs, ys := conv(s.X, intelbid.Parse), conv(s.Y, intelbid.Parse)
			reg("Less", s.Name, "intel-cgo", func(b *testing.B) { loop2(b, xs, ys, intelbid.Less) })
			reg("Less", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopLess(xs, ys, b.N) })
		}
		{
			xs, ys := conv(s.X, decquad.Parse), conv(s.Y, decquad.Parse)
			reg("Less", s.Name, "decquad-cgo", func(b *testing.B) { loop2(b, xs, ys, decquad.Less) })
			reg("Less", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopLess(xs, ys, b.N) })
		}
	}
	for _, s := range Text {
		{
			cs := conv(s.X, intelbid.CString)
			xs := conv(s.X, intelbid.Parse)
			reg("Parse", s.Name, "intel-cgo", func(b *testing.B) { loop1(b, cs, intelbid.ParseC) })
			reg("Parse", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopParse(cs, b.N) })
			// Format into a C buffer: no Go string is made.
			reg("Format", s.Name, "intel-cgo", func(b *testing.B) { loop1(b, xs, intelbid.FormatBuf) })
			reg("Format", s.Name, "intel-cloop", func(b *testing.B) { intelbid.LoopFormat(xs, b.N) })
		}
		{
			cs := conv(s.X, decquad.CString)
			xs := conv(s.X, decquad.Parse)
			reg("Parse", s.Name, "decquad-cgo", func(b *testing.B) { loop1(b, cs, decquad.ParseC) })
			reg("Parse", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopParse(cs, b.N) })
			reg("Format", s.Name, "decquad-cgo", func(b *testing.B) { loop1(b, xs, decquad.FormatBuf) })
			reg("Format", s.Name, "decquad-cloop", func(b *testing.B) { decquad.LoopFormat(xs, b.N) })
		}
	}
}
