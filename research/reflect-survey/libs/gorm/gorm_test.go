package gorm

import (
	"fmt"
	"testing"

	"github.com/glebarez/sqlite"
	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

const lib = "gorm.io/gorm"

// The value field and the pointer field live in separate models. A struct
// holding both a decimal and a pointer can't be stored through a pointer
// with this fork's compiler (internal compiler error; see probe/wbice), so a
// combined model doesn't compile.
type ItemV[T any] struct {
	ID uint
	V  T
}

type ItemP[T any] struct {
	ID uint
	P  *T
}

// Fixed table names: gorm's default name for a generic type includes the type
// argument (ItemV[decimal.Decimal] contains a '.'), which is invalid SQL.
func (ItemV[T]) TableName() string { return "item_vs" }
func (ItemP[T]) TableName() string { return "item_ps" }

func run[T any](s harness.Spec[T]) {
	for i, x := range s.Values {
		val := []string{"q", "long"}[i]
		lit := harness.Lit(s, s.Lits[i])
		db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{Logger: logger.Discard})
		if err != nil {
			harness.Record(lib, "Open", s.Type, val, harness.OtherError, err.Error())
			continue
		}
		var migErr error
		harness.Check(lib, "AutoMigrate", s.Type, "field/"+val, func() (string, string) {
			migErr = db.AutoMigrate(&ItemV[T]{}, &ItemP[T]{})
			if migErr != nil {
				return harness.ErrVerdict(migErr)
			}
			var ddl []string
			db.Raw(`select sql from sqlite_master where type = 'table' and name like 'item%'`).Scan(&ddl)
			return harness.Correct, fmt.Sprint(ddl)
		})
		if migErr != nil {
			// Hand-made tables so Create/First are still measured.
			db.Exec(`create table item_vs (id integer primary key, v text)`)
			db.Exec(`create table item_ps (id integer primary key, p text)`)
		}
		stored := func(table, col string, id uint) (string, string) {
			var v string
			db.Raw(`select cast(`+col+` as text) from `+table+` where id = ?`, id).Row().Scan(&v)
			switch {
			case v == lit:
				return harness.Correct, "stored " + v
			case harness.HasDigits(v, lit):
				return harness.CorrectNoQ, "stored " + v
			}
			return harness.Silent, fmt.Sprintf("want %s stored %q", lit, v)
		}
		var idV, idP uint
		harness.Check(lib, "Create", s.Type, "field/"+val, func() (string, string) {
			it := ItemV[T]{V: x}
			if err := db.Create(&it).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			idV = it.ID
			return stored("item_vs", "v", it.ID)
		})
		harness.Check(lib, "Create", s.Type, "ptr/"+val, func() (string, string) {
			xx := x
			it := ItemP[T]{P: &xx}
			if err := db.Create(&it).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			idP = it.ID
			return stored("item_ps", "p", it.ID)
		})
		harness.Check(lib, "First", s.Type, "field/"+val, func() (string, string) {
			var got ItemV[T]
			if err := db.First(&got, idV).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			return harness.Verdict(s, x, got.V, "")
		})
		harness.Check(lib, "First", s.Type, "ptr/"+val, func() (string, string) {
			var got ItemP[T]
			if err := db.First(&got, idP).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			if got.P == nil {
				return harness.Silent, "pointer field nil"
			}
			return harness.Verdict(s, x, *got.P, "")
		})
		harness.Check(lib, "Find(slice)", s.Type, "slice/"+val, func() (string, string) {
			var got []ItemV[T]
			if err := db.Find(&got).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			if len(got) != 1 {
				return harness.Silent, fmt.Sprintf("%d rows", len(got))
			}
			return harness.Verdict(s, x, got[0].V, "")
		})
		harness.Check(lib, "Where(v = ?)", s.Type, "param/"+val, func() (string, string) {
			var n int64
			if err := db.Model(&ItemV[T]{}).Where("v = ?", x).Count(&n).Error; err != nil {
				return harness.ErrVerdict(err)
			}
			if n != 1 {
				return harness.Silent, fmt.Sprintf("matched %d rows, want 1", n)
			}
			return harness.Correct, "matched 1 row"
		})
	}
}

func TestSurvey(t *testing.T) {
	harness.Runner{D64: run[decimal64], D128: run[decimal128], Shop: run[decimal.Decimal], Ctl: run[float64]}.Run(t)
}
