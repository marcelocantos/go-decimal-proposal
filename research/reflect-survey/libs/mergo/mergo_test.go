package mergo

import (
	"github.com/shopspring/decimal"
	"testing"

	"dario.cat/mergo"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "dario.cat/mergo"

func run[T any](s harness.Spec[T]) {
	var zero T
	x := s.Values[0]
	other := s.Parse("2.50")
	harness.Check(lib, "Merge (fill empty)", s.Type, "field", func() (string, string) {
		dst := harness.Box[T]{}
		if err := mergo.Merge(&dst, harness.Box[T]{V: x}); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, dst.V, "")
	})
	harness.Check(lib, "Merge (keep non-empty)", s.Type, "field", func() (string, string) {
		dst := harness.Box[T]{V: other}
		if err := mergo.Merge(&dst, harness.Box[T]{V: x}); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, other, dst.V, "dst was 2.50, src 1.50")
	})
	harness.Check(lib, "Merge(WithOverride)", s.Type, "field", func() (string, string) {
		dst := harness.Box[T]{V: other}
		if err := mergo.Merge(&dst, harness.Box[T]{V: x}, mergo.WithOverride); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, dst.V, "")
	})
	harness.Check(lib, "Merge(WithOverride, empty src)", s.Type, "field", func() (string, string) {
		dst := harness.Box[T]{V: other}
		if err := mergo.Merge(&dst, harness.Box[T]{V: zero}, mergo.WithOverride); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, other, dst.V, "empty src must not override")
	})
	harness.Check(lib, "Merge (fill empty)", s.Type, "map", func() (string, string) {
		dst := map[string]T{}
		if err := mergo.Merge(&dst, map[string]T{"k": x}); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, dst["k"], "")
	})
	harness.Check(lib, "Merge (fill empty)", s.Type, "ptr", func() (string, string) {
		xx := x
		dst := harness.PBox[T]{}
		if err := mergo.Merge(&dst, harness.PBox[T]{P: &xx}); err != nil {
			return harness.ErrVerdict(err)
		}
		if dst.P == nil {
			return harness.Silent, "pointer left nil"
		}
		return harness.Verdict(s, x, *dst.P, "")
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
