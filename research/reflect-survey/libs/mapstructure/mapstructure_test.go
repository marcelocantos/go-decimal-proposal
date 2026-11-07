package mapstructure

import (
	"fmt"
	"github.com/shopspring/decimal"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/mitchellh/mapstructure"
)

const lib = "github.com/mitchellh/mapstructure"

func decode(in, out any, weak bool) error {
	d, err := mapstructure.NewDecoder(&mapstructure.DecoderConfig{Result: out, WeaklyTypedInput: weak})
	if err != nil {
		return err
	}
	return d.Decode(in)
}

func run[T any](s harness.Spec[T]) {
	x := s.Values[0]
	// Same-type source: a map holding the Go value itself, as from viper.Set.
	harness.Check(lib, "Decode(map→struct, same type)", s.Type, "field", func() (string, string) {
		var y harness.Box[T]
		if err := decode(map[string]any{"v": x}, &y, false); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, y.V, "")
	})
	harness.Check(lib, "Decode(map→struct, same type)", s.Type, "slice", func() (string, string) {
		var y struct{ V []T }
		if err := decode(map[string]any{"v": []any{x}}, &y, false); err != nil {
			return harness.ErrVerdict(err)
		}
		if len(y.V) != 1 {
			return harness.Silent, fmt.Sprintf("got %v", y.V)
		}
		return harness.Verdict(s, x, y.V[0], "")
	})
	harness.Check(lib, "Decode(map→struct, same type)", s.Type, "map", func() (string, string) {
		var y struct{ V map[string]T }
		if err := decode(map[string]any{"v": map[string]any{"k": x}}, &y, false); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, y.V["k"], "")
	})
	harness.Check(lib, "Decode(map→struct, same type)", s.Type, "ptr", func() (string, string) {
		var y harness.PBox[T]
		if err := decode(map[string]any{"p": x}, &y, false); err != nil {
			return harness.ErrVerdict(err)
		}
		if y.P == nil {
			return harness.Silent, "pointer left nil"
		}
		return harness.Verdict(s, x, *y.P, "")
	})
	harness.Check(lib, "Decode(map→struct, same type)", s.Type, "top", func() (string, string) {
		var y T
		if err := decode(x, &y, false); err != nil {
			return harness.ErrVerdict(err)
		}
		return harness.Verdict(s, x, y, "")
	})
	// float64 source, as from encoding/json or yaml into map[string]any.
	for i, f := range []float64{1.5, 1234567.890123456} {
		want := s.Parse(fmt.Sprint(f))
		harness.Check(lib, "Decode(float64→field)", s.Type, []string{"field/q", "field/long"}[i], func() (string, string) {
			var y harness.Box[T]
			if err := decode(map[string]any{"v": f}, &y, false); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, want, y.V, "")
		})
	}
	// string source with WeaklyTypedInput, as from env vars and flags.
	for i, str := range s.Lits {
		want := s.Parse(str)
		harness.Check(lib, "Decode(string→field, weak)", s.Type, []string{"field/q", "field/long"}[i], func() (string, string) {
			var y harness.Box[T]
			if err := decode(map[string]any{"v": str}, &y, true); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, want, y.V, "")
		})
	}
	// struct → map.
	harness.Check(lib, "Decode(struct→map)", s.Type, "field", func() (string, string) {
		var m map[string]any
		if err := decode(harness.Box[T]{V: x}, &m, false); err != nil {
			return harness.ErrVerdict(err)
		}
		got, ok := m["v"].(T)
		if !ok {
			return harness.Silent, fmt.Sprintf("map value is %T %#v", m["v"], m["v"])
		}
		return harness.Verdict(s, x, got, "")
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
