package structpb

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/shopspring/decimal"
	"google.golang.org/protobuf/types/known/structpb"
)

// Protobuf-generated messages can't have a decimal64 field: protoc-gen-go
// only emits proto scalar types. structpb.NewValue/NewStruct take arbitrary
// Go values (any), so they are where a decimal reaches protobuf.
const lib = "google.golang.org/protobuf/types/known/structpb"

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		shape := []string{"top/q", "top/long"}[i]
		lit := harness.Lit(s, s.Lits[i])
		harness.Check(lib, "NewValue", s.Type, shape, func() (string, string) {
			v, err := structpb.NewValue(x)
			if err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Printed(v.String(), lit)
		})
		harness.Check(lib, "NewStruct", s.Type, "map/"+shape[4:], func() (string, string) {
			v, err := structpb.NewStruct(map[string]any{"k": x})
			if err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Printed(v.String(), lit)
		})
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
