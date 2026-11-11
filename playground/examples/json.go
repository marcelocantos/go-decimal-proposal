// Copyright 2026 Marcelo Cantos.
// Use of this source code is governed by the BSD-style LICENSE in this repository.

package main

import (
	"encoding/json/v2"
	"errors"
	"fmt"
	"math/decimal"
)

// Money usually travels through JSON as a string, because many readers
// parse a JSON number into a binary float. The `string` tag option does
// that for a decimal field, as it does for a float or an integer. Nothing
// here is specific to decimals: a decimal field follows a float field.
type Order struct {
	ID    string     `json:"id"`
	Price decimal64  `json:"price,string"`
	Qty   decimal64  `json:"qty"`
	Total decimal128 `json:"total,string"`
}

// The same shape with binary floats, for comparison.
type FloatOrder struct {
	ID    string  `json:"id"`
	Price float64 `json:"price,string"`
	Qty   float64 `json:"qty"`
	Total float64 `json:"total,string"`
}

func main() {
	const in = `{"id":"A-17","price":"0.10","qty":3,"total":"0"}`
	fmt.Println("Input:     ", in)

	var o Order
	if err := json.Unmarshal([]byte(in), &o); err != nil {
		panic(err)
	}
	o.Total = decimal128(o.Price * o.Qty)
	out, err := json.Marshal(o)
	if err != nil {
		panic(err)
	}
	fmt.Println("decimal:   ", string(out))

	var f FloatOrder
	if err := json.Unmarshal([]byte(in), &f); err != nil {
		panic(err)
	}
	f.Total = f.Price * f.Qty
	out, err = json.Marshal(f)
	if err != nil {
		panic(err)
	}
	fmt.Println("float64:   ", string(out))

	// A decimal128 keeps all 34 digits of a string field.
	const wide = `{"id":"B-2","price":"1","qty":1,"total":"1234567890.123456789012345678901234"}`
	if err := json.Unmarshal([]byte(wide), &o); err != nil {
		panic(err)
	}
	if err := json.Unmarshal([]byte(wide), &f); err != nil {
		panic(err)
	}
	fmt.Println()
	fmt.Println("34 digits: ", "1234567890.123456789012345678901234")
	fmt.Println("decimal128:", o.Total)
	fmt.Println("float64:   ", f.Total)

	// A string field takes a JSON number in quotes and nothing else. The
	// cause is printed, not the whole message: the json package varies
	// its wording from run to run so that nobody depends on it.
	fmt.Println()
	for _, bad := range []string{
		`{"price":0.10}`,    // not quoted
		`{"price":" 0.10"}`, // not a JSON number
		`{"price":"NaN"}`,   // JSON has no NaN
		`{"price":"1e999"}`, // more than a decimal64 holds
	} {
		err := json.Unmarshal([]byte(bad), &o)
		serr, ok := errors.AsType[*json.SemanticError](err)
		if !ok {
			panic(fmt.Sprintf("%s: got %v, want a SemanticError", bad, err))
		}
		cause := fmt.Sprintf("a JSON %v for a quoted %v", serr.JSONKind, serr.GoType)
		if serr.Err != nil {
			cause = serr.Err.Error()
		}
		fmt.Printf("%-19s rejected: %s\n", bad, cause)
	}

	// NaN and the infinities have no JSON form, so encoding one fails,
	// for a decimal as for a float.
	o.Price = decimal.NaN[decimal64]()
	_, err = json.Marshal(o)
	serr, ok := errors.AsType[*json.SemanticError](err)
	if !ok {
		panic(fmt.Sprintf("Marshal(NaN): got %v, want a SemanticError", err))
	}
	fmt.Println()
	fmt.Println("Marshal(NaN):       rejected:", serr.Err)
}
