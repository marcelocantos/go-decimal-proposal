# Stage 1: Build the decimal Go toolchain
FROM golang:1.26 AS toolchain
RUN git clone --branch decimal64 --depth 1 https://github.com/marcelocantos/go.git /decimal-go
WORKDIR /decimal-go/src
RUN CGO_ENABLED=0 GOROOT_BOOTSTRAP=/usr/local/go ./make.bash

# Stage 2: Build the playground server using the decimal toolchain
FROM toolchain AS builder
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH
COPY playground.go /app/playground.go
WORKDIR /app
RUN CGO_ENABLED=0 go build -o /playground playground.go

# Stage 3: Minimal runtime image
FROM debian:bookworm-slim
COPY --from=toolchain /decimal-go /decimal-go
COPY --from=builder /playground /playground
ENV GOROOT=/decimal-go
ENV PATH=/decimal-go/bin:$PATH
EXPOSE 8080
CMD ["/playground"]
