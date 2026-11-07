// Command mongonodecimal checks that a program importing mongo-driver's bson
// package, and using no decimals, starts and works. Run it with
// GOEXPERIMENT=nodecimal to check that the new reflect kinds stay invisible
// while the experiment is off; with the experiment on it panics at start-up.
package main

import (
	"fmt"

	"go.mongodb.org/mongo-driver/bson"
)

func main() {
	b, err := bson.Marshal(bson.M{"price": 1.5})
	if err != nil {
		panic(err)
	}
	var m bson.M
	if err := bson.Unmarshal(b, &m); err != nil {
		panic(err)
	}
	fmt.Println("ok", m["price"])
}
