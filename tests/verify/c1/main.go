package main

import "fmt"

const a decimal64 = 1.5
const b = a + 1 // cmd/compile: not constant? go/types: constant 2.5?

func main() { fmt.Println(b) }
