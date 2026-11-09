// Command table turns benchstat CSV files (benchstat -row /set -col /impl
// -format csv) into markdown tables with one row per candidate and one
// column per operand set: median ns/op ± benchstat's confidence interval,
// and allocs/op where any is non-zero.
//
// Usage: go run ./cmd/table results/bs-Add.csv ...
package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

type cell struct{ v, ci string }

func main() {
	for _, path := range os.Args[1:] {
		op := strings.TrimSuffix(strings.TrimPrefix(filepath.Base(path), "bs-"), ".csv")
		data, err := os.ReadFile(path)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		// benchstat writes one CSV block per unit, separated by blank lines,
		// after a few "key: value" lines.
		times := map[string]map[string]cell{}
		allocs := map[string]map[string]cell{}
		var impls, sets []string
		for _, block := range strings.Split(string(data), "\n\n") {
			r := csv.NewReader(strings.NewReader(block))
			r.FieldsPerRecord = -1
			recs, err := r.ReadAll()
			if err != nil || len(recs) < 3 {
				continue
			}
			hdr, units := recs[0], recs[1]
			if len(hdr) < 2 || hdr[0] != "" {
				// Strip the "goos: ..." lines that precede the first block.
				for len(recs) > 0 && (len(recs[0]) == 0 || recs[0][0] != "") {
					recs = recs[1:]
				}
				if len(recs) < 3 {
					continue
				}
				hdr, units = recs[0], recs[1]
			}
			var dst map[string]map[string]cell
			scale, isTime := 1.0, false
			switch units[1] {
			case "sec/op":
				dst, scale, isTime = times, 1e9, true
			case "allocs/op":
				dst = allocs
			default:
				continue
			}
			// The base column has value and CI; every other column has value,
			// CI, vs base and P.
			cols := map[int]string{}
			for i := 1; i < len(hdr); i++ {
				if hdr[i] != "" {
					cols[i] = hdr[i]
					if isTime {
						impls = append(impls, hdr[i])
					}
				}
			}
			for _, rec := range recs[2:] {
				if len(rec) == 0 || rec[0] == "" || rec[0] == "geomean" {
					continue
				}
				set := rec[0]
				if isTime {
					sets = append(sets, set)
				}
				for i, impl := range cols {
					if i >= len(rec) || rec[i] == "" {
						continue
					}
					f, err := strconv.ParseFloat(rec[i], 64)
					if err != nil {
						continue
					}
					if dst[impl] == nil {
						dst[impl] = map[string]cell{}
					}
					ci := ""
					if i+1 < len(rec) {
						ci = rec[i+1]
					}
					v := strconv.FormatFloat(f, 'f', -1, 64)
					if isTime {
						v = format(f * scale)
					}
					dst[impl][set] = cell{v, ci}
				}
			}
		}
		fmt.Printf("### %s\n\n| impl |", op)
		for _, s := range sets {
			fmt.Printf(" %s ns/op | allocs |", s)
		}
		fmt.Print("\n|---|")
		for range sets {
			fmt.Print("--:|--:|")
		}
		fmt.Println()
		for _, impl := range impls {
			fmt.Printf("| %s |", impl)
			for _, s := range sets {
				c, ok := times[impl][s]
				if !ok {
					fmt.Print(" — | — |")
					continue
				}
				a := allocs[impl][s].v
				if a == "" {
					a = "0"
				}
				fmt.Printf(" %s ± %s | %s |", c.v, c.ci, a)
			}
			fmt.Println()
		}
		fmt.Println()
	}
}

func format(f float64) string {
	switch {
	case f >= 100:
		return strconv.FormatFloat(f, 'f', 0, 64)
	case f >= 10:
		return strconv.FormatFloat(f, 'f', 1, 64)
	default:
		return strconv.FormatFloat(f, 'f', 2, 64)
	}
}
