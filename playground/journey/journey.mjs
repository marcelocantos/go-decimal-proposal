// Headless-browser journey for the static playground.
//
//	node journey.mjs [--site DIR] [--browser chromium|firefox|webkit]
//	                 [--shots DIR] [--metrics FILE] [--serve]
//
// Serves the built bundle (site/ by default) from a local static server,
// loads the page in a fresh browser profile, runs every bundled example and
// compares its output with the expected output committed beside it
// (playground/examples/<id>.out, which tools/buildsite checks against
// native go run on the pinned toolchain). It then checks that an import
// outside the shipped set names the available packages, that a compile
// error shows the compiler's message, and that a program that never ends is
// stopped by the run timeout and the playground recovers.
//
// It records first-load transfer size and time, and compile-and-run time
// for the default example, and with --shots takes screenshots at desktop
// and phone widths after checking the page does not scroll sideways.
//
// --serve only starts the static server, for looking at the page by hand.

import { chromium, firefox, webkit } from "playwright";
import { createServer } from "node:http";
import { readFile, mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const repo = path.resolve(here, "../..");
const args = Object.fromEntries(process.argv.slice(2).reduce((acc, a, i, all) => {
	if (a.startsWith("--")) acc.push([a.slice(2), all[i + 1] && !all[i + 1].startsWith("--") ? all[i + 1] : true]);
	return acc;
}, []));
const site = path.resolve(args.site || path.join(repo, "site"));
const examplesDir = path.join(repo, "playground/examples");
const RUN_TIMEOUT_S = 3; // the page's run timeout for this journey
const PAGES_PATH = "/go-decimal-proposal/"; // served as GitHub Pages serves it
const RUN_WAIT_MS = 120000;
const LOAD_WAIT_MS = 300000;

const types = {
	".html": "text/html; charset=utf-8", ".js": "text/javascript; charset=utf-8", ".css": "text/css; charset=utf-8",
	".json": "application/json", ".gz": "application/gzip", ".txt": "text/plain; charset=utf-8",
};

function serve(root) {
	const server = createServer(async (req, res) => {
		let rel = decodeURIComponent(new URL(req.url, "http://x").pathname);
		if (!rel.startsWith(PAGES_PATH)) {
			res.writeHead(404).end("not found");
			return;
		}
		rel = rel.slice(PAGES_PATH.length - 1);
		if (rel.endsWith("/")) rel += "index.html";
		const file = path.join(root, path.normalize(rel));
		if (!file.startsWith(root + path.sep)) {
			res.writeHead(403).end();
			return;
		}
		try {
			const body = await readFile(file);
			res.writeHead(200, { "Content-Type": types[path.extname(file)] || "application/octet-stream" });
			res.end(body);
		} catch {
			res.writeHead(404).end("not found");
		}
	});
	return new Promise((resolve) => server.listen(Number(args.port) || 0, "127.0.0.1", () => resolve(server)));
}

const failures = [];
function check(ok, what, detail = "") {
	console.log(`${ok ? "PASS" : "FAIL"}  ${what}${!ok && detail ? `\n${detail}` : ""}`);
	if (!ok) failures.push(what);
}

// runProgram runs whatever is in the editor and waits for the result.
async function runProgram(page) {
	await page.click("#run");
	await page.waitForFunction(() => document.body.dataset.state !== "ready", null, { timeout: 5000 }).catch(() => {});
	await page.waitForFunction(() => document.body.dataset.result && document.body.dataset.state !== "running",
		null, { timeout: RUN_WAIT_MS });
	return page.evaluate(() => ({
		result: document.body.dataset.result,
		exitCode: Number(document.body.dataset.exitCode),
		output: document.getElementById("output").textContent,
		status: document.getElementById("status").textContent,
		metrics: window.playgroundMetrics.runs.at(-1),
	}));
}

async function waitReady(page) {
	await page.waitForFunction(() => document.body.dataset.state === "ready", null, { timeout: LOAD_WAIT_MS });
}

async function shot(name) {
	if (!args.shots) return;
	await mkdir(args.shots, { recursive: true });
	await page.screenshot({ path: path.join(args.shots, `${name}.png`), fullPage: true });
}

async function setCode(page, code) {
	await page.fill("#code", code);
}

const server = await serve(site);
const origin = `http://127.0.0.1:${server.address().port}${PAGES_PATH}`;
if (args.serve) {
	console.log(`serving ${site} at ${origin}`);
	await new Promise(() => {});
}

const browserType = { chromium, firefox, webkit }[args.browser || "chromium"];
const browser = await browserType.launch();
const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
const page = await context.newPage();
page.on("pageerror", (err) => check(false, `no uncaught page error`, String(err)));

const transfers = [];
page.on("requestfinished", async (req) => {
	const sizes = await req.sizes().catch(() => null);
	if (sizes) transfers.push({ url: req.url(), bytes: sizes.responseBodySize + sizes.responseHeadersSize });
});

const report = { browser: `${browserType.name()} ${browser.version()}`, site, examples: {} };

// First load, cold cache.
await page.goto(`${origin}?timeout=${RUN_TIMEOUT_S}`);
await waitReady(page);
report.firstLoad = {
	readyMs: await page.evaluate(() => window.playgroundMetrics.navigationToReadyMs),
	transferBytes: transfers.reduce((n, t) => n + t.bytes, 0),
	requests: transfers.map((t) => ({ path: new URL(t.url).pathname, bytes: t.bytes })),
};
check(true, `page loaded in ${(report.firstLoad.readyMs / 1000).toFixed(2)} s, ` +
	`${(report.firstLoad.transferBytes / 1e6).toFixed(2)} MB transferred`);

// Every bundled example, in the page's order. The first is the default.
const manifest = JSON.parse(await readFile(path.join(examplesDir, "examples.json"), "utf8"));
const defaultId = await page.$eval("#examples", (el) => el.value);
check(defaultId === manifest[0].id, `default example is ${manifest[0].id}`, `got ${defaultId}`);
for (const ex of manifest) {
	await page.selectOption("#examples", ex.id);
	const want = await readFile(path.join(examplesDir, `${ex.id}.out`), "utf8");
	const got = await runProgram(page);
	report.examples[ex.id] = { result: got.result, exitCode: got.exitCode, matches: got.output === want, ...got.metrics };
	check(got.result === "run" && got.exitCode === 0 && got.output === want,
		`example ${ex.id} matches native go run (${(got.metrics.totalMs / 1000).toFixed(2)} s)`,
		`result=${got.result} exit=${got.exitCode}\n--- want\n${want}--- got\n${got.output}`);
}

// The default example again, now that the worker has run once.
await page.selectOption("#examples", manifest[0].id);
const warm = await runProgram(page);
report.defaultExample = { id: manifest[0].id, first: report.examples[manifest[0].id], again: warm.metrics };

// An import outside the shipped set names the packages available.
const offered = JSON.parse(await readFile(path.join(site, "build.json"), "utf8")).offered;
await setCode(page, `package main

import (
	"fmt"
	"net/http"
)

func main() { fmt.Println(http.StatusOK) }
`);
let got = await runProgram(page);
check(got.result === "import" && got.output.includes(`"net/http" is not available`) &&
	got.output.includes("The packages available are:\n") &&
	got.output.split("The packages available are:")[1].split(/[\s,.]+/).filter(Boolean).join(" ") === offered.join(" "),
	"an unavailable import names the packages available", got.output);
await shot("import");

// A compile error shows the compiler's message.
await setCode(page, `package main

import "fmt"

func main() {
	fmt.Println(x)
}
`);
got = await runProgram(page);
check(got.result === "compile" && got.output.includes("prog.go:6:14: undefined: x"),
	"a compile error shows the compiler's message", got.output);

// A program that never ends is stopped by the timeout, its earlier output
// is kept, and the playground recovers with a fresh worker.
await setCode(page, `package main

import "fmt"

func main() {
	fmt.Println("before the loop")
	for {
	}
}
`);
const loopStart = Date.now();
got = await runProgram(page);
const loopMs = Date.now() - loopStart;
check(got.result === "timeout" && got.output.startsWith("before the loop\n") &&
	got.output.includes(`ran for more than ${RUN_TIMEOUT_S} seconds and was stopped`) &&
	loopMs < (RUN_TIMEOUT_S + 30) * 1000,
	`an endless loop is stopped by the ${RUN_TIMEOUT_S} s timeout`, got.output);
await shot("timeout");
await waitReady(page);
await page.selectOption("#examples", manifest[0].id);
got = await runProgram(page);
const want0 = await readFile(path.join(examplesDir, `${manifest[0].id}.out`), "utf8");
check(got.result === "run" && got.output === want0, "the playground runs again after a timeout", got.output);

// Layout: no sideways scrolling, controls inside the viewport.
async function layout(width, height, name, colorScheme) {
	await page.setViewportSize({ width, height });
	await page.emulateMedia({ colorScheme });
	await page.selectOption("#examples", manifest[0].id);
	await runProgram(page);
	const geo = await page.evaluate(() => {
		const r = (id) => document.getElementById(id).getBoundingClientRect();
		return {
			scrollWidth: document.documentElement.scrollWidth,
			clientWidth: document.documentElement.clientWidth,
			run: r("run").toJSON(), examples: r("examples").toJSON(),
			code: r("code").toJSON(), output: r("output").toJSON(),
		};
	});
	check(geo.scrollWidth <= geo.clientWidth, `${name}: no horizontal page scroll`,
		`scrollWidth ${geo.scrollWidth} > clientWidth ${geo.clientWidth}`);
	for (const k of ["run", "examples", "code", "output"]) {
		check(geo[k].left >= 0 && geo[k].right <= geo.clientWidth, `${name}: #${k} within the viewport`, JSON.stringify(geo[k]));
	}
	await shot(name);
}
await layout(1280, 900, "desktop", "light");
await layout(1280, 900, "desktop-dark", "dark");
await layout(390, 844, "phone", "light");
await layout(390, 844, "phone-dark", "dark");

// Optionally, first load again over an emulated network (Chromium only):
// --throttle-mbps 50 --throttle-rtt-ms 20.
if (args["throttle-mbps"] && browserType === chromium) {
	const mbps = Number(args["throttle-mbps"]);
	const rtt = Number(args["throttle-rtt-ms"] || 20);
	const ctx = await browser.newContext({ viewport: { width: 1280, height: 900 } });
	const p = await ctx.newPage();
	const cdp = await ctx.newCDPSession(p);
	await cdp.send("Network.enable");
	await cdp.send("Network.emulateNetworkConditions", {
		offline: false, latency: rtt, downloadThroughput: (mbps * 1e6) / 8, uploadThroughput: (mbps * 1e6) / 8,
	});
	await p.goto(origin);
	await waitReady(p);
	const readyMs = await p.evaluate(() => window.playgroundMetrics.navigationToReadyMs);
	report.throttledLoad = { mbps, rttMs: rtt, readyMs };
	console.log(`first load over ${mbps} Mbit/s, ${rtt} ms RTT: ready in ${(readyMs / 1000).toFixed(2)} s`);
	await ctx.close();
}

await browser.close();
server.close();

report.failures = failures;
if (args.metrics) await writeFile(args.metrics, JSON.stringify(report, null, 2) + "\n");
const d = report.defaultExample;
console.log(`\nfirst load: ${(report.firstLoad.transferBytes / 1e6).toFixed(2)} MB in ${(report.firstLoad.readyMs / 1000).toFixed(2)} s`);
console.log(`default example (${d.id}): first run ${(d.first.totalMs / 1000).toFixed(2)} s ` +
	`(compile ${(d.first.compile / 1000).toFixed(2)}, link ${(d.first.link / 1000).toFixed(2)}, run ${(d.first.run / 1000).toFixed(2)}); ` +
	`again ${(d.again.totalMs / 1000).toFixed(2)} s`);
if (failures.length > 0) {
	console.log(`\n${failures.length} check(s) failed`);
	process.exit(1);
}
console.log("\nall checks passed");
