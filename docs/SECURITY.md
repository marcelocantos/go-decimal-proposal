# Playground security note

The playground at https://marcelocantos.github.io/go-decimal-proposal/
is a static site. GitHub Pages serves files; no server compiles or runs
anyone's code. The page fetches the Go compiler and linker (built for
WebAssembly from the fork pinned in `toolchain.lock`) and runs them in the
visitor's own browser. The earlier server playground on Fly.io, and the
container and process sandbox it needed, are gone.

## What the browser sandbox protects

- **The program runs in a Web Worker.** It has no access to the page's
  DOM, cookies or storage, and none to the visitor's files. Compiling and
  linking use an in-memory filesystem (`playground/web/memfs.js`) that
  starts empty apart from the standard-library archives and is discarded
  with the worker.
- **The program cannot reach JavaScript.** `syscall/js` is not offered,
  and imports outside the offered packages are refused before compiling.
  This keeps an ordinary program inside Go. It is not a security boundary:
  the boundary is the browser's sandbox around the worker.
- **A program that never ends is stopped.** The page terminates the worker
  after the run timeout (10 seconds), or when the program writes more than
  1 MB of output, and starts a fresh one.
- **Nothing is shared.** Code is never sent anywhere. There are no share
  links, so a page someone else prepared cannot run code in your browser.
  A draft of the program is kept in the browser's local storage for the
  next visit.

## What it does not protect

- **It is your code, run with your browser's powers.** Within the worker,
  WebAssembly runs with the same rights as any script on the page. A
  program that got past the import check could use the worker's network
  access (`fetch` to any site that allows it). Run code you understand,
  as you would in any playground.
- **Resource use is the browser's to limit.** A program can use CPU and
  memory until the timeout or the browser's own limits stop it. On a
  phone that can mean a slow or reloaded tab.
- **The toolchain is trusted as built.** The bundle is built in CI from
  the pinned fork, its file digests are recorded in `digests.txt` beside
  it, and building again from the same pin reproduces them. Pages serves
  it over HTTPS. A compromise of this repository or its CI could still
  publish a different bundle.

Report a security problem by opening an issue at
https://github.com/marcelocantos/go-decimal-proposal/issues, or privately
through GitHub's security advisories for the repository.
