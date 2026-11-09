#!/bin/bash
# Fetches and builds the two C libraries the cgo candidates link against,
# into third_party/ (ignored by git). Intel's makefile does not know arm64 and
# builds an unoptimised "ia32" library, so its sources are compiled directly
# at -O2 with BID_SIZE_LONG=8, call by value, rounding and flags as arguments.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p third_party/build/intel third_party/build/decnumber
if [ ! -d third_party/intel-rdfp ]; then
	git clone --depth 1 https://github.com/xmake-mirror/IntelRDFPMathLib third_party/intel-rdfp
fi
S=$PWD/third_party/intel-rdfp/LIBRARY/src
( cd third_party/build/intel && for f in "$S"/bid*.c; do
	clang -O2 -c -I"$S" -DUSE_COMPILER_F128_TYPE=0 -DUSE_COMPILER_F80_TYPE=0 -DLINUX \
		-DBID_SIZE_LONG=8 -DDECIMAL_CALL_BY_REFERENCE=0 -DDECIMAL_GLOBAL_ROUNDING=0 \
		-DDECIMAL_GLOBAL_EXCEPTION_FLAGS=0 -w -o "$(basename "$f" .c).o" "$f"
  done && ar rcs libbid.a *.o )
if [ ! -d third_party/decnumber/decNumber ]; then
	mkdir -p third_party/decnumber && ( cd third_party/decnumber && curl -sSLO https://speleotrove.com/decimal/decNumber-icu-368.zip && unzip -q decNumber-icu-368.zip )
fi
D=$PWD/third_party/decnumber/decNumber
( cd third_party/build/decnumber && clang -O3 -c "$D/decQuad.c" "$D/decContext.c" -I"$D" && ar rcs libdecquad.a decQuad.o decContext.o )
echo "built third_party/build/intel/libbid.a and third_party/build/decnumber/libdecquad.a"
