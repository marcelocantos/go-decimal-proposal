package cast

import (
	"fmt"
	"github.com/shopspring/decimal"
	"strconv"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/spf13/cast"
)

const lib = "github.com/spf13/cast"

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		shape := []string{"top/q", "top/long"}[i]
		lit := s.Lits[i]
		harness.Check(lib, "ToStringE", s.Type, shape, func() (string, string) {
			got, err := cast.ToStringE(x)
			if err != nil {
				return harness.ErrVerdict(err)
			}
			if got != lit {
				if s.Eq(s.Parse(got), x) {
					return harness.CorrectNoQ, fmt.Sprintf("want %q got %q", lit, got)
				}
				return harness.Silent, fmt.Sprintf("want %q got %q", lit, got)
			}
			return harness.Correct, fmt.Sprintf("got %q", got)
		})
		harness.Check(lib, "ToFloat64E", s.Type, shape, func() (string, string) {
			got, err := cast.ToFloat64E(x)
			if err != nil {
				return harness.ErrVerdict(err)
			}
			want := 0.0
			fmt.Sscan(lit, &want)
			if got != want {
				return harness.Silent, fmt.Sprintf("want %v got %v", want, got)
			}
			return harness.Correct, fmt.Sprintf("got %v (nearest float64)", got)
		})
		harness.Check(lib, "ToInt64E", s.Type, shape, func() (string, string) {
			got, err := cast.ToInt64E(x)
			if err != nil {
				return harness.ErrVerdict(err)
			}
			lf, _ := strconv.ParseFloat(lit, 64)
			want := int64(lf) // truncation toward zero
			if got != want {
				return harness.Silent, fmt.Sprintf("want %v (truncated) got %v", want, got)
			}
			return harness.Correct, fmt.Sprintf("got %v (truncated)", got)
		})
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
