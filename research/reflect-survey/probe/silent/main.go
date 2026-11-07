// Command silent reproduces every silent mishandling of the built-in decimal
// types found by the survey. Each line prints what the library returned with
// no error.
package main

import (
	"bytes"
	"fmt"

	"dario.cat/mergo"
	"github.com/kr/pretty"
	"github.com/spf13/viper"
	"sigs.k8s.io/yaml"
)

type Box struct{ V decimal128 }

func main() {
	// sigs.k8s.io/yaml: digits beyond float64 are lost, and the quantum.
	var long decimal128 = 1234567890.123456789012345678901234
	b, err := yaml.Marshal(Box{V: long})
	fmt.Printf("sigs.k8s.io/yaml Marshal:   %q err=%v\n", b, err)
	var back Box
	err = yaml.Unmarshal([]byte("v: 1234567890.123456789012345678901234\n"), &back)
	fmt.Printf("sigs.k8s.io/yaml Unmarshal: %v err=%v\n", back.V, err)
	err = yaml.Unmarshal([]byte("v: 1.50\n"), &back)
	fmt.Printf("sigs.k8s.io/yaml Unmarshal: %v err=%v (input 1.50)\n", back.V, err)

	// kr/pretty: the value is omitted.
	fmt.Printf("kr/pretty Sprint:           %q\n", pretty.Sprint(Box{V: 1.50}))

	// mergo: a zero decimal is not "empty", so it is neither filled nor protected.
	dst := Box{}
	err = mergo.Merge(&dst, Box{V: 1.50})
	fmt.Printf("mergo Merge(fill empty):    %v err=%v (want 1.50)\n", dst.V, err)
	dst = Box{V: 2.50}
	err = mergo.Merge(&dst, Box{}, mergo.WithOverride)
	fmt.Printf("mergo WithOverride(zero):   %v err=%v (want 2.50)\n", dst.V, err)

	// viper: Get* has no error result; cast's error is dropped.
	v := viper.New()
	v.Set("v", decimal64(1.50))
	fmt.Printf("viper GetString/GetFloat64: %q %v\n", v.GetString("v"), v.GetFloat64("v"))

	// Contrast: the same viper key read from a config file.
	v2 := viper.New()
	v2.SetConfigType("yaml")
	v2.ReadConfig(bytes.NewBufferString("v: 1.50\n"))
	fmt.Printf("viper from YAML file:       %q %v\n", v2.GetString("v"), v2.GetFloat64("v"))
}
