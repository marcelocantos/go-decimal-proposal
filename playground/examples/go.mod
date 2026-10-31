// Its own module so the root module's ./... does not try to build
// programs that only compile under the decimal toolchain. Each file is a
// separate main program, run on its own (go run hello.go).
module github.com/marcelocantos/go-decimal-proposal/playground/examples

go 1.25
