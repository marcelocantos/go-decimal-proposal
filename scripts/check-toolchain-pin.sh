#!/usr/bin/env bash
# ENT-002: toolchain identity must be a recorded SHA + tarball digest,
# not a floating branch tip and an unverified `latest` download.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
lock="$root/toolchain.lock"
workflow="$root/.github/workflows/build.yml"
dockerfile="$root/Dockerfile"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

test -f "$lock" || fail "toolchain.lock is missing"

fork_sha="$(awk -F= '/^fork_sha=/{print $2}' "$lock")"
tarball_sha="$(awk -F= '/^tarball_sha256=/{print $2}' "$lock")"

echo "$fork_sha" | grep -Eq '^[0-9a-f]{40}$' \
  || fail "toolchain.lock fork_sha is not 40 hex chars: ${fork_sha:-<empty>}"
echo "$tarball_sha" | grep -Eq '^[0-9a-f]{64}$' \
  || fail "toolchain.lock tarball_sha256 is not 64 hex chars: ${tarball_sha:-<empty>}"

if grep -q 'git clone .*--branch decimal64' "$workflow"; then
  fail "build.yml still clones the floating decimal64 branch tip"
fi

grep -q 'sha256sum -c' "$dockerfile" || fail "Dockerfile does not sha256sum -c the tarball"

echo "OK: toolchain pin recorded (fork_sha=$fork_sha)"
