// Copyright 2026 Marcelo Cantos.
// Use of this source code is governed by the BSD-style LICENSE in this repository.

package main

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"math/decimal"
	"strconv"

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
	roundTrip(db, "decimal128", precise, precise, "1234567890.123456789012345678901234", true)

	// The fork's default SQL conversion uses fixed notation: 1e+03 is
	// written as 1000. The value survives, but the positive quantum does not.
	const positive decimal128 = 1e+03
	roundTrip(db, "positive quantum, default", positive, positive, "1000", false)
	// A driver.Valuer adapter can preserve the canonical decimal string.
	roundTrip(db, "positive quantum, adapter", canonicalDecimal(positive), positive, "1e+03", true)

	var count int
	if err := db.QueryRow("SELECT COUNT(*) FROM amounts").Scan(&count); err != nil {
		panic(err)
	}
	if count != 4 {
		panic(fmt.Sprintf("stored %d rows, want 4", count))
	}
	fmt.Printf("\nRows stored: %d\n", count)
}

// canonicalDecimal is a finite decimal128 SQL parameter that retains its
// quantum. The driver receives text; the destination column must preserve it.
type canonicalDecimal decimal128

func (d canonicalDecimal) Value() (driver.Value, error) {
	x := decimal128(d)
	if decimal.IsNaN(x) || decimal.IsInf(x, 0) {
		return nil, fmt.Errorf("this example stores finite decimals only")
	}
	return strconv.FormatDecimal(x, 'g', -1, 128), nil
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
