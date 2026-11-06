package zap

import (
	"bytes"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/shopspring/decimal"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

const lib = "go.uber.org/zap"

func logOne(f zap.Field) string {
	var buf bytes.Buffer
	enc := zapcore.NewJSONEncoder(zapcore.EncoderConfig{MessageKey: "msg"})
	l := zap.New(zapcore.NewCore(enc, zapcore.AddSync(&buf), zapcore.DebugLevel))
	l.Info("m", f)
	l.Sync()
	return buf.String()
}

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		val := []string{"q", "long"}[i]
		lit := harness.Lit(s, s.Lits[i])
		xx := x
		for _, c := range []struct {
			shape string
			v     any
		}{
			{"top", x}, {"field", harness.Box[T]{V: x}}, {"slice", []T{x}}, {"map", map[string]T{"k": x}}, {"ptr", harness.PBox[T]{P: &xx}},
		} {
			harness.Check(lib, "Any (JSON encoder)", s.Type, c.shape+"/"+val, func() (string, string) {
				return harness.Printed(logOne(zap.Any("v", c.v)), lit)
			})
		}
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
