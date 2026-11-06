package copier

import (
	"fmt"
	"github.com/shopspring/decimal"
	"testing"

	"github.com/jinzhu/copier"
	"github.com/marcelocantos/reflect-survey/harness"
)

const lib = "github.com/jinzhu/copier"

// Float is a destination with a float64 field, for the cross-type copy.
type Float struct{ V float64 }

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		val := []string{"q", "long"}[i]
		harness.Check(lib, "Copy", s.Type, "top/"+val, func() (string, string) {
			var y T
			if err := copier.Copy(&y, &x); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, x, y, "")
		})
		harness.Check(lib, "Copy", s.Type, "field/"+val, func() (string, string) {
			var y harness.Box[T]
			if err := copier.Copy(&y, harness.Box[T]{V: x}); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, x, y.V, "")
		})
		harness.Check(lib, "Copy", s.Type, "slice/"+val, func() (string, string) {
			var y []T
			if err := copier.Copy(&y, []T{x}); err != nil {
				return harness.ErrVerdict(err)
			}
			if len(y) != 1 {
				return harness.Silent, fmt.Sprintf("got %d elements", len(y))
			}
			return harness.Verdict(s, x, y[0], "")
		})
		harness.Check(lib, "Copy", s.Type, "map/"+val, func() (string, string) {
			var y struct{ M map[string]T }
			if err := copier.Copy(&y, struct{ M map[string]T }{map[string]T{"k": x}}); err != nil {
				return harness.ErrVerdict(err)
			}
			v, ok := y.M["k"]
			if !ok {
				return harness.Silent, "map entry missing"
			}
			return harness.Verdict(s, x, v, "")
		})
		harness.Check(lib, "CopyWithOption(DeepCopy)", s.Type, "ptr/"+val, func() (string, string) {
			xx := x
			var y harness.PBox[T]
			if err := copier.CopyWithOption(&y, harness.PBox[T]{P: &xx}, copier.Option{DeepCopy: true}); err != nil {
				return harness.ErrVerdict(err)
			}
			if y.P == nil {
				return harness.Silent, "pointer left nil"
			}
			return harness.Verdict(s, x, *y.P, "")
		})
	}
	harness.Check(lib, "Copy(→float64 field) [info]", s.Type, "field/q", func() (string, string) {
		var y Float
		err := copier.Copy(&y, harness.Box[T]{V: s.Values[0]})
		return "info", fmt.Sprintf("err=%v V=%v", err, y.V)
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
