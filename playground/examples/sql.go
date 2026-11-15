// Copyright 2026 Marcelo Cantos.
// Use of this source code is governed by the BSD-style LICENSE in this repository.

package main

import (
	"database/sql"
	"fmt"
	"math/decimal"

	_ "github.com/ncruces/go-sqlite3/driver"
)

// SQLite has no exact decimal storage class. This example stores decimal
// text, then scans it through database/sql into Go decimal values. SQL
// arithmetic on these strings would convert them to SQLite numbers and
// could lose precision. It does not test another database's NUMERIC type.
func main() {
	db, err := sql.Open("sqlite3", ":memory:")
	if err != nil {
		panic(err)
	}
	defer func() {
		if _, err := db.Exec("PRAGMA optimize"); err != nil {
			panic(err)
		}
		if err := db.Close(); err != nil {
			panic(err)
		}
	}()
	db.SetMaxOpenConns(1) // Keep all operations on the same in-memory database.
	if _, err := db.Exec("CREATE TABLE amounts (name TEXT PRIMARY KEY, amount TEXT NOT NULL)"); err != nil {
		panic(err)
	}

	fmt.Println("SQLite in memory; decimal values stored as TEXT.")
	fmt.Println("This preserves decimal data, not SQL decimal arithmetic.")
	fmt.Println()
	roundTrip(db, "decimal64", decimal64(1.50), decimal64(1.50), "1.50", true)
	const precise decimal128 = 1234567890.123456789012345678901234
	roundTrip(db, "decimal128", precise, precise, "1.234567890123456789012345678901234e+09", true)

	// A decimal parameter is stored as its canonical string, the text a
	// float gets from 'g' at precision -1, so a positive quantum survives:
	// 1e+03 is not written as 1000.
	const positive decimal128 = 1e+03
	roundTrip(db, "positive quantum", positive, positive, "1e+03", true)

	var count int
	if err := db.QueryRow("SELECT COUNT(*) FROM amounts").Scan(&count); err != nil {
		panic(err)
	}
	if count != 3 {
		panic(fmt.Sprintf("stored %d rows, want 3", count))
	}
	fmt.Printf("\nRows stored: %d\n", count)
}

func roundTrip[D decimal.Decimal](db *sql.DB, name string, parameter any, want D, wantText string, wantQuantum bool) {
	if _, err := db.Exec("INSERT INTO amounts (name, amount) VALUES (?, ?)", name, parameter); err != nil {
		panic(err)
	}
	var text string
	var got D
	if err := db.QueryRow("SELECT amount, amount FROM amounts WHERE name = ?", name).Scan(&text, &got); err != nil {
		panic(err)
	}
	sameQuantum := decimal.SameQuantum(got, want)
	if text != wantText || got != want || sameQuantum != wantQuantum {
		panic(fmt.Sprintf("%s: stored %q, scanned %v, same quantum %v", name, text, got, sameQuantum))
	}
	fmt.Printf("%s: stored %s; value preserved=%t; quantum preserved=%t\n", name, text, got == want, sameQuantum)
}
