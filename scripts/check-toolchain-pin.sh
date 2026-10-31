#!/usr/bin/env bash
# ENT-002: toolchain identity must be a recorded SHA, not a floating branch tip.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
lock="$root/toolchain.lock"
workflow="$root/.github/workflows/build.yml"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

test -f "$lock" || fail "toolchain.lock is missing"

fork_sha="$(awk -F= '/^fork_sha=/{print $2}' "$lock")"

echo "$fork_sha" | grep -Eq '^[0-9a-f]{40}$' \
  || fail "toolchain.lock fork_sha is not 40 hex chars: ${fork_sha:-<empty>}"

if grep -q 'git clone .*--branch ' "$workflow"; then
  fail "build.yml still clones a floating branch tip"
fi

echo "OK: toolchain pin recorded (fork_sha=$fork_sha)"
