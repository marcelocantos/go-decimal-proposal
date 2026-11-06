package segmentiojson

import (
	"testing"

	"github.com/marcelocantos/reflect-survey/harness"
	"github.com/segmentio/encoding/json"
)

func TestSurvey(t *testing.T) {
	harness.RunAll(t, harness.Codec{Lib: "github.com/segmentio/encoding/json", Marshal: json.Marshal, Unmarshal: json.Unmarshal})
}
