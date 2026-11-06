package gocmp

import (
	"github.com/shopspring/decimal"
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "github.com/google/go-cmp/cmp"

func run[T any](s harness.Spec[T]) {
	a, a2, b := s.Parse("1.50"), s.Parse("1.50"), s.Parse("2.50")
	shapes := []struct {
		name         string
		same, differ [2]any
	}{
		{"top", [2]any{a, a2}, [2]any{a, b}},
		{"field", [2]any{harness.Box[T]{V: a}, harness.Box[T]{V: a2}}, [2]any{harness.Box[T]{V: a}, harness.Box[T]{V: b}}},
		{"slice", [2]any{[]T{a}, []T{a2}}, [2]any{[]T{a}, []T{b}}},
		{"map", [2]any{map[string]T{"k": a}, map[string]T{"k": a2}}, [2]any{map[string]T{"k": a}, map[string]T{"k": b}}},
		{"ptr", [2]any{harness.PBox[T]{P: &a}, harness.PBox[T]{P: &a2}}, [2]any{harness.PBox[T]{P: &a}, harness.PBox[T]{P: &b}}},
	}
	for _, sh := range shapes {
		harness.Check(lib, "Equal", s.Type, sh.name, func() (string, string) {
			eq, ne := cmp.Equal(sh.same[0], sh.same[1]), cmp.Equal(sh.differ[0], sh.differ[1])
			if eq && !ne {
				return harness.Correct, "1.50==1.50 true; 1.50==2.50 false"
			}
			return harness.Silent, "Equal(same)=" + map[bool]string{true: "true", false: "false"}[eq] + " Equal(differ)=" + map[bool]string{true: "true", false: "false"}[ne]
		})
		harness.Check(lib, "Diff", s.Type, sh.name, func() (string, string) {
			d := cmp.Diff(sh.differ[0], sh.differ[1])
			if d == "" {
				return harness.Silent, "empty diff for 1.50 vs 2.50"
			}
			if same := cmp.Diff(sh.same[0], sh.same[1]); same != "" {
				return harness.Silent, "non-empty diff for equal values: " + same
			}
			return harness.Correct, d
		})
	}
	// Informational: values equal under ==, different quantum.
	harness.Check(lib, "Equal(1.5, 1.50) [info]", s.Type, "top", func() (string, string) {
		return "info", map[bool]string{true: "true", false: "false"}[cmp.Equal(s.Parse("1.5"), a)]
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
