// Command kindname prints what reflect.Kind(27) and (28) are called.
package main

import (
	"fmt"
	"reflect"
)

func main() {
	fmt.Println(reflect.Kind(27).String(), reflect.Kind(28).String(), reflect.Kind(29).String())
}
