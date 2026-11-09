package perfcompare

// The pure-Go candidates other than the fork: decimal128-go, bid754 and
// shopspring/decimal, and float64 as the hardware reference.

import (
	"strconv"
	"testing"

	md "github.com/migueldecimal128/decimal128-go"
	shop "github.com/shopspring/decimal"
	bid754 "github.com/sky1core/bid754/bid754-go"
)

func mdParse(s string) md.Decimal128 { return must(md.Parse(s)) }

func b7Parse(s string) bid754.Decimal128BID { return must(bid754.NewDecimal128(s)) }

func shopParse(s string) shop.Decimal { return must(shop.NewFromString(s)) }

func f64Parse(s string) float64 { return must(strconv.ParseFloat(s, 64)) }

func init() {
	for _, s := range Arith {
		{
			xs, ys, q := conv(s.X, mdParse), conv(s.Y, mdParse), fill(mdParse(Quantum))
			reg("Add", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, ys, md.Decimal128.Add) })
			reg("Sub", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, ys, md.Decimal128.Sub) })
			reg("Mul", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, ys, md.Decimal128.Mul) })
			// FMA's receiver is the addend: y.FMA(x, y) = x*y + y.
			reg("FMA", s.Name, "decimal128-go", func(b *testing.B) {
				loop2(b, xs, ys, func(x, y md.Decimal128) md.Decimal128 { return y.FMA(x, y) })
			})
			reg("Quantize", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, q, md.Decimal128.Quantize) })
		}
		{
			xs, ys, q := conv(s.X, b7Parse), conv(s.Y, b7Parse), fill(b7Parse(Quantum))
			reg("Add", s.Name, "bid754", func(b *testing.B) { loop2(b, xs, ys, bid754.Decimal128BID.Add) })
			reg("Sub", s.Name, "bid754", func(b *testing.B) { loop2(b, xs, ys, bid754.Decimal128BID.Sub) })
			reg("Mul", s.Name, "bid754", func(b *testing.B) { loop2(b, xs, ys, bid754.Decimal128BID.Mul) })
			// FMA's receiver is the first factor: x.FMA(y, y) = x*y + y.
			reg("FMA", s.Name, "bid754", func(b *testing.B) {
				loop2(b, xs, ys, func(x, y bid754.Decimal128BID) bid754.Decimal128BID { r, _ := x.FMA(y, y); return r })
			})
			reg("Quantize", s.Name, "bid754", func(b *testing.B) { loop2(b, xs, q, bid754.Decimal128BID.Quantize) })
		}
		{
			xs, ys := conv(s.X, shopParse), conv(s.Y, shopParse)
			reg("Add", s.Name, "shopspring", func(b *testing.B) { loop2(b, xs, ys, shop.Decimal.Add) })
			reg("Mul", s.Name, "shopspring", func(b *testing.B) { loop2(b, xs, ys, shop.Decimal.Mul) })
		}
		{
			xs, ys := conv(s.X, f64Parse), conv(s.Y, f64Parse)
			reg("Add", s.Name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x + y }) })
			reg("Sub", s.Name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x - y }) })
			reg("Mul", s.Name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x * y }) })
		}
	}
	for _, s := range Division {
		{
			xs, ys := conv(s.X, mdParse), conv(s.Y, mdParse)
			reg("Div", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, ys, md.Decimal128.Quo) })
		}
		{
			xs, ys := conv(s.X, b7Parse), conv(s.Y, b7Parse)
			reg("Div", s.Name, "bid754", func(b *testing.B) { loop2(b, xs, ys, bid754.Decimal128BID.Div) })
		}
		{
			// shopspring divides to DivisionPrecision (16) places, not to
			// 34 significant digits, so its quotient is not the same value.
			xs, ys := conv(s.X, shopParse), conv(s.Y, shopParse)
			reg("Div", s.Name, "shopspring", func(b *testing.B) { loop2(b, xs, ys, shop.Decimal.Div) })
		}
		{
			xs, ys := conv(s.X, f64Parse), conv(s.Y, f64Parse)
			reg("Div", s.Name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x / y }) })
		}
	}
	for _, s := range Compare {
		{
			xs, ys := conv(s.X, mdParse), conv(s.Y, mdParse)
			reg("Less", s.Name, "decimal128-go", func(b *testing.B) { loop2(b, xs, ys, md.Decimal128.Less) })
		}
		{
			xs, ys := conv(s.X, b7Parse), conv(s.Y, b7Parse)
			reg("Less", s.Name, "bid754", func(b *testing.B) {
				loop2(b, xs, ys, func(x, y bid754.Decimal128BID) bool { r, _ := x.QuietLess(y); return r })
			})
		}
		{
			xs, ys := conv(s.X, shopParse), conv(s.Y, shopParse)
			reg("Less", s.Name, "shopspring", func(b *testing.B) { loop2(b, xs, ys, shop.Decimal.LessThan) })
		}
		{
			xs, ys := conv(s.X, f64Parse), conv(s.Y, f64Parse)
			reg("Less", s.Name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) bool { return x < y }) })
		}
	}
	for _, s := range Text {
		ss := &s.X
		reg("Parse", s.Name, "decimal128-go", func(b *testing.B) { loop1(b, ss, md.ParseOrNaN) })
		reg("Parse", s.Name, "bid754", func(b *testing.B) {
			loop1(b, ss, func(s string) bid754.Decimal128BID { d, _ := bid754.NewDecimal128(s); return d })
		})
		reg("Parse", s.Name, "shopspring", func(b *testing.B) {
			loop1(b, ss, func(s string) shop.Decimal { d, _ := shop.NewFromString(s); return d })
		})
		reg("Parse", s.Name, "float64", func(b *testing.B) {
			loop1(b, ss, func(s string) float64 { f, _ := strconv.ParseFloat(s, 64); return f })
		})
		mx, bx, sx, fx := conv(s.X, mdParse), conv(s.X, b7Parse), conv(s.X, shopParse), conv(s.X, f64Parse)
		reg("Format", s.Name, "decimal128-go", func(b *testing.B) { loop1(b, mx, md.Decimal128.String) })
		reg("Format", s.Name, "bid754", func(b *testing.B) { loop1(b, bx, bid754.Decimal128BID.String) })
		reg("Format", s.Name, "shopspring", func(b *testing.B) { loop1(b, sx, shop.Decimal.String) })
		buf := make([]byte, 0, 64)
		reg("Format", s.Name, "float64", func(b *testing.B) {
			loop1(b, fx, func(x float64) int { return len(strconv.AppendFloat(buf[:0], x, 'g', -1, 64)) })
		})
	}
}
