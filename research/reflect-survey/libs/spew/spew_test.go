package spew

import (
	"github.com/shopspring/decimal"
	"testing"

	"github.com/davecgh/go-spew/spew"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "github.com/davecgh/go-spew/spew"

func printed(out string, lits ...string) (string, string) {
	return harness.Printed(out, lits...)
}

func shapes[T any](s harness.Spec[T]) map[string]any {
	x := s.Values[0]
	return map[string]any{
		"top": x, "field": harness.Box[T]{V: x}, "slice": []T{x}, "map": map[string]T{"k": x}, "ptr": harness.PBox[T]{P: &x},
	}
}

func run[T any](s harness.Spec[T]) {
	for _, name := range []string{"top", "field", "slice", "map", "ptr"} {
		v := shapes(s)[name]
		harness.Check(lib, "Sdump", s.Type, name, func() (string, string) { return printed(spew.Sdump(v), harness.Lit(s, "1.50")) })
		harness.Check(lib, "Sprintf(%v)", s.Type, name, func() (string, string) { return printed(spew.Sprintf("%v", v), harness.Lit(s, "1.50")) })
	}
	harness.Check(lib, "Sdump", s.Type, "top/long", func() (string, string) { return printed(spew.Sdump(s.Values[1]), s.Lits[1]) })
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
