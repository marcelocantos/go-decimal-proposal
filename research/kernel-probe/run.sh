#!/bin/bash
# Runs the kernel probe against a built checkout of the fork: the driver is
# built for the host and for linux/386 and linux/s390x, the host binary runs
# natively and the others under Docker's emulation, and probe.py judges every
# result against Python's decimal module. Set FORK to a checkout of
# https://github.com/marcelocantos/go built with make.bash:
#   FORK=$HOME/go-decimal ./run.sh
set -euo pipefail
: "${FORK:?set FORK to a checkout of https://github.com/marcelocantos/go built with make.bash}"
here="$(cd "$(dirname "$0")" && pwd)"
out="${KERNEL_PROBE_OUT:-$here/out}"
mkdir -p "$out"

# The driver imports internal/bid, so it is built inside the fork's tree and
# removed again afterwards.
cmd="$FORK/src/cmd/kernelprobe"
mkdir -p "$cmd"
trap 'rm -rf "$cmd"' EXIT
cp "$here/driver.go" "$cmd/main.go"

build() { # goos goarch output
	(cd "$FORK/src" && GOROOT="$FORK" GOTOOLCHAIN=local GOEXPERIMENT=decimal CGO_ENABLED=0 \
		GOOS="$1" GOARCH="$2" "$FORK/bin/go" build -o "$3" ./cmd/kernelprobe)
}
build "$("$FORK/bin/go" env GOHOSTOS)" "$("$FORK/bin/go" env GOHOSTARCH)" "$out/probe-host"
build linux 386 "$out/probe-386"
build linux s390x "$out/probe-s390x"

export KERNEL_PROBE_OUT="$out"
AUDIT_LABEL=-host AUDIT_COMMAND="[\"$out/probe-host\"]" python3 -I "$here/probe.py"
for arch in 386 s390x; do
	AUDIT_LABEL="-$arch" \
		AUDIT_COMMAND="[\"docker\", \"run\", \"--rm\", \"-i\", \"--network=none\", \"-v\", \"$out:/audit:ro\", \"debian:bookworm-slim\", \"/audit/probe-$arch\"]" \
		python3 -I "$here/probe.py"
done
