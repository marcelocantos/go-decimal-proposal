package goccyjson

import (
	"testing"

	json "github.com/goccy/go-json"
	"github.com/marcelocantos/reflect-survey/harness"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/goccy/go-json", Marshal: json.Marshal, Unmarshal: json.Unmarshal})
}
