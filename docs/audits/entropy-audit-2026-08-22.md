# Entropy audit — go-decimal-proposal

Date: 2026-08-22
Mode: full (entropy + explicit hygiene validation)
Auditor: Grok Build subagent (sole owner for this repo)

## Executive summary

- **Snapshot:** `/Users/marcelo/work/github.com/marcelocantos/go-decimal-proposal`
- **Branch (initial):** `t4-actions-node24` tracking `origin/t4-actions-node24`
- **HEAD (initial and throughout):** `7f8604b1c319fb3bf8de8638cbf13950470979cc` — `ci: bump GitHub Actions to Node-24 majors`
- **Initial dirty state:** clean (`git status --porcelain=v1 -b` showed only the branch header)
- **Default branch on GitHub:** `master` at `d34cb201549f115d2ea7074dbd72368365cf1987` (`ci: bump GitHub Actions to Node 24 majors (#1)`). Local `master` was still `e2421b7`. A later evidence `git fetch origin --prune` deleted `origin/t4-actions-node24` (PR #1 merged and the remote branch was removed). Working tree remained clean; HEAD was not moved.
- **Tracked corpus:** 8 files, 2563 lines. No `go.mod`, `LICENSE`, `.gitignore`, `AGENTS.md`, `CLAUDE.md`, or `hygiene.yaml`.
- **Languages judged:** Go (server + validator), GitHub Actions YAML, Dockerfile, embedded HTML/JS/CSS, existing `fly.toml`. No Python, C/C++, Rust, SQL, or committed shell scripts in this tree.

**Headline mechanism:** This repository is a proposal-and-playground facade over an external compiler fork. The language change lives in `marcelocantos/go@decimal64`; this repo publishes a mutable `latest` toolchain tarball, documents the design, and runs a public `go run` playground. CI validates the *fork*, Docker consumes *whatever GitHub Release `latest` currently is*, and Fly deploys are not gated here. Those three artifacts can and do drift from each other and from the prose in `README.md` / `ROADMAP.md`.

**Highest-consequence findings:**

- **ENT-001 (P1):** The live playground at `https://go-decimal-proposal.fly.dev/` executes attacker-controlled Go with `exec.CommandContext(..., "go", "run", file)` as container root. The only containment is a 30s timeout and `CGO_ENABLED=0`.
- **ENT-002 (P1):** The published linux/amd64 toolchain is not a function of this repo's commit. CI clones the floating `decimal64` branch tip; the image `curl`s an unsigned, unchecked `.../releases/download/latest/...` tarball.

**Unverified residue:** Fly machine environment (metadata tokens, egress policy); whether `all.bash` passes on linux/amd64 in the fork; IEEE 754 `decTest` conformance (declared undone in `ROADMAP.md`); whether the live image matches the 2026-06-20 `latest` asset; contents of `marcelocantos/go` (out of scope).

## Scope and exclusions

**In scope:** every tracked file in this snapshot; GitHub Actions workflow definition and recent run metadata; GitHub repo/release/security settings; live HTTP GET `/` and POST `/api/run`; stock-Go build of `playground.go`.

**Named exclusions (not silent omissions):**

- `github.com/marcelocantos/go` `decimal64` branch — the actual compiler/runtime implementation (~129 files). Cited as an external source of truth; not audited.
- GitHub-hosted runner image and Fly.io platform internals.
- No generated, vendored, or snapshot trees exist in this repo.
- `tests/quantum_validate.go` is production-oracle code for a *custom* toolchain, not stock Go. It was compiled with `go1.26.4` only to prove it is not a stock-Go test.

## Commands run

| Command | Version / notes | Exit | Shipped vs auxiliary | Result / limitation |
|---|---|---|---|---|
| `git status --porcelain=v1 -b` | git 2.55.0 | 0 | n/a | Initial: `## t4-actions-node24...origin/t4-actions-node24`, no dirty files |
| `git rev-parse HEAD` | | 0 | n/a | `7f8604b1c319fb3bf8de8638cbf13950470979cc` |
| `git log --oneline -30`; `git ls-files`; `git log --stat -5` | | 0 | n/a | 5 first-parent commits on this branch; 8 tracked files |
| `go version` | go1.26.4 darwin/arm64 | 0 | auxiliary | Host toolchain, not the decimal fork |
| `gofmt -l playground.go tests/quantum_validate.go` | same | 0 | auxiliary | Empty (both files formatted) |
| `go build -o /tmp/go-decimal-playground-audit playground.go` | same | 0 | auxiliary | Stock Go can build the server (examples are strings) |
| `go vet playground.go` | same | 0 | auxiliary | Clean |
| `go build tests/quantum_validate.go` | same | 1 | auxiliary | `undefined: decimal64` / `math.Decimal64bits` — expected |
| `wc -l` of tracked text | | 0 | n/a | 567 + 122 + 1235 + 474 + 24 + 25 + 114 + 2 = 2563 |
| `gh repo view ... --json ...` | gh CLI | 0 | auxiliary | Public, `licenseInfo: null`, default branch `master`, `pushedAt: 2026-06-20` |
| `gh api .../branches/master/protection` | | 1 (HTTP 404) | auxiliary | `Branch not protected` |
| `gh api repos/... --jq '{security_and_analysis,...}'` | | 0 | auxiliary | Secret scanning + push protection enabled; Dependabot updates disabled |
| GitHub MCP `actions_list` workflow runs / jobs | | 0 | shipped-path metadata | Latest master run `27885089523` success; `make.bash` 21:57:43–22:00:07Z |
| GitHub MCP `get_release_by_tag` `latest` | | 0 | shipped artifact metadata | Mutable prerelease; asset `go-decimal-linux-amd64.tar.gz` 66 887 721 bytes, digest `sha256:50668e93…`, updated 2026-06-20T22:00:44Z |
| `~/.claude/skills/hygiene/hygiene_check.py` | uv-run script | 1 | auxiliary | `FileNotFoundError: .../hygiene.yaml` |
| `curl -sS https://go-decimal-proposal.fly.dev/` | | 0 HTTP 200 | **shipped** | 9661 bytes, HTML title `decimal64 playground`, 1.43s |
| `curl -X POST .../api/run` with `decimal64(0.1)+decimal64(0.2)` | | 0 HTTP 200 | **shipped** | `{"output":"0.3\n"}` in 7.42s |
| `git fetch origin --prune` | | 0 | n/a | Evidence only. `origin/master` → `d34cb20`; `origin/t4-actions-node24` deleted. HEAD unchanged |

Unavailable / not run (residue, not simulated):

- Custom decimal `GOROOT` is not on this host, so `tests/quantum_validate.go` was not executed here. Last green execution observed is CI job `82519065483` step “Run quantum validation tests”.
- `docker build` / `fly deploy` not run (would pull the live `latest` tarball; out of scope for a read-only audit).
- No clone detector, coverage tool, or `govulncheck` is declared; none was installed.
- Code scanning alerts: GitHub API `404 no analysis found`. Dependabot alerts API `403` (disabled).

## Observed architecture

```
README.md + ROADMAP.md          proposal prose (human-facing source of truth)
        |
        |  (no mechanical link)
        v
.github/workflows/build.yml  --clone floating-->  github.com/marcelocantos/go@decimal64
        |  make.bash + quantum_validate + strconv/fmt/math -run Decimal
        |  tar + GitHub Release tag_name: latest  (mutated on master push)
        v
Dockerfile  --curl unsigned latest tarball-->  playground binary + full GOROOT
        v
fly.toml  -->  https://go-decimal-proposal.fly.dev/   (manual deploy; not in CI)
```

**Entry points**

| Surface | Path | Notes |
|---|---|---|
| HTTP UI | `playground.go:144` `GET /` | Serves embedded `indexHTML` |
| HTTP API | `playground.go:145` `POST /api/run` | Writes body to a temp `.go` file and `go run`s it |
| CI | `.github/workflows/build.yml` | `push`/`pull_request` to `master`, `workflow_dispatch` |
| Release | same file, job `release` | `contents: write`; only on push / dispatch |
| Deploy | `fly.toml` + `Dockerfile` | Not invoked from this repo’s CI |
| Validator | `tests/quantum_validate.go` | `package main`; run with the fork’s `go` |

**Declared vs observed rules**

- **Agree:** This repo is a proposal + playground, not the compiler. Implementation is the external fork (`README.md:980–984`). CI really does `make.bash` on `ubuntu-latest`. Playground really does execute decimal syntax (live `0.3` result).
- **Inferred from code:** Docker/Fly are the production path for the playground; CI is a toolchain factory. Action versions on this snapshot are Node-24 majors (`checkout@v6`, `setup-go@v6`, `upload-artifact@v7`, `download-artifact@v8`); GitHub `master` already contains the squash of that change.
- **Contradictions:** `README.md:991–995` and `ROADMAP.md:11–18` still say Linux bootstrap is unverified. CI run `27885089523` executed `./make.bash` successfully in ~144s. That is not `all.bash`. `README.md:1172` still says “124 files” after a commit that claimed to update three occurrences to 129. `html/template` remains in the stdlib list after being called test-only.
- **Unknown intent:** Whether Fly deploys are deliberately manual; whether `latest` is meant to track the fork tip rather than this repo; whether the playground is accepted as an unsandboxed demo.

No in-repo import graph exists (two `package main` files, no modules). There is no cycle to report. The architectural coupling is **cross-repo and cross-artifact**, not Go imports.

## Dimension vector

| Dimension | State | Evidence summary | Change from baseline |
|---|---|---|---|
| Architecture topology | concern | Clear two-file Go surface, but the live product depends on an unpinned external fork and a mutable GitHub release | n/a (first full audit) |
| Redundancy / sources of truth | concern | Proposal stats, `html/template` scope, example snippets, git tag `latest` vs GitHub Release `latest` vs fork HEAD | n/a |
| Change amplification | concern | Example edits must be repeated in README and `playground.go`; a fork-only change republishes the playground’s compiler without a commit here | n/a |
| Local code quality | concern | `gofmt`/`vet` clean and small, but the one server discards errors and has no request/process jail | n/a |
| Correctness / verification | concern | Fork `make.bash` + three package filters + quantum harness are green in CI; playground and image have no CI oracle | n/a |
| Security / dependencies | concern | Public unsandboxed `go run` as root; unpinned clone and tarball; no branch protection; Dependabot off. Secret scanning + push protection on | n/a |
| Build / release / operations | concern | Mutable `latest` tarball, no image/digest pin, no Fly deploy job, no `go.mod` | n/a |
| Documentation / governance | concern | Strong proposal/roadmap prose; leftover “124 files”; Linux claim stale; no LICENSE; hygiene undeclared | n/a |

No scalar score.

## Findings

### ENT-001: Public playground executes untrusted Go unsandboxed as root

- **Priority:** P1
- **Dimensions:** Security / dependencies; Local code quality; Architecture topology
- **Status:** observed fact (exec path, missing USER, live service); inference that the process is root (Debian default, no `USER`)
- **Evidence:**
  - `playground.go:109–118` — `exec.CommandContext(ctx, goBin, "run", f.Name())` on `req.Code` after `os.CreateTemp` + `WriteString`
  - `playground.go:85–88` — JSON body decoded with no `http.MaxBytesReader`
  - `playground.go:47` — 30s timeout is the only kill switch
  - `playground.go:149` — `http.ListenAndServe(listenAddr, nil)` (default mux, no timeouts)
  - `Dockerfile:18–24` — runtime stage copies `/decimal-go` and `/playground`; no `USER`
  - Live `POST https://go-decimal-proposal.fly.dev/api/run` returned `0.3\n` (this audit)
  - `README.md:42` advertises the playground
- **Mechanism:** Any client can compile and run arbitrary Go with the container’s network, filesystem, and privileges. `CommandContext` cancels the child, not reparented descendants. Combined with ENT-006, a client can also exhaust the 1 GB VM via huge source or `CombinedOutput`.
- **Blast radius:** The Fly machine (`fly.toml:22–25`, 1 shared CPU / 1 GB), its egress, and any credentials present in that environment. Not the GitHub repo contents, unless the VM holds deploy tokens (unverified).
- **Counterevidence checked:** `CGO_ENABLED=0`; 30s timeout; Fly `force_https`; `auto_stop_machines`; isolated VM; output rendered with `textContent` (`playground.go:548–553`) so stored XSS of compiler output is unlikely; examples injected via `json.Marshal` (`playground.go:138–140`). The official Go playground uses a dedicated sandbox precisely because this shape is unsafe.
- **Smallest coherent remediation:** Run user programs in a non-root, no-network, rlimited jail (gVisor/nsjail/Firecracker-within, or Fly’s isolated-process model) with a cgroup memory cap. Fail closed if the jail cannot start. Keep the 30s timeout as a backstop, not the control.
- **Verification:** A CI/journey POST of a program that dials the network or writes outside the temp dir must fail. A benign `0.1+0.2` POST must still return `0.3`.
- **Ratchet candidate:** Command evidence: `go test` (once a harness exists) or a documented Fly/process policy file; later a `hygiene.yaml` `security.playground-sandbox` item.

### ENT-002: Toolchain identity is a floating branch tip plus a mutated `latest` tarball

- **Priority:** P1
- **Dimensions:** Security / dependencies; Build / release / operations; Change amplification
- **Status:** observed fact
- **Evidence:**
  - `.github/workflows/build.yml:25–28` — `git clone --depth 1 --branch decimal64 https://github.com/marcelocantos/go.git` (no SHA)
  - `.github/workflows/build.yml:76–82` — tarball of that clone’s `bin/ src/ pkg/ ...`
  - `.github/workflows/build.yml:104–114` — `softprops/action-gh-release@v2` with `tag_name: latest` on every master push / dispatch
  - `Dockerfile:7–9` — `curl -fsSL .../releases/download/latest/go-decimal-linux-amd64.tar.gz | tar xz` with no checksum
  - GitHub Release `latest` `immutable: false`, asset digest `sha256:50668e932e3874ec211f26edf217ae69241a1ac733fad243be0e2cf1b45799bf` **not consumed by Docker**
  - Local git tag `latest` = `df664243af81d7c1774acd71dc5a32b9d7b20036`, **not an ancestor of `master`** (`git merge-base --is-ancestor latest master` exited 1)
- **Mechanism:** Two builds of the same proposal-repo SHA can emit different compilers. Docker/Fly can boot a compiler that this commit never saw. A push to the *fork* (or a compromised `decimal64` tip) becomes the next playground toolchain without a reviewable pin here. The git tag named `latest` and the GitHub Release named `latest` already disagree.
- **Blast radius:** Every consumer of the tarball (Dockerfile, anyone downloading the release) and the live playground after the next `fly deploy`.
- **Counterevidence checked:** HTTPS to GitHub; release job gated off pull requests (`build.yml:93`); asset digest now exists on the release API but is unused; v0.1.0 / v0.2.0 tags exist but Docker does not pin them. Mutating `latest` is convenient for a demo, not an accidental extra tag.
- **Smallest coherent remediation:** Pin the clone to a SHA recorded in this repo. Write that SHA and a SHA256 of the tarball next to the workflow. Have Docker `COPY` or `curl` and `sha256sum -c` that digest. Stop treating the git tag `latest` as history; use a moving GitHub Release *or* a git tag, not both.
- **Verification:** Re-running CI on the same commit must clone the same fork SHA and produce the same tarball digest. A Dockerfile build must fail if the digest mismatches.
- **Ratchet candidate:** `file:` evidence for a `toolchain.lock` (SHA + sha256); CI step name that records `git rev-parse HEAD` of the clone.

### ENT-003: CI never builds the playground, the image, or a deploy

- **Priority:** P2
- **Dimensions:** Correctness / verification; Build / release / operations
- **Status:** observed fact
- **Evidence:**
  - `.github/workflows/build.yml` steps: checkout, setup-go 1.25, clone fork, `make.bash`, `go run tests/quantum_validate.go`, `go test` strconv/fmt/math `-run Decimal`, tar, upload. No `go build playground.go`, no `gofmt`/`vet`, no `docker build`, no `flyctl`.
  - `Dockerfile:14–15` is the only compile of `playground.go`, and it happens at image-build time on Fly, not in CI.
  - This audit’s `go build playground.go` and live GET/POST succeeded, but those are not standing gates.
- **Mechanism:** A broken `handleRun`, a `Sprintf` verb mistake in `indexHTML`, or a Dockerfile curl failure only shows up at deploy or in production. CI can be green on a commit that cannot boot the advertised playground.
- **Blast radius:** The owner-visible product (`README.md:42`, live host). Proposal prose is unaffected.
- **Counterevidence checked:** CI *does* exercise the compiler the playground needs (quantum + stdlib Decimal tests). That is a real oracle for the fork, not for this server. Live probe this audit: GET 200, POST `0.3\n`.
- **Smallest coherent remediation:** Add a CI job on stock Go: `gofmt -l`, `go vet`, `go build` of `playground.go`. Optionally `docker build` (after ENT-002 pin) without deploy.
- **Verification:** A syntax error in `playground.go` must fail CI. Today it would not.
- **Ratchet candidate:** `ci_step: {workflow: build.yml, name: Build playground}` once added; `command: go build playground.go`.

### ENT-004: Docs still claim Linux bootstrap is unverified; CI already runs `make.bash` on linux/amd64

- **Priority:** P2
- **Dimensions:** Documentation / governance; Redundancy / sources of truth
- **Status:** observed fact for the contradiction; inference that authors meant `all.bash` / a native self-hosted check, not GHA `make.bash`
- **Evidence:**
  - `README.md:991–995` — “has not yet been built or tested on Linux (linux/amd64)”
  - `ROADMAP.md:11–20` — “Linux bootstrap ICE — *not yet verified*”; “Native Linux bootstrap has not yet been re-tested”; work item is `make.bash` **and** `all.bash`
  - `ROADMAP.md:449` — “Mostly done — Linux bootstrap not yet verified”
  - `.github/workflows/build.yml:30–35` — `./make.bash` on `ubuntu-latest`
  - GitHub Actions job `82519065483` step “Build toolchain from source” succeeded 2026-06-20T21:57:43Z–22:00:07Z (~144s)
  - `Dockerfile:1–2` already states the toolchain is “Built from source on linux/amd64 via GitHub Actions”
- **Mechanism:** Reviewers of #19787 can discount the implementation as unported while the proposal repo’s own CI has been bootstrapping on Linux. The remaining honest gap (`all.bash`, not `make.bash`) is hidden behind an over-broad “not verified”.
- **Blast radius:** Proposal credibility; ROADMAP Phase 0 sequencing.
- **Counterevidence checked:** CI is not `all.bash`. 144s is consistent with `make.bash` + `CGO_ENABLED=0` on a GitHub runner, not a full `all.bash`. macOS `all.bash` claims in README were not re-run here (fork out of scope).
- **Smallest coherent remediation:** Split the claim: “CI `make.bash` on linux/amd64: passing as of \<run URL\>”; “`all.bash` on linux/amd64: not run.” Keep Phase 0 open only for `all.bash`.
- **Verification:** A grep/test that fails if README contains “has not yet been built or tested on Linux” while `build.yml` still invokes `make.bash`.
- **Ratchet candidate:** Manual attestation with `last_verified` pointing at a CI run URL, or delete the stale sentence.

### ENT-005: Proposal stats, stdlib scope, and examples have more than one owner

- **Priority:** P2
- **Dimensions:** Redundancy / sources of truth; Change amplification; Documentation / governance
- **Status:** observed fact
- **Evidence:**
  - File count: `README.md:108`, `README.md:167`, `README.md:986` say **129** files; `README.md:1172` still says **124** files. Commit `e2421b7` claimed “File count: 124 → 129 (3 occurrences in README)” and missed Open issues item 6.
  - `html/template`: `e2421b7` message says “remove html/template (test-only)”; `README.md:660–661` and `ROADMAP.md:129`, `ROADMAP.md:322` still list it as in-scope.
  - Examples: invoice / currency / 0.1+0.2 / quantum snippets exist in both `README.md:786–855` and `playground.go:157–288`. Playground invoice omitted expected-output comments (intentional, commit `b569599`); playground quantum adds an extra addition demo not in README.
  - Header `README.md:7` “Last updated: 2026-02-28” despite later stats and CI commits.
- **Mechanism:** The next example or package-list edit has to be made in two (sometimes three) places. The 124/129 miss shows that process already failed once. Fork file counts cannot be derived from this repo, so the numbers will rot again unless they are generated or dropped.
- **Blast radius:** Proposal readers and playground users seeing different programs; Go team reviewers using stale scope.
- **Counterevidence checked:** Slight example divergence is partly deliberate (no spoilers). Stats cannot be mechanically true without querying the fork. ROADMAP CL table (`ROADMAP.md:114`, ~12 150 lines) is a planning estimate, not a second file count.
- **Smallest coherent remediation:** One occurrence of the file/line/package counts, or a script that greps the fork. Single-source examples (generate README fences from `playground.go`, or the reverse). Fix the leftover “124” now.
- **Verification:** `rg '124 files' README.md` empty; a test that playground example N’s source is a substring of README or a shared testdata file.
- **Ratchet candidate:** `command:` grep that forbids `124 files`; later a golden-file test for examples.

### ENT-006: Playground HTTP server has no body, output, or header timeouts

- **Priority:** P2
- **Dimensions:** Security / dependencies; Build / release / operations
- **Status:** observed fact
- **Evidence:**
  - `playground.go:85` — `json.NewDecoder(r.Body).Decode` with no `MaxBytesReader`
  - `playground.go:118` — `cmd.CombinedOutput()` unbounded
  - `playground.go:149` — `ListenAndServe` without `ReadHeaderTimeout` / `WriteTimeout`
  - `fly.toml:23` — VM memory `"1gb"`
- **Mechanism:** Independent of code-execution unsafety (ENT-001), a client can Slowloris the default server or force a multi-hundred-MB compile/output and OOM the machine. `min_machines_running = 0` plus `auto_start_machines` (`fly.toml:11–13`) turns that into a wake-and-kill loop.
- **Blast radius:** Availability of the advertised playground; Fly bill.
- **Counterevidence checked:** 30s run timeout bounds *CPU time of `go run`*, not request size or hung headers. `force_https` does not help.
- **Smallest coherent remediation:** `http.Server{ReadHeaderTimeout, WriteTimeout}`; `http.MaxBytesReader` on `/api/run` (e.g. 64KiB source); cap combined output before JSON encode; optional Fly concurrency limit.
- **Verification:** POST a 10MiB body must 413; a Slowloris-style test against a local server must time out the connection, not the process.
- **Ratchet candidate:** Once tests exist, `command: go test` covering MaxBytes; or a review checklist. Not yet mechanically present.

### ENT-007: Public repo has no LICENSE, module, gitignore, or hygiene declaration

- **Priority:** P3
- **Dimensions:** Documentation / governance; Build / release / operations
- **Status:** observed fact
- **Evidence:**
  - `git ls-files` — 8 paths, none of `LICENSE`, `go.mod`, `.gitignore`, `hygiene.yaml`, `AGENTS.md`
  - `gh repo view` `licenseInfo: null`
  - `README.md:33–40` and `README.md:1167–1196` discuss contributing the implementation to the Go project (CLA / AI-generated code), while this wrapper repo itself is unlicensed
  - `go build playground.go` succeeded as a file-list compile (GO111MODULE file mode), so missing `go.mod` is survivable but unpinned
- **Mechanism:** No SPDX license on a public proposal intended for `golang/proposal`. No `go` version pin for the server. No `.gitignore` for an in-tree `go build` binary. No `hygiene.yaml` means fleet hygiene cannot see this repo (see Hygiene posture).
- **Blast radius:** Legal reuse of the proposal text and playground; low operational risk.
- **Counterevidence checked:** Secret scanning and push protection are on. Single collaborator `marcelocantos`. Proposal text may be rewritten for Gerrit anyway (`ROADMAP.md:468–474`).
- **Smallest coherent remediation:** Add a LICENSE matching the author’s intent; a one-line `go.mod`; `.gitignore` for binaries; declare `hygiene.yaml` only if the owner wants a floor (do not invent one in this audit).
- **Verification:** `gh api ... --jq .license` non-null; `go list -m` succeeds.
- **Ratchet candidate:** `file: {path: LICENSE}`; `file: {path: go.mod}`.

### ENT-008: Discarded errors, hardcoded pass count, and hand-decoded BID fields

- **Priority:** P3
- **Dimensions:** Local code quality; Correctness / verification
- **Status:** observed fact
- **Evidence:**
  - `playground.go:35` — `os.MkdirAll` error ignored
  - `playground.go:60`, `73` — warmup `WriteString` / `CombinedOutput` ignored
  - `playground.go:132` — `json.NewEncoder(w).Encode` error ignored
  - `playground.go:138` — `json.Marshal(examples)` error ignored (cannot fail for this literal, but the pattern is load-bearing for HTML generation)
  - `tests/quantum_validate.go:121` — `fmt.Printf("\nall %d tests passed\n", 18)` independent of how many `check()` calls ran
  - `tests/quantum_validate.go:51–52` — exponent/coefficient decoded with magic `>>53`, `0x3FF`, bias `398`, instead of a named API
  - `tests/quantum_validate.go:1–4` vs `package main` — comment says “Package tests”
- **Mechanism:** Warmup failure is silent (first user pays cold compile or gets a confusing error). Adding a `check()` without updating `18` lies on success. BID bit-field math will silently pass the wrong encoding if the small-coefficient form is not used.
- **Blast radius:** Operator debugging; quantum oracle honesty. Not the compiler.
- **Counterevidence checked:** The 18 checks currently match the `check(` call count (18). The BID decode is used only for `1.50*1.20 = 1.8000`, which is the small-coefficient encoding. `gofmt`/`vet` clean.
- **Smallest coherent remediation:** Check `MkdirAll`; log warmup errors; derive pass count from the counter; use `math` helpers if the fork exports them, otherwise name the masks.
- **Verification:** `gofmt` already green; a unit test that `check` count == printed total, or delete the constant.
- **Ratchet candidate:** `command: gofmt -l` once CI builds this repo; not a security ratchet.

### ENT-009: Git tag `latest` is a historical island; GitHub Release `latest` moves

- **Priority:** P3
- **Dimensions:** Redundancy / sources of truth; Build / release / operations
- **Status:** observed fact
- **Evidence:**
  - `git show-ref --tags`: `refs/tags/latest` → `df66424` (“Mark math decimal tests as non-blocking in CI”)
  - `git merge-base --is-ancestor latest master` → exit 1
  - GitHub Release `latest` `target_commitish: master`, `updated_at: 2026-06-20T22:00:44Z`
  - First-parent `master` history on this clone does not contain `df66424` (history rewrite / squash around the initial import)
- **Mechanism:** `git checkout latest` does not yield the toolchain Docker installs. Operators can “pin” the wrong object.
- **Blast radius:** Humans and scripts that treat git tags as release identity.
- **Counterevidence checked:** `action-gh-release` updating a floating GitHub Release named `latest` is an established (if discouraged) pattern; the git tag left behind is the defect.
- **Smallest coherent remediation:** Delete the stale git tag or retarget it when the release moves; document that only the GitHub Release is authoritative (after ENT-002).
- **Verification:** `git merge-base --is-ancestor $(git rev-parse latest) origin/master` or no `latest` git tag.
- **Ratchet candidate:** Absent git tag `latest`, or a CI check that `git rev-parse latest` equals the release target.

## Redundancy and competing-source-of-truth inventory

| Fact | Owners | Drift already seen? |
|---|---|---|
| Compiler source | `marcelocantos/go@decimal64` HEAD (unpinned) | Every CI run by design |
| Published toolchain | GitHub Release `latest` asset | Yes; updated 2026-06-20; git tag `latest` elsewhere |
| Playground compiler | Docker `curl` of that asset at image build; Fly deploy time | Unverified vs current Dockerfile |
| Implementation size | README (129 vs leftover 124); ROADMAP ~12 150 CL lines; fork tree | Yes (`124` leftover) |
| `html/template` in stdlib work | README “Standard library additions”; ROADMAP CL 12; commit `e2421b7` | Yes |
| Demo programs | README examples; `playground.go` `var examples` | Partial (spoilers / extra quantum demo) |
| Linux bootstrap status | README/ROADMAP prose vs `build.yml` `make.bash` vs Dockerfile comment | Yes |
| Action versions | this snapshot `@v6/@v7/@v8`; local `master` still `@v4/@v5` until pulled; GitHub `origin/master` already squash-merged | Operational, not dual source in one tree |

Deliberate duplication: quantum properties appear in both `tests/quantum_validate.go` and README/playground as *illustrations*. The test is the oracle; the docs are not. That split is healthy if README does not invent extra numeric claims (the `1.50*1.20=1.8000` claim is shared and consistent).

## Healthy structure worth retaining

- **Facade vs implementation.** Keeping the 12k-line compiler in `marcelocantos/go` and this repo as proposal + demo is the right grain. Do not import the fork into this tree.
- **CI actually bootstraps a compiler.** `make.bash` + `tests/quantum_validate.go` + `go test ./strconv|fmt|math/ -run Decimal` on linux/amd64 is a real shipped-path oracle for the *language change*, and it has been green (run `27885089523`).
- **Quantum harness is property-oriented.** `tests/quantum_validate.go` checks literals, mul/add/div/sub quantum, widening, named constants, NaN/Inf bits, and a BID coefficient — not “it compiled”.
- **Release job is not on pull_request.** `build.yml:93` prevents PR authors from mutating `latest`.
- **Playground UI output is `textContent`.** Compiler stdout is not `innerHTML`. Example JSON is `encoding/json` into a `<script>` via `%s` with CSS `%` escaped as `50%%` (`playground.go:444`, `478`).
- **`gofmt` / `go vet` clean** on `playground.go`. Stock Go builds the server because decimal types appear only in string examples.
- **Secret scanning and push protection** enabled. No secrets in the tracked tree.
- **Honest AI disclosure** (`README.md:33–40`, `1167–1196`) and a concrete ROADMAP. That is better governance than a silent generated dump.
- **Live path works.** GET `/` 200; POST `/api/run` `0.1+0.2` → `0.3\n` on 2026-08-22.

## Hygiene posture

`hygiene.yaml` is **absent**. Hygiene posture is **not declared**. It was not initialized.

Validator invocation (mandatory explicit run):

```
/Users/marcelo/.claude/skills/hygiene/hygiene_check.py
```

Exit 1. Full output:

```
Traceback (most recent call last):
  File "/Users/marcelo/.claude/skills/hygiene/hygiene_check.py", line 331, in <module>
    sys.exit(main())
  File "/Users/marcelo/.claude/skills/hygiene/hygiene_check.py", line 283, in main
    rep = check_repo(root, doc_path)
  File "/Users/marcelo/.claude/skills/hygiene/hygiene_check.py", line 237, in check_repo
    doc = yaml.safe_load(doc_path.read_text())
  ...
FileNotFoundError: [Errno 2] No such file or directory: '/Users/marcelo/work/github.com/marcelocantos/go-decimal-proposal/hygiene.yaml'
```

No per-dimension held tiers or floors exist to report. Observed reality that a future declaration would have to encode honestly (not created here):

| Dimension | What exists | Gap |
|---|---|---|
| correctness | CI `make.bash` + quantum + Decimal tests (fork) | No playground test; quantum not `go test` |
| security | secret scanning, push protection, HTTPS on Fly | Unsandboxed `go run`; no Dependabot; no code scanning |
| quality | gofmt-clean sources | Not enforced in CI |
| build | GHA toolchain factory | No `go.mod`; Docker unpinned |
| release | mutable `latest` prerelease | No versioned, digest-pinned deploy |
| docs | README + ROADMAP | No LICENSE; stale Linux/124 claims |
| governance | single owner, no branch protection | — |

Overlap: ENT-001/002/003 are structural (entropy). Hygiene, if onboarded later, should only *ratchet* the oracles listed on those findings, not duplicate the prose.

## Oracle coverage and residue

| Property | Decided by | Notes |
|---|---|---|
| `playground.go` formats and typechecks | Auxiliary `gofmt`/`vet`/`go build` this audit | Not in CI |
| Playground serves HTML | Shipped live GET 200 | Not in CI |
| Decimal `0.1+0.2` in the playground | Shipped live POST → `0.3\n` | One-off audit probe, not a journey gate |
| Literal/arithmetic quantum | CI `go run tests/quantum_validate.go` with fork `GOROOT` | Cannot run with stock Go |
| strconv/fmt/math decimal APIs | CI `go test -run Decimal` in the fork | Filter, not the whole package |
| linux/amd64 `make.bash` | CI step on `ubuntu-latest` | Green 2026-06-20 |
| linux/amd64 `all.bash` | Nothing | ROADMAP Phase 0 |
| IEEE 754 `decTest` | Nothing in this repo | ROADMAP Phase 1; lives in the fork |
| Playground sandbox / non-root | Nothing | ENT-001 |
| Tarball digest / fork SHA | Release API has digest; unused | ENT-002 |
| Docker image = CI tarball | Nothing | Manual Fly deploy |
| License / module identity | Nothing | ENT-007 |

**Failed / skipped checks:** stock `go build` of `tests/quantum_validate.go` (expected fail); hygiene validator (no yaml); branch-protection API 404; code-scanning 404; Dependabot 403.

**Owner residue (intent only):**

- Is the playground an accepted unsandboxed demo, or does it need a jail before it stays public?
- Should `latest` track the fork tip forever, or should this repo pin SHAs?
- Are Fly deploys deliberately manual?
- Should `html/template` be documented as in-scope or test-only?
- What license covers *this* repo versus the Go fork?

Mechanical work (pins, LICENSE, CI `go build`, README 124/Linux edits) is not owner residue.

## Remediation sequence

1. **Security seam for the only internet process.** Jail or non-root + no-network + memory limit for `go run` (ENT-001), then body/timeouts (ENT-006). Re-probe live `0.1+0.2`.
2. **Make the toolchain a function of a recorded SHA + digest** (ENT-002). Point Docker at that digest. Retire or retarget git tag `latest` (ENT-009).
3. **Gate the facade.** CI `gofmt`/`vet`/`go build playground.go` (ENT-003). Do not claim the playground is tested until that job exists.
4. **Converge prose with CI.** Rewrite the Linux bootstrap sentence; fix “124 files”; decide `html/template` (ENT-004, ENT-005).
5. **Governance floor when wanted.** LICENSE, `go.mod`, `.gitignore` (ENT-007). Hygiene.yaml only on explicit onboard; floors must match the table above, not aspirational sandboxing.
6. **Local nits** (ENT-008) after the gates exist, so they cannot regress silently.
7. **Re-run this audit** on the same finding IDs and the same live POST.

No architectural rewrite of the two-repo split is required.
