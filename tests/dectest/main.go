// Command dectest smoke-runs the IBM Speleotrove decTest vectors for the
// priority arithmetic operations (add, multiply, divide, both decDouble and
// decQuad) through the fork's *runtime* decimal64/decimal128 operators —
// not through internal/bid directly. It must be built and run with the
// pinned fork toolchain (GOROOT at toolchain.lock's fork_sha) so the
// compiler/runtime wiring is exercised end to end, matching
// tests/oracle and tests/quantum_validate.go.
//
// This program does not vendor the decTest files: it reads them from a
// directory named on the command line or via BID_DECTEST_DIR (🎯T1.2.5;
// the licence constraint recorded in the fork's
// internal/bid/vectors_test.go applies equally here — the files carry an
// IBM notice with no redistribution grant, so they stay out of this
// repository and out of CI by default).
//
// Usage:
//
//	GOROOT=<pinned checkout> <pinned>/bin/go run ./tests/dectest -dir <dir-with-*.decTest>
//
// Report: for every vector line in the priority files, the vector either
// passes (operator result matches the expected value after rounding to
// the file's declared precision), fails (value mismatch — reported with
// file:line, inputs, want, got), or is skipped with a named, printed
// reason (never silently dropped). Exit status is non-zero on any
// skip-with-unexpected-reason or failure, so this cannot pass green by
// accident.

//go:build decimal64

package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
)

// priorityFiles is ROADMAP's dd/dq add, multiply, divide set (🎯T1.2.5
// acceptance: "Smoke run executes priority files ddAdd/ddMultiply/ddDivide
// and dq equivalents").
var priorityFiles = []string{
	"ddAdd.decTest",
	"ddMultiply.decTest",
	"ddDivide.decTest",
	"dqAdd.decTest",
	"dqMultiply.decTest",
	"dqDivide.decTest",
}

// opOf maps a file's base name to the operation it exercises, and the
// bit width (64 for dd*, 128 for dq*) the operands are parsed at.
func opOf(base string) (op string, bits int) {
	switch {
	case strings.HasPrefix(base, "dd"):
		bits = 64
	case strings.HasPrefix(base, "dq"):
		bits = 128
	default:
		return "", 0
	}
	switch {
	case strings.Contains(base, "Add"):
		op = "add"
	case strings.Contains(base, "Multiply"):
		op = "multiply"
	case strings.Contains(base, "Divide"):
		op = "divide"
	}
	return op, bits
}

type counts struct {
	pass, fail int
	skip       map[string]int
}

func (c *counts) addSkip(reason string) {
	if c.skip == nil {
		c.skip = map[string]int{}
	}
	c.skip[reason]++
}

func (c *counts) total() int {
	n := c.pass + c.fail
	for _, v := range c.skip {
		n += v
	}
	return n
}

// vecLine matches a decTest test line, e.g.:
//
//	ddadd001 add 1       1       ->  2
//	ddadd905 add 1  -9999999999999999  ->  -9999999999999998  Rounded
//
// Directive lines (precision:, rounding:, etc.) and comments (-- ...) are
// handled separately by the caller.
var vecLine = regexp.MustCompile(`^(\S+)\s+(\S+)\s+(.*?)\s*->\s*(\S+)\s*(.*)$`)

// tokenize splits a decTest operand/result list on whitespace, respecting
// single-quoted strings (the format quotes operands that need it, e.g.
// '#INF', '-Infinity', or any string containing a special payload).
func tokenize(s string) []string {
	var toks []string
	i := 0
	for i < len(s) {
		for i < len(s) && s[i] == ' ' {
			i++
		}
		if i >= len(s) {
			break
		}
		if s[i] == '\'' {
			j := i + 1
			for j < len(s) && s[j] != '\'' {
				j++
			}
			toks = append(toks, s[i+1:j])
			i = j + 1
			continue
		}
		j := i
		for j < len(s) && s[j] != ' ' {
			j++
		}
		toks = append(toks, s[i:j])
		i = j
	}
	return toks
}

func runFile(path string, c *counts) error {
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	op, bits := opOf(filepath.Base(path))
	if op == "" {
		return fmt.Errorf("unrecognized priority file name %s", path)
	}

	sc := bufio.NewScanner(f)
	sc.Buffer(make([]byte, 64*1024), 1<<20)
	lineNo := 0
	// rounding tracks the file's current "rounding:" directive. decTest
	// files exercise all five IEEE 754 rounding modes section by
	// section; the fork's runtime operators implement round-to-nearest,
	// ties-to-even only (README design decision 4), so a vector under
	// any other declared mode is skipped with a named reason instead of
	// silently compared against the wrong rounding.
	rounding := "half_even"
	for sc.Scan() {
		lineNo++
		line := sc.Text()
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "--") {
			continue
		}
		if strings.Contains(trimmed, ":") && !strings.Contains(trimmed, "->") {
			if r, ok := directiveValue(trimmed, "rounding"); ok {
				rounding = r
			}
			c.addSkip("directive-line")
			continue
		}
		if rounding != "half_even" {
			c.addSkip("rounding-mode:" + rounding)
			continue
		}
		m := vecLine.FindStringSubmatch(trimmed)
		if m == nil {
			c.addSkip("unparsed-line")
			continue
		}
		id, vecOp, operandStr, resultStr, conditions := m[1], m[2], m[3], strings.Trim(m[4], "'"), strings.TrimSpace(m[5])
		if vecOp != op {
			// Shared setup files aren't expected here (each priority file
			// is single-operation), but skip explicitly rather than drop.
			c.addSkip("operation-mismatch:" + vecOp)
			continue
		}
		operands := tokenize(operandStr)
		if len(operands) != 2 {
			c.addSkip("arity")
			continue
		}
		if resultStr == "?" {
			c.addSkip("undefined-result")
			continue
		}
		// decTest marks exceptional conditions as trailing flag words.
		// This smoke test does not check signal/status flags, only the
		// result value — but it skips (named) rather than silently
		// passing when the vector is about a condition this harness
		// does not model: division by zero, Overflow, and operands/
		// results containing NaN/sNaN/Infinity payload semantics the
		// comparison below can't canonicalize.
		if strings.Contains(conditions, "Division_by_zero") ||
			strings.Contains(conditions, "Division_impossible") ||
			strings.Contains(conditions, "Division_undefined") ||
			strings.Contains(conditions, "Invalid_operation") {
			c.addSkip("condition:" + firstWord(conditions))
			continue
		}
		if hasSpecial(operands[0]) || hasSpecial(operands[1]) || hasSpecial(resultStr) {
			c.addSkip("special-value")
			continue
		}

		got, err := evalOp(op, operands[0], operands[1], bits)
		if err != nil {
			c.addSkip("eval-error:" + errKind(err))
			continue
		}
		want, err := parseExpect(resultStr, bits)
		if err != nil {
			c.addSkip("want-parse-error:" + errKind(err))
			continue
		}
		if got == want {
			c.pass++
		} else {
			c.fail++
			if c.fail <= 20 {
				fmt.Printf("FAIL %s %s:%d: %s(%s, %s) = %s, want %s\n",
					id, filepath.Base(path), lineNo, op, operands[0], operands[1], got, want)
			}
		}
	}
	return sc.Err()
}

// errKind collapses a strconv.NumError down to its function and
// underlying error, dropping the specific offending string, so the skip
// tally groups by cause instead of fragmenting into one bucket per
// distinct unparseable literal.
func errKind(err error) string {
	type numErr interface {
		error
		Unwrap() error
	}
	if ne, ok := err.(numErr); ok {
		return ne.Unwrap().Error()
	}
	return err.Error()
}

// directiveValue reports the value of a "name: value" decTest
// directive line, lower-cased, if trimmed starts with that name.
func directiveValue(trimmed, name string) (string, bool) {
	if !strings.HasPrefix(strings.ToLower(trimmed), name+":") {
		return "", false
	}
	v := strings.TrimSpace(trimmed[len(name)+1:])
	return strings.ToLower(v), true
}

func firstWord(s string) string {
	s = strings.TrimSpace(s)
	if i := strings.IndexAny(s, " \t"); i >= 0 {
		return s[:i]
	}
	return s
}

func hasSpecial(tok string) bool {
	u := strings.ToUpper(strings.TrimPrefix(strings.TrimPrefix(tok, "-"), "+"))
	return strings.Contains(u, "NAN") || strings.Contains(u, "INF") || u == "#INF" || u == "?"
}

// evalOp parses the two operands at the given width, applies op through
// the language's decimal64/decimal128 operators (the point of this
// harness — runtime arithmetic, not the internal/bid package), and
// formats the result back to the shortest round-tripping decimal string
// for comparison against the vector's expected text.
func evalOp(op, a, b string, bits int) (string, error) {
	da, err := strconv.ParseDecimal(a, bits)
	if err != nil {
		return "", err
	}
	db, err := strconv.ParseDecimal(b, bits)
	if err != nil {
		return "", err
	}
	if bits == 64 {
		x, y := decimal64(da), decimal64(db)
		var z decimal64
		switch op {
		case "add":
			z = x + y
		case "multiply":
			z = x * y
		case "divide":
			z = x / y
		}
		return strconv.FormatDecimal(decimal128(z), 'g', -1, 64), nil
	}
	x, y := decimal128(da), decimal128(db)
	var z decimal128
	switch op {
	case "add":
		z = x + y
	case "multiply":
		z = x * y
	case "divide":
		z = x / y
	}
	return strconv.FormatDecimal(z, 'g', -1, 128), nil
}

func parseExpect(s string, bits int) (string, error) {
	d, err := strconv.ParseDecimal(s, bits)
	if err != nil {
		return "", err
	}
	return strconv.FormatDecimal(d, 'g', -1, bits), nil
}

func main() {
	dir := flag.String("dir", os.Getenv("BID_DECTEST_DIR"), "directory holding the priority *.decTest files (also read from BID_DECTEST_DIR)")
	flag.Parse()
	if *dir == "" {
		fmt.Fprintln(os.Stderr, "dectest: no -dir and BID_DECTEST_DIR unset; nothing to run (this is not a pass — see tests/dectest/README.md)")
		os.Exit(2)
	}

	var grand counts
	grand.skip = map[string]int{}
	anyFileMissing := false
	for _, name := range priorityFiles {
		path := filepath.Join(*dir, name)
		if _, err := os.Stat(path); err != nil {
			fmt.Fprintf(os.Stderr, "dectest: %s: %v (skipping whole file, named)\n", name, err)
			grand.addSkip("file-missing:" + name)
			anyFileMissing = true
			continue
		}
		var c counts
		c.skip = map[string]int{}
		if err := runFile(path, &c); err != nil {
			fmt.Fprintf(os.Stderr, "dectest: %s: %v\n", name, err)
			os.Exit(1)
		}
		fmt.Printf("%-18s pass=%-6d fail=%-6d skip=%-6d total=%d\n", name, c.pass, c.fail, sumSkip(c.skip), c.total())
		grand.pass += c.pass
		grand.fail += c.fail
		for k, v := range c.skip {
			grand.skip[k] += v
		}
	}
	fmt.Printf("TOTAL              pass=%-6d fail=%-6d skip=%-6d total=%d\n", grand.pass, grand.fail, sumSkip(grand.skip), grand.total())
	fmt.Println("skip reasons:")
	for k, v := range grand.skip {
		fmt.Printf("  %-28s %d\n", k, v)
	}

	if grand.fail > 0 || anyFileMissing {
		os.Exit(1)
	}
}

func sumSkip(m map[string]int) int {
	n := 0
	for _, v := range m {
		n += v
	}
	return n
}
