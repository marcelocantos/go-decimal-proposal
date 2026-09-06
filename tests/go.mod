// Its own module so the root module's ./... does not try to build a
// program that only compiles under the decimal64 toolchain.
module github.com/marcelocantos/go-decimal-proposal/tests

go 1.25
