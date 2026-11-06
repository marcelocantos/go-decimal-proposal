package sqlx

import (
	"fmt"
	"testing"

	"github.com/jmoiron/sqlx"
	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/shopspring/decimal"
	_ "modernc.org/sqlite"
)

const lib = "github.com/jmoiron/sqlx"

type Row[T any] struct {
	V T `db:"v"`
}

func open() (*sqlx.DB, error) {
	db, err := sqlx.Open("sqlite", ":memory:")
	if err != nil {
		return nil, err
	}
	db.SetMaxOpenConns(1)
	// TEXT affinity keeps "1.50" as written; NUMERIC would turn it into REAL 1.5.
	_, err = db.Exec(`create table t (v text)`)
	return db, err
}

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		shape := []string{"field/q", "field/long"}[i]
		lit := s.Lits[i]
		// Parameter direction: what reaches the database.
		harness.Check(lib, "Exec(param)", s.Type, shape, func() (string, string) {
			db, err := open()
			if err != nil {
				return harness.OtherError, "setup: " + err.Error()
			}
			defer db.Close()
			if _, err := db.Exec(`insert into t values (?)`, x); err != nil {
				return harness.ErrVerdict(err)
			}
			var stored string
			if err := db.Get(&stored, `select v from t`); err != nil {
				return harness.OtherError, "readback: " + err.Error()
			}
			switch {
			case stored == lit:
				return harness.Correct, "stored " + stored
			case harness.HasDigits(stored, lit):
				return harness.CorrectNoQ, "stored " + stored
			}
			return harness.Silent, fmt.Sprintf("want %s stored %s", lit, stored)
		})
		// Scan direction: a decimal string in the database into a struct field.
		harness.Check(lib, "Get(scan into struct)", s.Type, shape, func() (string, string) {
			db, err := open()
			if err != nil {
				return harness.OtherError, "setup: " + err.Error()
			}
			defer db.Close()
			if _, err := db.Exec(`insert into t values (?)`, lit); err != nil {
				return harness.OtherError, "setup insert: " + err.Error()
			}
			var r Row[T]
			if err := db.Get(&r, `select v from t`); err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, x, r.V, "")
		})
		harness.Check(lib, "Select(scan into slice)", s.Type, shape, func() (string, string) {
			db, err := open()
			if err != nil {
				return harness.OtherError, "setup: " + err.Error()
			}
			defer db.Close()
			if _, err := db.Exec(`insert into t values (?)`, lit); err != nil {
				return harness.OtherError, "setup insert: " + err.Error()
			}
			var rs []T
			if err := db.Select(&rs, `select v from t`); err != nil {
				return harness.ErrVerdict(err)
			}
			if len(rs) != 1 {
				return harness.Silent, fmt.Sprintf("%d rows", len(rs))
			}
			return harness.Verdict(s, x, rs[0], "")
		})
		harness.Check(lib, "Get(scan into *T field)", s.Type, shape, func() (string, string) {
			db, err := open()
			if err != nil {
				return harness.OtherError, "setup: " + err.Error()
			}
			defer db.Close()
			if _, err := db.Exec(`insert into t values (?)`, lit); err != nil {
				return harness.OtherError, "setup insert: " + err.Error()
			}
			var r struct {
				V *T `db:"v"`
			}
			if err := db.Get(&r, `select v from t`); err != nil {
				return harness.ErrVerdict(err)
			}
			if r.V == nil {
				return harness.Silent, "nil"
			}
			return harness.Verdict(s, x, *r.V, "")
		})
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
