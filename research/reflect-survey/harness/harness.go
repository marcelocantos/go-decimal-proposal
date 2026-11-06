// Package harness runs decimal values through reflection-based libraries and
// records one observed outcome per case.
//
// Every outcome is computed from what the library returned at run time: an
// error, a recovered panic, or the value that came back. Nothing is inferred
// from reading library source.
package harness

import (
	"fmt"
	"os"
	"regexp"
	"runtime/debug"
	"strconv"
	"strings"
	"testing"

	"github.com/shopspring/decimal"
)

// Outcome classes. Each case gets exactly one.
const (
	Correct       = "correct"         // value and quantum preserved
	CorrectNoQ    = "correct-quantum" // value preserved, quantum (trailing zeros) lost
	CleanError    = "clean-error"     // error naming the type/kind as unsupported
	OtherError    = "other-error"     // error, but not one that names the type as unsupported
	Silent        = "silent"          // wrong result with no error
	Opaque        = "opaque"          // round-trips, but the wire holds no readable number (raw bits, gob bytes)
	Panic         = "panic"           // panicked
	NotApplicable = "n/a"             // shape not expressible in this format
)

// Spec describes one decimal representation under test.
type Spec[T any] struct {
	Type   string            // "decimal64", "decimal128", "shopspring"
	Values []T               // values to try
	Lits   []string          // the decimal literals Values were built from
	Eq     func(a, b T) bool // numeric equality, ignoring quantum
	Q      func(T) string    // canonical string including quantum (1.50 vs 1.5)
	Digits func(T) string    // digits a correct wire encoding must contain
	Parse  func(string) T    // build a T from a decimal string
}

// The values: 1.50 tests the quantum; the long one tests whether the value is
// squeezed through float64 (which keeps about 17 significant digits).
const (
	quantumLit = "1.50"
	long64Lit  = "1234567.890123456"                   // 16 digits, decimal64 holds 16
	long128Lit = "1234567890.123456789012345678901234" // 34 digits, decimal128 holds 34
)

func D64() Spec[decimal64] {
	return Spec[decimal64]{
		Type:   "decimal64",
		Values: []decimal64{1.50, 1234567.890123456},
		Lits:   []string{quantumLit, long64Lit},
		Eq:     func(a, b decimal64) bool { return a == b },
		Q:      func(a decimal64) string { return strconv.FormatDecimal(decimal128(a), 'g', -1, 64) },
		Digits: func(a decimal64) string {
			return strings.TrimRight(strings.TrimRight(strconv.FormatDecimal(decimal128(a), 'f', -1, 64), "0"), ".")
		},
		Parse: func(s string) decimal64 { d, _ := strconv.ParseDecimal(s, 64); return decimal64(d) },
	}
}

func D128() Spec[decimal128] {
	return Spec[decimal128]{
		Type:   "decimal128",
		Values: []decimal128{1.50, 1234567890.123456789012345678901234},
		Lits:   []string{quantumLit, long128Lit},
		Eq:     func(a, b decimal128) bool { return a == b },
		Q:      func(a decimal128) string { return strconv.FormatDecimal(a, 'g', -1, 128) },
		Digits: func(a decimal128) string {
			return strings.TrimRight(strings.TrimRight(strconv.FormatDecimal(a, 'f', -1, 128), "0"), ".")
		},
		Parse: func(s string) decimal128 { d, _ := strconv.ParseDecimal(s, 128); return d },
	}
}

func Shop() Spec[decimal.Decimal] {
	return Spec[decimal.Decimal]{
		Type:   "shopspring",
		Values: []decimal.Decimal{decimal.RequireFromString(quantumLit), decimal.RequireFromString(long128Lit)},
		Lits:   []string{quantumLit, long128Lit},
		Eq:     func(a, b decimal.Decimal) bool { return a.Equal(b) },
		Q: func(a decimal.Decimal) string {
			return fmt.Sprintf("%s(exp=%d)", a.String(), a.Exponent())
		},
		Digits: func(a decimal.Decimal) string { return a.String() },
		Parse:  decimal.RequireFromString,
	}
}

// Float is a float64 control. A test whose control is not "correct" is
// measuring the test, not the decimal type. Quantum is meaningless here.
func Float() Spec[float64] {
	return Spec[float64]{
		Type:   "float64(control)",
		Values: []float64{1.50, 1234567.890123456},
		Lits:   []string{"1.5", long64Lit},
		Eq:     func(a, b float64) bool { return a == b },
		Q:      func(a float64) string { return strconv.FormatFloat(a, 'g', -1, 64) },
		Digits: func(a float64) string { return strconv.FormatFloat(a, 'f', -1, 64) },
		Parse:  func(s string) float64 { f, _ := strconv.ParseFloat(s, 64); return f },
	}
}

// SelfCheck verifies that the toolchain keeps the quantum of the test
// literals, so a "quantum lost" result is the library's doing.
func SelfCheck(t *testing.T) {
	t.Helper()
	if got := D64().Q(1.50); got != "1.50" {
		t.Fatalf("toolchain: decimal64(1.50) formats as %q", got)
	}
	if got := D128().Q(1.50); got != "1.50" {
		t.Fatalf("toolchain: decimal128(1.50) formats as %q", got)
	}
	if got := D128().Q(1234567890.123456789012345678901234); got != long128Lit {
		t.Fatalf("toolchain: long decimal128 formats as %q", got)
	}
}

// Record prints one result line. The run script collects lines that start
// with "RESULT\t" into results/results.tsv.
func Record(lib, entry, typ, shape, outcome, detail string) {
	detail = strings.NewReplacer("\t", " ", "\n", "⏎").Replace(detail)
	if len(detail) > 400 && os.Getenv("SURVEY_STACKS") == "" {
		detail = detail[:400] + "…"
	}
	fmt.Fprintf(os.Stdout, "RESULT\t%s\t%s\t%s\t%s\t%s\t%s\n", lib, entry, typ, shape, outcome, detail)
}

// Try calls f, converting a panic into an error-like report.
func Try(f func() error) (err error, panicMsg string) {
	defer func() {
		if r := recover(); r != nil {
			panicMsg = fmt.Sprint(r)
			if os.Getenv("SURVEY_STACKS") != "" {
				panicMsg += "⏎" + string(debug.Stack())
			}
		}
	}()
	return f(), ""
}

// ClassifyErr decides whether an error names the type as unsupported.
func ClassifyErr(err error) string {
	m := strings.ToLower(err.Error())
	for _, k := range []string{"unsupported", "not supported", "decimal", "unknown type", "invalid type", "unsupported type", "can't", "cannot", "unhandled", "kind", "must be numerical"} {
		if strings.Contains(m, k) {
			return CleanError
		}
	}
	return OtherError
}

// HasDigits reports whether text contains the number whose plain decimal form
// is plain, allowing exponent notation (1.234e+06) and trailing zeros.
func HasDigits(text, plain string) bool {
	c := strings.TrimLeft(strings.ReplaceAll(strings.TrimPrefix(plain, "-"), ".", ""), "0")
	c = strings.TrimRight(c, "0")
	var b strings.Builder
	b.WriteString(`(^|[^0-9])0*\.?`)
	for i, r := range c {
		if i > 0 {
			b.WriteString(`\.?`)
		}
		b.WriteRune(r)
	}
	b.WriteString(`0*([^0-9]|$)`)
	return regexp.MustCompile(b.String()).MatchString(text)
}

// Box, PBox are the struct-field and pointer shapes.
type Box[T any] struct {
	V T `json:"v" yaml:"v" toml:"v" bson:"v" msgpack:"v" cbor:"v" mapstructure:"v"`
}

type PBox[T any] struct {
	P *T `json:"p" yaml:"p" toml:"p" bson:"p" msgpack:"p" cbor:"p" mapstructure:"p"`
}

// Codec is a marshal/unmarshal pair.
type Codec struct {
	Lib             string
	Marshal         func(any) ([]byte, error)
	Unmarshal       func([]byte, any) error
	TopMustBeObject bool // the format can't encode a bare scalar or array at top level
	Binary          bool // show the wire as hex
}

// RunCodec puts every value of s through c in all five shapes.
func RunCodec[T any](c Codec, s Spec[T]) {
	for i, x := range s.Values {
		val := "q" // quantum value
		if i == 1 {
			val = "long"
		}
		type shape struct {
			name string
			in   any
			out  func() (any, func() (T, bool)) // fresh target and extractor
		}
		xx := x
		shapes := []shape{
			{"top", x, func() (any, func() (T, bool)) {
				var y T
				return &y, func() (T, bool) { return y, true }
			}},
			{"field", Box[T]{V: x}, func() (any, func() (T, bool)) {
				var y Box[T]
				return &y, func() (T, bool) { return y.V, true }
			}},
			{"slice", []T{x}, func() (any, func() (T, bool)) {
				var y []T
				return &y, func() (T, bool) {
					if len(y) != 1 {
						var z T
						return z, false
					}
					return y[0], true
				}
			}},
			{"map", map[string]T{"k": x}, func() (any, func() (T, bool)) {
				var y map[string]T
				return &y, func() (T, bool) { v, ok := y["k"]; return v, ok }
			}},
			{"ptr", PBox[T]{P: &xx}, func() (any, func() (T, bool)) {
				var y PBox[T]
				return &y, func() (T, bool) {
					if y.P == nil {
						var z T
						return z, false
					}
					return *y.P, true
				}
			}},
		}
		for _, sh := range shapes {
			name := sh.name + "/" + val
			if c.TopMustBeObject && (sh.name == "top" || sh.name == "slice") {
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, NotApplicable, "format requires a table/document at top level")
				continue
			}
			var wire []byte
			err, p := Try(func() error {
				var err error
				wire, err = c.Marshal(sh.in)
				return err
			})
			if p != "" {
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Panic, "in Marshal: "+p)
				continue
			}
			if err != nil {
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, ClassifyErr(err), "Marshal err: "+err.Error())
				continue
			}
			w := string(wire)
			if c.Binary {
				w = fmt.Sprintf("%x", wire)
			}
			// What a consumer that doesn't know the Go type sees.
			var generic any
			gerr, gp := Try(func() error { return c.Unmarshal(wire, &generic) })
			genericStr := fmt.Sprintf("%#v", generic)
			if gerr != nil || gp != "" {
				genericStr = fmt.Sprintf("(generic decode failed: %v%s)", gerr, gp)
			}
			// A generic decode to []byte means the wire is an opaque blob; don't
			// mistake its byte values printed in decimal for the number.
			_, blob := generic.([]byte)
			wireHasDigits := HasDigits(string(wire), s.Digits(x)) || (!blob && HasDigits(fmt.Sprint(generic), s.Digits(x)))

			target, get := sh.out()
			err, p = Try(func() error { return c.Unmarshal(wire, target) })
			detail := fmt.Sprintf("wire=%s generic=%s", w, genericStr)
			if p != "" {
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Panic, "in Unmarshal: "+p+" | "+detail)
				continue
			}
			if err != nil {
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, ClassifyErr(err), "Unmarshal err: "+err.Error()+" | "+detail)
				continue
			}
			y, ok := get()
			switch {
			case !ok:
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Silent, "element missing after decode | "+detail)
			case !s.Eq(x, y):
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Silent, fmt.Sprintf("want %s got %s | %s", s.Q(x), s.Q(y), detail))
			case !wireHasDigits:
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Opaque, fmt.Sprintf("round trip ok but wire lacks %q (a consumer without the Go type can't read it) | %s", s.Digits(x), detail))
			case s.Q(x) != s.Q(y):
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, CorrectNoQ, fmt.Sprintf("want %s got %s | %s", s.Q(x), s.Q(y), detail))
			default:
				Record(c.Lib, "Marshal→Unmarshal", s.Type, name, Correct, detail)
			}
		}
	}
}

// RunAll runs a codec against all three specs.
func RunAll(t *testing.T, c Codec) {
	SelfCheck(t)
	RunCodec(c, D64())
	RunCodec(c, D128())
	RunCodec(c, Shop())
	RunDecode(c, D64(), []string{quantumLit, long64Lit})
	RunDecode(c, D128(), []string{quantumLit, long128Lit})
	RunDecode(c, Shop(), []string{quantumLit, long128Lit})
	RunCodec(c, Float())
	RunDecode(c, Float(), []string{"1.5", long64Lit})
}

// Decoding direction, independent of whether the library can encode.
//
// A text codec gets the shape encoded with a sentinel float64 whose text is
// then replaced by the exact decimal literal, so the input carries all digits
// and the trailing zero. A binary codec gets a float64 on the wire (the
// closest a generic producer can do) and the expectation is that float's
// shortest decimal form.
const sentinel = 9.25

// RunDecode decodes numeric wire values into T in all five shapes.
func RunDecode[T any](c Codec, s Spec[T], lits []string) {
	for i, lit := range lits {
		val := "q"
		if i == 1 {
			val = "long"
		}
		f, _ := strconv.ParseFloat(lit, 64)
		want := s.Parse(lit)
		srcVal := sentinel
		if c.Binary {
			srcVal = f
			want = s.Parse(strconv.FormatFloat(f, 'g', -1, 64))
		}
		type shape struct {
			name string
			in   any
			out  func() (any, func() (T, bool))
		}
		shapes := []shape{
			{"top", srcVal, func() (any, func() (T, bool)) {
				var y T
				return &y, func() (T, bool) { return y, true }
			}},
			{"field", Box[float64]{V: srcVal}, func() (any, func() (T, bool)) {
				var y Box[T]
				return &y, func() (T, bool) { return y.V, true }
			}},
			{"slice", []float64{srcVal}, func() (any, func() (T, bool)) {
				var y []T
				return &y, func() (T, bool) {
					if len(y) != 1 {
						var z T
						return z, false
					}
					return y[0], true
				}
			}},
			{"map", map[string]float64{"k": srcVal}, func() (any, func() (T, bool)) {
				var y map[string]T
				return &y, func() (T, bool) { v, ok := y["k"]; return v, ok }
			}},
			{"ptr", PBox[float64]{P: &srcVal}, func() (any, func() (T, bool)) {
				var y PBox[T]
				return &y, func() (T, bool) {
					if y.P == nil {
						var z T
						return z, false
					}
					return *y.P, true
				}
			}},
		}
		for _, sh := range shapes {
			name := sh.name + "/" + val
			if c.TopMustBeObject && (sh.name == "top" || sh.name == "slice") {
				Record(c.Lib, "Unmarshal(number)", s.Type, name, NotApplicable, "format requires a table/document at top level")
				continue
			}
			wire, err := c.Marshal(sh.in)
			if err != nil {
				Record(c.Lib, "Unmarshal(number)", s.Type, name, NotApplicable, "could not build input: "+err.Error())
				continue
			}
			if !c.Binary {
				wire = []byte(strings.Replace(string(wire), "9.25", lit, 1))
			}
			w := string(wire)
			if c.Binary {
				w = fmt.Sprintf("%x", wire)
			}
			target, get := sh.out()
			err, p := Try(func() error { return c.Unmarshal(wire, target) })
			if p != "" {
				Record(c.Lib, "Unmarshal(number)", s.Type, name, Panic, p+" | wire="+w)
				continue
			}
			if err != nil {
				Record(c.Lib, "Unmarshal(number)", s.Type, name, ClassifyErr(err), "err: "+err.Error()+" | wire="+w)
				continue
			}
			y, ok := get()
			switch {
			case !ok:
				Record(c.Lib, "Unmarshal(number)", s.Type, name, Silent, "element missing after decode | wire="+w)
			case !s.Eq(want, y):
				Record(c.Lib, "Unmarshal(number)", s.Type, name, Silent, fmt.Sprintf("want %s got %s | wire=%s", s.Q(want), s.Q(y), w))
			case s.Q(want) != s.Q(y):
				Record(c.Lib, "Unmarshal(number)", s.Type, name, CorrectNoQ, fmt.Sprintf("want %s got %s | wire=%s", s.Q(want), s.Q(y), w))
			default:
				Record(c.Lib, "Unmarshal(number)", s.Type, name, Correct, fmt.Sprintf("got %s | wire=%s", s.Q(y), w))
			}
		}
	}
}

// Check runs f and records its verdict, or Panic if it panics.
func Check(lib, entry, typ, shape string, f func() (outcome, detail string)) {
	var outcome, detail string
	_, p := Try(func() error { outcome, detail = f(); return nil })
	if p != "" {
		outcome, detail = Panic, p
	}
	Record(lib, entry, typ, shape, outcome, detail)
}

// Verdict compares a result with the expected value: Correct, CorrectNoQ or Silent.
func Verdict[T any](s Spec[T], want, got T, extra string) (string, string) {
	d := fmt.Sprintf("want %s got %s", s.Q(want), s.Q(got))
	if extra != "" {
		d += " | " + extra
	}
	switch {
	case !s.Eq(want, got):
		return Silent, d
	case s.Q(want) != s.Q(got):
		return CorrectNoQ, d
	}
	return Correct, d
}

// ErrVerdict classifies a non-nil error.
func ErrVerdict(err error) (string, string) { return ClassifyErr(err), "err: " + err.Error() }

// Specs runs f for each of the three representations. Go has no generic
// closures, so callers pass three instantiations.
type Runner struct {
	D64  func(Spec[decimal64])
	D128 func(Spec[decimal128])
	Shop func(Spec[decimal.Decimal])
	Ctl  func(Spec[float64])
}

func (r Runner) Run(t *testing.T) {
	SelfCheck(t)
	r.D64(D64())
	r.D128(D128())
	r.Shop(Shop())
	if r.Ctl != nil {
		r.Ctl(Float())
	}
}

// Lit is the literal a correct printer shows for the decimal literal l: l
// itself, except for the float64 control, which has no quantum.
func Lit[T any](s Spec[T], l string) string {
	if strings.HasPrefix(s.Type, "float64") {
		f, _ := strconv.ParseFloat(l, 64)
		return strconv.FormatFloat(f, 'f', -1, 64)
	}
	return l
}

// Printed judges printer output: each literal must appear exactly (Correct),
// or at least as the same number without its trailing zeros or in exponent
// form (CorrectNoQ); otherwise the value is missing (Silent).
func Printed(out string, lits ...string) (string, string) {
	outcome := Correct
	for _, l := range lits {
		switch {
		case strings.Contains(out, l):
		case HasDigits(out, l):
			// Exponent form or dropped trailing zeros. Only the latter loses
			// a quantum, and only if the literal had trailing zeros.
			if strings.Contains(l, ".") && strings.HasSuffix(l, "0") {
				outcome = CorrectNoQ
			}
		default:
			return Silent, "missing " + l + ": " + out
		}
	}
	return outcome, out
}
