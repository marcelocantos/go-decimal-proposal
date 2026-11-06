package msgpack

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/vmihailenco/msgpack/v5"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/vmihailenco/msgpack/v5", Marshal: msgpack.Marshal, Unmarshal: msgpack.Unmarshal, Binary: true})
}
