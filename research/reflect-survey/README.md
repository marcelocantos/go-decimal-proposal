# Reflection-library survey: built-in `decimal64`/`decimal128` vs a library decimal

This module measures what widely imported Go reflection libraries do when they
meet the Go decimal fork's built-in types `decimal64` and `decimal128`
(`reflect.Decimal64` = 27 and `reflect.Decimal128` = 28). For comparison, each
case is also run with `github.com/shopspring/decimal` (a struct type that
implements `encoding.TextMarshaler`, `json.Marshaler`, `encoding.BinaryMarshaler`,
`sql.Scanner` and `driver.Valuer`) and with plain `float64` as a control.

Every outcome comes from running the library: an error it returned, a panic
recovered from it, or the value it produced. No outcome comes from reading
source. Source was read only afterwards, to locate the code responsible for
each outcome.

Context: https://github.com/golang/go/issues/19787 (reply to comment 6692782966).

## Rerunning

```sh
# 1. Build the fork toolchain. The survey ran at commit 29d6435daa;
#    any later commit on the fork's decimal branch has the same reflect kinds.
git clone -b decimal https://github.com/marcelocantos/go "$HOME/go-decimal"
(cd "$HOME/go-decimal/src" && ./make.bash)
# 2. From this directory:
FORK=$HOME/go-decimal . ./env.sh   # GOROOT, PATH, GOTOOLCHAIN=local, GOEXPERIMENT=decimal
go run ./cmd/survey    # writes results/results.tsv, results/summary.md, out/raw.txt
go run ./probe/silent  # reproduces every silent mishandling of the built-in types
go build ./probe/wbice # reproduces the compiler crash (see "Side findings")
SURVEY_STACKS=1 go test -count=1 -v ./libs/msgpack   # one library, with panic stacks
```

CI (the proposal repo's `build` job) runs `go run ./cmd/survey -check` on
the toolchain pinned in `toolchain.lock`. That reruns every case and fails if
any outcome differs from `results/results.tsv`, ignoring the free-text detail
column. Many cases are expected to fail; the check is that the survey runs and
that the committed table is what the code produces. After a deliberate change,
rerun without `-check` and commit the new table.

`probe/mongonodecimal` imports mongo-driver and uses no decimals. With
`GOEXPERIMENT=nodecimal` on a fork that hides the new kinds while the
experiment is off (fork commit f3e9d665ab and later), it prints `ok 1.5`; with
the experiment on, or on fork revisions before that commit in either mode, it
panics at start-up.

`go.mod` says `go 1.28` because the fork gates the types on it. Library
versions are pinned in `go.mod`/`go.sum`.

## Method

* **Values.** `1.50` tests the quantum (1.50 and 1.5 are equal but have
  different quanta). A long value tests whether the number passes through
  `float64`: `1234567.890123456` (16 digits) for decimal64, and
  `1234567890.123456789012345678901234` (34 digits) for decimal128 and
  shopspring.
* **Shapes.** Each value goes in at top level, as a struct field, as a slice
  element, as a map value and behind a pointer field, where the API allows it.
* **Directions.** Codecs run two entry points:
  * `Marshal→Unmarshal`: encode the value, then decode it back into the same
    Go type.
  * `Unmarshal(number)`: decode a numeric literal from the wire into the
    decimal type, independent of whether the library can encode it. Text
    formats get the exact literal (`1.50`). Binary formats get a float64,
    the best a generic producer can send, and the expected value is that
    float's shortest decimal form.

  Other libraries run their main APIs in both directions where they have two.
* **Outcome classes** (exactly one per case):
  * `correct`: the value and the quantum survive.
  * `correct-quantum`: the value survives but the quantum is lost (1.50 becomes 1.5).
  * `clean-error`: an error naming the type, or saying it is unsupported or
    not numeric.
  * `other-error`: an error that doesn't say the type is the problem.
  * `silent`: a wrong result with no error.
  * `opaque`: the round trip works, but the wire holds no readable number
    (gob bytes, or a struct dump of internals).
  * `panic`.
  * `compile-failure`.
  * `n/a`: a top-level scalar or array in TOML or BSON, which the format can't express.

  Each entry-point cell in the table shows its worst outcome first, then the
  others with their case counts.
* **Control.** Every test also runs with `float64`. A test whose control
  isn't `correct` would be measuring the test. Every control is `correct`
  except mongo-driver, which panics at init with float64 too (see below).
* **Import counts** were read from the pkg.go.dev "Imported by" header on
  2026-11-07 (`results/importcounts-2026-11-07.txt`). pkg.go.dev counts
  importing *packages* it knows about. `github.com/imdario/mergo` shows 0
  because the module moved to `dario.cat/mergo`.

## Libraries and versions

| library | version | pkg.go.dev "Imported by" |
|---|---|---|
| go.uber.org/zap | v1.28.0 | 119,696 |
| github.com/spf13/viper | v1.21.0 | 103,320 |
| gorm.io/gorm (+ github.com/glebarez/sqlite v1.11.0) | v1.31.2 | 86,926 |
| gopkg.in/yaml.v3 | v3.0.1 | 44,731 |
| github.com/BurntSushi/toml | v1.6.0 | 38,240 |
| github.com/mitchellh/mapstructure | v1.5.0 | 30,442 |
| github.com/jmoiron/sqlx (+ modernc.org/sqlite v1.61.1) | v1.4.0 | 27,167 |
| github.com/go-playground/validator/v10 | v10.30.6 | 25,452 |
| go.mongodb.org/mongo-driver/bson | v1.17.10 | 25,035 |
| github.com/davecgh/go-spew/spew | v1.1.1 | 18,700 |
| github.com/json-iterator/go | v1.1.12 | 18,454 |
| github.com/stretchr/testify/assert | v1.12.1 | 16,016 (require: 20,797) |
| github.com/spf13/cast | v1.10.0 | 14,499 |
| sigs.k8s.io/yaml | v1.6.0 | 12,078 |
| google.golang.org/protobuf/types/known/structpb | v1.36.12 | 7,186 |
| github.com/google/go-cmp/cmp | v0.7.0 | 5,704 |
| dario.cat/mergo | v1.0.2 | 4,273 |
| github.com/goccy/go-json | v0.12.0 | 4,192 |
| github.com/kr/pretty | v0.3.1 | 3,609 |
| github.com/jinzhu/copier | v0.4.0 | 3,251 |
| github.com/pelletier/go-toml/v2 | v2.4.3 | 1,986 |
| github.com/fxamacker/cbor/v2 | v2.10.0 | 1,912 |
| github.com/vmihailenco/msgpack/v5 | v5.4.1 | 1,833 |
| go.mongodb.org/mongo-driver/v2/bson | v2.9.3 | 1,385 |
| github.com/mohae/deepcopy | 2017-09-29 | 1,142 |
| github.com/go-viper/mapstructure/v2 | v2.5.0 | 1,070 |
| github.com/segmentio/encoding/json | v0.5.4 | 348 |
| (comparison) github.com/shopspring/decimal | v1.6.0 | 40,713 |

Protobuf: a generated message can't have a `decimal64` field, because
protoc-gen-go emits only proto scalar types, so generated code never reflects
over one. A decimal reaches protobuf only through APIs that take `any`, so
`structpb.NewValue` and `structpb.NewStruct` are tested.

## Results

Raw per-case data, with the observed wire bytes and errors, is in
`results/results.tsv`. The table below is `results/summary.md`.

| library | entry point | decimal64 | decimal128 | shopspring | float64 control |
|---|---|---|---|---|---|
| go.mongodb.org/mongo-driver/bson | (package init; every entry point) | **panic** ×1 | **panic** ×1 | **panic** ×1 | **panic** ×1 |
| go.mongodb.org/mongo-driver/v2/bson | (package init; every entry point) | **panic** ×1 | **panic** ×1 | **panic** ×1 | **panic** ×1 |
| github.com/BurntSushi/toml | Marshal→Unmarshal | **clean-error** ×6, n/a ×4 | **clean-error** ×6, n/a ×4 | **correct-quantum** ×3, correct ×3, n/a ×4 | **correct** ×6, n/a ×4 |
| github.com/BurntSushi/toml | Unmarshal(number) | **clean-error** ×6, n/a ×4 | **clean-error** ×6, n/a ×4 | **silent** ×3, correct-quantum ×3, n/a ×4 | **correct** ×6, n/a ×4 |
| github.com/spf13/cast | ToStringE | **clean-error** ×2 | **clean-error** ×2 | **correct-quantum** ×1, correct ×1 | **correct** ×2 |
| github.com/spf13/cast | ToFloat64E | **clean-error** ×2 | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 |
| github.com/spf13/cast | ToInt64E | **clean-error** ×2 | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 |
| github.com/fxamacker/cbor/v2 | Marshal→Unmarshal | **clean-error** ×10 | **clean-error** ×10 | **opaque** ×6, correct ×4 | **correct** ×10 |
| github.com/fxamacker/cbor/v2 | Unmarshal(number) | **clean-error** ×10 | **clean-error** ×10 | **clean-error** ×10 | **correct** ×10 |
| github.com/jinzhu/copier | Copy | **correct** ×8 | **correct** ×8 | **correct** ×8 | **correct** ×8 |
| github.com/jinzhu/copier | CopyWithOption(DeepCopy) | **correct** ×2 | **correct** ×2 | **correct** ×2 | **correct** ×2 |
| github.com/mohae/deepcopy | Copy | **correct** ×10 | **correct** ×10 | **silent** ×10 | **correct** ×10 |
| github.com/goccy/go-json | Marshal→Unmarshal | **clean-error** ×10 | **clean-error** ×10 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |
| github.com/goccy/go-json | Unmarshal(number) | **clean-error** ×10 | **clean-error** ×10 | **correct** ×10 | **correct** ×10 |
| github.com/google/go-cmp/cmp | Equal | **panic** ×5 | **panic** ×5 | **correct** ×5 | **correct** ×5 |
| github.com/google/go-cmp/cmp | Diff | **panic** ×5 | **panic** ×5 | **correct** ×5 | **correct** ×5 |
| gorm.io/gorm | AutoMigrate | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 | **correct** ×2 |
| gorm.io/gorm | Create | **clean-error** ×4 | **clean-error** ×4 | **correct-quantum** ×2, correct ×2 | **correct** ×4 |
| gorm.io/gorm | First | **clean-error** ×4 | **clean-error** ×4 | **correct-quantum** ×2, correct ×2 | **correct** ×4 |
| gorm.io/gorm | Find(slice) | **clean-error** ×2 | **clean-error** ×2 | **correct-quantum** ×1, correct ×1 | **correct** ×2 |
| gorm.io/gorm | Where(v = ?) | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 | **correct** ×2 |
| github.com/pelletier/go-toml/v2 | Marshal→Unmarshal | **clean-error** ×6, n/a ×4 | **clean-error** ×6, n/a ×4 | **correct-quantum** ×3, correct ×3, n/a ×4 | **correct** ×6, n/a ×4 |
| github.com/pelletier/go-toml/v2 | Unmarshal(number) | **clean-error** ×6, n/a ×4 | **clean-error** ×6, n/a ×4 | **correct** ×6, n/a ×4 | **correct** ×6, n/a ×4 |
| github.com/go-viper/mapstructure/v2 | Decode(map→struct, same type) | **clean-error** ×5 | **clean-error** ×5 | **correct** ×5 | **correct** ×5 |
| github.com/go-viper/mapstructure/v2 | Decode(float64→field) | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/go-viper/mapstructure/v2 | Decode(string→field, weak) | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/go-viper/mapstructure/v2 | Decode(struct→map) | **correct** ×1 | **correct** ×1 | **silent** ×1 | **correct** ×1 |
| github.com/json-iterator/go | Marshal→Unmarshal | **clean-error** ×10 | **clean-error** ×10 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |
| github.com/json-iterator/go | Unmarshal(number) | **clean-error** ×10 | **clean-error** ×10 | **correct** ×10 | **correct** ×10 |
| sigs.k8s.io/yaml | Marshal→Unmarshal | **correct-quantum** ×5, correct ×5 | **silent** ×5, correct-quantum ×5 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |
| sigs.k8s.io/yaml | Unmarshal(number) | **correct-quantum** ×5, correct ×5 | **silent** ×5, correct-quantum ×5 | **silent** ×5, correct-quantum ×5 | **correct** ×10 |
| github.com/kr/pretty | Sprint | **silent** ×6 | **silent** ×6 | **opaque** ×6 | **correct** ×6 |
| github.com/kr/pretty | Sprintf(%# v) | **silent** ×5 | **silent** ×5 | **opaque** ×5 | **correct** ×5 |
| github.com/kr/pretty | Diff | **panic** ×1 | **panic** ×1 | **opaque** ×1 | **correct** ×1 |
| github.com/mitchellh/mapstructure | Decode(map→struct, same type) | **clean-error** ×5 | **clean-error** ×5 | **correct** ×5 | **correct** ×5 |
| github.com/mitchellh/mapstructure | Decode(float64→field) | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/mitchellh/mapstructure | Decode(string→field, weak) | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/mitchellh/mapstructure | Decode(struct→map) | **correct** ×1 | **correct** ×1 | **silent** ×1 | **correct** ×1 |
| dario.cat/mergo | Merge (fill empty) | **silent** ×1, correct ×2 | **silent** ×1, correct ×2 | **silent** ×1, correct ×2 | **correct** ×3 |
| dario.cat/mergo | Merge (keep non-empty) | **correct** ×1 | **correct** ×1 | **correct** ×1 | **correct** ×1 |
| dario.cat/mergo | Merge(WithOverride) | **correct** ×1 | **correct** ×1 | **correct** ×1 | **correct** ×1 |
| dario.cat/mergo | Merge(WithOverride, empty src) | **silent** ×1 | **silent** ×1 | **silent** ×1 | **correct** ×1 |
| github.com/vmihailenco/msgpack/v5 | Marshal→Unmarshal | **panic** ×10 | **panic** ×10 | **opaque** ×6, correct ×4 | **correct** ×10 |
| github.com/vmihailenco/msgpack/v5 | Unmarshal(number) | **panic** ×10 | **panic** ×10 | **other-error** ×10 | **correct** ×10 |
| github.com/segmentio/encoding/json | Marshal→Unmarshal | **clean-error** ×10 | **clean-error** ×10 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |
| github.com/segmentio/encoding/json | Unmarshal(number) | **clean-error** ×10 | **clean-error** ×10 | **correct** ×10 | **correct** ×10 |
| github.com/davecgh/go-spew/spew | Sdump | **correct** ×6 | **correct** ×6 | **correct-quantum** ×5, correct ×1 | **correct** ×6 |
| github.com/davecgh/go-spew/spew | Sprintf(%v) | **correct** ×5 | **correct** ×5 | **correct-quantum** ×5 | **correct** ×5 |
| github.com/jmoiron/sqlx | Exec(param) | **correct** ×2 | **correct** ×2 | **correct-quantum** ×1, correct ×1 | **correct** ×2 |
| github.com/jmoiron/sqlx | Get(scan into struct) | **correct** ×2 | **correct** ×2 | **correct** ×2 | **correct** ×2 |
| github.com/jmoiron/sqlx | Select(scan into slice) | **correct** ×2 | **correct** ×2 | **correct** ×2 | **correct** ×2 |
| github.com/jmoiron/sqlx | Get(scan into *T field) | **correct** ×2 | **correct** ×2 | **correct** ×2 | **correct** ×2 |
| google.golang.org/protobuf/types/known/structpb | NewValue | **clean-error** ×2 | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 |
| google.golang.org/protobuf/types/known/structpb | NewStruct | **clean-error** ×2 | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 |
| github.com/stretchr/testify/assert | ObjectsAreEqual | **correct** ×5 | **correct** ×5 | **correct** ×5 | **correct** ×5 |
| github.com/stretchr/testify/assert | Equal (failure message) | **correct** ×5 | **correct** ×5 | **correct** ×5 | **correct** ×5 |
| github.com/stretchr/testify/assert | Greater | **clean-error** ×1 | **clean-error** ×1 | **clean-error** ×1 | **correct** ×1 |
| github.com/stretchr/testify/assert | InDelta | **clean-error** ×1 | **clean-error** ×1 | **clean-error** ×1 | **correct** ×1 |
| github.com/stretchr/testify/assert | Zero | **correct** ×1 | **correct** ×1 | **correct** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Struct required | **correct** ×1 | **correct** ×1 | **silent** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Struct gt=1 | **panic** ×1 | **panic** ×1 | **panic** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Struct lte=10 | **panic** ×1 | **panic** ×1 | **panic** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Struct dive,gt=1 | **panic** ×1 | **panic** ×1 | **panic** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Struct ptr gt=1 | **panic** ×1 | **panic** ×1 | **panic** ×1 | **correct** ×1 |
| github.com/go-playground/validator/v10 | Var gt=1 | **panic** ×1 | **panic** ×1 | **silent** ×1 | **correct** ×1 |
| github.com/spf13/viper | ReadConfig(yaml)+Unmarshal | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/spf13/viper | ReadConfig(json)+Unmarshal | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/spf13/viper | ReadConfig(yaml-quoted)+Unmarshal | **clean-error** ×2 | **clean-error** ×2 | **other-error** ×2 | **correct** ×2 |
| github.com/spf13/viper | Set+Unmarshal | **clean-error** ×2 | **clean-error** ×2 | **correct** ×2 | **correct** ×2 |
| github.com/spf13/viper | Set+GetString | **silent** ×2 | **silent** ×2 | **correct-quantum** ×1, correct ×1 | **correct** ×2 |
| github.com/spf13/viper | Set+GetFloat64 | **silent** ×2 | **silent** ×2 | **silent** ×2 | **correct** ×2 |
| gopkg.in/yaml.v3 | Marshal→Unmarshal | **panic** ×10 | **panic** ×10 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |
| gopkg.in/yaml.v3 | Unmarshal(number) | **clean-error** ×10 | **clean-error** ×10 | **correct** ×10 | **correct** ×10 |
| go.uber.org/zap | Any (JSON encoder) | **correct** ×10 | **correct** ×10 | **correct-quantum** ×5, correct ×5 | **correct** ×10 |

### Entry points by worst outcome across shapes

| outcome | decimal64 | decimal128 | shopspring | float64 control |
|---|---|---|---|---|
| panic | 13 | 13 | 6 | 2 |
| silent | 6 | 8 | 10 | 0 |
| opaque | 0 | 0 | 5 | 0 |
| other-error | 0 | 0 | 8 | 0 |
| clean-error | 35 | 35 | 7 | 0 |
| correct-quantum | 2 | 0 | 16 | 0 |
| correct | 18 | 18 | 22 | 72 |

### Individual cases (every shape and value)

| outcome | decimal64 | decimal128 | shopspring | float64 control |
|---|---|---|---|---|
| panic | 48 | 48 | 6 | 2 |
| silent | 17 | 27 | 26 | 0 |
| opaque | 0 | 0 | 24 | 0 |
| other-error | 0 | 0 | 24 | 0 |
| clean-error | 166 | 166 | 20 | 0 |
| correct-quantum | 10 | 10 | 62 | 0 |
| correct | 77 | 67 | 156 | 316 |
| n/a | 16 | 16 | 16 | 16 |

Entry-point counts treat a whole package-init panic as one entry point. That
applies to both mongo-driver rows, and it happens for every type, including the
float64 control.

## Silent mishandlings of the built-in types

The reproducer is `go run ./probe/silent`. Observed output:

```
sigs.k8s.io/yaml Marshal:   "V: 1.2345678901234567e+09\n" err=<nil>
sigs.k8s.io/yaml Unmarshal: 1234567890.1234567 err=<nil>
sigs.k8s.io/yaml Unmarshal: 1.5 err=<nil> (input 1.50)
kr/pretty Sprint:           "main.Box{V:}"
mergo Merge(fill empty):    0 err=<nil> (want 1.50)
mergo WithOverride(zero):   0 err=<nil> (want 2.50)
viper GetString/GetFloat64: "" 0
viper from YAML file:       "1.5" 1.5
```

| library | what happens | responsible code | fix size |
|---|---|---|---|
| sigs.k8s.io/yaml `Marshal` | It calls the fork's `encoding/json` (which emits `1.50` and all 34 digits), then `JSONToYAML` re-parses the JSON with go-yaml into `interface{}`, which yields a float64. decimal128 loses every digit past the 17th; both types lose the quantum. decimal64's 16-digit value happened to survive float64. | `yaml.go:105-119` (`JSONToYAML`: `yaml.Unmarshal(j, &jsonObj)`) | Needs number-preserving JSON→YAML conversion: keep numeric scalars as text. This is not a one-case fix. |
| sigs.k8s.io/yaml `Unmarshal` | The YAML scalar becomes a float64 before it reaches `encoding/json`. Only string-kind targets get the original text. **shopspring is hit identically** (its 34-digit value also comes back with 17 digits). | `yaml.go:329-355` (`convertToJSONableObject`: only `Kind() == reflect.String` is special-cased) | Keep the scalar's source text for decimal (and text-unmarshaling) targets. Moderate. |
| kr/pretty `Sprint`, `Sprintf("%# v")`, `Formatter` | Prints nothing where the value should be: `Box{V:}`, `[]decimal64{}`. | `formatter.go:128-294`: the `printValue` kind switch has no decimal case and no `default` | Add one case. |
| dario.cat/mergo `Merge` | A zero decimal counts as "non-empty", so `Merge` doesn't fill it, and `WithOverride` overwrites a set value with a zero source. **shopspring shows the same two failures** (its zero is a struct holding a nil `*big.Int`). | `mergo.go:37-61`: `isEmptyValue` has no decimal case and returns false at `:61` | Add one case (`v.IsZero()`). |
| spf13/viper `GetString`, `GetFloat64` | They return `""` and `0` for a decimal set with `viper.Set`. The `Get*` API has no error result, so cast's clean error is dropped. **shopspring's `GetFloat64` also returns 0.** | `viper.go:792`, `viper.go:862` call `cast.ToString`/`cast.ToFloat64`, which discard the error; the root is cast (next table) | Fixed by fixing cast. |

## Code locations for the other non-correct built-in outcomes

| library | outcome | responsible code | fix size |
|---|---|---|---|
| mongo-driver v1 `bson` | panic at package init, for every program that imports it, whether or not it uses decimals: `The capacity of kindEncoderCache is too small. This is due to a new type being added to reflect.Kind.` | `bson/bsoncodec/codec_cache.go:17-21`, a deliberate guard that `reflect.Kind(27).String() == "kind27"`; the arrays at `:103` and `:140` are `[reflect.UnsafePointer + 1]` | Resize two arrays and update the guard. Encoding decimals then needs a new encoder; BSON has a native decimal128 type to map to. |
| mongo-driver v2 `bson` | Same init panic. | `bson/codec_cache.go:18-27`, `:105` | Same. |
| vmihailenco/msgpack/v5 | panic: `index out of range [27] with length 27`, in Marshal and Unmarshal | `encode_value.go:13` and `decode_value.go:20`: slices of codec funcs indexed by Kind, read at `encode_value.go:122` and `decode_value.go:123` | Two table entries, plus an encoder and a decoder (msgpack has no decimal type, so the wire form is a choice: string or ext). |
| gopkg.in/yaml.v3 `Marshal` | panic: `cannot marshal type: decimal64` | `encode.go:181-182` (kind-switch `default: panic`); `yaml.go:294` `handleErr` re-panics anything that isn't a `yamlError` | Add one encode case (emit a `!!float` scalar). |
| gopkg.in/yaml.v3 `Unmarshal` | clean error: ``cannot unmarshal !!float `1.50` into decimal64`` | `decode.go:362` (`terror`, reached because the scalar kind switch has no decimal case) | Add one decode case. |
| google/go-cmp `Equal`, `Diff` | panic: `decimal64 kind not handled` | `cmp/compare.go:299` (`compareAny` kind-switch `default: panic`) | Add one case. The choice is whether 1.5 and 1.50 compare equal. |
| kr/pretty `Diff` | panic: `unknown reflect Kind: decimal64` | `diff.go:203` (`default: panic`) | Add one case. |
| go-playground/validator `gt`, `lte` (also via `dive` and on a pointer field; `Var`) | panic: `Bad field type decimal64`. `required` works. Only `gt`, `lte` and `required` were run; the other comparison rules share the same pattern but were not measured. **shopspring panics on the same rules on struct fields** (only `time.Time` structs are accepted), and `Var(d, "gt=1")` silently accepts 0.50. | `baked_in.go:2489` (`isGt`), `:2671` (`isLte`); 39 `panic("Bad field type …")` sites in `baked_in.go`; 12 functions carry a `case reflect.Float32, reflect.Float64:` | Add a case to about 12 functions. |
| goccy/go-json | clean error: `json: unsupported type: decimal64` (both directions) | `internal/encoder/compiler.go:632` (`UnsupportedTypeError`); decoder kind switch | A new encoder and decoder, since the library compiles its own code paths. |
| json-iterator/go | clean error: `decimal64 is unsupported type` | `reflect.go:285` (encoder), `reflect.go:186` (decoder) | A new encoder and decoder. |
| segmentio/encoding/json | clean error: `json: unsupported type: decimal64` | `json/encode.go:824` | A new encoder and decoder. |
| fxamacker/cbor/v2 | clean error: `cbor: unsupported type`; decode: `cannot unmarshal primitives into Go value of type decimal64` | `cache.go:482`; `decode.go:180` | A new encoder and decoder (CBOR has tag 4, decimal fraction, to map to). |
| BurntSushi/toml | clean error: `unsupported type: decimal64` | `encode.go:610`; `decode.go:289` | Add an encode case and a decode case. |
| pelletier/go-toml/v2 | clean error: `toml: cannot encode value of type decimal64`; decode: `cannot decode TOML float into struct field … of type decimal64` | `marshaler.go:1459`; `unmarshaler.go:1517` | Add an encode case and a decode case. |
| mitchellh/mapstructure | clean error: `unsupported type: decimal64`, for map→struct with any source type. struct→map is correct. | `mapstructure.go:495` (kind-switch default in `decode`) | A new `decodeDecimal`, about the size of `decodeFloat`. |
| go-viper/mapstructure/v2 | Same. | `mapstructure.go:657` | Same. |
| spf13/viper `Unmarshal` (from a config file or `Set`) | clean error, inherited from go-viper/mapstructure | the mapstructure location above | Fixed by fixing mapstructure. |
| spf13/cast `ToStringE`, `ToFloat64E`, `ToInt64E` | clean error: `unable to cast 1.50 of type decimal64 to string` | `basic.go:70` (`ToStringE` type switch, `default:` at `:120`), `number.go:138`/`:448`. cast switches on concrete types, not kinds | Add `case decimal64, decimal128:` to each converter (about 15 functions). |
| gorm | clean error: `failed to parse field: V, error: unsupported data type: 0x…` (AutoMigrate, Create, First, Find, Where) | `schema/field.go:233`: the kind switch that assigns `DataType` has no decimal case, so `DataType` stays empty and `schema/schema.go:141-162` returns `ErrUnsupportedDataType` | Add one case (`DataType` → a decimal or numeric type). The fork's `database/sql` already converts the values. |
| structpb `NewValue`, `NewStruct` | clean error: `proto: invalid type: decimal64` | `types/known/structpb/struct.pb.go:381` (type switch default) | Add a case (to a number or a string value; proto has no decimal). **shopspring gets the same error.** |
| testify `Greater` | clean error: `Can not compare type "decimal64"` | `assert/assertion_compare.go:477` | Add one case. **shopspring gets the same error.** |
| testify `InDelta` | `Parameters must be numerical` | `assert/assertions.go:1463`, `:1558` (`toFloat` type switch) | Add one case. **shopspring gets the same error.** |

## What worked for the built-in types, and why

* `copier.Copy`, `deepcopy.Copy`, `testify.ObjectsAreEqual`/`Equal`/`Zero`,
  and mapstructure struct→map preserved value and quantum. They move values
  with `reflect.Value.Set` or compare them with `reflect.DeepEqual`, without
  a kind switch.
* `zap.Any`, `spew.Sdump`/`Sprintf`, `sqlx` and testify's failure messages
  are correct because they delegate to the fork's `encoding/json`, `fmt` or
  `database/sql`, which already handle the new kinds. For example, sqlx
  stored `1.50` as `'1.50'` through `database/sql/driver`'s
  `DefaultParameterConverter` (`driver/types.go:287-290` in the fork; the
  sqlite driver has no `CheckNamedValue`), and scanned it back with the quantum intact.

## What the `encoding` interfaces buy shopspring here

* JSON (goccy, jsoniter, segmentio, and sigs.k8s.io/yaml's Marshal), YAML,
  TOML, gorm and sqlx: shopspring works through `MarshalJSON`/`MarshalText`/
  `Scan`/`Value` where the built-in types get clean errors or a panic. Its
  default `MarshalJSON` and `String` drop trailing zeros, so the quantum is
  lost (`"1.5"`). Decoding `1.50` keeps exponent −2.
* msgpack and cbor: shopspring round-trips through `MarshalBinary`, but the
  wire holds gob-encoded `big.Int` bytes (`c406fffffffe0296`), which a
  non-Go consumer can't read as a number (`opaque`). Decoding a wire
  float64 into shopspring fails with an error.
* Libraries whose kind switch doesn't consult the interfaces don't help
  shopspring either:
  * mapstructure (and viper config loading) need an opt-in decode hook and
    return `expected a map or struct, got "float64"`.
  * cast's `ToFloat64E` errors.
  * mergo, validator (`gt` panics; `required` always passes on the struct),
    deepcopy (it copies to a zero Decimal because its fields are unexported),
    and kr/pretty (it dumps `big.Int` internals) all mishandle it.
  * go-cmp works because it calls shopspring's `Equal` method.
* BurntSushi/toml decoding the TOML float `1234567890.123456789012345678901234`
  into shopspring gave `1234567890.123457`, with no error.

## Side findings

* **Compiler crash in the fork.** Storing through a pointer any struct that
  contains both a decimal and a pointer fails to compile:
  `internal compiler error: 'store': bad write barrier type decimal64`.
  The reproducer is `probe/wbice` (`*p = Item{V: x, P: q}` where
  `Item{V decimal64; P *int}`). `storeTypeScalars` in
  `src/cmd/compile/internal/ssagen/ssa.go:5953-5999` has no
  `t.IsDecimal()` case. This is untested here, but adding decimals to the
  scalar case at `:5955` looks like the fix. The gorm test splits its model
  in two to avoid it.
* **mongo-driver's init guard** fires for any new `reflect.Kind`, before any
  decimal value exists. The guard is deliberate. It fires because the fork's
  `reflect` names Kinds 27 and 28 even without `GOEXPERIMENT=decimal`
  (`go run ./probe/kindname` prints `decimal64 decimal128 kind29` both ways).

## Layout

* `harness/`: values, shapes, outcome classification, and the codec runner.
* `libs/<name>/`: one test package per library, so a build failure or an init
  panic in one library can't hide the others.
* `cmd/survey/`: runs every package and writes `results/`.
* `probe/silent`, `probe/wbice`, `probe/kindname`: standalone reproducers.
