package burntsushitoml

import (
	"testing"

	"github.com/BurntSushi/toml"
	"github.com/marcelocantos/reflect-survey/harness"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/BurntSushi/toml", Marshal: toml.Marshal, Unmarshal: toml.Unmarshal, TopMustBeObject: true})
}
