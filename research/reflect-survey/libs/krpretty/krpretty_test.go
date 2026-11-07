package krpretty

import (
	"github.com/shopspring/decimal"
	"strings"
	"testing"

	"github.com/kr/pretty"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "github.com/kr/pretty"

func printed(out string, lits ...string) (string, string) {
	// A struct dump of the representation (shopspring's big.Int and exponent)
	// carries the value but not in readable form.
	if strings.Contains(out, "exp:") || strings.Contains(out, ".abs[") {
		return harness.Opaque, out
	}
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
		harness.Check(lib, "Sprint", s.Type, name, func() (string, string) { return printed(pretty.Sprint(v), harness.Lit(s, "1.50")) })
		harness.Check(lib, "Sprintf(%# v)", s.Type, name, func() (string, string) { return printed(pretty.Sprintf("%# v", v), harness.Lit(s, "1.50")) })
	}
	harness.Check(lib, "Sprint", s.Type, "top/long", func() (string, string) { return printed(pretty.Sprint(s.Values[1]), s.Lits[1]) })
	harness.Check(lib, "Diff", s.Type, "field", func() (string, string) {
		d := pretty.Diff(harness.Box[T]{V: s.Parse("1.50")}, harness.Box[T]{V: s.Parse("2.50")})
		if len(d) == 0 {
			return harness.Silent, "no diff for 1.50 vs 2.50"
		}
		if same := pretty.Diff(harness.Box[T]{V: s.Parse("1.50")}, harness.Box[T]{V: s.Parse("1.50")}); len(same) != 0 {
			return harness.Silent, "diff for equal values: " + strings.Join(same, "; ")
		}
		return printed(strings.Join(d, "; "), harness.Lit(s, "1.50"), harness.Lit(s, "2.50"))
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
