package main

import (
	"fmt"
	"reflect"
	"strconv"
)

func twice(d decimal128) decimal128 { return d * 2 }
func twice64(d decimal64) decimal64 { return d * 2 }

func main() {
	fmt.Println("reflect.Kind: Decimal64 =", int(reflect.Decimal64), "Complex64 =", int(reflect.Complex64), "UnsafePointer =", int(reflect.UnsafePointer), "(Go 1.27: 15, 26)")
	d, err := strconv.ParseDecimal64("1e999")
	fmt.Println("ParseDecimal64(1e999) =", d, err)
	d, err = strconv.ParseDecimal64("12345678901234569")
	fmt.Println("ParseDecimal64(12345678901234569) =", d, err, "(want ...570)")
	var r decimal64 = 'a'
	fmt.Println("var d decimal64 = 'a' ->", r, "(want 97)")
	fmt.Println("decimal64(0x1p-2) ->", decimal64(0x1p-2), "(want 0.25)")
	fmt.Println("reflect.Call decimal64:", reflect.ValueOf(twice64).Call([]reflect.Value{reflect.ValueOf(decimal64(1.25))})[0])
	defer func() { fmt.Println("reflect.Call decimal128 panic:", recover()) }()
	fmt.Println("reflect.Call decimal128:", reflect.ValueOf(twice).Call([]reflect.Value{reflect.ValueOf(decimal128(1.25))})[0])
}
