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
	if (sizes) transfers.push({ url: req.url(), method: req.method(), bytes: sizes.responseBodySize + sizes.responseHeadersSize });
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
{
	// The page only reads its own static files, once each, in full.
	const info = JSON.parse(await readFile(path.join(site, "build.json"), "utf8"));
	const fetched = report.firstLoad.requests;
	const once = (asset) => fetched.filter((r) => r.path === PAGES_PATH + asset.path).length === 1 &&
		fetched.find((r) => r.path === PAGES_PATH + asset.path).bytes >= asset.size;
	check(transfers.every((t) => t.url.startsWith(origin) && t.method === "GET") && report.firstLoad.readyMs > 0 &&
		once(info.compile) && once(info.link) && once(info.std),
		`first load fetches only the bundle: ${(report.firstLoad.readyMs / 1000).toFixed(2)} s, ` +
		`${(report.firstLoad.transferBytes / 1e6).toFixed(2)} MB`, JSON.stringify(fetched));
}

// Every bundled example, in the page's order. The first is the default.
const manifest = JSON.parse(await readFile(path.join(examplesDir, "examples.json"), "utf8"));
const defaultId = await page.$eval("#examples", (el) => el.value);
check(defaultId === manifest[0].id, `default example is ${manifest[0].id}`, `got ${defaultId}`);
check(await page.getByRole("checkbox", { name: "GOEXPERIMENT=decimal" }).isChecked(),
	"GOEXPERIMENT=decimal is checked initially");
check(!report.firstLoad.requests.some((r) => r.path.includes("std-nodecimal/")),
	"the experiment-off library is not downloaded until selected");
for (const ex of manifest) {
	await page.selectOption("#examples", ex.id);
	const want = await readFile(path.join(examplesDir, `${ex.id}.out`), "utf8");
	const got = await runProgram(page);
	report.examples[ex.id] = { result: got.result, exitCode: got.exitCode, matches: got.output === want, ...got.metrics };
	check(got.result === "run" && got.exitCode === 0 && got.output === want,
		`example ${ex.id} matches native go run (${(got.metrics.totalMs / 1000).toFixed(2)} s)`,
		`result=${got.result} exit=${got.exitCode}\n--- want\n${want}--- got\n${got.output}`);
}

// The tour of the IEEE 754-2019 operations, checked by name so that it
// cannot leave the manifest unnoticed: it ran above, and its whole output,
// the section on the operations 754-2019 added included, matched native go
// run exactly.
{
	const id = "ieee-754-2019";
	const want = await readFile(path.join(examplesDir, `${id}.out`), "utf8");
	check(report.examples[id]?.matches === true && want.includes("\n--- Added in IEEE 754-2019 ---\n"),
		`example ${id} is bundled and matches its expected output exactly`, JSON.stringify(report.examples[id]));
}

// The default example again, now that the worker has run once.
check(report.examples.sql?.matches === true,
	"the real SQLite decimal round trips are bundled and match native output");
await setCode(page, `package main
import "fmt"
type totals struct { a, b, c decimal128 }
//go:noinline
func calculate(x totals) totals { return x }
//go:noinline
func forward(x totals) totals { return calculate(x) }
func main() {
	x := forward(totals{1.50, -2.75, 3.125})
	fmt.Println(x.a, x.b, x.c)
}
`);
const aggregate = await runProgram(page);
check(aggregate.result === "run" && aggregate.exitCode === 0 && aggregate.output === "1.50 -2.75 3.125\n",
	"decimal128 struct arguments and results preserve every field", aggregate.output);
await page.selectOption("#examples", manifest[0].id);
const warm = await runProgram(page);
report.defaultExample = { id: manifest[0].id, first: report.examples[manifest[0].id], again: warm.metrics };

// The compiler flag and the standard-library API must switch together.
// Merely changing the compiler environment would leave ParseDecimal and
// reflect's decimal methods available through the enabled export data.
{
	const toggle = page.getByRole("checkbox", { name: "GOEXPERIMENT=decimal" });
	const source = await page.inputValue("#code");
	await toggle.uncheck();
	await waitReady(page);
	check(await page.inputValue("#code") === source, "changing the experiment preserves the program");
	check(!(await page.textContent("#packages")).split(", ").includes("math/decimal"),
		"the experiment-off package list excludes math/decimal");
	for (const name of ["decimal64", "decimal128"]) {
		await setCode(page, `package main\nfunc main() { var x ${name}; _ = x }\n`);
		const out = await runProgram(page);
		check(out.result === "compile" && out.output.includes(`${name} requires GOEXPERIMENT=decimal`),
			`experiment off rejects unbound ${name}`, out.output);
	}
	for (const [pkg, expr] of [["math", "Decimal64bits"], ["reflect", "Decimal64"],
		["reflect", "Value{}.CanDecimal"], ["strconv", "ParseDecimal"]]) {
		await setCode(page, `package main\nimport "${pkg}"\nvar _ = ${pkg}.${expr}\nfunc main() {}\n`);
		const out = await runProgram(page);
		check(out.result === "compile" && (out.output.includes("undefined") || out.output.includes("no field or method")),
			`experiment off excludes ${pkg}.${expr}`, out.output);
	}
	await setCode(page, 'package main\nimport _ "math/decimal"\nfunc main() {}\n');
	const unavailable = await runProgram(page);
	check(unavailable.result === "import" && unavailable.output.includes('"math/decimal" is not available'),
		"experiment off excludes the math/decimal package", unavailable.output);
	const ordinary = `package main
import ("fmt"; "reflect")
type decimal64 string
type decimal128 int
func main() {
	var x decimal64 = "shadow"
	var y decimal128 = 3
	_, method := reflect.TypeOf(reflect.Value{}).MethodByName("Decimal")
	fmt.Println(x, y, reflect.Kind(27), method)
}
`;
	await setCode(page, ordinary);
	const plain = await runProgram(page);
	check(plain.result === "run" && plain.output === "shadow 3 kind27 false\n",
		"ordinary names and reflection retain experiment-off behaviour", plain.output);
	await setCode(page, `package main
import ("database/sql"; "fmt"; _ "github.com/ncruces/go-sqlite3/driver")
func main() {
	db, err := sql.Open("sqlite3", ":memory:")
	if err != nil { panic(err) }
	defer db.Close()
	var answer int
	if err := db.QueryRow("SELECT 6 * 7").Scan(&answer); err != nil { panic(err) }
	fmt.Println("SQLite without decimals:", answer)
}
`);
	const sql = await runProgram(page);
	check(sql.result === "run" && sql.exitCode === 0 && sql.output === "SQLite without decimals: 42\n",
		"ordinary SQLite works with the decimal experiment off", sql.output);
	await setCode(page, 'package main\nfunc main() { for {} }\n');
	const timed = await runProgram(page);
	await waitReady(page);
	await setCode(page, ordinary);
	const recovered = await runProgram(page);
	check(timed.result === "timeout" && !await toggle.isChecked() && recovered.result === "run" && recovered.output === plain.output,
		"timeout recovery retains the unchecked mode and its library", recovered.output);
	await toggle.check();
	await waitReady(page);
	await page.selectOption("#examples", manifest[0].id);
	const enabled = await runProgram(page);
	check(enabled.result === "run" && enabled.output === await readFile(path.join(examplesDir, `${manifest[0].id}.out`), "utf8"),
		"checking the experiment restores decimal compilation", enabled.output);
	await toggle.uncheck();
	await waitReady(page);
	await toggle.check();
	await waitReady(page);
	const offAsset = JSON.parse(await readFile(path.join(site, "build.json"), "utf8")).nodecimal.std.path;
	check(transfers.filter((t) => new URL(t.url).pathname === PAGES_PATH + offAsset).length === 1,
		"mode switches and timeout recovery reuse the downloaded experiment-off library");
	await toggle.uncheck();
	await waitReady(page);
	await page.reload();
	await waitReady(page);
	check(await toggle.isChecked(), "a reload restores the default checked mode");
}

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
	got.output.split("The packages available are:")[1].trim().replace(/\.$/, "").split(/[\s,]+/).join(" ") === offered.join(" "),
	"an unavailable import names the packages available", got.output);
await shot("import");

// Padding the imports cannot get syscall/js past the scanner.
const padded = () => `package main

import (
${Array.from({ length: 2200 }, () => '\t_ "fmt"').join("\n")}
	"syscall/js"
	"fmt"
)

func main() {
	fmt.Println("has JS:", js.Global().Get("indexedDB").Truthy())
}
`;
await setCode(page, padded());
got = await runProgram(page);
check(got.result === "import" && got.output.includes(`"syscall/js" is not available`) && !got.output.includes("has JS"),
	"syscall/js after 2200 padded imports is refused", got.output);

// unsafe is refused, however its import path is written.
for (const lit of ['"unsafe"', '`unsafe`', '"\\x75nsafe"', '"\\165nsafe"', '"\\u0075nsafe"']) {
	await setCode(page, `package main\n\nimport _ ${lit}\n\nfunc main() {}\n`);
	got = await runProgram(page);
	check(got.result === "import" && got.output.includes(`"unsafe" is not available`), `import ${lit} is refused`, got.output);
}

// An escaped import path that Go accepts works.
await setCode(page, 'package main\n\nimport "\\x66mt"\n\nfunc main() { fmt.Println("escaped import") }\n');
got = await runProgram(page);
check(got.result === "run" && got.output === "escaped import\n", "an escaped import path compiles and runs", got.output);

// The compiler's importcfg names exactly the offered packages.
const cfgPackages = (await readFile(path.join(site, "std/importcfg.compile"), "utf8")).split("\n")
	.filter((l) => l.startsWith("packagefile ")).map((l) => l.slice("packagefile ".length).split("=")[0]).sort();
check(cfgPackages.join(" ") === [...offered].sort().join(" "), "the compiler's importcfg lists only the offered packages", cfgPackages.join(" "));

// A program cannot damage the toolchain for later runs.
await setCode(page, `package main

import (
	"fmt"
	"os"
)

func main() {
	_, err := os.Stat("/std/importcfg.compile")
	fmt.Println(os.IsNotExist(err), os.RemoveAll("/std"), os.RemoveAll("/tmp"), os.RemoveAll("/work"))
	fmt.Println(os.WriteFile("/std/importcfg.link", nil, 0o644) != nil)
}
`);
got = await runProgram(page);
check(got.result === "run" && got.output === "true <nil> <nil> <nil>\ntrue\n", "a program does not see /std", got.output);
await page.selectOption("#examples", manifest[0].id);
got = await runProgram(page);
check(got.result === "run" && got.output === await readFile(path.join(examplesDir, `${manifest[0].id}.out`), "utf8"),
	"the next run still compiles after a program removed what it could", got.output);

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
			experiment: document.querySelector(".experiment").getBoundingClientRect().toJSON(),
			code: r("code").toJSON(), output: r("output").toJSON(),
		};
	});
	check(geo.scrollWidth <= geo.clientWidth, `${name}: no horizontal page scroll`,
		`scrollWidth ${geo.scrollWidth} > clientWidth ${geo.clientWidth}`);
	for (const k of ["run", "examples", "experiment", "code", "output"]) {
		check(geo[k].left >= 0 && geo[k].right <= geo.clientWidth, `${name}: #${k} within the viewport`, JSON.stringify(geo[k]));
	}
	await shot(name);
}
await layout(1280, 900, "desktop", "light");
await layout(1280, 900, "desktop-dark", "dark");
await layout(390, 844, "phone", "light");
await layout(390, 844, "phone-dark", "dark");

// openVariant opens a fresh page with worker.js altered or the browser's
// behaviour changed, for checking the layers behind the normal path.
async function openVariant({ workerEdit, initScript }) {
	const ctx = await browser.newContext({ viewport: { width: 1280, height: 900 } });
	const p = await ctx.newPage();
	let edits = 0;
	if (workerEdit) {
		await p.route(/\/worker\.js/, async (route) => {
			const resp = await route.fetch();
			const body = await resp.text();
			const edited = workerEdit(body);
			if (edited !== body) edits++;
			await route.fulfill({ response: resp, body: edited });
		});
	}
	if (initScript) await p.addInitScript(initScript);
	await p.goto(`${origin}?timeout=${RUN_TIMEOUT_S}`);
	await waitReady(p);
	return { ctx, p, edited: () => edits > 0 };
}

// With the scanner out of the way, the compiler itself refuses syscall/js.
{
	const v = await openVariant({ workerEdit: (src) => src.replace("function imports(src) {", "function imports(src) { return [];") });
	await setCode(v.p, padded());
	const out = await runProgram(v.p);
	check(v.edited() && out.result === "compile" && out.output.includes("syscall/js") && !out.output.includes("has JS"),
		"the compiler refuses syscall/js when the scanner says nothing", `edited=${v.edited()}\n${out.result}\n${out.output}`);
	await v.ctx.close();
}

// A source the scanner cannot read is compiled for its errors but not run.
{
	const v = await openVariant({ workerEdit: (src) => src.replace("function imports(src) {", "function imports(src) { return null;") });
	const ok = await runProgram(v.p);
	check(v.edited() && ok.result === "import" && ok.output.includes("could not read this program's imports"),
		"a program whose imports cannot be read does not run", `edited=${v.edited()}\n${ok.result}\n${ok.output}`);
	await setCode(v.p, "package main\n\nfunc main() { x }\n");
	const bad = await runProgram(v.p);
	check(bad.result === "compile" && bad.output.includes("prog.go:3:15"), "and its compile errors are still shown", bad.output);
	await v.ctx.close();
}

// A browser that cannot post a WebAssembly.Module still survives a restart.
{
	const v = await openVariant({
		initScript: () => {
			const post = Worker.prototype.postMessage;
			Worker.prototype.postMessage = function (msg, ...rest) {
				if (msg && msg.compile instanceof WebAssembly.Module) {
					window.dataCloneErrors = (window.dataCloneErrors || 0) + 1;
					throw new DOMException("no modules", "DataCloneError");
				}
				return post.call(this, msg, ...rest);
			};
		},
	});
	const first = await runProgram(v.p);
	await setCode(v.p, "package main\n\nfunc main() {\n\tfor {\n\t}\n}\n");
	const loop = await runProgram(v.p);
	await waitReady(v.p);
	await v.p.selectOption("#examples", manifest[0].id);
	const again = await runProgram(v.p);
	const thrown = await v.p.evaluate(() => window.dataCloneErrors);
	check(thrown === 2 && first.result === "run" && loop.result === "timeout" && again.result === "run" && again.output === first.output,
		"the DataCloneError fallback works across a worker restart", `thrown=${thrown} ${first.result} ${loop.result} ${again.result}\n${again.output}`);
	await v.ctx.close();
}

// A reload keeps the selected example, and an edited program.
{
	const ctx = await browser.newContext();
	const p = await ctx.newPage();
	await p.goto(origin);
	await p.waitForFunction(() => document.getElementById("examples").options.length > 0);
	const other = manifest[2];
	// Reload straight after each change, inside the fragment's debounce, with
	// the first program's fragment already written.
	await p.waitForFunction(() => location.hash.length > 1, null, { timeout: 5000 });
	await p.selectOption("#examples", other.id);
	await p.reload();
	await p.waitForFunction(() => document.getElementById("examples").options.length > 0);
	check(await p.$eval("#examples", (el) => el.value) === other.id, "a reload keeps the selected example");
	await p.waitForFunction(() => location.hash.length > 1, null, { timeout: 5000 });
	await p.fill("#code", "package main\n\nfunc main() {}\n");
	await p.reload();
	await p.waitForFunction(() => document.getElementById("examples").options.length > 0);
	check(await p.$eval("#code", (el) => el.value) === "package main\n\nfunc main() {}\n" &&
		await p.$eval("#examples", (el) => el.value) === "", "a reload keeps an edited program");
	await ctx.close();
}

// The URL fragment carries the program: editing rewrites it without adding
// history entries, and opening the URL elsewhere loads and runs that program.
{
	const ctx = await browser.newContext();
	const p = await ctx.newPage();
	await p.goto(`${origin}?timeout=${RUN_TIMEOUT_S}`);
	await p.waitForFunction(() => document.getElementById("examples").options.length > 0);
	await p.waitForFunction(() => location.hash.length > 1, null, { timeout: 5000 });
	const historyBefore = await p.evaluate(() => history.length);
	const initialHash = await p.evaluate(() => location.hash);
	const code = "package main\n\nimport \"fmt\"\n\nfunc main() {\n\tfmt.Println(\"shared ✓\", decimal64(1.50))\n}\n";
	await p.fill("#code", code);
	await p.waitForFunction((h) => location.hash.length > 1 && location.hash !== h, initialHash, { timeout: 5000 });
	const url = p.url();
	const hash = new URL(url).hash.slice(1);
	check(/^[A-Za-z0-9_-]+$/.test(hash) && hash.length < Buffer.from(code).toString("base64").length,
		"the fragment is compressed base64url", hash);
	check(await p.evaluate(() => history.length) === historyBefore, "fragment updates add no history entries");
	await ctx.close();

	const ctx2 = await browser.newContext();
	const q = await ctx2.newPage();
	await q.goto(url);
	await waitReady(q);
	check(await q.$eval("#code", (el) => el.value) === code && await q.$eval("#examples", (el) => el.value) === "",
		"a shared URL opens its program");
	check(await q.evaluate(() => document.body.dataset.result === undefined), "a shared program does not run until Run is pressed");
	const shared = await runProgram(q);
	check(shared.result === "run" && shared.output.startsWith("shared ✓"), "a shared program runs", shared.output);
	const ex = manifest[1];
	await q.selectOption("#examples", ex.id);
	await q.waitForFunction((h) => location.hash.slice(1) !== h, hash, { timeout: 5000 });
	await q.goto(q.url());
	await q.reload();
	await q.waitForFunction(() => document.getElementById("examples").options.length > 0);
	check(await q.$eval("#examples", (el) => el.value) === ex.id, "a shared example opens as that example");
	await q.evaluate(() => localStorage.setItem("decimal-playground-draft", "package main\n\n// mine\nfunc main() {}\n"));
	await q.goto(url);
	await q.reload();
	await q.waitForFunction(() => document.getElementById("examples").options.length > 0);
	check(await q.evaluate(() => localStorage.getItem("decimal-playground-draft")) === "package main\n\n// mine\nfunc main() {}\n",
		"opening a shared URL keeps the visitor's saved draft");
	await q.goto(`${origin}#not-valid-base64!`);
	await q.reload();
	await q.waitForFunction(() => document.getElementById("examples").options.length > 0);
	check(await q.$eval("#code", (el) => el.value).then((v) => v.length > 0), "a bad fragment falls back to a program");
	await ctx2.close();
}

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
