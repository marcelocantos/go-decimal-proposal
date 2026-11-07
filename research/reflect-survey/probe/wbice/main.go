// Command wbice reproduces a compiler crash: storing a struct that holds a
// decimal and a pointer through a pointer (a write-barrier store).
package main

type Item struct {
	V decimal64
	P *int
}

//go:noinline
func store(p *Item, x decimal64, q *int) {
	*p = Item{V: x, P: q}
}

func main() {
	var it Item
	n := 1
	store(&it, 1.5, &n)
	println(it.V == 1.5)
}
