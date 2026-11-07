package cbor

import (
	"testing"

	"github.com/fxamacker/cbor/v2"
	"github.com/marcelocantos/reflect-survey/harness"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/fxamacker/cbor/v2", Marshal: cbor.Marshal, Unmarshal: cbor.Unmarshal, Binary: true})
}
