// Its own module so the root module's ./... does not try to build
// programs that only compile under the decimal toolchain. Each file is a
// separate main program, run on its own (go run hello.go).
module github.com/marcelocantos/go-decimal-proposal/playground/examples

go 1.28

require github.com/ncruces/go-sqlite3 v0.37.0

require (
	github.com/ncruces/go-sqlite3-wasm/v6 v6.5.35401 // indirect
	github.com/ncruces/julianday v1.0.0 // indirect
	golang.org/x/sys v0.49.0 // indirect
)
