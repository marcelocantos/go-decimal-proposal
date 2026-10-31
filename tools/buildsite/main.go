// Command buildsite builds the static in-browser playground into a
// directory (site/ by default) from the decimal Go toolchain pinned in
// toolchain.lock.
//
// Usage, from the repository root:
//
//	$GOROOT/bin/go run ./tools/buildsite -goroot $GOROOT [-out site] [-update]
//
// where $GOROOT is a built checkout of the fork at the pinned SHA, built by
// make.bash with CGO_ENABLED=0 as CI builds it (make.bash records that
// setting in the toolchain, and cmd/compile's code depends on it). Run this
// program with that toolchain's own go command: the bundle's gzip streams
// come from the compress/flate of whichever Go runs it, and the pinned one
// keeps them reproducible.
//
// The bundle holds cmd/compile and cmd/link built for js/wasm,
// wasm_exec.js, precompiled js/wasm archives for the offered standard
// library packages and everything they import, an importcfg for each tool,
// the page, and the examples. digests.txt records the sha256 of every file.
// It is the same on every build host tried (darwin/arm64, linux/arm64,
// linux/amd64) when the toolchain is built as above. CI requires it to match
// playground/digests.txt, the committed record: after changing the pin or
// the page, build and copy site/digests.txt there.
//
// Each example's expected output is what native `go run` prints on the
// pinned toolchain. It is committed beside the example
// (playground/examples/<id>.out); this program fails if the native output
// has drifted from it, and -update rewrites it. The browser journey
// (playground/journey) compares the page's output with the same files.
package main

import (
	"archive/tar"
	"bytes"
	"compress/gzip"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"slices"
	"strings"
	"time"
)

// shipped is the set of standard-library packages the playground offers by
// name. Every non-internal package in their import closure is offered too,
// since its archive ships anyway; see offered below.
var shipped = []string{"cmp", "errors", "fmt", "math", "os", "slices", "sort", "strconv", "strings"}

// withheld are packages in the closure that are not offered. syscall/js
// reaches the JavaScript environment of the worker the program runs in.
var withheld = []string{"syscall/js"}

// Paths inside the bundle and inside the worker's in-memory filesystem.
const (
	stdArchivePrefix  = "/std/"      // the worker unpacks std.tar.gz here
	bundlePlaceholder = "__BUNDLE__" // in index.html's asset URLs
	digestsFile       = "digests.txt"
	committedDigests  = "playground/digests.txt"
	indexFile         = "index.html"
	bundleDigestLen   = 16 // hex digits
	examplesDir       = "playground/examples"
	webDir            = "playground/web"
	lockFile          = "toolchain.lock"
)

type example struct {
	ID    string `json:"id"`
	Title string `json:"title"`
	Src   string `json:"src,omitempty"`
	Code  string `json:"code,omitempty"`
}

type asset struct {
	Path string `json:"path"`
	Size int64  `json:"size"`
}

// buildInfo is site/build.json, read by the page.
type buildInfo struct {
	ForkSHA   string   `json:"fork_sha"`
	GoVersion string   `json:"go_version"`
	Offered   []string `json:"offered"`
	Compile   asset    `json:"compile"`
	Link      asset    `json:"link"`
	Std       asset    `json:"std"`
	// The compiler sees only the offered packages, so an import of any
	// other fails there; the linker needs the whole closure.
	ImportcfgCompile string `json:"importcfg_compile"`
	ImportcfgLink    string `json:"importcfg_link"`
}

func main() {
	log.SetFlags(0)
	log.SetPrefix("buildsite: ")
	goroot := flag.String("goroot", os.Getenv("GOROOT"), "built checkout of the decimal fork at the pinned SHA")
	out := flag.String("out", "site", "output directory")
	update := flag.Bool("update", false, "rewrite the examples' expected outputs from native go run")
	flag.Parse()
	if *goroot == "" {
		log.Fatal("-goroot is required")
	}
	root, err := filepath.Abs(*goroot)
	if err != nil {
		log.Fatal(err)
	}

	// The toolchain must be the pinned one.
	forkSHA := readLock(lockFile, "fork_sha")
	head, err := exec.Command("git", "-C", root, "rev-parse", "HEAD").Output()
	if err != nil {
		log.Fatalf("%s is not a git checkout of the fork: %v", root, err)
	}
	if got := strings.TrimSpace(string(head)); got != forkSHA {
		log.Fatalf("%s is at %s; %s pins %s", root, got, lockFile, forkSHA)
	}
	goCmd := filepath.Join(root, "bin", "go")
	env := append(os.Environ(),
		"GOROOT="+root, "GOTOOLCHAIN=local", "GOFLAGS=", "GOEXPERIMENT=", "CGO_ENABLED=0", "GOWORK=off")
	wasmEnv := append(slices.Clone(env), "GOOS=js", "GOARCH=wasm")
	goVersion := strings.TrimSpace(string(run(exec.Command(goCmd, "env", "GOVERSION"), env, "")))

	if err := cleanOutput(*out); err != nil {
		log.Fatal(err)
	}
	tmp, err := os.MkdirTemp("", "buildsite")
	if err != nil {
		log.Fatal(err)
	}
	defer os.RemoveAll(tmp)

	// cmd/compile and cmd/link for js/wasm.
	info := buildInfo{ForkSHA: forkSHA, GoVersion: goVersion}
	for _, tool := range []string{"compile", "link"} {
		bin := filepath.Join(tmp, tool+".wasm")
		// Empty build IDs: the go command derives them from hashes of the
		// host toolchain's own binaries, so they differ between build
		// hosts. A tool carries its build ID twice: in the binary's header
		// and in cmd/internal/objabi.buildID, which only a devel toolchain
		// reads (for go tool -V=full).
		ldflags := "-ldflags=-buildid= -X=cmd/internal/objabi.buildID="
		run(exec.Command(goCmd, "build", "-trimpath", ldflags, "-o", bin, "cmd/"+tool),
			wasmEnv, filepath.Join(root, "src"))
		a := writeGzip(*out, "tools/"+tool+".wasm.gz", readFile(bin))
		if tool == "compile" {
			info.Compile = a
		} else {
			info.Link = a
		}
	}

	// Precompiled archives for the offered packages and their closure.
	// go list -export builds each package and names its archive in the
	// build cache.
	listing := run(exec.Command(goCmd, append([]string{"list", "-trimpath", "-export", "-deps",
		"-f", "{{.ImportPath}}\t{{.Export}}"}, shipped...)...), wasmEnv, filepath.Join(root, "src"))
	var tarBuf bytes.Buffer
	tw := tar.NewWriter(&tarBuf)
	var archives []string
	for line := range strings.Lines(string(listing)) {
		pkg, export, _ := strings.Cut(strings.TrimSpace(line), "\t")
		if export == "" {
			continue // unsafe: the compiler provides it
		}
		archives = append(archives, pkg)
		data := readFile(export)
		name := "pkg/" + pkg + ".a"
		hdr := &tar.Header{Name: name, Mode: 0o644, Size: int64(len(data)), Typeflag: tar.TypeReg,
			ModTime: time.Unix(0, 0), Format: tar.FormatUSTAR}
		if err := tw.WriteHeader(hdr); err != nil {
			log.Fatal(err)
		}
		if _, err := tw.Write(data); err != nil {
			log.Fatal(err)
		}
	}
	if err := tw.Close(); err != nil {
		log.Fatal(err)
	}
	info.Std = writeGzip(*out, "std/std.tar.gz", tarBuf.Bytes())
	cfgCompile := "# import config\n"
	cfgLink := "# import config\n"
	for _, pkg := range archives {
		line := fmt.Sprintf("packagefile %s=%spkg/%s.a\n", pkg, stdArchivePrefix, pkg)
		cfgLink += line
		if !isInternal(pkg) && !slices.Contains(withheld, pkg) {
			info.Offered = append(info.Offered, pkg)
			cfgCompile += line
		}
	}
	slices.Sort(info.Offered)
	info.ImportcfgCompile = "std/importcfg.compile"
	info.ImportcfgLink = "std/importcfg.link"
	writeFile(*out, info.ImportcfgCompile, []byte(cfgCompile))
	writeFile(*out, info.ImportcfgLink, []byte(cfgLink))
	for _, pkg := range shipped {
		if !slices.Contains(info.Offered, pkg) {
			log.Fatalf("shipped package %s is missing from its own closure", pkg)
		}
	}

	// wasm_exec.js moved from misc/wasm to lib/wasm in Go 1.24.
	wasmExec, err := os.ReadFile(filepath.Join(root, "lib", "wasm", "wasm_exec.js"))
	if errors.Is(err, fs.ErrNotExist) {
		wasmExec, err = os.ReadFile(filepath.Join(root, "misc", "wasm", "wasm_exec.js"))
	}
	if err != nil {
		log.Fatal(err)
	}
	writeFile(*out, "wasm_exec.js", wasmExec)

	// The page.
	entries, err := os.ReadDir(webDir)
	if err != nil {
		log.Fatal(err)
	}
	for _, e := range entries {
		if e.Type().IsRegular() && e.Name() != indexFile {
			writeFile(*out, e.Name(), readFile(filepath.Join(webDir, e.Name())))
		}
	}

	// The examples, checked against native go run on the pinned toolchain.
	var examples []example
	if err := json.Unmarshal(readFile(filepath.Join(examplesDir, "examples.json")), &examples); err != nil {
		log.Fatalf("examples.json: %v", err)
	}
	drifted := false
	for i, ex := range examples {
		src := filepath.Join(examplesDir, filepath.FromSlash(ex.Src))
		examples[i].Code = string(readFile(src))
		examples[i].Src = ""
		got := run(exec.Command(goCmd, "run", filepath.Base(src)), env, filepath.Dir(src))
		wantPath := filepath.Join(examplesDir, ex.ID+".out")
		if *update {
			if err := os.WriteFile(wantPath, got, 0o644); err != nil {
				log.Fatal(err)
			}
			continue
		}
		want, err := os.ReadFile(wantPath)
		if err != nil {
			log.Fatalf("%v (run with -update to record it)", err)
		}
		if !bytes.Equal(got, want) {
			log.Printf("example %s: native go run output differs from %s", ex.ID, wantPath)
			drifted = true
		}
	}
	if drifted {
		log.Fatal("expected outputs have drifted from native go run; review and rerun with -update")
	}
	writeJSON(*out, "examples.json", examples)
	writeJSON(*out, "build.json", info)

	// index.html names its assets with a digest of everything else, so a
	// new deploy's page does not read assets cached from an earlier one.
	index := string(readFile(filepath.Join(webDir, indexFile)))
	if !strings.Contains(index, bundlePlaceholder) {
		log.Fatalf("%s does not contain %s", indexFile, bundlePlaceholder)
	}
	bundleSum := sha256.Sum256([]byte(digestList(*out)))
	bundle := hex.EncodeToString(bundleSum[:])[:bundleDigestLen]
	writeFile(*out, indexFile, []byte(strings.ReplaceAll(index, bundlePlaceholder, bundle)))

	digests := digestList(*out)
	writeFile(*out, digestsFile, []byte(digests))

	// Nothing else detects a toolchain built differently from CI's, so say
	// why the digests will not match the committed record.
	if !strings.Contains(string(readFile(filepath.Join(root, "src", "internal", "buildcfg", "zbootstrap.go"))),
		`DefaultCGO_ENABLED = "0"`) {
		log.Printf("warning: %s was not built with CGO_ENABLED=0, so its digests differ from %s; see playground/README.md",
			root, committedDigests)
	}
	if string(readFile(committedDigests)) == digests {
		log.Printf("digests match %s", committedDigests)
	} else {
		log.Printf("digests differ from %s", committedDigests)
	}
	log.Printf("built %s from %s (%s): %d archives, %d examples", *out, forkSHA[:12], goVersion, len(archives), len(examples))
}

// digestList returns a sha256sum-style line for every file under dir except
// digests.txt, in path order.
func digestList(dir string) string {
	var list strings.Builder
	err := filepath.WalkDir(dir, func(p string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return err
		}
		rel, err := filepath.Rel(dir, p)
		if err != nil {
			return err
		}
		rel = filepath.ToSlash(rel)
		if rel == digestsFile {
			return nil
		}
		sum := sha256.Sum256(readFile(p))
		fmt.Fprintf(&list, "%s  %s\n", hex.EncodeToString(sum[:]), rel)
		return nil
	})
	if err != nil {
		log.Fatal(err)
	}
	return list.String()
}

// readLock returns a key's value from toolchain.lock.
func readLock(file, key string) string {
	for line := range strings.Lines(string(readFile(file))) {
		if v, ok := strings.CutPrefix(strings.TrimSpace(line), key+"="); ok {
			return v
		}
	}
	log.Fatalf("%s has no %s", file, key)
	return ""
}

// cleanOutput empties dir, refusing to delete a directory this program did
// not produce.
func cleanOutput(dir string) error {
	entries, err := os.ReadDir(dir)
	if errors.Is(err, fs.ErrNotExist) {
		return os.MkdirAll(dir, 0o755)
	}
	if err != nil {
		return err
	}
	if len(entries) > 0 {
		if _, err := os.Stat(filepath.Join(dir, digestsFile)); err != nil {
			return fmt.Errorf("%s is not empty and holds no %s; refusing to replace it", dir, digestsFile)
		}
	}
	if err := os.RemoveAll(dir); err != nil {
		return err
	}
	return os.MkdirAll(dir, 0o755)
}

// isInternal reports whether pkg is not importable by a user program.
func isInternal(pkg string) bool {
	if strings.HasPrefix(pkg, "vendor/") {
		return true
	}
	return slices.Contains(strings.Split(pkg, "/"), "internal")
}

// run runs cmd and returns its stdout, exiting with its stderr on failure.
func run(cmd *exec.Cmd, env []string, dir string) []byte {
	cmd.Env = env
	cmd.Dir = dir
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	out, err := cmd.Output()
	if err != nil {
		log.Fatalf("%s: %v\n%s", strings.Join(cmd.Args, " "), err, stderr.Bytes())
	}
	return out
}

func readFile(name string) []byte {
	data, err := os.ReadFile(name)
	if err != nil {
		log.Fatal(err)
	}
	return data
}

func writeFile(dir, rel string, data []byte) {
	name := filepath.Join(dir, filepath.FromSlash(rel))
	if err := os.MkdirAll(filepath.Dir(name), 0o755); err != nil {
		log.Fatal(err)
	}
	if err := os.WriteFile(name, data, 0o644); err != nil {
		log.Fatal(err)
	}
}

func writeJSON(dir, rel string, v any) {
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		log.Fatal(err)
	}
	writeFile(dir, rel, append(data, '\n'))
}

// writeGzip writes data gzipped. The header carries no name or time, so the
// stream depends only on the data and the compressor.
func writeGzip(dir, rel string, data []byte) asset {
	var buf bytes.Buffer
	zw, err := gzip.NewWriterLevel(&buf, gzip.BestCompression)
	if err != nil {
		log.Fatal(err)
	}
	if _, err := zw.Write(data); err != nil {
		log.Fatal(err)
	}
	if err := zw.Close(); err != nil {
		log.Fatal(err)
	}
	writeFile(dir, rel, buf.Bytes())
	return asset{Path: path.Clean(rel), Size: int64(buf.Len())}
}
