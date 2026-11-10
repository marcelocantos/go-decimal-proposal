// Package decquad calls decNumber's decQuad module (decNumber 3.68, ICU
// licence) through cgo. The library is built outside this repository as a
// static archive; see the README for the build.
//
// decQuad is IEEE 754 decimal128 in the DPD encoding. Every function uses a
// context from decContextDefault(DEC_INIT_DECQUAD): 34 digits, ties to even.
// The Go-side functions make one cgo call per operation. The Loop* functions
// run the whole benchmark loop in C, so that their per-iteration cost is the
// library's own, without the cgo transition.
package decquad

/*
#cgo CFLAGS: -O3 -I${SRCDIR}/../third_party/decnumber/decNumber
#cgo LDFLAGS: ${SRCDIR}/../third_party/build/decnumber/libdecquad.a
#include "decQuad.h"
#include <string.h>
#include <stdlib.h>

static decContext ctx;
static void dq_init(void) { decContextDefault(&ctx, DEC_INIT_DECQUAD); }

static decQuad dq_add(decQuad x, decQuad y) { decQuad r; decQuadAdd(&r, &x, &y, &ctx); return r; }
static decQuad dq_sub(decQuad x, decQuad y) { decQuad r; decQuadSubtract(&r, &x, &y, &ctx); return r; }
static decQuad dq_mul(decQuad x, decQuad y) { decQuad r; decQuadMultiply(&r, &x, &y, &ctx); return r; }
static decQuad dq_div(decQuad x, decQuad y) { decQuad r; decQuadDivide(&r, &x, &y, &ctx); return r; }
static decQuad dq_fma(decQuad x, decQuad y, decQuad z) { decQuad r; decQuadFMA(&r, &x, &y, &z, &ctx); return r; }
static decQuad dq_quantize(decQuad x, decQuad y) { decQuad r; decQuadQuantize(&r, &x, &y, &ctx); return r; }
// Less: Compare gives -1, 0, 1 or NaN; x < y when the result is negative
// and not a NaN.
static int dq_less(decQuad x, decQuad y) {
	decQuad r; decQuadCompare(&r, &x, &y, &ctx);
	return decQuadIsNegative(&r) && !decQuadIsNaN(&r);
}
static decQuad dq_parse(char *s) { decQuad r; decQuadFromString(&r, s, &ctx); return r; }
static int dq_format(char *buf, decQuad x) { decQuadToString(&x, buf); return (int)strlen(buf); }

static volatile decQuad sink;
static volatile int isink;

#define LOOP2(name, call) \
	static void name(decQuad *xs, decQuad *ys, long n) { \
		decQuad r = xs[0]; \
		for (long i = 0; i < n; i++) { long j = i & 3; r = call(xs[j], ys[j]); } \
		memcpy((void *)&sink, &r, sizeof r); \
	}
LOOP2(dql_add, dq_add)
LOOP2(dql_sub, dq_sub)
LOOP2(dql_mul, dq_mul)
LOOP2(dql_div, dq_div)
LOOP2(dql_quantize, dq_quantize)

static void dql_fma(decQuad *xs, decQuad *ys, long n) {
	decQuad r = xs[0];
	for (long i = 0; i < n; i++) { long j = i & 3; r = dq_fma(xs[j], ys[j], ys[j]); }
	memcpy((void *)&sink, &r, sizeof r);
}
static void dql_less(decQuad *xs, decQuad *ys, long n) {
	int r = 0;
	for (long i = 0; i < n; i++) { long j = i & 3; r = dq_less(xs[j], ys[j]); }
	isink = r;
}
static void dql_parse(char **ss, long n) {
	decQuad r;
	for (long i = 0; i < n; i++) r = dq_parse(ss[i & 3]);
	memcpy((void *)&sink, &r, sizeof r);
}
static void dql_format(decQuad *xs, long n) {
	char buf[DECQUAD_String];
	int r = 0;
	for (long i = 0; i < n; i++) r = dq_format(buf, xs[i & 3]);
	isink = r;
}

// The drawn loops index pools of 1024 operand pairs by a generator, as
// loop2d does in Go: an order the branch predictor cannot learn, which the
// four variants above are not.
#define DLOOP2(name, call) \
	static void name(decQuad *xs, decQuad *ys, long n) { \
		decQuad r = xs[0]; \
		unsigned long long s = 88172645463325252ULL; \
		for (long i = 0; i < n; i++) { \
			s ^= s << 13; s ^= s >> 7; s ^= s << 17; \
			long j = (long)((s >> 32) & 1023); \
			r = call(xs[j], ys[j]); \
		} \
		memcpy((void *)&sink, &r, sizeof r); \
	}
DLOOP2(dqd_add, dq_add)
DLOOP2(dqd_sub, dq_sub)
DLOOP2(dqd_mul, dq_mul)
DLOOP2(dqd_div, dq_div)
static void dqd_less(decQuad *xs, decQuad *ys, long n) {
	int r = 0;
	unsigned long long s = 88172645463325252ULL;
	for (long i = 0; i < n; i++) {
		s ^= s << 13; s ^= s >> 7; s ^= s << 17;
		long j = (long)((s >> 32) & 1023);
		r += dq_less(xs[j], ys[j]);
	}
	isink = r;
}
*/
import "C"

import "unsafe"

func init() { C.dq_init() }

// D is a decQuad: decimal128 in the DPD encoding, in the byte order of the
// machine.
type D [16]byte

func c(x D) C.decQuad { return *(*C.decQuad)(unsafe.Pointer(&x)) }
func g(x C.decQuad) D { return *(*D)(unsafe.Pointer(&x)) }

func Add(x, y D) D      { return g(C.dq_add(c(x), c(y))) }
func Sub(x, y D) D      { return g(C.dq_sub(c(x), c(y))) }
func Mul(x, y D) D      { return g(C.dq_mul(c(x), c(y))) }
func Div(x, y D) D      { return g(C.dq_div(c(x), c(y))) }
func FMA(x, y, z D) D   { return g(C.dq_fma(c(x), c(y), c(z))) }
func Quantize(x, y D) D { return g(C.dq_quantize(c(x), c(y))) }
func Less(x, y D) bool  { return C.dq_less(c(x), c(y)) != 0 }

// CStr is a NUL-terminated string in C memory, for ParseC and LoopParse.
type CStr struct{ p *C.char }

// CString copies s to C memory. It is never freed: the benchmarks make a
// handful.
func CString(s string) CStr { return CStr{C.CString(s)} }

func ParseC(s CStr) D { return g(C.dq_parse(s.p)) }

// Parse parses s; it allocates a C copy of s, so it is for setup, not for
// timing.
func Parse(s string) D {
	cs := C.CString(s)
	defer C.free(unsafe.Pointer(cs))
	return g(C.dq_parse(cs))
}

var fbuf = (*C.char)(C.malloc(C.DECQUAD_String))

// FormatBuf formats x into a C buffer and returns the length; Format returns
// the Go string.
func FormatBuf(x D) int { return int(C.dq_format(fbuf, c(x))) }
func Format(x D) string {
	n := C.dq_format(fbuf, c(x))
	return C.GoStringN(fbuf, n)
}

func cp(xs *[4]D) *C.decQuad { return (*C.decQuad)(unsafe.Pointer(&xs[0])) }

func LoopAdd(xs, ys *[4]D, n int)      { C.dql_add(cp(xs), cp(ys), C.long(n)) }
func LoopSub(xs, ys *[4]D, n int)      { C.dql_sub(cp(xs), cp(ys), C.long(n)) }
func LoopMul(xs, ys *[4]D, n int)      { C.dql_mul(cp(xs), cp(ys), C.long(n)) }
func LoopDiv(xs, ys *[4]D, n int)      { C.dql_div(cp(xs), cp(ys), C.long(n)) }
func LoopFMA(xs, ys *[4]D, n int)      { C.dql_fma(cp(xs), cp(ys), C.long(n)) }
func LoopQuantize(xs, ys *[4]D, n int) { C.dql_quantize(cp(xs), cp(ys), C.long(n)) }
func LoopLess(xs, ys *[4]D, n int)     { C.dql_less(cp(xs), cp(ys), C.long(n)) }
func LoopFormat(xs *[4]D, n int)       { C.dql_format(cp(xs), C.long(n)) }

// LoopParse parses the four C strings (from CString) n times.
func LoopParse(ss *[4]CStr, n int) { C.dql_parse((**C.char)(unsafe.Pointer(&ss[0])), C.long(n)) }

// The drawn loops: xs and ys are pools of 1024 operands.
func dp(xs []D) *C.decQuad {
	if len(xs) != 1024 {
		panic("decquad: a drawn pool has 1024 operands")
	}
	return (*C.decQuad)(unsafe.Pointer(&xs[0]))
}

func DrawnAdd(xs, ys []D, n int)  { C.dqd_add(dp(xs), dp(ys), C.long(n)) }
func DrawnSub(xs, ys []D, n int)  { C.dqd_sub(dp(xs), dp(ys), C.long(n)) }
func DrawnMul(xs, ys []D, n int)  { C.dqd_mul(dp(xs), dp(ys), C.long(n)) }
func DrawnDiv(xs, ys []D, n int)  { C.dqd_div(dp(xs), dp(ys), C.long(n)) }
func DrawnLess(xs, ys []D, n int) { C.dqd_less(dp(xs), dp(ys), C.long(n)) }
