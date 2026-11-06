package jsoniter

import (
	"testing"

	jsoniter "github.com/json-iterator/go"
	"github.com/marcelocantos/reflect-survey/harness"
)

func TestSurvey(t *testing.T) {
	j := jsoniter.ConfigCompatibleWithStandardLibrary
	harness.RunAll(t, harness.Codec{Lib: "github.com/json-iterator/go", Marshal: j.Marshal, Unmarshal: j.Unmarshal})
}
