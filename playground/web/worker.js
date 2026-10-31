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
//               where importcfg is {compile, link}
//               {type: "run", code}
// Messages out: {type: "ready"} {type: "phase", phase}
//               {type: "output", fd, text}
//               {type: "done", result, exitCode, timings}

"use strict";

const VERSION = self.location.search; // the bundle digest; see app.js
importScripts("memfs.js" + VERSION);
const memfs = new MemFS();
memfs.install();
importScripts("wasm_exec.js" + VERSION);

const WORK = "/work";
const PROG = "prog.go";
const OBJ = WORK + "/prog.a";
const EXE = WORK + "/prog.wasm";
const IMPORTCFG_COMPILE = "/std/importcfg.compile"; // the offered packages only
const IMPORTCFG_LINK = "/std/importcfg.link"; // their whole import closure
const ENV = { HOME: "/home", TMPDIR: "/tmp", PATH: "/bin" };

let tools = null; // {compile, link}: WebAssembly.Module
let offered = [];
let stdDir = null; // the /std directory: archives and importcfgs

// Every write is posted as it happens: a program that never yields gives
// the worker no later chance to send what it buffered. The page coalesces
// the messages for display.
let decoder = { 1: new TextDecoder(), 2: new TextDecoder() };
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

// unquote decodes a Go string literal, or returns null if it is not one.
function unquote(lit) {
	if (lit.length < 2 || lit.at(-1) !== lit[0]) return null;
	const body = lit.slice(1, -1);
	if (lit[0] === "`") return body.replaceAll("\r", "");
	const simple = { a: 7, b: 8, f: 12, n: 10, r: 13, t: 9, v: 11, "\\": 92, '"': 34 };
	const part = /\\(?:([abfnrtv\\"])|x([0-9a-fA-F]{2})|([0-7]{3})|u([0-9a-fA-F]{4})|U([0-9a-fA-F]{8}))|[^\\]+/guy;
	const encoder = new TextEncoder();
	const bytes = [];
	let end = 0;
	for (let m; end < body.length && (m = part.exec(body)) !== null; end = part.lastIndex) {
		if (m[1]) bytes.push(simple[m[1]]);
		else if (m[2]) bytes.push(parseInt(m[2], 16));
		else if (m[3]) {
			const n = parseInt(m[3], 8);
			if (n > 255) return null;
			bytes.push(n);
		} else if (m[4] || m[5]) {
			const n = parseInt(m[4] || m[5], 16);
			if (n > 0x10ffff || (n >= 0xd800 && n < 0xe000)) return null;
			bytes.push(...encoder.encode(String.fromCodePoint(n)));
		} else bytes.push(...encoder.encode(m[0]));
	}
	return end === body.length ? new TextDecoder().decode(Uint8Array.from(bytes)) : null;
}

// imports returns the import paths of a Go source file, reading no further
// than its import declarations, or null when it cannot tell what they are.
//
// This gives a refused import a helpful message, and it is what refuses
// unsafe, which the compiler provides itself whatever its importcfg says.
// Every other unoffered package is refused by the compiler too, since its
// importcfg lists only the offered packages. A source this cannot read goes
// to the compiler to be diagnosed, but does not get to run.
function imports(src) {
	const re = /\s+|\/\/[^\n]*|\/\*[\s\S]*?\*\/|"(?:[^"\\\n]|\\.)*"|`[^`]*`|[\p{L}_][\p{L}\p{Nd}_]*|./guy;
	const next = () => {
		for (let m; (m = re.exec(src)) !== null;) {
			if (!/^\s/.test(m[0]) && !m[0].startsWith("//") && !m[0].startsWith("/*")) return m[0];
		}
		return "";
	};
	const ident = (t) => /^[\p{L}_]/u.test(t);
	let tok = next();
	if (tok !== "package" || !ident(next())) return null;
	tok = next();
	if (tok === ";") tok = next();
	const paths = [];
	const spec = () => {
		if (tok === "." || ident(tok)) tok = next();
		const path = /^["`]/.test(tok) ? unquote(tok) : null;
		if (path === null) return false;
		paths.push(path);
		tok = next();
		if (tok === ";") tok = next();
		return true;
	};
	while (tok === "import") {
		tok = next();
		if (tok === "(") {
			tok = next();
			while (tok !== ")") {
				if (!spec()) return null;
			}
			tok = next();
			if (tok === ";") tok = next();
		} else if (!spec()) {
			return null;
		}
	}
	return paths;
}

async function run(code) {
	const timings = {};

	// Each run starts from a new filesystem holding only the toolchain, so
	// nothing an earlier program did can affect it.
	memfs.root = memfs.newDir(0o755);
	memfs.root.children.set("std", stdDir);
	memfs.fds.clear();
	for (const dir of [WORK, "/tmp", "/home"]) memfs.mkdirAll(dir);
	memfs.cwd = WORK;
	memfs.writeFile(WORK + "/" + PROG, new TextEncoder().encode(code));
	decoder = { 1: new TextDecoder(), 2: new TextDecoder() };

	const scanned = imports(code);
	const unavailable = (scanned || []).filter((p) => !offered.includes(p));
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
		"-importcfg", IMPORTCFG_COMPILE, PROG,
	]);
	timings.compile = performance.now() - t0;
	if (status !== 0) {
		postMessage({ type: "done", result: "compile", exitCode: status, timings });
		return;
	}
	if (scanned === null) {
		postMessage({ type: "output", fd: 2, text: `${PROG}: the playground could not read this program's imports, so it will not run it.\n` });
		postMessage({ type: "done", result: "import", exitCode: 1, timings });
		return;
	}

	postMessage({ type: "phase", phase: "link" });
	t0 = performance.now();
	status = await runGo(tools.link, ["link", "-o", EXE, "-importcfg", IMPORTCFG_LINK, "-buildmode=exe", OBJ]);
	timings.link = performance.now() - t0;
	if (status !== 0) {
		postMessage({ type: "done", result: "link", exitCode: status, timings });
		return;
	}

	const exe = await WebAssembly.compile(memfs.readFile(EXE));
	memfs.removeAll(OBJ);
	memfs.removeAll(EXE);
	// The program does not see the toolchain: the next run needs it intact.
	memfs.root.children.delete("std");
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
			memfs.writeFile(IMPORTCFG_COMPILE, new TextEncoder().encode(msg.importcfg.compile));
			memfs.writeFile(IMPORTCFG_LINK, new TextEncoder().encode(msg.importcfg.link));
			stdDir = memfs.root.children.get("std");
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
