# Pre-built Go toolchain with decimal64/decimal128 support.
# Cross-compiled from darwin/arm64 to avoid linux/amd64 compiler bootstrap bugs.
FROM debian:bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Download and unpack the pre-built toolchain
RUN mkdir -p /decimal-go \
    && curl -fsSL https://github.com/marcelocantos/go-decimal-proposal/releases/download/v0.2.0/go-decimal-linux-amd64.tar.gz \
    | tar xz -C /decimal-go \
    && mv /decimal-go/bin/linux_amd64/* /decimal-go/bin/ \
    && rmdir /decimal-go/bin/linux_amd64
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
