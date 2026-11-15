#!/bin/bash
# Builds both benchmark binaries and runs them interleaved: each round runs
# every row of perfcompare.test once, then the kernel rows of bid.test once.
# Usage: ./run.sh [rounds] [benchtime]   (defaults 12 and 500ms)
# With LOADMAX set (for example LOADMAX=13.5), each round starts only when
# the 1-minute load average is below it.
# Output: results/compare.txt, results/kernel.txt, results/uptime.txt.
set -euo pipefail
cd "$(dirname "$0")"
. ./env.sh
export CGO_ENABLED=1
rounds=${1:-12}
benchtime=${2:-500ms}

load1() { uptime | sed -E 's/.*load averages?: *([0-9.]+).*/\1/'; }

go test -c -o perfcompare.test .
(cd "$GOROOT/src" && go test -c -o "$OLDPWD/bid.test" ./internal/bid)

mkdir -p results
: > results/compare.txt
: > results/kernel.txt
{ echo "before: $(uptime)"; } > results/uptime.txt
for ((r = 1; r <= rounds; r++)); do
	if [ -n "${LOADMAX:-}" ]; then
		until awk -v l="$(load1)" -v m="$LOADMAX" 'BEGIN { exit !(l < m) }'; do sleep 20; done
	fi
	echo "round $r/$rounds: $(uptime)" >> results/uptime.txt
	./perfcompare.test -test.run '^$' -test.bench 'BenchmarkCompare' -test.benchmem \
		-test.benchtime "$benchtime" -test.count 1 >> results/compare.txt
	./bid.test -test.run '^$' -test.bench 'BenchmarkKernel/(Add|Sub|Mul|Div|FMA|Quantize|Less|Parse|Append)/128/' \
		-test.benchmem -test.benchtime "$benchtime" -test.count 1 >> results/kernel.txt
	echo "round $r/$rounds end: $(uptime)" >> results/uptime.txt
done
echo "after: $(uptime)" >> results/uptime.txt
