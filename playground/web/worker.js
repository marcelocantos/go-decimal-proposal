// Copyright 2026 Marcelo Cantos. Use of this source code is governed by
// a BSD-style license (see the Go project's LICENSE).

// The playground's Web Worker: compiles, links and runs one Go program.
//
// The go command does not run in a browser, so this does what it would do
// for a single-file main package: run cmd/compile, then cmd/link, both
// built for js/wasm, against precompiled standard-library archives named by
// an importcfg. All files live in an in-memory filesystem (memfs.js). The
// linked program is a third wasm module, run here with its stdout and
// stderr sent to the page.
//
// The page enforces the run timeout by terminating this worker, which is
// the only way to stop a Go program that never yields.
//
// Messages in:  {type: "init", compile, link, files, importcfg, offered}
//               {type: "run", code}
// Messages out: {type: "ready"} {type: "phase", phase}
//               {type: "output", fd, text}
//               {type: "done", result, exitCode, timings}

"use strict";

importScripts("memfs.js");
const memfs = new MemFS();
memfs.install();
importScripts("wasm_exec.js");

const WORK = "/work";
const PROG = "prog.go";
const OBJ = WORK + "/prog.a";
const EXE = WORK + "/prog.wasm";
const IMPORTCFG = "/std/importcfg";
const ENV = { HOME: "/home", TMPDIR: "/tmp", PATH: "/bin" };

let tools = null; // {compile, link}: WebAssembly.Module
let offered = [];

// Every write is posted as it happens: a program that never yields gives
// the worker no later chance to send what it buffered. The page coalesces
// the messages for display.
const decoder = { 1: new TextDecoder(), 2: new TextDecoder() };
memfs.onOutput = (fd, bytes) => {
	const text = decoder[fd].decode(bytes, { stream: true });
	if (text !== "") postMessage({ type: "output", fd, text });
};

// runGo runs a wasm module as a Go command and resolves to its exit code.
async function runGo(module, argv) {
	const go = new Go();
	go.argv = argv;
	go.env = ENV;
	let exitCode = 0;
	go.exit = (code) => { exitCode = code; };
	const instance = await WebAssembly.instantiate(module, go.importObject);
	await go.run(instance);
	return exitCode;
}

// imports returns the import paths of a Go source file, or null when the
// source is too malformed to tell (the compiler will then report why).
function imports(src) {
	const tokens = [];
	const re = /\s+|\/\/[^\n]*|\/\*[\s\S]*?\*\/|"(?:[^"\\\n]|\\.)*"|`[^`]*`|[\p{L}_][\p{L}\p{Nd}_]*|./guy;
	let m;
	while ((m = re.exec(src)) !== null && tokens.length < 4096) {
		const t = m[0];
		if (/^\s/.test(t) || t.startsWith("//") || t.startsWith("/*")) continue;
		tokens.push(t);
	}
	let i = 0;
	const ident = (t) => /^[\p{L}_]/u.test(t || "");
	if (tokens[i++] !== "package" || !ident(tokens[i++])) return null;
	if (tokens[i] === ";") i++;
	const paths = [];
	const spec = () => {
		if (tokens[i] === "." || ident(tokens[i])) i++;
		const t = tokens[i++] || "";
		if (!/^["`]/.test(t)) return false;
		paths.push(t.startsWith("`") ? t.slice(1, -1) : JSON.parse(t));
		if (tokens[i] === ";") i++;
		return true;
	};
	while (tokens[i] === "import") {
		i++;
		if (tokens[i] === "(") {
			i++;
			while (tokens[i] !== ")") {
				if (i >= tokens.length || !spec()) return null;
			}
			i++;
			if (tokens[i] === ";") i++;
		} else if (!spec()) {
			return null;
		}
	}
	return paths;
}

async function run(code) {
	const timings = {};
	memfs.removeAll(WORK);
	memfs.mkdirAll(WORK);
	memfs.cwd = WORK;
	memfs.writeFile(WORK + "/" + PROG, new TextEncoder().encode(code));

	const unavailable = (imports(code) || []).filter((p) => !offered.includes(p));
	if (unavailable.length > 0) {
		const names = unavailable.map((p) => `"${p}"`).join(", ");
		const one = unavailable.length === 1;
		// The list is wrapped: the output pane does not wrap lines.
		const lines = [];
		for (const pkg of offered) {
			const item = pkg + (pkg === offered.at(-1) ? "." : ",");
			if (lines.length > 0 && lines.at(-1).length + 1 + item.length <= 60) lines[lines.length - 1] += " " + item;
			else lines.push(item);
		}
		const msg = `${PROG}: ${one ? "package" : "packages"} ${names} ${one ? "is" : "are"} ` +
			`not available in this playground.\nThe packages available are:\n` +
			lines.map((l) => "\t" + l + "\n").join("");
		postMessage({ type: "output", fd: 2, text: msg });
		postMessage({ type: "done", result: "import", exitCode: 1, timings });
		return;
	}

	postMessage({ type: "phase", phase: "compile" });
	let t0 = performance.now();
	let status = await runGo(tools.compile, [
		"compile", "-o", OBJ, "-p", "main", "-complete", "-pack", "-c=1", "-trimpath", WORK,
		"-importcfg", IMPORTCFG, PROG,
	]);
	timings.compile = performance.now() - t0;
	if (status !== 0) {
		postMessage({ type: "done", result: "compile", exitCode: status, timings });
		return;
	}

	postMessage({ type: "phase", phase: "link" });
	t0 = performance.now();
	status = await runGo(tools.link, ["link", "-o", EXE, "-importcfg", IMPORTCFG, "-buildmode=exe", OBJ]);
	timings.link = performance.now() - t0;
	if (status !== 0) {
		postMessage({ type: "done", result: "link", exitCode: status, timings });
		return;
	}

	const exe = await WebAssembly.compile(memfs.readFile(EXE));
	memfs.removeAll(OBJ);
	memfs.removeAll(EXE);
	postMessage({ type: "phase", phase: "run" });
	t0 = performance.now();
	status = await runGo(exe, ["prog"]);
	timings.run = performance.now() - t0;
	postMessage({ type: "done", result: "run", exitCode: status, timings });
}

self.onmessage = async (e) => {
	const msg = e.data;
	try {
		if (msg.type === "init") {
			const asModule = (m) => (m instanceof WebAssembly.Module ? m : WebAssembly.compile(m));
			tools = { compile: await asModule(msg.compile), link: await asModule(msg.link) };
			for (const [path, bytes] of msg.files) memfs.writeFile(path, bytes);
			memfs.writeFile(IMPORTCFG, new TextEncoder().encode(msg.importcfg));
			memfs.mkdirAll("/tmp");
			memfs.mkdirAll("/home");
			offered = msg.offered;
			postMessage({ type: "ready" });
		} else if (msg.type === "run") {
			await run(msg.code);
		}
	} catch (err) {
		postMessage({ type: "output", fd: 2, text: `\nplayground: ${err && err.stack ? err.stack : err}\n` });
		postMessage({ type: "done", result: "error", exitCode: -1, timings: {} });
	}
};
