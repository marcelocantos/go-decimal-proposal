package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"time"
)

var (
	goToolchain string
	listenAddr  string
	goCache     string
)

func init() {
	goToolchain = os.Getenv("GOROOT")
	if goToolchain == "" {
		goToolchain = runtime.GOROOT()
	}

	listenAddr = os.Getenv("PORT")
	if listenAddr == "" {
		listenAddr = "8080"
	}
	listenAddr = ":" + listenAddr

	goCache = filepath.Join(os.TempDir(), "decimal64-playground-cache")
	os.MkdirAll(goCache, 0755)
}

type runRequest struct {
	Code string `json:"code"`
}

type runResponse struct {
	Output string `json:"output"`
	Error  string `json:"error,omitempty"`
}

const runTimeout = 10 * time.Second

func handleRun(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "POST only", http.StatusMethodNotAllowed)
		return
	}

	var req runRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "bad request", http.StatusBadRequest)
		return
	}

	// Write source to temp file.
	f, err := os.CreateTemp("", "decimal64-play-*.go")
	if err != nil {
		writeJSON(w, runResponse{Error: "internal error: " + err.Error()})
		return
	}
	defer os.Remove(f.Name())

	if _, err := f.WriteString(req.Code); err != nil {
		f.Close()
		writeJSON(w, runResponse{Error: "internal error: " + err.Error()})
		return
	}
	f.Close()

	// Run with timeout.
	ctx, cancel := context.WithTimeout(r.Context(), runTimeout)
	defer cancel()

	goBin := filepath.Join(goToolchain, "bin", "go")
	cmd := exec.CommandContext(ctx, goBin, "run", f.Name())
	cmd.Env = append(os.Environ(),
		"GOROOT="+goToolchain,
		"GOEXPERIMENT=",
		"CGO_ENABLED=0",
		"GOCACHE="+goCache,
	)

	out, err := cmd.CombinedOutput()
	resp := runResponse{Output: string(out)}
	if err != nil {
		if ctx.Err() == context.DeadlineExceeded {
			resp.Error = "program timed out (10s limit)"
		} else {
			resp.Error = err.Error()
		}
	}
	writeJSON(w, resp)
}

func writeJSON(w http.ResponseWriter, v any) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(v)
}

func handleIndex(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	// Inject defaultCode as a JSON string so escapes are preserved.
	codeJSON, _ := json.Marshal(defaultCode)
	html := fmt.Sprintf(indexHTML, string(codeJSON))
	fmt.Fprint(w, html)
}

func main() {
	http.HandleFunc("/", handleIndex)
	http.HandleFunc("/api/run", handleRun)

	log.Printf("decimal64 playground listening on http://localhost%s", listenAddr)
	log.Printf("using GOROOT=%s", goToolchain)
	log.Fatal(http.ListenAndServe(listenAddr, nil))
}

const defaultCode = `package main

import "fmt"

func main() {
	// The killer example: 0.1 + 0.2
	var a decimal64 = 0.1
	var b decimal64 = 0.2
	fmt.Printf("0.1 + 0.2 = %v\n", a+b)
	fmt.Printf("0.1 + 0.2 == 0.3? %v\n", a+b == 0.3)

	// Compare with float64
	var fa float64 = 0.1
	var fb float64 = 0.2
	fmt.Printf("\nfloat64: 0.1 + 0.2 = %.20f\n", fa+fb)
	fmt.Printf("float64: 0.1 + 0.2 == 0.3? %v\n", fa+fb == 0.3)

	// Arithmetic
	var x decimal64 = 1.5
	var y decimal64 = 2.5
	fmt.Printf("\n1.5 + 2.5 = %v\n", x+y)
	fmt.Printf("1.5 * 2.5 = %v\n", x*y)
	fmt.Printf("1.5 / 2.5 = %v\n", x/y)

	// Conversions
	var i int64 = 42
	var d decimal64 = decimal64(i)
	fmt.Printf("\nint64(42) as decimal64: %v\n", d)
	fmt.Printf("back to int64: %v\n", int64(d))

	// Map with decimal64 keys
	m := map[decimal64]string{
		0.1: "one tenth",
		0.2: "two tenths",
		0.3: "three tenths",
	}
	fmt.Printf("\nm[0.1+0.2] = %q\n", m[a+b])
}
`

const indexHTML = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>decimal64 playground</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
:root {
  --bg: #1e1e2e;
  --surface: #181825;
  --surface2: #313244;
  --text: #cdd6f4;
  --subtext: #a6adc8;
  --green: #a6e3a1;
  --green-hover: #94e298;
  --red: #f38ba8;
  --blue: #89b4fa;
  --border: #45475a;
  --header: #11111b;
}
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  background: var(--bg);
  color: var(--text);
  height: 100vh;
  display: flex;
  flex-direction: column;
}
header {
  background: var(--header);
  padding: 12px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
header h1 {
  font-size: 18px;
  font-weight: 600;
  color: var(--text);
}
header h1 span {
  color: var(--blue);
  font-family: "SF Mono", "Fira Code", "Consolas", monospace;
}
.btn {
  padding: 8px 20px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s;
}
.btn-run {
  background: var(--green);
  color: var(--header);
}
.btn-run:hover { background: var(--green-hover); }
.btn-run:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.shortcut {
  color: var(--subtext);
  font-size: 12px;
  margin-left: -8px;
}
.spacer { flex: 1; }
.tag {
  font-size: 12px;
  color: var(--subtext);
  background: var(--surface2);
  padding: 4px 10px;
  border-radius: 4px;
}
main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.editor-pane {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
textarea {
  flex: 1;
  background: var(--surface);
  color: var(--text);
  border: none;
  padding: 16px 20px;
  font-family: "SF Mono", "Fira Code", "Consolas", "Liberation Mono", monospace;
  font-size: 14px;
  line-height: 1.6;
  resize: none;
  outline: none;
  tab-size: 4;
  -moz-tab-size: 4;
}
textarea::placeholder { color: var(--subtext); }
.output-pane {
  border-top: 2px solid var(--border);
  min-height: 120px;
  max-height: 40vh;
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
}
.output-header {
  padding: 8px 20px;
  font-size: 12px;
  font-weight: 600;
  color: var(--subtext);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  background: var(--header);
  border-bottom: 1px solid var(--border);
}
.output-content {
  flex: 1;
  overflow: auto;
  padding: 12px 20px;
  background: var(--surface);
  font-family: "SF Mono", "Fira Code", "Consolas", "Liberation Mono", monospace;
  font-size: 14px;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-all;
}
.output-content.error { color: var(--red); }
.output-content.success { color: var(--text); }
.spinner {
  display: inline-block;
  width: 14px;
  height: 14px;
  border: 2px solid var(--header);
  border-top-color: transparent;
  border-radius: 50%%;
  animation: spin 0.6s linear infinite;
  vertical-align: middle;
  margin-right: 6px;
}
@keyframes spin { to { transform: rotate(360deg); } }
</style>
</head>
<body>
<header>
  <h1><span>decimal64</span> playground</h1>
  <div class="spacer"></div>
  <span class="shortcut">Ctrl+Enter</span>
  <button class="btn btn-run" id="runBtn" onclick="runCode()">Run</button>
  <span class="tag">go1.26 + decimal64/decimal128</span>
</header>
<main>
  <div class="editor-pane">
    <textarea id="code" spellcheck="false"></textarea>
  </div>
  <div class="output-pane">
    <div class="output-header">Output</div>
    <div class="output-content" id="output">Click "Run" or press Ctrl+Enter to execute.</div>
  </div>
</main>
<script>
const codeEl = document.getElementById('code');
const outputEl = document.getElementById('output');
const runBtn = document.getElementById('runBtn');

codeEl.value = %s;

// Tab key inserts a real tab.
codeEl.addEventListener('keydown', function(e) {
  if (e.key === 'Tab') {
    e.preventDefault();
    const s = this.selectionStart;
    const end = this.selectionEnd;
    this.value = this.value.substring(0, s) + '\t' + this.value.substring(end);
    this.selectionStart = this.selectionEnd = s + 1;
  }
  if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
    e.preventDefault();
    runCode();
  }
});

async function runCode() {
  runBtn.disabled = true;
  runBtn.innerHTML = '<span class="spinner"></span>Running';
  outputEl.className = 'output-content';
  outputEl.textContent = 'Compiling and running...';

  try {
    const resp = await fetch('/api/run', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({code: codeEl.value}),
    });
    const data = await resp.json();

    if (data.error) {
      outputEl.className = 'output-content error';
      outputEl.textContent = data.output ? data.output + '\n' + data.error : data.error;
    } else {
      outputEl.className = 'output-content success';
      outputEl.textContent = data.output || '(no output)';
    }
  } catch (err) {
    outputEl.className = 'output-content error';
    outputEl.textContent = 'Request failed: ' + err.message;
  } finally {
    runBtn.disabled = false;
    runBtn.textContent = 'Run';
  }
}
</script>
</body>
</html>
`
