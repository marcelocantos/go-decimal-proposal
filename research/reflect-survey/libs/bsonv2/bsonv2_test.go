package bsonv2

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestSurvey(t *testing.T) {
	// BSON documents must be documents at top level, so bare scalars and arrays are n/a.
	harness.RunAll(t, harness.Codec{Lib: "go.mongodb.org/mongo-driver/v2/bson", Marshal: bson.Marshal, Unmarshal: bson.Unmarshal, TopMustBeObject: true, Binary: true})
}
