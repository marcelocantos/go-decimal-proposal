// Command survey runs every package under libs/, collects the RESULT lines
// each test prints, and writes results/results.tsv and results/summary.md
// (committed) and out/raw.txt (full test output, not committed).
//
// A package whose test binary dies before printing any result (an init-time
// panic) or fails to build is recorded as such, with the first lines of the
// output as detail, so that no library silently drops out of the table.
//
// With -check it writes nothing. Instead it compares the outcome of every
// case with the committed results/results.tsv, keyed on library, entry
// point, type and shape, and exits 1 if any case is new, missing or has a
// different outcome. The detail column is free text (error messages, first
// lines of a panic) and is not compared. CI runs this so that the table
// cannot drift from what the code produces.
//
// Run from the module root with the fork toolchain on PATH (see env.sh).
package main

import (
	"bufio"
	"bytes"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
)

type row struct{ lib, entry, typ, shape, outcome, detail string }

// libName maps a package directory to the library it tests, for packages
// that can die before reporting their own name.
var libName = map[string]string{
	"bson":   "go.mongodb.org/mongo-driver/bson",
	"bsonv2": "go.mongodb.org/mongo-driver/v2/bson",
}

const resultsFile = "results/results.tsv"

func main() {
	check := flag.Bool("check", false, "compare outcomes with "+resultsFile+" instead of writing results")
	flag.Parse()
	dirs, err := filepath.Glob("libs/*")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	sort.Strings(dirs)
	var rows []row
	var raw bytes.Buffer
	for _, d := range dirs {
		cmd := exec.Command("go", "test", "-count=1", "-v", "./"+d)
		cmd.Env = append(os.Environ(), "SURVEY_STACKS=")
		out, runErr := cmd.CombinedOutput()
		fmt.Fprintf(&raw, "### %s\n%s\n", d, out)
		var got []row
		sc := bufio.NewScanner(bytes.NewReader(out))
		sc.Buffer(make([]byte, 1<<20), 1<<20)
		for sc.Scan() {
			f := strings.Split(sc.Text(), "\t")
			if len(f) == 7 && f[0] == "RESULT" {
				got = append(got, row{f[1], f[2], f[3], f[4], f[5], f[6]})
			}
		}
		if len(got) == 0 {
			lib := libName[filepath.Base(d)]
			if lib == "" {
				lib = filepath.Base(d)
			}
			first := firstLines(string(out), 3)
			switch {
			case bytes.Contains(out, []byte("[build failed]")) || bytes.Contains(out, []byte("[setup failed]")):
				got = append(got, row{lib, "(build)", "all", "-", "compile-failure", first})
			case bytes.Contains(out, []byte("panic:")):
				for _, typ := range []string{"decimal64", "decimal128", "shopspring", "float64(control)"} {
					got = append(got, row{lib, "(package init; every entry point)", typ, "-", "panic", "process dies at import, before any decimal is used: " + first})
				}
			default:
				got = append(got, row{lib, "(run)", "all", "-", "other-error", fmt.Sprintf("%v: %s", runErr, first)})
			}
		}
		rows = append(rows, got...)
		fmt.Fprintf(os.Stderr, "%-20s %d results\n", d, len(got))
	}
	os.MkdirAll("out", 0o755)
	os.WriteFile("out/raw.txt", raw.Bytes(), 0o644)
	if *check {
		os.Exit(checkRows(rows))
	}
	var tsv bytes.Buffer
	tsv.WriteString("library\tentry\ttype\tshape\toutcome\tdetail\n")
	for _, r := range rows {
		fmt.Fprintf(&tsv, "%s\t%s\t%s\t%s\t%s\t%s\n", r.lib, r.entry, r.typ, r.shape, r.outcome, r.detail)
	}
	os.MkdirAll("results", 0o755)
	os.WriteFile(resultsFile, tsv.Bytes(), 0o644)
	os.WriteFile("results/summary.md", []byte(summary(rows)), 0o644)
}

// checkRows compares the outcome of each case with the committed table and
// returns the process exit code: 0 if every case matches, 1 otherwise.
func checkRows(rows []row) int {
	data, err := os.ReadFile(resultsFile)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		return 1
	}
	key := func(lib, entry, typ, shape string) string {
		return lib + "\t" + entry + "\t" + typ + "\t" + shape
	}
	want := map[string]string{}
	for i, line := range strings.Split(strings.TrimRight(string(data), "\n"), "\n") {
		if i == 0 {
			continue // header
		}
		f := strings.Split(line, "\t")
		if len(f) < 5 {
			fmt.Fprintf(os.Stderr, "%s:%d: malformed line\n", resultsFile, i+1)
			return 1
		}
		want[key(f[0], f[1], f[2], f[3])] = f[4]
	}
	bad := 0
	seen := map[string]bool{}
	for _, r := range rows {
		k := key(r.lib, r.entry, r.typ, r.shape)
		seen[k] = true
		w, ok := want[k]
		switch {
		case !ok:
			fmt.Printf("new case: %s -> %s\n", strings.ReplaceAll(k, "\t", " | "), r.outcome)
			bad++
		case w != r.outcome:
			fmt.Printf("changed: %s: %s -> %s (%s)\n", strings.ReplaceAll(k, "\t", " | "), w, r.outcome, r.detail)
			bad++
		}
	}
	for k, w := range want {
		if !seen[k] {
			fmt.Printf("missing case: %s (was %s)\n", strings.ReplaceAll(k, "\t", " | "), w)
			bad++
		}
	}
	if bad > 0 {
		fmt.Printf("%d of %d cases differ from %s; rerun without -check and commit the new table if the change is expected\n", bad, len(want), resultsFile)
		return 1
	}
	fmt.Printf("all %d cases match %s\n", len(want), resultsFile)
	return 0
}

func firstLines(s string, n int) string {
	var keep []string
	for _, l := range strings.Split(s, "\n") {
		if strings.TrimSpace(l) == "" || strings.HasPrefix(l, "#") {
			continue
		}
		keep = append(keep, strings.TrimSpace(l))
		if len(keep) == n {
			break
		}
	}
	return strings.Join(keep, " ⏎ ")
}

// rank orders outcomes from worst to best, for collapsing the shapes of one
// entry point into a single cell.
var rank = map[string]int{
	"panic": 0, "compile-failure": 1, "silent": 2, "opaque": 3, "other-error": 4,
	"clean-error": 5, "correct-quantum": 6, "correct": 7, "n/a": 8, "info": 9,
}

var types = []string{"decimal64", "decimal128", "shopspring", "float64(control)"}

func summary(rows []row) string {
	type key struct{ lib, entry string }
	cells := map[key]map[string]map[string]int{} // key → type → outcome → count
	var keys []key
	for _, r := range rows {
		if r.outcome == "info" || strings.Contains(r.entry, "[info]") {
			continue
		}
		k := key{r.lib, r.entry}
		if cells[k] == nil {
			cells[k] = map[string]map[string]int{}
			keys = append(keys, k)
		}
		typs := []string{r.typ}
		if r.typ == "all" {
			typs = types
		}
		for _, t := range typs {
			if cells[k][t] == nil {
				cells[k][t] = map[string]int{}
			}
			cells[k][t][r.outcome]++
		}
	}
	var b strings.Builder
	b.WriteString("| library | entry point | decimal64 | decimal128 | shopspring | float64 control |\n|---|---|---|---|---|---|\n")
	for _, k := range keys {
		fmt.Fprintf(&b, "| %s | %s |", k.lib, k.entry)
		for _, t := range types {
			fmt.Fprintf(&b, " %s |", cell(cells[k][t]))
		}
		b.WriteString("\n")
	}
	// Counts per entry point (worst shape wins), built-in types only.
	b.WriteString("\n### Entry points by worst outcome across shapes\n\n| outcome | decimal64 | decimal128 | shopspring | float64 control |\n|---|---|---|---|---|\n")
	tally := map[string]map[string]int{}
	for _, k := range keys {
		for _, t := range types {
			w := worst(cells[k][t])
			if w == "" {
				continue
			}
			if tally[w] == nil {
				tally[w] = map[string]int{}
			}
			tally[w][t]++
		}
	}
	outs := make([]string, 0, len(tally))
	for o := range tally {
		outs = append(outs, o)
	}
	sort.Slice(outs, func(i, j int) bool { return rank[outs[i]] < rank[outs[j]] })
	for _, o := range outs {
		fmt.Fprintf(&b, "| %s |", o)
		for _, t := range types {
			fmt.Fprintf(&b, " %d |", tally[o][t])
		}
		b.WriteString("\n")
	}
	// Raw case counts.
	b.WriteString("\n### Individual cases (every shape and value)\n\n| outcome | decimal64 | decimal128 | shopspring | float64 control |\n|---|---|---|---|---|\n")
	caseTally := map[string]map[string]int{}
	for _, r := range rows {
		if r.outcome == "info" || strings.Contains(r.entry, "[info]") {
			continue
		}
		if caseTally[r.outcome] == nil {
			caseTally[r.outcome] = map[string]int{}
		}
		caseTally[r.outcome][r.typ]++
	}
	outs = outs[:0]
	for o := range caseTally {
		outs = append(outs, o)
	}
	sort.Slice(outs, func(i, j int) bool { return rank[outs[i]] < rank[outs[j]] })
	for _, o := range outs {
		fmt.Fprintf(&b, "| %s |", o)
		for _, t := range types {
			fmt.Fprintf(&b, " %d |", caseTally[o][t])
		}
		b.WriteString("\n")
	}
	return b.String()
}

func worst(m map[string]int) string {
	w, best := "", 100
	for o := range m {
		if o == "n/a" {
			continue
		}
		if rank[o] < best {
			w, best = o, rank[o]
		}
	}
	if w == "" && m["n/a"] > 0 {
		return "n/a"
	}
	return w
}

// cell shows the worst outcome, and the others in parentheses when shapes differ.
func cell(m map[string]int) string {
	if len(m) == 0 {
		return ""
	}
	outs := make([]string, 0, len(m))
	for o := range m {
		outs = append(outs, o)
	}
	sort.Slice(outs, func(i, j int) bool { return rank[outs[i]] < rank[outs[j]] })
	s := fmt.Sprintf("**%s** ×%d", outs[0], m[outs[0]])
	for _, o := range outs[1:] {
		s += fmt.Sprintf(", %s ×%d", o, m[o])
	}
	return s
}
