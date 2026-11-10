// Differential test: decimal64/decimal128 operators in the fork vs an
// independent exact oracle (math/big) applying IEEE 754-2008 rules:
// round-half-even to p digits, preferred (ideal) exponent for exact
// results, exponent clamping at emin/emax, overflow to Inf.
package main

import (
	"flag"
	"fmt"
	"math"
	"math/big"
	"math/rand"
	"os"
	"sort"
)

type fmtSpec struct {
	p          int // digits
	emin, emax int // exponent range for coefficient
	bias       int
}

var f64 = fmtSpec{p: 16, emin: -398, emax: 369, bias: 398}
var f128 = fmtSpec{p: 34, emin: -6176, emax: 6111, bias: 6176}

type dec struct {
	neg  bool
	coef *big.Int
	exp  int
	kind int // 0 finite, 1 inf, 2 nan
}

func (d dec) String() string {
	switch d.kind {
	case 1:
		if d.neg {
			return "-Inf"
		}
		return "+Inf"
	case 2:
		return "NaN"
	}
	s := ""
	if d.neg {
		s = "-"
	}
	return fmt.Sprintf("%s%sE%d", s, d.coef.String(), d.exp)
}

func pow10(n int) *big.Int {
	return new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(n)), nil)
}

var maxCoef64 = big.NewInt(9999999999999999)
var maxCoef128, _ = new(big.Int).SetString("9999999999999999999999999999999999", 10)

func (s fmtSpec) maxCoef() *big.Int {
	if s.p == 16 {
		return maxCoef64
	}
	return maxCoef128
}

// ---- BID unpack ----

func unpack64(bits uint64) dec {
	d := dec{neg: bits>>63 != 0}
	if (bits>>61)&3 == 3 {
		if (bits>>58)&0x1f == 0x1e {
			d.kind = 1
			return d
		}
		if (bits>>58)&0x1f == 0x1f {
			d.kind = 2
			return d
		}
		d.exp = int((bits>>51)&0x3ff) - 398
		c := (uint64(1) << 53) | (bits & (1<<51 - 1))
		d.coef = new(big.Int).SetUint64(c)
		if d.coef.Cmp(maxCoef64) > 0 {
			d.coef = big.NewInt(0)
		}
		return d
	}
	d.exp = int((bits>>53)&0x3ff) - 398
	d.coef = new(big.Int).SetUint64(bits & (1<<53 - 1))
	return d
}

func unpack128(hi, lo uint64) dec {
	d := dec{neg: hi>>63 != 0}
	if (hi>>61)&3 == 3 {
		if (hi>>58)&0x1f == 0x1e {
			d.kind = 1
			return d
		}
		if (hi>>58)&0x1f == 0x1f {
			d.kind = 2
			return d
		}
		// Form 2: coefficient >= 2^113 > 10^34-1: non-canonical zero.
		d.exp = int((hi>>47)&0x3fff) - 6176
		d.coef = big.NewInt(0)
		return d
	}
	d.exp = int((hi>>49)&0x3fff) - 6176
	d.coef = new(big.Int).SetUint64(hi & (1<<49 - 1))
	d.coef.Lsh(d.coef, 64)
	d.coef.Or(d.coef, new(big.Int).SetUint64(lo))
	if d.coef.Cmp(maxCoef128) > 0 {
		d.coef = big.NewInt(0)
	}
	return d
}

// ---- BID pack (canonical) ----

func pack64(neg bool, coef uint64, exp int) decimal64 {
	var bits uint64
	if neg {
		bits = 1 << 63
	}
	be := uint64(exp + 398)
	if coef < 1<<53 {
		bits |= be<<53 | coef
	} else {
		bits |= 3<<61 | be<<51 | (coef & (1<<51 - 1))
	}
	return math.Decimal64frombits(bits)
}

var hiFirst bool
var moderate = flag.Bool("moderate", false, "exponents in -10..10 only") // does Decimal128bits return (hi, lo)?

func pack128(neg bool, coef *big.Int, exp int) decimal128 {
	var hi uint64
	if neg {
		hi = 1 << 63
	}
	be := uint64(exp + 6176)
	hi |= be << 49
	lo := new(big.Int).And(coef, new(big.Int).SetUint64(math.MaxUint64)).Uint64()
	hi |= new(big.Int).Rsh(coef, 64).Uint64()
	if hiFirst {
		return math.Decimal128frombits(hi, lo)
	}
	return math.Decimal128frombits(lo, hi)
}

func bits128(d decimal128) (hi, lo uint64) {
	a, b := math.Decimal128bits(d)
	if hiFirst {
		return a, b
	}
	return b, a
}

// ---- Oracle ----

func toRat(d dec) *big.Rat {
	r := new(big.Rat).SetInt(d.coef)
	if d.exp >= 0 {
		r.Mul(r, new(big.Rat).SetInt(pow10(d.exp)))
	} else {
		r.Quo(r, new(big.Rat).SetInt(pow10(-d.exp)))
	}
	if d.neg {
		r.Neg(r)
	}
	return r
}

// roundHalfEven returns round(num/den) for positive num, den.
func roundHalfEven(num, den *big.Int) *big.Int {
	q, rem := new(big.Int).QuoRem(num, den, new(big.Int))
	twice := new(big.Int).Lsh(rem, 1)
	switch twice.Cmp(den) {
	case 1:
		q.Add(q, big.NewInt(1))
	case 0:
		if q.Bit(0) == 1 {
			q.Add(q, big.NewInt(1))
		}
	}
	return q
}

func clamp(e, lo, hi int) int {
	if e < lo {
		return lo
	}
	if e > hi {
		return hi
	}
	return e
}

func numDigits(x *big.Int) int {
	return len(new(big.Int).Abs(x).String())
}

// finite computes the IEEE result for exact rational r with preferred
// exponent ideal, sign of zero zneg.
func (s fmtSpec) finite(r *big.Rat, ideal int, zneg bool) dec {
	if r.Sign() == 0 {
		return dec{neg: zneg, coef: big.NewInt(0), exp: clamp(ideal, s.emin, s.emax)}
	}
	neg := r.Sign() < 0
	ar := new(big.Rat).Abs(r)
	num, den := ar.Num(), ar.Denom()
	// Exact-at-ideal attempt: c = ar * 10^-ideal.
	// General: find shortest exact decimal representation if finite.
	// e_min_rep: largest exponent such that ar*10^-e is an integer.
	// ar = num/den; finite decimal iff den = 2^a 5^b.
	exact := false
	var cExact *big.Int
	var eExact int
	{
		d := new(big.Int).Set(den)
		a, b := 0, 0
		two, five := big.NewInt(2), big.NewInt(5)
		m := new(big.Int)
		for {
			q, rm := new(big.Int).QuoRem(d, two, m)
			if rm.Sign() != 0 {
				break
			}
			d = q
			a++
		}
		for {
			q, rm := new(big.Int).QuoRem(d, five, m)
			if rm.Sign() != 0 {
				break
			}
			d = q
			b++
		}
		if d.Cmp(big.NewInt(1)) == 0 {
			exact = true
			k := a
			if b > k {
				k = b
			}
			// ar = num/(2^a 5^b) = num*2^(k-a)*5^(k-b) / 10^k
			c := new(big.Int).Mul(num, new(big.Int).Exp(two, big.NewInt(int64(k-a)), nil))
			c.Mul(c, new(big.Int).Exp(five, big.NewInt(int64(k-b)), nil))
			e := -k
			ten := big.NewInt(10)
			for {
				q, rm := new(big.Int).QuoRem(c, ten, m)
				if rm.Sign() != 0 {
					break
				}
				c = q
				e++
			}
			cExact, eExact = c, e
		}
	}
	var c *big.Int
	var e int
	done := false
	if exact {
		// choose e in [ideal, eExact] closest to ideal with <= p digits
		if eExact >= ideal {
			e = ideal
			c = new(big.Int).Mul(cExact, pow10(eExact-ideal))
			for c.Cmp(s.maxCoef()) > 0 && e < eExact {
				e++
				c = new(big.Int).Mul(cExact, pow10(eExact-e))
			}
			if c.Cmp(s.maxCoef()) <= 0 {
				done = true
			}
		} else {
			e, c = eExact, cExact
			if c.Cmp(s.maxCoef()) <= 0 {
				done = true
			}
		}
	}
	if !done {
		// inexact: round to p digits.
		// round to p digits at e = floor(log10 ar) - (p-1)
		e = floorLog10(ar) - (s.p - 1)
		c = roundAt(ar, e)
		if c.Cmp(s.maxCoef()) > 0 { // 10^p after rounding
			e++
			c = roundAt(ar, e)
		}
	}
	// subnormal clamp
	if e < s.emin {
		e = s.emin
		c = roundAt(ar, e)
	}
	// overflow / exponent clamp
	if e > s.emax {
		c = new(big.Int).Mul(c, pow10(e-s.emax))
		e = s.emax
		if c.Cmp(s.maxCoef()) > 0 {
			return dec{neg: neg, kind: 1}
		}
	}
	if c.Sign() == 0 {
		// underflow to zero
		return dec{neg: neg, coef: c, exp: e}
	}
	return dec{neg: neg, coef: c, exp: e}
}

func floorLog10(ar *big.Rat) int {
	num, den := ar.Num(), ar.Denom()
	est := numDigits(num) - numDigits(den) - 1
	for {
		if ar.Cmp(ratPow10(est)) < 0 {
			est--
			continue
		}
		if ar.Cmp(ratPow10(est+1)) >= 0 {
			est++
			continue
		}
		return est
	}
}

func ratPow10(e int) *big.Rat {
	if e >= 0 {
		return new(big.Rat).SetInt(pow10(e))
	}
	return new(big.Rat).SetFrac(big.NewInt(1), pow10(-e))
}

// roundAt returns RHE(ar / 10^e).
func roundAt(ar *big.Rat, e int) *big.Int {
	q := new(big.Rat).Quo(ar, ratPow10(e))
	return roundHalfEven(q.Num(), q.Denom())
}

func (s fmtSpec) oracle(op byte, a, b dec) dec {
	if a.kind == 2 || b.kind == 2 {
		return dec{kind: 2}
	}
	switch op {
	case '+', '-':
		bb := b
		if op == '-' {
			bb.neg = !bb.neg
		}
		if a.kind == 1 && bb.kind == 1 {
			if a.neg != bb.neg {
				return dec{kind: 2}
			}
			return a
		}
		if a.kind == 1 {
			return a
		}
		if bb.kind == 1 {
			return bb
		}
		ideal := a.exp
		if bb.exp < ideal {
			ideal = bb.exp
		}
		r := new(big.Rat).Add(toRat(a), toRat(bb))
		zneg := a.neg && bb.neg // RNE: +0 unless both negative
		if r.Sign() == 0 && a.coef.Sign() == 0 && bb.coef.Sign() == 0 {
			zneg = a.neg && bb.neg
		} else if r.Sign() == 0 {
			zneg = false
		}
		return s.finite(r, ideal, zneg)
	case '*':
		neg := a.neg != b.neg
		if a.kind == 1 || b.kind == 1 {
			if (a.kind == 0 && a.coef.Sign() == 0) || (b.kind == 0 && b.coef.Sign() == 0) {
				return dec{kind: 2}
			}
			return dec{neg: neg, kind: 1}
		}
		return s.finite(new(big.Rat).Mul(toRat(a), toRat(b)), a.exp+b.exp, neg)
	case '/':
		neg := a.neg != b.neg
		if a.kind == 1 && b.kind == 1 {
			return dec{kind: 2}
		}
		if a.kind == 1 {
			return dec{neg: neg, kind: 1}
		}
		if b.kind == 1 {
			return dec{neg: neg, coef: big.NewInt(0), exp: clamp(a.exp-s.emax, s.emin, s.emax)}
		}
		if b.coef.Sign() == 0 {
			if a.coef.Sign() == 0 {
				return dec{kind: 2}
			}
			return dec{neg: neg, kind: 1}
		}
		return s.finite(new(big.Rat).Quo(toRat(a), toRat(b)), a.exp-b.exp, neg)
	}
	panic("op")
}

// ---- random operands ----

func randCoef(rng *rand.Rand, p int) *big.Int {
	nd := 1 + rng.Intn(p)
	switch rng.Intn(6) {
	case 0:
		return big.NewInt(0)
	case 1: // all nines
		return new(big.Int).Sub(pow10(nd), big.NewInt(1))
	case 2: // power of ten
		return pow10(nd - 1)
	}
	lo := pow10(nd - 1)
	span := new(big.Int).Sub(pow10(nd), lo)
	c := new(big.Int).Rand(rng, span)
	return c.Add(c, lo)
}

func randExp(rng *rand.Rand, s fmtSpec) int {
	if *moderate {
		return rng.Intn(21) - 10
	}
	switch rng.Intn(8) {
	case 0:
		return s.emin + rng.Intn(20)
	case 1:
		return s.emax - rng.Intn(20)
	case 2:
		return rng.Intn(s.emax-s.emin+1) + s.emin
	}
	return rng.Intn(41) - 20
}

func randDec(rng *rand.Rand, s fmtSpec) dec {
	return dec{neg: rng.Intn(2) == 0, coef: randCoef(rng, s.p), exp: randExp(rng, s)}
}

type mismatch struct {
	op    byte
	a, b  dec
	want  dec
	got   dec
	class string
}

func classify(want, got dec) string {
	if want.kind != got.kind {
		return "kind"
	}
	if want.kind != 0 {
		if want.kind == 1 && want.neg != got.neg {
			return "infsign"
		}
		return ""
	}
	wr, gr := toRat(want), toRat(got)
	if wr.Cmp(gr) != 0 {
		return "value"
	}
	if want.coef.Sign() == 0 {
		if want.neg != got.neg {
			return "zerosign"
		}
		if want.exp != got.exp {
			return "zeroexp"
		}
		return ""
	}
	if want.exp != got.exp {
		return "quantum"
	}
	if want.neg != got.neg {
		return "sign"
	}
	return ""
}

func main() {
	n := flag.Int("n", 100000, "cases per op per type")
	seed := flag.Int64("seed", 1, "seed")
	show := flag.Int("show", 3, "examples per class")
	flag.Parse()

	// Determine Decimal128bits word order.
	a, b := math.Decimal128bits(decimal128(1))
	hiFirst = a>>49 != 0
	_ = b
	_ = os.Exit
	fmt.Printf("Decimal128bits returns (hi,lo)=%v\n", hiFirst)

	rng := rand.New(rand.NewSource(*seed))
	results := map[string]map[string][]mismatch{}
	counts := map[string]map[string]int{}
	rec := func(ty string, m mismatch) {
		if results[ty] == nil {
			results[ty] = map[string][]mismatch{}
			counts[ty] = map[string]int{}
		}
		k := fmt.Sprintf("%c:%s", m.op, m.class)
		counts[ty][k]++
		if len(results[ty][k]) < *show {
			results[ty][k] = append(results[ty][k], m)
		}
	}

	for _, op := range []byte{'+', '-', '*', '/'} {
		for i := 0; i < *n; i++ {
			ad, bd := randDec(rng, f64), randDec(rng, f64)
			x, y := pack64(ad.neg, ad.coef.Uint64(), ad.exp), pack64(bd.neg, bd.coef.Uint64(), bd.exp)
			var z decimal64
			switch op {
			case '+':
				z = x + y
			case '-':
				z = x - y
			case '*':
				z = x * y
			case '/':
				z = x / y
			}
			got := unpack64(math.Decimal64bits(z))
			want := f64.oracle(op, ad, bd)
			if c := classify(want, got); c != "" {
				rec("decimal64", mismatch{op, ad, bd, want, got, c})
			}
		}
		for i := 0; i < *n; i++ {
			ad, bd := randDec(rng, f128), randDec(rng, f128)
			x, y := pack128(ad.neg, ad.coef, ad.exp), pack128(bd.neg, bd.coef, bd.exp)
			var z decimal128
			switch op {
			case '+':
				z = x + y
			case '-':
				z = x - y
			case '*':
				z = x * y
			case '/':
				z = x / y
			}
			hi, lo := bits128(z)
			got := unpack128(hi, lo)
			want := f128.oracle(op, ad, bd)
			if c := classify(want, got); c != "" {
				rec("decimal128", mismatch{op, ad, bd, want, got, c})
			}
		}
	}
	for _, ty := range []string{"decimal64", "decimal128"} {
		fmt.Printf("\n== %s: %d cases per op ==\n", ty, *n)
		keys := make([]string, 0)
		for k := range counts[ty] {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		if len(keys) == 0 {
			fmt.Println("no mismatches")
		}
		for _, k := range keys {
			fmt.Printf("%-12s %6d mismatches\n", k, counts[ty][k])
			for _, m := range results[ty][k] {
				fmt.Printf("    %s %c %s\n      want %s\n      got  %s\n", m.a, m.op, m.b, m.want, m.got)
			}
		}
	}
}
