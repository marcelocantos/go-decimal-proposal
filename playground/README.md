# Static playground

The page at https://marcelocantos.github.io/go-decimal-proposal/ compiles
and runs Go in the visitor's browser. `tools/buildsite` builds the bundle
from the fork pinned in `toolchain.lock`.

| Path | What it holds |
|---|---|
| `web/` | The page, its worker, and the in-memory filesystem |
| `examples/` | The bundled programs, with expected output from native `go run` |
| `digests.txt` | The committed record of the bundle; CI requires an exact match |
| `journey/` | The headless-browser check that CI runs |

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
and linux/amd64 gave a byte-identical bundle at this pin. Any other
toolchain build still reproduces itself, but with a different
`tools/compile.wasm.gz`. `buildsite` warns when the toolchain was built
differently and says whether the digests match.

After changing the page or moving the pin, rebuild and run
`cp site/digests.txt playground/digests.txt`. After moving the pin, also run
`buildsite` with `-update` and review the changes to the expected outputs.

## Measurements

The baseline is the strawman measured on 2026-10-27. The rest was measured
on 2026-11-01 at fork commit 414c2749d1 on an Apple M4 Max, in a fresh browser
profile, with the bundle served from localhost.

| First-load transfer | Baseline, gzipped | Measured |
|---|---|---|
| `cmd/compile` | 9.6 MB | 10.62 MB |
| `cmd/link` | 3.0 MB | 3.32 MB |
| Archives | 5.2 MB | 5.40 MB |
| Everything, with the page | about 18 MB | 19.41 MB |

The baseline had 61 archives and the bundle has 60, including `internal/bid`.

| Time | Baseline | Chromium 156 | Firefox 157 |
|---|---|---|---|
| Page ready on localhost | not measured | 0.2 s | 0.5 s |
| Page ready, emulated 50 Mbit/s, 20 ms RTT | not measured | 3.4 s | not measured |
| Default example, first run | not measured | 0.39 s | 0.21 s |
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
