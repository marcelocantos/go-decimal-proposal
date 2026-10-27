# Pre-built Go toolchain with decimal64/decimal128 support.
# Built from source on linux/amd64 via GitHub Actions.
FROM debian:bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Download and unpack the pre-built toolchain. The digest is the one
# recorded in toolchain.lock — a mutated `latest` tarball must fail closed.
COPY toolchain.lock /tmp/toolchain.lock
RUN mkdir -p /decimal-go \
    && curl -fsSL https://github.com/marcelocantos/go-decimal-proposal/releases/download/latest/go-decimal-linux-amd64.tar.gz \
      -o /tmp/go-decimal-linux-amd64.tar.gz \
    && awk -F= '/^tarball_sha256=/{print $2 "  /tmp/go-decimal-linux-amd64.tar.gz"}' /tmp/toolchain.lock \
      | sha256sum -c \
    && tar xz -C /decimal-go -f /tmp/go-decimal-linux-amd64.tar.gz \
    && rm /tmp/go-decimal-linux-amd64.tar.gz /tmp/toolchain.lock
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH

# Build the playground server
COPY playground.go /app/playground.go
RUN GOTOOLCHAIN=local GOEXPERIMENT='' CGO_ENABLED=0 /decimal-go/bin/go build -o /playground /app/playground.go

# Minimal runtime image
FROM debian:bookworm-slim
COPY --from=base /decimal-go /decimal-go
COPY --from=base /playground /playground
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH
EXPOSE 8080
CMD ["/playground"]
