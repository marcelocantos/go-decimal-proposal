package k8syaml

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"sigs.k8s.io/yaml"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "sigs.k8s.io/yaml", Marshal: yaml.Marshal, Unmarshal: func(b []byte, v any) error { return yaml.Unmarshal(b, v) }})
}
