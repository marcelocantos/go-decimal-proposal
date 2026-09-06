# Playground security posture

The playground compiles and runs Go source submitted over HTTP. That is
the product, so the question is never "is this safe" but "what exactly is
contained, and what is not". This document is the answer. It is meant to
be read before changing `sandbox.go` or `config.go`, and before deciding
how to expose the service.

**A partial sandbox described as a sandbox is worse than none**, because
it invites exposure decisions the containment cannot support. What
follows separates what is enforced from what is not.

## Threat model

The attacker can POST arbitrary Go source to `/api/run`, as many times as
the server will accept, and read the combined output. Their goals, in
descending order of damage:

1. Read the host's secrets (deployment tokens, API keys).
2. Execute with privilege — as root, or escaping the container.
3. Reach the network from inside the deployment's trust boundary.
4. Persist: modify the toolchain or the server so later requests are
   compromised too.
5. Deny service: exhaust CPU, memory, disk, or process slots.

## What is enforced

| Property | Mechanism | Where |
|---|---|---|
| Not reachable without a shared secret | `X-Playground-Token`, compared in constant time over SHA-256 digests | `config.go` `requireAuth` |
| Disabled by default | No token and no explicit opt-in means `/api/run` returns 503 | `config.go` `loadConfig` |
| Host secrets not visible to submitted code | Environment allowlist, not the process environment | `sandbox.go` `childEnv` |
| Not running as root | Dedicated unprivileged uid; the toolchain and server binary stay root-owned and read-only to it | `Dockerfile` |
| Bounded wall time | 30s context, whole process group killed | `playground.go`, `sandbox.go` `killGroup` |
| Bounded CPU time | `RLIMIT_CPU` | `sandbox.go` `applyLimits` |
| Bounded file writes | `RLIMIT_FSIZE` | same |
| Bounded processes | `RLIMIT_NPROC` (Linux) | same |
| Bounded memory | `RLIMIT_AS` (Linux) | same |
| Bounded request size | `http.MaxBytesReader`, 64 KB | `playground.go` |
| Bounded output | 256 KB cap | `sandbox.go` `cappedWriter` |
| Bounded concurrency | 2 in-flight runs, then load shedding | `playground.go` |
| Slowloris resistance | Explicit server read/write/idle timeouts | `playground.go` |

The limits are applied by re-execing this binary as `--exec-limited`,
which calls `setrlimit` on itself and then `execve`s the toolchain: Go
cannot set a child's rlimits directly, and limits survive `execve`.

## What is NOT enforced

These are open. Do not describe this service as sandboxed.

- **No filesystem isolation.** A submitted program can read any file the
  `play` uid can read — which on a stock Debian image is most of `/etc`,
  every binary, and the toolchain itself. It cannot write to the
  toolchain or the server binary (root-owned), and its own scratch
  directory is removed after the run, but it is not confined to that
  directory.
- **No network isolation.** A submitted program can open outbound
  connections: to the internet, and to anything else reachable from
  inside the deployment's network. On a platform with a private network
  between apps, that reach is the private network. This is the largest
  remaining hole.
- **No syscall filtering.** No seccomp profile. A kernel vulnerability
  reachable by syscall is reachable from submitted code.
- **No protection against a malicious toolchain.** The image downloads
  the toolchain from a mutable `latest` release tag over HTTPS with no
  checksum. Whoever can publish that release controls what every
  subsequent request executes. Tracked separately from this document.
- **Nothing rate-limits a valid token.** The concurrency cap sheds load,
  but a holder of the token can submit continuously.

## Closing the two large holes

Filesystem and network isolation need namespaces, which this process
cannot create for itself once it has dropped privilege. The hook is
`PLAYGROUND_SANDBOX_CMD`: an argv prefix that the compile-and-run command
is executed through, placed outermost so it wraps everything else.

With `nsjail` or `bubblewrap` in the image, a configuration that mounts a
read-only view of the toolchain, gives the program a private empty
`/tmp`, and puts it in an empty network namespace closes both. That work
is not done here, and until it is, the honest description of this service
is "authenticated code execution with resource limits", not "a sandbox".

## Deployment guidance

- Set `PLAYGROUND_AUTH_TOKEN` to a high-entropy secret. Rotate it by
  changing the value; there is no revocation list because there is one
  credential.
- `PLAYGROUND_ALLOW_ANONYMOUS=1` re-opens the endpoint to the whole
  internet. Given the two holes above, do not set it on a deployment that
  shares a network with anything else, or that holds any secret.
- Prefer running it on a machine with nothing else on its network and no
  secrets in its environment, so that the unenforced properties matter
  less.
