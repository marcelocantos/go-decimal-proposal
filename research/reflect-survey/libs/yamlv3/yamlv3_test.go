package yamlv3

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"gopkg.in/yaml.v3"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "gopkg.in/yaml.v3", Marshal: yaml.Marshal, Unmarshal: yaml.Unmarshal})
}
