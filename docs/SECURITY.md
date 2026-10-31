# Playground security note

The playground at https://marcelocantos.github.io/go-decimal-proposal/
is a static site. GitHub Pages serves files; no server compiles or runs
anyone's code. The page fetches the Go compiler and linker (built for
WebAssembly from the fork pinned in `toolchain.lock`) and runs them in the
visitor's own browser. The earlier server playground on Fly.io, and the
container and process sandbox it needed, are gone.

## Who could be harmed

Only the visitor, by a program the visitor put there. There are no share
links and nothing is loaded from a URL: `?example=` chooses among the
bundled examples and `?timeout=` sets a bounded limit. The page never
sends code anywhere. So the program that runs is always a bundled example
or one the visitor typed or pasted, and the realistic risk is pasting a
hostile program from somewhere else.

## What the browser protects

The program runs in a Web Worker, inside the browser's sandbox. That
sandbox is the security boundary.

- It has no access to the visitor's files, or to the page's DOM.
- The in-memory filesystem (`playground/web/memfs.js`) that compiling and
  linking use is rebuilt for each run and discarded with the worker. The
  program does not see the toolchain's files.
- A program that never ends is stopped: the page terminates the worker
  after the run timeout (10 seconds), or when the program writes more than
  1 MB of output, and starts a fresh one. Output reaches the page as text,
  never as markup.

## What the worker can do

A worker is not an empty box. JavaScript in it can use IndexedDB,
CacheStorage and `fetch`: to its own origin freely, and to other sites
where they allow cross-origin requests.

The page's origin is `marcelocantos.github.io`, which it shares with the
owner's other GitHub Pages sites. Whatever those sites keep in IndexedDB
or CacheStorage in this visitor's browser is reachable from this worker,
and their pages can be fetched. The draft kept in `localStorage` is not
reachable, since workers have no `localStorage`. Other origins are outside
it, including github.com and the visitor's session there.

## How far an ordinary Go program gets

An ordinary program does not reach any of that, because it has no way to
call JavaScript.

- `syscall/js` is not offered. The compiler's importcfg lists only the
  offered packages, so an import of anything else fails in the compiler.
- `unsafe` is built into the compiler, so an importcfg cannot exclude it.
  The page's import scanner refuses it, and without it `//go:linkname` is
  refused too. A program whose imports the scanner cannot read does not run.

**This is not a security boundary.** `reflect`, which is offered because
decimal types take part in it, can forge pointers without importing
`unsafe` (`reflect.NewAt` with `Value.UnsafePointer`). A program written
for the purpose could corrupt its own memory, and it runs beside the code
that calls JavaScript, so assume it could then do what the previous
section describes. Read a program before running it, as you would with
any code from a stranger.

## What it does not protect

- **Resource use is the browser's to limit.** A program can use CPU and
  memory until the timeout or the browser's own limits stop it. On a
  phone that can mean a slow or reloaded tab.
- **The toolchain is trusted as built.** CI builds the bundle from the
  pinned fork, and its digests must match `playground/digests.txt`. Pages
  serves it over HTTPS. A compromise of this repository or its CI could
  still publish a different bundle.

Report a security problem by opening an issue at
https://github.com/marcelocantos/go-decimal-proposal/issues, or privately
through GitHub's security advisories for the repository.
