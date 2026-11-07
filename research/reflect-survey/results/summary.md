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
