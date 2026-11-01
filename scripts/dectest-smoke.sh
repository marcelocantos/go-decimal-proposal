#!/usr/bin/env bash
# 🎯T1.2.5 / 🎯T1249: runs tests/dectest with the pinned fork toolchain
# (toolchain.lock's fork_sha), the way cmd/integrate's .jevons-integrate-
# prereq.yaml prerequisite does before its own go build/touched-package
# gate. The harness's main.go is built with -tags decimal64, so only this
# script (or another caller passing the same tag with a fork GOROOT)
# compiles the real program; the host-go touched-package test sees only
# tests/dectest/hostgo_stub.go and stays trivially green.
#
# Toolchain: reused from $GO_DECIMAL_FORK_GOROOT if set and pinned to the
# right SHA; else from a private cache under $GO_DECIMAL_FORK_CACHE
# (default ~/.cache/go-decimal-proposal/fork/<sha>), cloned and built with
# make.bash on first use and reused after (mirrors .github/workflows/
# build.yml's "Clone Go fork" + "Build toolchain from source" steps,
# except to a private path — never the shared sibling checkout at
# github.com/golang/go, per this fleet's sibling-shared-clone rule).
#
# decTest vectors: not vendored (IBM notice, no redistribution grant; see
# tests/dectest/README.md). BID_DECTEST_DIR or a conventional local copy
# (Python's bundled decimaltestdata) is used when found; when neither is
# available this script SKIPS the smoke run (prints why, exits 0) rather
# than failing an integrate landing over test data that was never
# supposed to live in the repo or in CI.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
lock="$root/toolchain.lock"

fail() {
  echo "dectest-smoke: FAIL: $*" >&2
  exit 1
}

test -f "$lock" || fail "toolchain.lock is missing"
fork_sha="$(awk -F= '/^fork_sha=/{print $2}' "$lock")"
fork_repo="$(awk -F= '/^fork_repo=/{print $2}' "$lock")"
echo "$fork_sha" | grep -Eq '^[0-9a-f]{40}$' || fail "toolchain.lock fork_sha is not 40 hex chars: ${fork_sha:-<empty>}"
test -n "$fork_repo" || fail "toolchain.lock fork_repo is empty"

goroot=""
if [ -n "${GO_DECIMAL_FORK_GOROOT:-}" ] && [ -x "${GO_DECIMAL_FORK_GOROOT}/bin/go" ]; then
  have_sha="$(GOROOT="$GO_DECIMAL_FORK_GOROOT" GOTOOLCHAIN=local "${GO_DECIMAL_FORK_GOROOT}/bin/go" env GOVERSION 2>/dev/null || true)"
  case "$have_sha" in
    *"${fork_sha:0:10}"*) goroot="$GO_DECIMAL_FORK_GOROOT" ;;
    *) echo "dectest-smoke: GO_DECIMAL_FORK_GOROOT=$GO_DECIMAL_FORK_GOROOT is not built at $fork_sha ($have_sha); ignoring" >&2 ;;
  esac
fi

if [ -z "$goroot" ]; then
  cache_root="${GO_DECIMAL_FORK_CACHE:-$HOME/.cache/go-decimal-proposal/fork}"
  cand="$cache_root/$fork_sha"
  if [ -x "$cand/bin/go" ]; then
    goroot="$cand"
  else
    echo "dectest-smoke: building fork toolchain @ $fork_sha into $cand (first run; cached after)"
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    git clone --filter=blob:none "$fork_repo" "$tmp/src-checkout"
    git -C "$tmp/src-checkout" checkout --quiet --detach "$fork_sha"
    got="$(git -C "$tmp/src-checkout" rev-parse HEAD)"
    [ "$got" = "$fork_sha" ] || fail "checkout landed on $got, not $fork_sha"
    (
      cd "$tmp/src-checkout/src"
      GOROOT="$tmp/src-checkout" GOROOT_BOOTSTRAP="$(go env GOROOT)" \
        CGO_ENABLED=0 GOTOOLCHAIN=local GOEXPERIMENT='' ./make.bash
    )
    mkdir -p "$cache_root"
    rm -rf "$cand"
    mv "$tmp/src-checkout" "$cand"
    trap - EXIT
    rm -rf "$tmp"
    goroot="$cand"
  fi
fi

dir="${BID_DECTEST_DIR:-}"
if [ -z "$dir" ]; then
  for cand_dir in \
    /Library/Frameworks/Python.framework/Versions/*/lib/python*/test/decimaltestdata \
    /usr/lib/python3*/test/decimaltestdata
  do
    if [ -d "$cand_dir" ]; then
      dir="$cand_dir"
      break
    fi
  done
fi

if [ -z "$dir" ] || [ ! -d "$dir" ]; then
  echo "dectest-smoke: no decTest vectors found (BID_DECTEST_DIR unset, no bundled Python copy found); skipping — not vendored, see tests/dectest/README.md"
  exit 0
fi

echo "dectest-smoke: GOROOT=$goroot dir=$dir"
cd "$root/tests"
GOROOT="$goroot" GOTOOLCHAIN=local GOEXPERIMENT='' CGO_ENABLED=0 GOWORK=off \
  "$goroot/bin/go" run -tags decimal64 ./dectest -dir "$dir"
