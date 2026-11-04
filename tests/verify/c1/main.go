package main

import "fmt"

const a decimal64 = 1.5
const b = a + 1 // a constant, 2.5, in both type checkers (audit finding C1)

func main() { fmt.Println(b) }
