package perfcompare

import (
	"slices"
	"testing"
)

// A row is one benchmark: an operation on a set by a candidate. The
// candidate files register rows in init; BenchmarkCompare runs them grouped
// by operation and set, so that within one run of the binary every
// candidate of an (operation, set) cell runs back to back.
type row struct {
	op, set, impl string
	f             func(b *testing.B)
}

var rows []row

func reg(op, set, impl string, f func(b *testing.B)) {
	rows = append(rows, row{op, set, impl, f})
}

var (
	opOrder   = []string{"Add", "Sub", "Mul", "Div", "FMA", "Quantize", "Less", "Parse", "Format", "Fmt", "Cgo"}
	setOrder  = []string{"money", "full", "far", "pow10", "drawn-money", "drawn-full", "empty", "binary"}
	implOrder = []string{"float64", "fork", "fork-mathdecimal", "fork-strconv", "fork-strconv-string", "fork-fmt", "decimal128-go", "bid754", "intel-cgo", "intel-cloop", "decquad-cgo", "decquad-cloop", "shopspring", "cgo-nop"}
)

func BenchmarkCompare(b *testing.B) {
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

// The loop helpers are the same for every candidate: a plain loop over the
// variants with the call written into it and the result kept in a sink.
// They and the closures passed to them are inlined, as in the kernel's own
// benchmarks.

var (
	sinkAny any
)

func loop1[A, R any](b *testing.B, xs *[NVariants]A, f func(x A) R) {
	var s R
	for i := 0; i < b.N; i++ {
		s = f(xs[i&(NVariants-1)])
	}
	sinkAny = s
}

func loop2[A, R any](b *testing.B, xs, ys *[NVariants]A, f func(x, y A) R) {
	var s R
	for i := 0; i < b.N; i++ {
		j := i & (NVariants - 1)
		s = f(xs[j], ys[j])
	}
	sinkAny = s
}

func loop3[A, R any](b *testing.B, xs, ys, zs *[NVariants]A, f func(x, y, z A) R) {
	var s R
	for i := 0; i < b.N; i++ {
		j := i & (NVariants - 1)
		s = f(xs[j], ys[j], zs[j])
	}
	sinkAny = s
}

func must[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}

// conv parses the variants of a set with a candidate's parser.
func conv[T any](ss [NVariants]string, parse func(string) T) *[NVariants]T {
	var r [NVariants]T
	for i, s := range ss {
		r[i] = parse(s)
	}
	return &r
}

func fill[T any](v T) *[NVariants]T {
	var r [NVariants]T
	for i := range r {
		r[i] = v
	}
	return &r
}
