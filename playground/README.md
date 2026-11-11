# Static playground

The page at https://marcelocantos.github.io/go-decimal-proposal/ compiles
and runs Go in the visitor's browser. `tools/buildsite` builds the bundle
from the fork pinned in `toolchain.lock`.

The `GOEXPERIMENT=decimal` checkbox is checked initially. Uncheck it to try
the compiler and standard-library API with the experiment off. The editor's
contents are preserved. The off-mode archives download on first use and
are reused when switching modes or recovering from a run timeout. The
available-package list changes with the setting; `math/decimal` is absent
when off. Reloading starts with the experiment enabled again.

The **SQL round trips (in-memory SQLite)** example runs a real SQLite
database entirely in the browser, using the pure Go driver
`github.com/ncruces/go-sqlite3/driver`. Dependencies are pinned in
`examples/go.mod` and `examples/go.sum`; the builder uses that same graph
for both experiment settings. No database service or JavaScript SQL bridge
is involved.

It binds and scans both decimal widths through `database/sql`, retaining
all 34 digits of the decimal128 example. SQLite stores these values in a
`TEXT` column: this demonstrates exact data transport, not exact SQL
decimal arithmetic or another database's `NUMERIC` support. The fork's
default parameter conversion writes `1e+03` as `1000`, preserving value
but losing the positive quantum. The example's finite decimal128
`driver.Valuer` adapter uses canonical text to retain that quantum too.
The column must preserve the text; a numeric affinity could coerce it.
NULL handling and database-specific decimal policies remain applications'
and drivers' responsibilities.

The **JSON string fields** example decodes and encodes decimals through
`encoding/json/v2` with the standard `string` tag option, beside the same
struct with `float64` fields. A decimal field follows a float field: a
quoted value must be a JSON number, and NaN and the infinities are
rejected in both directions. It prints each error's cause and not the
message, because the json package varies its wording between runs.

| Path | What it holds |
|---|---|
| `web/` | The page, its worker, and the in-memory filesystem |
| `examples/` | The bundled programs, with expected output from native `go run` |
| `digests.txt` | The committed record of the bundle; CI requires an exact match |
| `journey/` | The headless-browser check that CI runs |

The URL fragment carries the editor's program for sharing: the page
rewrites it as the program changes, without adding history entries. It is
the source, compressed with raw DEFLATE (`CompressionStream("deflate-raw")`)
and written as unpadded base64url.

[`docs/SECURITY.md`](../docs/SECURITY.md) says what the browser sandbox
does and does not protect.

## Building

From the repository root, with `$GOROOT` a checkout of the fork at the
pinned SHA:

```sh
(cd $GOROOT/src && GOROOT_BOOTSTRAP=/path/to/go1.26 CGO_ENABLED=0 GOTOOLCHAIN=local GOEXPERIMENT= ./make.bash)
$GOROOT/bin/go run ./tools/buildsite -goroot $GOROOT
```

**The committed digests need a toolchain built with `CGO_ENABLED=0`, as CI
builds it.** `make.bash` records that setting in the toolchain, and
`cmd/compile`'s code depends on it. Built that way, darwin/arm64
and linux/amd64 gave a byte-identical bundle at the earlier pin
32c1829380. CI checks cross-host reproducibility against the recorded digests. Any other
toolchain build still reproduces itself, but with a different
`tools/compile.wasm.gz`. `buildsite` warns when the toolchain was built
differently and says whether the digests match.

After changing the page or moving the pin, rebuild and run
`cp site/digests.txt playground/digests.txt`. After moving the pin, also run
`buildsite` with `-update` and review the changes to the expected outputs.

## Measurements

The baseline is the strawman measured on 2026-10-27. The rest was measured
on 2026-11-01 at fork commit 32c14fd1b1 on an Apple M4 Max, in a fresh browser
profile, with the bundle served from localhost.

| First-load transfer | Baseline, gzipped | Measured |
|---|---|---|
| `cmd/compile` | 9.6 MB | 10.62 MB |
| `cmd/link` | 3.0 MB | 3.32 MB |
| Archives | 5.2 MB | 5.40 MB |
| Everything, with the page | about 18 MB | 19.41 MB |

These measurements describe the earlier bundle. With the embedded SQLite
driver, the current bundle has 126 archives with decimal enabled and 125
with it off. On 2026-11-08, its Chromium journey measured 30.80 MB on first
load and 0.72 s to compile, link and run the SQL example. Both experiment
settings include SQLite; first switching off downloads its separate archive.
The off-mode archive is not part of the initial load.
Offering `encoding/json` and `encoding/json/v2` adds one archive to each
setting, 127 and 126; on 2026-11-11 the Chromium journey measured 31.17 MB
on first load at fork commit fa04fab1b6.

| Time | Baseline | Chromium 156 | Firefox 157 |
|---|---|---|---|
| Page ready on localhost | not measured | 0.2 s | 0.5 s |
| Page ready, emulated 50 Mbit/s, 20 ms RTT | not measured | 3.4 s | not measured |
| Default example, first run | not measured | 0.40 s | 0.20 s |
| Default example, later runs | not measured | 0.13 s | 0.16 s |

A run is the time from clicking Run to the program finishing: compiling,
linking and running.

To retake them, build the bundle and run:

```sh
cd playground/journey
npm ci
npx playwright install chromium firefox
node journey.mjs --metrics /tmp/chromium.json --throttle-mbps 50
node journey.mjs --metrics /tmp/firefox.json --browser firefox
```

Each run prints the figures and writes the detail to the metrics file. CI
uploads the same file, measured on its own runner, as the
`playground-journey` artifact.
