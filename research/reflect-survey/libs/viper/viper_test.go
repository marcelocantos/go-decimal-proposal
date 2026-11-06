package viper

import (
	"bytes"
	"fmt"
	"github.com/shopspring/decimal"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/spf13/viper"
)

const lib = "github.com/spf13/viper"

func run[T any](s harness.Spec[T]) {
	for i, lit := range s.Lits {
		shape := []string{"field/q", "field/long"}[i]
		want := s.Parse(lit)
		for _, cfg := range []struct{ typ, text string }{
			{"yaml", "v: " + lit + "\n"},
			{"json", `{"v": ` + lit + `}`},
			{"yaml-quoted", "v: \"" + lit + "\"\n"},
		} {
			harness.Check(lib, "ReadConfig("+cfg.typ+")+Unmarshal", s.Type, shape, func() (string, string) {
				v := viper.New()
				typ := cfg.typ
				if typ == "yaml-quoted" {
					typ = "yaml"
				}
				v.SetConfigType(typ)
				if err := v.ReadConfig(bytes.NewBufferString(cfg.text)); err != nil {
					return harness.OtherError, "config: " + err.Error()
				}
				var y harness.Box[T]
				if err := v.Unmarshal(&y); err != nil {
					return harness.ErrVerdict(err)
				}
				return harness.Verdict(s, want, y.V, "")
			})
		}
		x := s.Values[i]
		harness.Check(lib, "Set+Unmarshal", s.Type, shape, func() (string, string) {
			v := viper.New()
			v.Set("v", x)
			var y harness.Box[T]
			if err := v.Unmarshal(&y); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, x, y.V, "")
		})
		harness.Check(lib, "Set+GetString", s.Type, shape, func() (string, string) {
			v := viper.New()
			v.Set("v", x)
			got := v.GetString("v")
			if got == lit {
				return harness.Correct, fmt.Sprintf("got %q", got)
			}
			if got != "" && s.Eq(s.Parse(got), x) {
				return harness.CorrectNoQ, fmt.Sprintf("want %q got %q", lit, got)
			}
			return harness.Silent, fmt.Sprintf("want %q got %q (no error API)", lit, got)
		})
		harness.Check(lib, "Set+GetFloat64", s.Type, shape, func() (string, string) {
			v := viper.New()
			v.Set("v", x)
			got := v.GetFloat64("v")
			var f float64
			fmt.Sscan(lit, &f)
			if got == f {
				return harness.Correct, fmt.Sprintf("got %v", got)
			}
			return harness.Silent, fmt.Sprintf("want %v got %v (no error API)", f, got)
		})
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
