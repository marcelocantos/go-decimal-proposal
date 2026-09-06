# Pre-built Go toolchain with decimal64/decimal128 support.
# Built from source on linux/amd64 via GitHub Actions.
FROM debian:bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Download and unpack the pre-built toolchain
RUN mkdir -p /decimal-go \
    && curl -fsSL https://github.com/marcelocantos/go-decimal-proposal/releases/download/latest/go-decimal-linux-amd64.tar.gz \
    | tar xz -C /decimal-go
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH

# Build the playground server. The server is several files now (the
# request controls and the process sandbox are their own units), so this
# copies the module rather than a single file.
WORKDIR /app
COPY go.mod ./
COPY *.go ./
RUN GOTOOLCHAIN=local GOEXPERIMENT='' CGO_ENABLED=0 /decimal-go/bin/go build -o /playground .

# Minimal runtime image
FROM debian:bookworm-slim
COPY --from=base /decimal-go /decimal-go
COPY --from=base /playground /playground
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH

# The server compiles and runs code submitted by strangers. Running that
# as root means a container escape, a kernel bug, or any writable path
# under / is reachable with full privilege; an unprivileged uid is the
# cheapest reduction available and costs nothing, because neither the
# server nor the toolchain needs root.
#
# The uid owns only its own scratch: /decimal-go and /playground stay
# root-owned and read-only to it, so a submitted program cannot rewrite
# the compiler it will be compiled by on the next request.
RUN useradd --system --create-home --home-dir /home/play --shell /usr/sbin/nologin play \
    && chown -R play:play /home/play
USER play
# The server derives its build cache from os.TempDir(), so pointing
# TMPDIR at the uid's own home is what keeps both the cache and the
# per-request scratch directories inside the one writable tree.
ENV HOME=/home/play
ENV TMPDIR=/home/play

EXPOSE 8080
CMD ["/playground"]
