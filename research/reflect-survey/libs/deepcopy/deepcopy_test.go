package deepcopy

import (
	"fmt"
	"github.com/shopspring/decimal"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/mohae/deepcopy"
)

const lib = "github.com/mohae/deepcopy"

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		val := []string{"q", "long"}[i]
		xx := x
		cases := []struct {
			name string
			in   any
			get  func(any) (T, bool)
		}{
			{"top", x, func(v any) (T, bool) { y, ok := v.(T); return y, ok }},
			{"field", harness.Box[T]{V: x}, func(v any) (T, bool) { y, ok := v.(harness.Box[T]); return y.V, ok }},
			{"slice", []T{x}, func(v any) (T, bool) {
				y, ok := v.([]T)
				if !ok || len(y) != 1 {
					var z T
					return z, false
				}
				return y[0], true
			}},
			{"map", map[string]T{"k": x}, func(v any) (T, bool) { y, ok := v.(map[string]T); return y["k"], ok }},
			{"ptr", harness.PBox[T]{P: &xx}, func(v any) (T, bool) {
				y, ok := v.(harness.PBox[T])
				if !ok || y.P == nil {
					var z T
					return z, false
				}
				return *y.P, true
			}},
		}
		for _, c := range cases {
			harness.Check(lib, "Copy", s.Type, c.name+"/"+val, func() (string, string) {
				out := deepcopy.Copy(c.in)
				y, ok := c.get(out)
				if !ok {
					return harness.Silent, fmt.Sprintf("result %T %#v", out, out)
				}
				return harness.Verdict(s, x, y, "")
			})
		}
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
