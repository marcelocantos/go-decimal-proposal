package main

type K struct {
	A decimal64
	B int
}

func main() {
	m := map[K]int{}
	m[K{1.5, 2}] = 1
	println(len(m))
}
