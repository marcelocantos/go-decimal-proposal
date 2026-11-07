package gotoml

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/pelletier/go-toml/v2"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/pelletier/go-toml/v2", Marshal: toml.Marshal, Unmarshal: toml.Unmarshal, TopMustBeObject: true})
}
