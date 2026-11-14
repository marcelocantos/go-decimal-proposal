// Package perfd64 measures the fork's decimal64 operators beside float64,
// with decimal128 for reference, on identical operand classes. It needs the
// fork toolchain and GOEXPERIMENT=decimal.
//
// Fixed sets come in four variants that differ only in the last digit, so a
// loop indexes them with i&3 and nothing folds; a branch predictor learns
// them, so they show each path as if always predicted. Drawn sets are pools
// of 1024 pairs indexed by a xorshift step, so no predictor can learn the
// order; every drawn row carries the generator's cost alike.
package perfd64

import (
	"math/rand"
	"slices"
	"strconv"
	"strings"
	"testing"
)

const nVariants = 4

type set struct {
	name string
	x, y [nVariants]string
}

var (
	money = set{"money",
		[nVariants]string{"1234.56", "1234.57", "1234.58", "1234.59"},
		[nVariants]string{"78.90", "78.91", "78.92", "78.93"}}
	// full: 16 digits each, exponents 0 and -4, so the aligned sum is 20
	// digits and rounds; the product is 32 digits and rounds.
	full = set{"full",
		[nVariants]string{"1234567890123456", "1234567890123455", "1234567890123454", "1234567890123453"},
		[nVariants]string{"9876543210987654E-4", "9876543210987655E-4", "9876543210987656E-4", "9876543210987657E-4"}}
	far = set{"far",
		[nVariants]string{"1.23456789E+30", "1.23456788E+30", "1.23456787E+30", "1.23456786E+30"},
		[nVariants]string{"9.87654321E-30", "9.87654322E-30", "9.87654323E-30", "9.87654324E-30"}}
	pow10 = set{"pow10",
		[nVariants]string{"123456.789", "123456.788", "123456.787", "123456.786"},
		[nVariants]string{"1000", "1000", "1000", "1000"}}
)

var (
	arith    = []set{money, full, far}
	division = []set{money, full, far, pow10}
	compare  = []set{money, full}
)

const drawnN = 1024

var drawnSets = []struct {
	name string
	gen  func(r *rand.Rand) (string, string)
}{
	{"drawn-money", func(r *rand.Rand) (string, string) {
		return sign(r) + digits(r, 3+r.Intn(7)) + "E-2", sign(r) + digits(r, 3+r.Intn(7)) + "E-2"
	}},
	// drawn-plus: the amounts of drawn-money, all positive, as in a
	// running total, where the signs never vary.
	{"drawn-plus", func(r *rand.Rand) (string, string) {
		return digits(r, 3+r.Intn(7)) + "E-2", digits(r, 3+r.Intn(7)) + "E-2"
	}},
	{"drawn-full", func(r *rand.Rand) (string, string) {
		e := r.Intn(20) - 10
		x := sign(r) + digits(r, 16) + "E" + strconv.Itoa(e)
		y := sign(r) + digits(r, 16) + "E" + strconv.Itoa(e-1-r.Intn(12))
		if r.Intn(2) == 0 {
			x, y = y, x
		}
		return x, y
	}},
}

func sign(r *rand.Rand) string {
	if r.Intn(2) == 0 {
		return "-"
	}
	return ""
}

func digits(r *rand.Rand, n int) string {
	var b strings.Builder
	b.WriteByte(byte('1' + r.Intn(9)))
	for range n - 1 {
		b.WriteByte(byte('0' + r.Intn(10)))
	}
	return b.String()
}

type row struct {
	op, set, impl string
	f             func(b *testing.B)
}

var rows []row

func reg(op, set, impl string, f func(b *testing.B)) { rows = append(rows, row{op, set, impl, f}) }

var (
	opOrder   = []string{"Add", "Sub", "Mul", "Div", "Less"}
	setOrder  = []string{"money", "full", "far", "pow10", "drawn-money", "drawn-plus", "drawn-full"}
	implOrder = []string{"float64", "decimal64", "decimal128"}
)

func BenchmarkD64(b *testing.B) {
	sorted := slices.Clone(rows)
	slices.SortStableFunc(sorted, func(p, q row) int {
		if d := slices.Index(opOrder, p.op) - slices.Index(opOrder, q.op); d != 0 {
			return d
		}
		if d := slices.Index(setOrder, p.set) - slices.Index(setOrder, q.set); d != 0 {
			return d
		}
		return slices.Index(implOrder, p.impl) - slices.Index(implOrder, q.impl)
	})
	for _, r := range sorted {
		b.Run(r.op+"/set="+r.set+"/impl="+r.impl, r.f)
	}
}

var sinkAny any

func loop2[A, R any](b *testing.B, xs, ys *[nVariants]A, f func(x, y A) R) {
	var s R
	for i := 0; i < b.N; i++ {
		j := i & (nVariants - 1)
		s = f(xs[j], ys[j])
	}
	sinkAny = s
}

func loop2d[A, R any](b *testing.B, xs, ys []A, f func(x, y A) R) {
	var s R
	r := uint64(88172645463325252)
	for i := 0; i < b.N; i++ {
		r ^= r << 13
		r ^= r >> 7
		r ^= r << 17
		j := r >> 32 & (drawnN - 1)
		s = f(xs[j], ys[j])
	}
	sinkAny = s
}

func must[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}

func conv[T any](ss [nVariants]string, parse func(string) T) *[nVariants]T {
	var r [nVariants]T
	for i, s := range ss {
		r[i] = parse(s)
	}
	return &r
}

func pool[T any](ss []string, parse func(string) T) []T {
	r := make([]T, len(ss))
	for i, s := range ss {
		r[i] = parse(s)
	}
	return r
}

func parse64(s string) decimal64   { return decimal64(must(strconv.ParseDecimal(s, 64))) }
func parse128(s string) decimal128 { return must(strconv.ParseDecimal(s, 128)) }
func parseF(s string) float64      { return must(strconv.ParseFloat(s, 64)) }

// arithRows registers the operators of one type on fixed sets; the three
// types are written out in init because the operators are not generic.
func init() {
	for _, s := range arith {
		{
			xs, ys := conv(s.x, parseF), conv(s.y, parseF)
			reg("Add", s.name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x + y }) })
			reg("Sub", s.name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x - y }) })
			reg("Mul", s.name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x * y }) })
		}
		{
			xs, ys := conv(s.x, parse64), conv(s.y, parse64)
			reg("Add", s.name, "decimal64", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal64) decimal64 { return x + y }) })
			reg("Sub", s.name, "decimal64", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal64) decimal64 { return x - y }) })
			reg("Mul", s.name, "decimal64", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal64) decimal64 { return x * y }) })
		}
		{
			xs, ys := conv(s.x, parse128), conv(s.y, parse128)
			reg("Add", s.name, "decimal128", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x + y }) })
			reg("Sub", s.name, "decimal128", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x - y }) })
			reg("Mul", s.name, "decimal128", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x * y }) })
		}
	}
	for _, s := range division {
		{
			xs, ys := conv(s.x, parseF), conv(s.y, parseF)
			reg("Div", s.name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) float64 { return x / y }) })
		}
		{
			xs, ys := conv(s.x, parse64), conv(s.y, parse64)
			reg("Div", s.name, "decimal64", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal64) decimal64 { return x / y }) })
		}
		{
			xs, ys := conv(s.x, parse128), conv(s.y, parse128)
			reg("Div", s.name, "decimal128", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) decimal128 { return x / y }) })
		}
	}
	for _, s := range compare {
		{
			xs, ys := conv(s.x, parseF), conv(s.y, parseF)
			reg("Less", s.name, "float64", func(b *testing.B) { loop2(b, xs, ys, func(x, y float64) bool { return x < y }) })
		}
		{
			xs, ys := conv(s.x, parse64), conv(s.y, parse64)
			reg("Less", s.name, "decimal64", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal64) bool { return x < y }) })
		}
		{
			xs, ys := conv(s.x, parse128), conv(s.y, parse128)
			reg("Less", s.name, "decimal128", func(b *testing.B) { loop2(b, xs, ys, func(x, y decimal128) bool { return x < y }) })
		}
	}
	for _, d := range drawnSets {
		r := rand.New(rand.NewSource(20261114))
		var sx, sy []string
		for range drawnN {
			x, y := d.gen(r)
			sx, sy = append(sx, x), append(sy, y)
		}
		name := d.name
		{
			xs, ys := pool(sx, parseF), pool(sy, parseF)
			reg("Add", name, "float64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y float64) float64 { return x + y }) })
			reg("Sub", name, "float64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y float64) float64 { return x - y }) })
			reg("Mul", name, "float64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y float64) float64 { return x * y }) })
			reg("Div", name, "float64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y float64) float64 { return x / y }) })
			reg("Less", name, "float64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y float64) bool { return x < y }) })
		}
		{
			xs, ys := pool(sx, parse64), pool(sy, parse64)
			reg("Add", name, "decimal64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal64) decimal64 { return x + y }) })
			reg("Sub", name, "decimal64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal64) decimal64 { return x - y }) })
			reg("Mul", name, "decimal64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal64) decimal64 { return x * y }) })
			reg("Div", name, "decimal64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal64) decimal64 { return x / y }) })
			reg("Less", name, "decimal64", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal64) bool { return x < y }) })
		}
		{
			xs, ys := pool(sx, parse128), pool(sy, parse128)
			reg("Add", name, "decimal128", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x + y }) })
			reg("Sub", name, "decimal128", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x - y }) })
			reg("Mul", name, "decimal128", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x * y }) })
			reg("Div", name, "decimal128", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) decimal128 { return x / y }) })
			reg("Less", name, "decimal128", func(b *testing.B) { loop2d(b, xs, ys, func(x, y decimal128) bool { return x < y }) })
		}
	}
}

// TestOperandsExact checks that the fixed decimal64 operands parse without
// rounding, so every row measures the stated digits.
func TestOperandsExact(t *testing.T) {
	for _, s := range append(slices.Clone(division), money) {
		for _, v := range append(s.x[:], s.y[:]...) {
			d := parse64(v)
			if got, want := strconv.FormatDecimal(decimal128(d), 'e', -1, 64), strconv.FormatDecimal(parse128(v), 'e', -1, 128); got != want {
				t.Errorf("%s: decimal64 %s, decimal128 %s", v, got, want)
			}
		}
	}
}
