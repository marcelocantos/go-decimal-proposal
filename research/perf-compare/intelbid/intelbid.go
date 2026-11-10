// Package intelbid calls Intel's Decimal Floating-Point Math Library
// (IntelRDFPMathLib v2.3, BSD) through cgo. The library is built outside this
// repository as a static archive; see the README for the build.
//
// Every function rounds to nearest, ties to even, and discards the flags.
// The Go-side functions make one cgo call per operation. The Loop*
// functions run the whole benchmark loop in C, so that their per-iteration
// cost is the library's own, without the cgo transition.
package intelbid

/*
#cgo CFLAGS: -O2 -I${SRCDIR}/../third_party/intel-rdfp/LIBRARY/src -DUSE_COMPILER_F128_TYPE=0 -DUSE_COMPILER_F80_TYPE=0 -DLINUX -DBID_SIZE_LONG=8 -DDECIMAL_CALL_BY_REFERENCE=0 -DDECIMAL_GLOBAL_ROUNDING=0 -DDECIMAL_GLOBAL_EXCEPTION_FLAGS=0 -w
#cgo LDFLAGS: ${SRCDIR}/../third_party/build/intel/libbid.a -lm
#include "bid_conf.h"
#include "bid_functions.h"
#include <string.h>
#include <stdlib.h>

#define RNE BID_ROUNDING_TO_NEAREST

static BID_UINT128 ib_add(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_add(x, y, RNE, &f); }
static BID_UINT128 ib_sub(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_sub(x, y, RNE, &f); }
static BID_UINT128 ib_mul(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_mul(x, y, RNE, &f); }
static BID_UINT128 ib_div(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_div(x, y, RNE, &f); }
static BID_UINT128 ib_fma(BID_UINT128 x, BID_UINT128 y, BID_UINT128 z) { _IDEC_flags f = 0; return bid128_fma(x, y, z, RNE, &f); }
static BID_UINT128 ib_quantize(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_quantize(x, y, RNE, &f); }
static int ib_less(BID_UINT128 x, BID_UINT128 y) { _IDEC_flags f = 0; return bid128_quiet_less(x, y, &f); }
static BID_UINT128 ib_parse(char *s) { _IDEC_flags f = 0; return bid128_from_string(s, RNE, &f); }
static int ib_format(char *buf, BID_UINT128 x) { _IDEC_flags f = 0; bid128_to_string(buf, x, &f); return (int)strlen(buf); }

static void ib_nop(void) {}
static BID_UINT128 ib_nop2(BID_UINT128 x, BID_UINT128 y) { return x; }

// The C loops index the four variants with i&3, as the Go loops do, and
// keep the last result in a volatile sink.
static volatile BID_UINT128 sink;
static volatile int isink;

#define LOOP2(name, call) \
	static void name(BID_UINT128 *xs, BID_UINT128 *ys, long n) { \
		BID_UINT128 r = xs[0]; \
		for (long i = 0; i < n; i++) { long j = i & 3; r = call(xs[j], ys[j]); } \
		sink = r; \
	}
LOOP2(ibl_add, ib_add)
LOOP2(ibl_sub, ib_sub)
LOOP2(ibl_mul, ib_mul)
LOOP2(ibl_div, ib_div)
LOOP2(ibl_quantize, ib_quantize)

static void ibl_fma(BID_UINT128 *xs, BID_UINT128 *ys, long n) {
	BID_UINT128 r = xs[0];
	for (long i = 0; i < n; i++) { long j = i & 3; r = ib_fma(xs[j], ys[j], ys[j]); }
	sink = r;
}
static void ibl_less(BID_UINT128 *xs, BID_UINT128 *ys, long n) {
	int r = 0;
	for (long i = 0; i < n; i++) { long j = i & 3; r = ib_less(xs[j], ys[j]); }
	isink = r;
}
static void ibl_parse(char **ss, long n) {
	BID_UINT128 r = {{0, 0}};
	for (long i = 0; i < n; i++) r = ib_parse(ss[i & 3]);
	sink = r;
}
static void ibl_format(BID_UINT128 *xs, long n) {
	char buf[64];
	int r = 0;
	for (long i = 0; i < n; i++) r = ib_format(buf, xs[i & 3]);
	isink = r;
}

// The drawn loops index pools of 1024 operand pairs by a generator, as
// loop2d does in Go: an order the branch predictor cannot learn, which the
// four variants above are not.
#define DLOOP2(name, call) \
	static void name(BID_UINT128 *xs, BID_UINT128 *ys, long n) { \
		BID_UINT128 r = xs[0]; \
		unsigned long long s = 88172645463325252ULL; \
		for (long i = 0; i < n; i++) { \
			s ^= s << 13; s ^= s >> 7; s ^= s << 17; \
			long j = (long)((s >> 32) & 1023); \
			r = call(xs[j], ys[j]); \
		} \
		sink = r; \
	}
DLOOP2(ibd_add, ib_add)
DLOOP2(ibd_sub, ib_sub)
DLOOP2(ibd_mul, ib_mul)
DLOOP2(ibd_div, ib_div)
static void ibd_less(BID_UINT128 *xs, BID_UINT128 *ys, long n) {
	int r = 0;
	unsigned long long s = 88172645463325252ULL;
	for (long i = 0; i < n; i++) {
		s ^= s << 13; s ^= s >> 7; s ^= s << 17;
		long j = (long)((s >> 32) & 1023);
		r += ib_less(xs[j], ys[j]);
	}
	isink = r;
}
*/
import "C"

import "unsafe"

// D is a decimal128 in BID encoding: D[0] is the low word.
type D [2]uint64

func c(x D) C.BID_UINT128 { return *(*C.BID_UINT128)(unsafe.Pointer(&x)) }
func g(x C.BID_UINT128) D { return *(*D)(unsafe.Pointer(&x)) }

func Add(x, y D) D      { return g(C.ib_add(c(x), c(y))) }
func Sub(x, y D) D      { return g(C.ib_sub(c(x), c(y))) }
func Mul(x, y D) D      { return g(C.ib_mul(c(x), c(y))) }
func Div(x, y D) D      { return g(C.ib_div(c(x), c(y))) }
func FMA(x, y, z D) D   { return g(C.ib_fma(c(x), c(y), c(z))) }
func Quantize(x, y D) D { return g(C.ib_quantize(c(x), c(y))) }
func Less(x, y D) bool  { return C.ib_less(c(x), c(y)) != 0 }
func Nop()              { C.ib_nop() }
func Nop2(x, y D) D     { return g(C.ib_nop2(c(x), c(y))) }
func ParseC(s CStr) D   { return g(C.ib_parse(s.p)) }

// CStr is a NUL-terminated string in C memory, for ParseC and LoopParse.
type CStr struct{ p *C.char }

// CString copies s to C memory. It is never freed: the benchmarks make a
// handful.
func CString(s string) CStr { return CStr{C.CString(s)} }

// Parse parses s; it allocates a C copy of s, so it is for setup, not for
// timing.
func Parse(s string) D {
	cs := C.CString(s)
	defer C.free(unsafe.Pointer(cs))
	return g(C.ib_parse(cs))
}

// FormatBuf formats x into a C buffer and returns the length; Format returns
// the Go string.
var fbuf = (*C.char)(C.malloc(64))

func FormatBuf(x D) int { return int(C.ib_format(fbuf, c(x))) }
func Format(x D) string {
	n := C.ib_format(fbuf, c(x))
	return C.GoStringN(fbuf, n)
}

func cp(xs *[4]D) *C.BID_UINT128 { return (*C.BID_UINT128)(unsafe.Pointer(&xs[0])) }

func LoopAdd(xs, ys *[4]D, n int)      { C.ibl_add(cp(xs), cp(ys), C.long(n)) }
func LoopSub(xs, ys *[4]D, n int)      { C.ibl_sub(cp(xs), cp(ys), C.long(n)) }
func LoopMul(xs, ys *[4]D, n int)      { C.ibl_mul(cp(xs), cp(ys), C.long(n)) }
func LoopDiv(xs, ys *[4]D, n int)      { C.ibl_div(cp(xs), cp(ys), C.long(n)) }
func LoopFMA(xs, ys *[4]D, n int)      { C.ibl_fma(cp(xs), cp(ys), C.long(n)) }
func LoopQuantize(xs, ys *[4]D, n int) { C.ibl_quantize(cp(xs), cp(ys), C.long(n)) }
func LoopLess(xs, ys *[4]D, n int)     { C.ibl_less(cp(xs), cp(ys), C.long(n)) }
func LoopFormat(xs *[4]D, n int)       { C.ibl_format(cp(xs), C.long(n)) }

// LoopParse parses the four C strings (from CString) n times.
func LoopParse(ss *[4]CStr, n int) { C.ibl_parse((**C.char)(unsafe.Pointer(&ss[0])), C.long(n)) }

// The drawn loops: xs and ys are pools of 1024 operands.
func dp(xs []D) *C.BID_UINT128 {
	if len(xs) != 1024 {
		panic("intelbid: a drawn pool has 1024 operands")
	}
	return (*C.BID_UINT128)(unsafe.Pointer(&xs[0]))
}

func DrawnAdd(xs, ys []D, n int)  { C.ibd_add(dp(xs), dp(ys), C.long(n)) }
func DrawnSub(xs, ys []D, n int)  { C.ibd_sub(dp(xs), dp(ys), C.long(n)) }
func DrawnMul(xs, ys []D, n int)  { C.ibd_mul(dp(xs), dp(ys), C.long(n)) }
func DrawnDiv(xs, ys []D, n int)  { C.ibd_div(dp(xs), dp(ys), C.long(n)) }
func DrawnLess(xs, ys []D, n int) { C.ibd_less(dp(xs), dp(ys), C.long(n)) }
