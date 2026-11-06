package validator

import (
	"github.com/shopspring/decimal"
	"testing"

	"github.com/go-playground/validator/v10"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "github.com/go-playground/validator/v10"

type Req[T any] struct {
	V T `validate:"required"`
}
type Gt[T any] struct {
	V T `validate:"gt=1"`
}
type Lte[T any] struct {
	V T `validate:"lte=10"`
}
type SliceGt[T any] struct {
	V []T `validate:"dive,gt=1"`
}
type PtrGt[T any] struct {
	P *T `validate:"required,gt=1"`
}

// check expects pass on good and failure on bad; anything else is a mismatch.
func check(entry, typ string, good, bad any, ruleName string) {
	harness.Check(lib, entry, typ, "field", func() (string, string) {
		v := validator.New()
		errGood := v.Struct(good)
		errBad := v.Struct(bad)
		switch {
		case errGood == nil && errBad != nil:
			return harness.Correct, "good passes; bad fails: " + errBad.Error()
		case errGood != nil && errBad != nil && errGood.Error() == errBad.Error():
			return harness.ErrVerdict(errGood)
		case errGood == nil && errBad == nil:
			return harness.Silent, "rule " + ruleName + " accepted the value that should fail"
		default:
			msg := "good: <nil>"
			if errGood != nil {
				msg = "good: " + errGood.Error()
			}
			if errBad != nil {
				msg += "; bad: " + errBad.Error()
			}
			return harness.Silent, msg
		}
	})
}

func run[T any](s harness.Spec[T]) {
	var zero T
	x := s.Parse("1.50")
	small := s.Parse("0.50")
	big := s.Parse("12.5")
	check("Struct required", s.Type, Req[T]{x}, Req[T]{zero}, "required")
	check("Struct gt=1", s.Type, Gt[T]{x}, Gt[T]{small}, "gt=1")
	check("Struct lte=10", s.Type, Lte[T]{x}, Lte[T]{big}, "lte=10")
	check("Struct dive,gt=1", s.Type, SliceGt[T]{[]T{x}}, SliceGt[T]{[]T{small}}, "dive,gt=1")
	check("Struct ptr gt=1", s.Type, PtrGt[T]{&x}, PtrGt[T]{&small}, "required,gt=1")
	harness.Check(lib, "Var gt=1", s.Type, "top", func() (string, string) {
		v := validator.New()
		e1, e2 := v.Var(x, "gt=1"), v.Var(small, "gt=1")
		switch {
		case e1 == nil && e2 != nil:
			return harness.Correct, "1.50 passes; 0.50 fails"
		case e1 == nil && e2 == nil:
			return harness.Silent, "0.50 accepted by gt=1"
		case e1 != nil:
			return harness.ErrVerdict(e1)
		}
		return harness.Silent, "?"
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
