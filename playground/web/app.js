// Copyright 2026 Marcelo Cantos. Use of this source code is governed by
// a BSD-style license (see the Go project's LICENSE).

// The playground page: loads the toolchain, keeps a worker ready to compile
// and run, and enforces the run timeout by terminating that worker.
//
// The page loads the toolchain once (cmd/compile and cmd/link as gzipped
// wasm, the standard-library archives as a gzipped tar) and compiles the
// two tools to WebAssembly modules. The checkbox switches the compiler flag
// and the matching standard-library archives; the off-mode library is fetched
// on first use. Each worker receives the selected modules and archives, so
// replacing a worker after a timeout does not fetch again.
//
// Query parameters: ?example=<id> selects an example; ?timeout=<seconds>
// sets the run timeout (1 to 60).
//
// The fragment carries the program for sharing: #<code> is the source,
// UTF-8 encoded, compressed with raw DEFLATE and written as unpadded
// base64url. The page rewrites it (without adding history entries) as the
// program changes, and a fragment on load takes precedence over ?example
// and the saved draft. The fragment is never sent to the server, and a
// shared program only runs when the visitor presses Run.
//
// For the browser journey, <body> carries data-state (loading, ready,
// running, restarting, failed) and, after each run, data-result (run,
// compile, link, import, timeout, output-limit, error) and data-exit-code.
// window.playgroundMetrics holds load and run timings.

"use strict";

const DEFAULT_TIMEOUT_S = 10;
const COMPILE_LIMIT_MS = 120000; // compile and link together
const OUTPUT_LIMIT = 1 << 20; // characters
const DRAFT_KEY = "decimal-playground-draft";
const SHARE_DELAY_MS = 300; // Safari throttles frequent replaceState calls
const MB = 1e6;

// The bundle digest, from this script's own URL (buildsite writes it into
// index.html). Every asset is fetched with it, so a new deploy does not read
// assets the browser cached from an earlier one.
const VERSION = new URL(document.currentScript.src).search;

const $ = (id) => document.getElementById(id);
const codeEl = $("code");
const outputEl = $("output");
const runEl = $("run");
const statusEl = $("status");
const examplesEl = $("examples");
const decimalEl = $("decimal");

const params = new URLSearchParams(location.search);
const timeoutS = Math.min(60, Math.max(1, Number(params.get("timeout")) || DEFAULT_TIMEOUT_S));

const metrics = { navigationToReadyMs: null, runs: [] };
window.playgroundMetrics = metrics;

let toolchain = null; // shared compiler modules and the selected stdlib
const stdlibs = new Map(); // mode -> loaded archives; off is fetched on first use
let worker = null;
let current = null; // the run in progress
let carryStatus = ""; // shown with "Ready" after a worker restart

function setState(state) {
	document.body.dataset.state = state;
	runEl.disabled = state !== "ready";
	decimalEl.disabled = state !== "ready";
}

function setStatus(text) {
	statusEl.textContent = text;
}

function seconds(ms) {
	return `${(ms / 1000).toFixed(2)} s`;
}

// Output arrives one message per write; it is gathered here and added to
// the page once per animation frame.
let pendingOutput = [];
let outputFrame = 0;

function append(text, cls) {
	const last = pendingOutput.at(-1);
	if (last && last.cls === cls) last.text += text;
	else pendingOutput.push({ text, cls });
	if (!outputFrame) outputFrame = requestAnimationFrame(flushOutput);
}

function flushOutput() {
	cancelAnimationFrame(outputFrame);
	outputFrame = 0;
	for (const { text, cls } of pendingOutput) {
		if (cls) {
			const span = document.createElement("span");
			span.className = cls;
			span.textContent = text;
			outputEl.appendChild(span);
		} else {
			outputEl.appendChild(document.createTextNode(text));
		}
	}
	pendingOutput = [];
}

function saveDraft() {
	try {
		localStorage.setItem(DRAFT_KEY, codeEl.value);
	} catch {
		// Storage can be unavailable (private windows, blocked site data).
	}
}

// encodeShare and decodeShare convert between source and the fragment form.
async function encodeShare(code) {
	const stream = new Blob([code]).stream().pipeThrough(new CompressionStream("deflate-raw"));
	const bytes = new Uint8Array(await new Response(stream).arrayBuffer());
	let bin = "";
	for (const b of bytes) bin += String.fromCharCode(b);
	return btoa(bin).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

async function decodeShare(text) {
	const bin = atob(text.replace(/-/g, "+").replace(/_/g, "/"));
	const bytes = Uint8Array.from(bin, (c) => c.charCodeAt(0));
	const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream("deflate-raw"));
	return new TextDecoder("utf-8", { fatal: true }).decode(await new Response(stream).arrayBuffer());
}

// sharedCode returns the program in the fragment, or null if there is none
// or it does not decode.
async function sharedCode() {
	const text = location.hash.slice(1);
	if (!text) return null;
	try {
		return await decodeShare(text);
	} catch {
		return null;
	}
}

let shareTimer = null;
let shareSeq = 0;

// updateShare rewrites the fragment to the current program, after a pause
// in typing. Until then the old fragment is stale, so it is dropped at
// once: a reload in the meantime must load the draft, not the program the
// fragment held. That keeps it to two replaceState calls per pause.
function updateShare() {
	const seq = ++shareSeq;
	clearTimeout(shareTimer);
	if (location.hash) {
		try {
			history.replaceState(history.state, "", location.pathname + location.search);
		} catch {
			// Over a browser's replaceState rate limit.
		}
	}
	shareTimer = setTimeout(async () => {
		const encoded = await encodeShare(codeEl.value);
		if (seq !== shareSeq) return; // a later edit has overtaken this one
		try {
			history.replaceState(history.state, "", "#" + encoded);
		} catch {
			// Over a browser's replaceState rate limit; the next edit retries.
		}
	}, SHARE_DELAY_MS);
}

function loadDraft() {
	try {
		return localStorage.getItem(DRAFT_KEY);
	} catch {
		return null;
	}
}

// fetchGunzip fetches a gzipped asset, decompresses it and reports the
// compressed bytes received.
async function fetchGunzip(url, onBytes) {
	const resp = await fetch(url + VERSION);
	if (!resp.ok) throw new Error(`${url}: ${resp.status} ${resp.statusText}`);
	const counted = resp.body.pipeThrough(new TransformStream({
		transform(chunk, controller) {
			onBytes(chunk.byteLength);
			controller.enqueue(chunk);
		},
	}));
	const raw = counted.pipeThrough(new DecompressionStream("gzip"));
	return new Uint8Array(await new Response(raw).arrayBuffer());
}

// untar reads the regular files of a ustar archive.
function untar(bytes, prefix) {
	const files = [];
	const text = new TextDecoder();
	const field = (off, len) => text.decode(bytes.subarray(off, off + len)).replace(/\0.*$/s, "");
	for (let off = 0; off + 512 <= bytes.length;) {
		const name = field(off, 100);
		if (name === "") break;
		const size = parseInt(field(off + 124, 12).trim(), 8);
		const type = field(off + 156, 1);
		if (type === "0" || type === "") {
			files.push([prefix + name, bytes.slice(off + 512, off + 512 + size)]);
		}
		off += 512 + Math.ceil(size / 512) * 512;
	}
	return files;
}

async function loadStdlib(info, progress) {
	const text = async (path) => {
		const response = await fetch(path + VERSION);
		if (!response.ok) throw new Error(`${path}: ${response.status} ${response.statusText}`);
		return response.text();
	};
	const [std, compile, link] = await Promise.all([
		fetchGunzip(info.std.path, progress), text(info.importcfg_compile), text(info.importcfg_link),
	]);
	return { files: untar(std, "/std/"), importcfg: { compile, link }, offered: info.offered };
}

async function loadToolchain(info) {
	const total = info.compile.size + info.link.size + info.std.size;
	let received = 0;
	const progress = (n) => {
		received += n;
		setStatus(`Loading the compiler… ${(received / MB).toFixed(1)} of ${(total / MB).toFixed(1)} MB`);
	};
	progress(0);
	const [compile, link, stdlib] = await Promise.all([
		fetchGunzip(info.compile.path, progress),
		fetchGunzip(info.link.path, progress),
		loadStdlib(info, progress),
	]);
	setStatus("Preparing the compiler…");
	const [compileMod, linkMod] = await Promise.all([WebAssembly.compile(compile), WebAssembly.compile(link)]);
	return {
		compile: compileMod, link: linkMod, compileBytes: compile, linkBytes: link,
		stdlib,
	};
}

// startWorker creates a worker and hands it the toolchain. Modules are
// shared with the worker without copying where the browser allows it;
// otherwise the worker compiles the bytes itself.
function startWorker() {
	worker = new Worker("worker.js" + VERSION);
	worker.onmessage = onWorkerMessage;
	worker.onerror = (e) => {
		append(`\nplayground: worker error: ${e.message}\n`, "stderr");
		setStatus("The playground failed to start. Reload the page to try again.");
		setState("failed");
	};
	const msg = { type: "init", ...toolchain.stdlib, decimal: decimalEl.checked };
	try {
		worker.postMessage({ ...msg, compile: toolchain.compile, link: toolchain.link });
		// Modules can be posted in this browser, so the bytes are not needed.
		toolchain.compileBytes = toolchain.linkBytes = null;
	} catch (e) {
		if (e.name !== "DataCloneError") throw e;
		worker.postMessage({ ...msg, compile: toolchain.compileBytes, link: toolchain.linkBytes });
	}
}

function stopWorker(result, notice, status) {
	worker.terminate();
	clearTimeout(current.timer);
	append(notice, "notice");
	finish(result, -1, status);
	carryStatus = status;
	setState("restarting");
	startWorker();
}

function finish(result, exitCode, status) {
	clearTimeout(current.timer);
	flushOutput();
	const run = current;
	run.totalMs = performance.now() - run.start;
	metrics.runs.push({ result, exitCode, totalMs: run.totalMs, ...run.timings });
	document.body.dataset.result = result;
	document.body.dataset.exitCode = String(exitCode);
	setStatus(status);
	current = null;
}

function onWorkerMessage(e) {
	const msg = e.data;
	switch (msg.type) {
	case "ready":
		setState("ready");
		setStatus(carryStatus ? `${carryStatus} Ready to run again.` : "Ready.");
		carryStatus = "";
		if (metrics.navigationToReadyMs === null) metrics.navigationToReadyMs = performance.now();
		break;
	case "phase":
		if (!current) break;
		clearTimeout(current.timer);
		if (msg.phase === "run") {
			setStatus("Running…");
			current.timer = setTimeout(() => stopWorker("timeout",
				`\n[The program ran for more than ${timeoutS} seconds and was stopped.]\n`,
				`Timed out after ${timeoutS} s.`), timeoutS * 1000);
		} else {
			setStatus(msg.phase === "compile" ? "Compiling…" : "Linking…");
			current.timer = setTimeout(() => stopWorker("error",
				"\n[Compiling took too long and was stopped.]\n", "Compilation timed out."), COMPILE_LIMIT_MS);
		}
		break;
	case "output":
		if (!current) break;
		current.chars += msg.text.length;
		append(msg.text, msg.fd === 2 ? "stderr" : "");
		if (current.chars > OUTPUT_LIMIT) {
			stopWorker("output-limit", "\n[The program wrote more than 1 MB of output and was stopped.]\n",
				"Output limit exceeded.");
		}
		break;
	case "done": {
		if (!current) break;
		const t = msg.timings;
		current.timings = t;
		const times = [
			t.compile !== undefined ? `compiled in ${seconds(t.compile)}` : "",
			t.link !== undefined ? `linked in ${seconds(t.link)}` : "",
			t.run !== undefined ? `ran in ${seconds(t.run)}` : "",
		].filter(Boolean).join(", ");
		let status;
		if (msg.result === "run" && msg.exitCode === 0) {
			status = times.charAt(0).toUpperCase() + times.slice(1) + ".";
		} else if (msg.result === "run") {
			status = `Program exited with status ${msg.exitCode} (${times}).`;
		} else if (msg.result === "compile") {
			status = "Compilation failed.";
		} else if (msg.result === "link") {
			status = "Linking failed.";
		} else if (msg.result === "import") {
			status = "Import not available.";
		} else {
			status = "The playground hit an internal error.";
		}
		if (msg.result === "run" && msg.exitCode !== 0) {
			append(`\n[exit status ${msg.exitCode}]\n`, "notice");
		}
		finish(msg.result, msg.exitCode, status);
		setState("ready");
		break;
	}
	}
}

function run() {
	if (document.body.dataset.state !== "ready") return;
	pendingOutput = [];
	outputEl.textContent = "";
	delete document.body.dataset.result;
	delete document.body.dataset.exitCode;
	current = { start: performance.now(), timer: null, chars: 0, timings: {} };
	setState("running");
	setStatus("Compiling…");
	worker.postMessage({ type: "run", code: codeEl.value });
}

async function main() {
	$("limit").textContent = String(timeoutS);
	const [info, examples] = await Promise.all([
		fetch("build.json" + VERSION).then((r) => r.json()),
		fetch("examples.json" + VERSION).then((r) => r.json()),
	]);

	$("packages").textContent = info.offered.join(", ");
	const fork = $("fork");
	fork.href = `https://github.com/marcelocantos/go/tree/${info.fork_sha}`;
	fork.textContent = `marcelocantos/go@${info.fork_sha.slice(0, 10)}`;

	for (const ex of examples) {
		const opt = document.createElement("option");
		opt.value = ex.id;
		opt.textContent = ex.title;
		examplesEl.appendChild(opt);
	}
	const byId = new Map(examples.map((ex) => [ex.id, ex]));
	const custom = document.createElement("option");
	custom.value = "";
	custom.textContent = "Your program";

	// showCode puts a program in the editor, selecting its example if it is
	// one and "Your program" otherwise.
	function showCode(code) {
		const ex = examples.find((e) => e.code === code);
		if (ex) {
			custom.remove();
			examplesEl.value = ex.id;
		} else {
			examplesEl.prepend(custom);
			examplesEl.value = "";
		}
		codeEl.value = code;
	}

	const shared = await sharedCode();
	const requested = byId.get(params.get("example"));
	const draft = shared === null && !requested ? loadDraft() : null;
	// A shared program is not saved as the draft until the visitor edits it,
	// so opening a link does not overwrite their own program.
	showCode(shared ?? requested?.code ?? draft ?? examples[0].code);
	updateShare();

	examplesEl.addEventListener("change", () => {
		const ex = byId.get(examplesEl.value);
		if (!ex) return;
		codeEl.value = ex.code;
		saveDraft();
		updateShare();
	});
	codeEl.addEventListener("input", () => {
		if (!custom.isConnected) examplesEl.prepend(custom);
		examplesEl.value = "";
		saveDraft();
		updateShare();
	});
	// A fragment edited or pasted into the address bar loads that program.
	// (replaceState does not fire hashchange, so the page's own rewrites
	// do not come back here.)
	window.addEventListener("hashchange", async () => {
		clearTimeout(shareTimer);
		const seq = ++shareSeq;
		const code = await sharedCode();
		if (seq !== shareSeq || code === null || code === codeEl.value) return;
		showCode(code);
	});
	codeEl.addEventListener("keydown", (e) => {
		if (e.key === "Enter" && (e.ctrlKey || e.metaKey)) {
			e.preventDefault();
			run();
		} else if (e.key === "Tab" && !e.shiftKey && !e.altKey && !e.ctrlKey && !e.metaKey) {
			e.preventDefault();
			document.execCommand("insertText", false, "\t");
		}
	});
	runEl.addEventListener("click", run);
	decimalEl.addEventListener("change", async () => {
		setState("loading");
		worker.terminate();
		carryStatus = "";
		const mode = decimalEl.checked ? "decimal" : "nodecimal";
		try {
			if (!stdlibs.has(mode)) {
				const lib = info.nodecimal;
				let received = 0;
				const progress = (n) => {
					received += n;
					setStatus(`Loading the standard library… ${(received / MB).toFixed(1)} of ${(lib.std.size / MB).toFixed(1)} MB`);
				};
				progress(0);
				stdlibs.set(mode, await loadStdlib(lib, progress));
			}
			toolchain.stdlib = stdlibs.get(mode);
			$("packages").textContent = toolchain.stdlib.offered.join(", ");
			delete document.body.dataset.result;
			delete document.body.dataset.exitCode;
			setStatus("Preparing the compiler…");
			startWorker();
		} catch (err) {
			setStatus(`The standard library failed to load: ${err.message}. Reload to try again.`);
			setState("failed");
		}
	});

	// Restoration and all edit handlers are ready before input is enabled.
	// The editor remains usable while the larger compiler assets download.
	codeEl.disabled = false;
	examplesEl.disabled = false;
	toolchain = await loadToolchain(info);
	stdlibs.set("decimal", toolchain.stdlib);
	// Browsers may restore form controls on reload. Initial archives are
	// enabled, so reset the checkbox to match before starting the compiler.
	decimalEl.checked = true;
	startWorker();
}

main().catch((err) => {
	setStatus(`The playground failed to load: ${err.message}`);
	append(String(err && err.stack ? err.stack : err), "stderr");
	setState("failed");
});
