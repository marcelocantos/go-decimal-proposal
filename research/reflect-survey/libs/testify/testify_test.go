package testify

import (
	"fmt"
	"github.com/shopspring/decimal"
	"strings"
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/stretchr/testify/assert"
)

const lib = "github.com/stretchr/testify/assert"

// fakeT records assertion failures instead of failing the survey.
type fakeT struct{ msgs []string }

// Errorf keeps only the "Error:" part of testify's report; the trace differs per call site.
func (f *fakeT) Errorf(format string, args ...any) {
	m := fmt.Sprintf(format, args...)
	if i := strings.Index(m, "Error:"); i >= 0 {
		m = m[i:]
	}
	f.msgs = append(f.msgs, strings.Join(strings.Fields(m), " "))
}

func (f *fakeT) text() string { return strings.Join(f.msgs, " ") }

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
		harness.Check(lib, "ObjectsAreEqual", s.Type, sh.name, func() (string, string) {
			eq, ne := assert.ObjectsAreEqual(sh.same[0], sh.same[1]), assert.ObjectsAreEqual(sh.differ[0], sh.differ[1])
			if eq && !ne {
				return harness.Correct, "same=true differ=false"
			}
			return harness.Silent, fmt.Sprintf("same=%v differ=%v", eq, ne)
		})
		harness.Check(lib, "Equal (failure message)", s.Type, sh.name, func() (string, string) {
			ft := &fakeT{}
			okSame := assert.Equal(ft, sh.same[0], sh.same[1])
			ft2 := &fakeT{}
			okDiffer := assert.Equal(ft2, sh.differ[0], sh.differ[1])
			msg := ft2.text()
			switch {
			case !okSame:
				return harness.Silent, "equal values reported unequal: " + ft.text()
			case okDiffer:
				return harness.Silent, "1.50 vs 2.50 reported equal"
			case !strings.Contains(msg, "2.5"):
				return harness.Correct, "verdict right; message does not show the values: " + msg
			}
			return harness.Correct, msg
		})
	}
	harness.Check(lib, "Greater", s.Type, "top", func() (string, string) {
		ft := &fakeT{}
		ok1 := assert.Greater(ft, b, a)
		ft2 := &fakeT{}
		ok2 := assert.Greater(ft2, a, b)
		switch {
		case ok1 && !ok2:
			return harness.Correct, "2.50>1.50 passes; 1.50>2.50 fails"
		case !ok1 && !ok2 && ft.text() == ft2.text():
			return harness.ErrVerdict(fmt.Errorf("%s", ft.text()))
		}
		return harness.Silent, fmt.Sprintf("Greater(2.50,1.50)=%v %s; Greater(1.50,2.50)=%v", ok1, ft.text(), ok2)
	})
	harness.Check(lib, "InDelta", s.Type, "top", func() (string, string) {
		ft := &fakeT{}
		ok1 := assert.InDelta(ft, a, a2, 0.001)
		ft2 := &fakeT{}
		ok2 := assert.InDelta(ft2, a, b, 0.001)
		switch {
		case ok1 && !ok2:
			return harness.Correct, "1.50~1.50 passes; 1.50~2.50 fails"
		case !ok1 && !ok2 && ft.text() == ft2.text():
			return harness.ErrVerdict(fmt.Errorf("%s", ft.text()))
		}
		return harness.Silent, fmt.Sprintf("InDelta(same)=%v %s; InDelta(differ)=%v", ok1, ft.text(), ok2)
	})
	harness.Check(lib, "Zero", s.Type, "top", func() (string, string) {
		var z T
		ok1 := assert.Zero(&fakeT{}, z)
		ok2 := assert.Zero(&fakeT{}, a)
		if ok1 && !ok2 {
			return harness.Correct, "zero passes; 1.50 fails"
		}
		return harness.Silent, fmt.Sprintf("Zero(0)=%v Zero(1.50)=%v", ok1, ok2)
	})
	harness.Check(lib, "Equal(1.5, 1.50) [info]", s.Type, "top", func() (string, string) {
		return "info", fmt.Sprint(assert.ObjectsAreEqual(s.Parse("1.5"), a))
	})
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
