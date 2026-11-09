package perfcompare

// The fork's built-in decimal128: the language operators, math/decimal,
// strconv and fmt. Needs the fork toolchain and GOEXPERIMENT=decimal.

import (
	"fmt"
	"math/decimal"
	"strconv"
	"testing"
)

func forkParse(s string) decimal128 { return must(strconv.ParseDecimal(s, 128)) }

func init() {
	for _, s := range Arith {
		xs, ys := conv(s.X, forkParse), conv(s.Y, forkParse)
		q := fill(forkParse(Quantum))
		reg("Add", s.Name, "fork", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x + y }) })
		reg("Sub", s.Name, "fork", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x - y }) })
		reg("Mul", s.Name, "fork", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x * y }) })
		reg("FMA", s.Name, "fork-mathdecimal", func(b *testing.B) {
			loop2(b, xs, ys, func(x, y decimal128) decimal128 { return decimal.FMA(x, y, y) })
		})
		reg("Quantize", s.Name, "fork-mathdecimal", func(b *testing.B) {
			loop2(b, xs, q, func(x, q decimal128) decimal128 { return decimal.Quantize(x, q) })
		})
	}
	for _, s := range Division {
		xs, ys := conv(s.X, forkParse), conv(s.Y, forkParse)
		reg("Div", s.Name, "fork", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x / y }) })
	}
	for _, s := range Compare {
		xs, ys := conv(s.X, forkParse), conv(s.Y, forkParse)
		reg("Less", s.Name, "fork", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) bool { return x < y }) })
	}
	for _, s := range Text {
		ss := &s.X
		xs := conv(s.X, forkParse)
		reg("Parse", s.Name, "fork-strconv", func(b *testing.B) {
			loop1(b, ss, func(s string) decimal128 { d, _ := strconv.ParseDecimal(s, 128); return d })
		})
		// Format with a reused buffer (AppendDecimal, no allocation) and
		// with a new string (FormatDecimal), which is what the other Go
		// candidates' String methods return.
		buf := make([]byte, 0, 64)
		reg("Format", s.Name, "fork-strconv", func(b *testing.B) {
			loop1(b, xs, func(x decimal128) int { return len(strconv.AppendDecimal(buf[:0], x, 'g', -1, 128)) })
		})
		reg("Format", s.Name, "fork-strconv-string", func(b *testing.B) {
			loop1(b, xs, func(x decimal128) string { return strconv.FormatDecimal(x, 'g', -1, 128) })
		})
		reg("Fmt", s.Name, "fork-fmt", func(b *testing.B) {
			loop1(b, xs, func(x decimal128) string { return fmt.Sprint(x) })
		})
	}
}

func decimalFMA(x, y, z decimal128) decimal128 { return decimal.FMA(x, y, z) }

func decimalQuantize(x, y decimal128) decimal128 { return decimal.Quantize(x, y) }
