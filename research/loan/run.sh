#!/bin/bash
# Runs the loan schedule three ways and checks that they agree to the cent:
# built-in decimal128 (the fork), github.com/shopspring/decimal, and the
# math/decimal package of https://go.dev/issue/82668 as implemented by
# patchset 7 of https://go.dev/cl/855581, which is copied into stdlib/decimal
# (ignored by git). Set FORK to a checkout of the fork built with make.bash:
#   FORK=$HOME/go-decimal ./run.sh
set -euo pipefail
: "${FORK:?set FORK to a checkout of https://github.com/marcelocantos/go built with make.bash}"
cd "$(dirname "$0")"

if [ ! -f stdlib/decimal/arith.go ]; then
	mkdir -p stdlib/decimal
	for f in arith.go cmp.go decimal.go doc.go format.go marshal.go round.go; do
		curl -sSf "https://go-review.googlesource.com/changes/855581/revisions/7/files/src%2Fmath%2Fdecimal%2F$f/content" |
			base64 --decode > "stdlib/decimal/$f"
	done
fi

out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
(cd builtin && GOROOT="$FORK" GOTOOLCHAIN=local GOEXPERIMENT=decimal "$FORK/bin/go" run .) > "$out/builtin"
(cd shopspring && go run .) > "$out/shopspring"
(cd stdlib && go run .) > "$out/stdlib"

diff "$out/builtin" "$out/shopspring"
diff "$out/builtin" "$out/stdlib"
echo "all three schedules agree: $(wc -l < "$out/builtin" | tr -d ' ') balances, last $(tail -1 "$out/builtin")"
