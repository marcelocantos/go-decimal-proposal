// Copyright 2026 Marcelo Cantos
// SPDX-License-Identifier: Apache-2.0

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const root = process.argv[2];
if (!root) throw new Error("usage: node summarize.mjs /path/to/go-decimal128-app-benchmark");
const data = join(root, "results/data");
const machine = JSON.parse(readFileSync(new URL("machine.json", import.meta.url), "utf8"));
const records = readdirSync(data).filter(f => f.endsWith(".jsonl") && f !== "startup.jsonl")
	.flatMap(f => readFileSync(join(data, f), "utf8").trim().split("\n").filter(Boolean).map(JSON.parse));

// These are the two frozen measurement revisions, rather than a selection
// of the fastest records. Every row of each complete invocation is retained.
const revisions = {
	baseline: {
		benchmark: "6cc51751f01c92a3baf6edd7ba99b5040abdf10a",
		fork: "903d630330f7c9720783a8a48a44eb16323c7174",
	},
	optimized: {
		benchmark: "66320dac923596dfff313e982e6d49c64662d0dd",
		fork: "545bd7a4bea66888a9150936847114bc2bd71c34",
	},
};
const phases = {};
for (const [name, revision] of Object.entries(revisions)) {
	const rows = records.filter(r => r.bench_commit === revision.benchmark && !r.bench_dirty &&
		(name === "baseline" ? r.go_version.includes("903d630330") :
			r.go_source_commit === revision.fork && !r.go_source_dirty));
	if (rows.some(r => r.arch !== machine.arch)) throw new Error(`${name}: architecture differs from the frozen machine witness`);
	const attempts = [...new Set(rows.map(r => r.timestamp_utc))].sort();
	const shapes = attempts.map(ts => rows.filter(r => r.timestamp_utc === ts)
		.map(r => `${r.impl}/${r.app}/${r.sub ?? ""}`).sort());
	if (shapes.some(s => JSON.stringify(s) !== JSON.stringify(shapes[0]))) throw new Error(`${name}: invocation shapes differ`);
	const accepted = [];
	const rejected = [];
	for (const ts of attempts) {
		const failures = rows.filter(r => r.timestamp_utc === ts && r.compute_status !== "unsupported" &&
			(!r.correct || r.gate_runs !== 9 || r.gate_runs_passed !== r.gate_runs ||
				r.compute_status !== "ok" || r.compute_xcheck_flag ||
				!Number.isFinite(r.compute_ns_per_record) || r.compute_ns_per_record <= 0));
		if (failures.length) {
			rejected.push({ timestamp: ts, failures });
		} else {
			accepted.push(ts);
		}
	}
	if (accepted.length !== 2) throw new Error(`${name}: expected two valid complete invocations, found ${accepted.length}; rejected ${rejected.length}`);
	phases[name] = { revision, timestamps: accepted, rejected,
		rows: rows.filter(r => accepted.includes(r.timestamp_utc)), all_attempts: rows };
}
const shape = phase => phase.rows.filter(r => r.timestamp_utc === phase.timestamps[0])
	.map(r => `${r.impl}/${r.app}/${r.sub ?? ""}`).sort();
if (JSON.stringify(shape(phases.baseline)) !== JSON.stringify(shape(phases.optimized))) {
	throw new Error("baseline and optimized runs do not cover the same scenarios and libraries");
}
const mean = xs => xs.reduce((a, b) => a + b, 0) / xs.length;
const scenario = r => `${r.app}${r.sub ? `/${r.sub}` : ""}`;
const keys = [...new Set(phases.baseline.rows.filter(r => r.impl === "go-decimal-poc").map(scenario))];
const comparisons = keys.map(key => {
	const samples = (phase, impl) => phases[phase].rows
		.filter(r => scenario(r) === key && r.impl === impl);
	const before = samples("baseline", "go-decimal-poc");
	const after = samples("optimized", "go-decimal-poc");
	if (after[0].compute_status === "unsupported") {
		return { scenario: key, status: "unsupported", reason: after[0].compute_error };
	}
	const values = rows => rows.map(r => r.compute_ns_per_record);
	const baseline = values(before);
	const optimized = values(after);
	const references = {};
	for (const impl of [...new Set(phases.optimized.rows.map(r => r.impl))]) {
		if (impl === "go-decimal-poc") continue;
		const rows = samples("optimized", impl);
		references[impl] = rows[0].compute_status === "unsupported" ?
			{ status: "unsupported", reason: rows[0].compute_error } :
			{ status: "ok", samples: values(rows), mean: mean(values(rows)) };
	}
	return { scenario: key, status: "ok", baseline, optimized,
		baseline_mean: mean(baseline), optimized_mean: mean(optimized),
		time_reduction_percent: 100 * (1 - mean(optimized) / mean(baseline)), references };
});
const result = {
	platform: machine,
	protocol: "Two full interleaved upstream-runner invocations per revision, nine golden-gated whole runs per supported row, three compute processes per row. Table means average the runner's best-sample figure from each invocation. Shared host; exploratory performance evidence.",
	phases: Object.fromEntries(Object.entries(phases).map(([name, p]) => [name, {
		revision: p.revision, accepted_timestamps: p.timestamps, rejected: p.rejected, records: p.all_attempts,
	}])), comparisons,
};
const readmeURL = new URL("README.md", import.meta.url);
let readme = readFileSync(readmeURL, "utf8");
const labels = { euro_conversion: "Euro conversion", "tax_preparation/fed": "Federal tax",
	"tax_preparation/ca": "California tax", "tax_preparation/nc": "North Carolina tax", telco: "Telco" };
const number = n => n.toLocaleString("en-US", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const table = ["| Workload | POC before | POC after | Less compute time | Miguel after | bid754 after |",
	"|---|---:|---:|---:|---:|---:|", ...comparisons.filter(r => r.status === "ok").map(r => {
		const ref = name => r.references[name].status === "ok" ? number(r.references[name].mean) : "Unsupported";
		return `| ${labels[r.scenario] ?? r.scenario} | ${number(r.baseline_mean)} | ${number(r.optimized_mean)} | ${r.time_reduction_percent.toFixed(1)}% | ${ref("miguel-decimal128-go")} | ${ref("bid754")} |`;
	})].join("\n");
readme = readme.replace(/<!-- results:start -->[\s\S]*?<!-- results:end -->/,
	`<!-- results:start -->\n${table}\n<!-- results:end -->`);
writeFileSync(new URL("measurements.json", import.meta.url), JSON.stringify(result, null, 2) + "\n");
if (process.argv[3]) {
	const groups = {};
	const lines = readFileSync(process.argv[3], "utf8").split("\n");
	for (const line of lines) {
		const m = /^(BenchmarkAdapter(?:Cost|FormatCases)\/\S+?)-\d+\s+\d+\s+([\d.]+) ns\/op\s+(\d+) B\/op\s+(\d+) allocs\/op$/.exec(line);
		if (!m) continue;
		(groups[m[1]] ??= []).push({ ns: Number(m[2]), bytes: Number(m[3]), allocs: Number(m[4]) });
	}
	for (const [key, samples] of Object.entries(groups)) {
		if (samples.length !== 6) throw new Error(`${key}: expected six samples, found ${samples.length}`);
	}
	if (Object.keys(groups).length !== 22) throw new Error("missing adapter benchmark cases");
	const median = samples => {
		const sorted = samples.map(x => x.ns).sort((a, b) => a - b);
		return (sorted[2] + sorted[3]) / 2;
	};
	const costs = {};
	for (const key of Object.keys(groups).filter(k => /\/(direct|native)$/.test(k))) {
		const wrapper = key.replace(/\/direct$/, "/wrapper").replace(/\/native$/, "/GDAAdapter");
		const control = median(groups[key]);
		const adapted = median(groups[wrapper]);
		const paired = groups[key].map((sample, i) => 100 * (groups[wrapper][i].ns / sample.ns - 1));
		const ordered = [...paired].sort((a, b) => a - b);
		costs[key.replace(/\/(direct|native)$/, "")] = {
			direct_median_ns: control, adapter_median_ns: adapted,
			adapter_extra_percent: 100 * (adapted / control - 1),
			paired_extra_percent: paired, paired_median_extra_percent: (ordered[2] + ordered[3]) / 2,
		};
	}
	writeFileSync(new URL("adapter-costs.json", import.meta.url), JSON.stringify({
		fork: revisions.optimized.fork, benchmark: revisions.optimized.benchmark, groups, costs,
	}, null, 2) + "\n");
	const costTable = ["| Probe | Median extra time | Range of six paired deltas |",
		"|---|---:|---:|", ...Object.entries(costs).map(([key, c]) =>
			`| ${key.replace("BenchmarkAdapterCost/", "").replace("BenchmarkAdapterFormatCases/", "Format/")} | ${c.paired_median_extra_percent.toFixed(1)}% | ${Math.min(...c.paired_extra_percent).toFixed(1)}% to ${Math.max(...c.paired_extra_percent).toFixed(1)}% |`)].join("\n");
	readme = readme.replace(/<!-- adapter:start -->[\s\S]*?<!-- adapter:end -->/,
		`<!-- adapter:start -->\n${costTable}\n<!-- adapter:end -->`);
}
writeFileSync(readmeURL, readme);
const supported = comparisons.filter(r => r.status === "ok");
const rowsHTML = supported.map(r => {
	const series = [
		["Before POC", r.baseline_mean, "var(--muted-foreground)", 0.45],
		["After POC", r.optimized_mean, "var(--chart-1)", 1],
		["Miguel", r.references["miguel-decimal128-go"].mean, "var(--chart-2)", 1],
		["bid754", r.references.bid754.mean, "var(--chart-3)", 1],
	];
	const bars = series.map(([name, value, color, opacity]) => value == null ?
		'<div class="bar missing">bid754 unsupported</div>' :
		`<div class="bar" title="${name}: ${number(value)} ns/record" style="width:${100 * value / r.baseline_mean / 1.6}%;background:${color};opacity:${opacity}"><span>${(100 * value / r.baseline_mean).toFixed(1)}</span></div>`).join("");
	return `<div class="row"><div class="label">${labels[r.scenario] ?? r.scenario}<small>${r.time_reduction_percent.toFixed(1)}% less time</small></div><div class="plot"><div class="bars">${bars}</div></div></div>`;
}).join("");
const html = `<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style>
html,body{margin:0;background:transparent;color:var(--foreground);font-family:var(--font-sans)}
p{font-size:12px;color:var(--muted-foreground);margin:0 0 12px;line-height:1.5}.legend{display:flex;flex-wrap:wrap;gap:8px 18px;font-size:12px;margin-bottom:16px}.legend i{display:inline-block;width:10px;height:10px;margin-right:5px;border-radius:2px}.chart{height:355px}.row{display:grid;grid-template-columns:minmax(100px,150px) minmax(0,1fr);gap:12px;align-items:center;margin-bottom:16px}.label{font-size:13px;line-height:1.35}.label small{display:block;color:var(--muted-foreground);font-size:11px;margin-top:4px}.plot{padding-right:36px}.bars{border-left:1px solid var(--border);position:relative}.bars:before{content:"";position:absolute;left:62.5%;top:0;bottom:0;border-left:1px dashed var(--border)}.bar{height:9px;margin:4px 0;position:relative;min-width:1px}.bar span{position:absolute;left:100%;margin-left:5px;font-size:10px;line-height:9px;font-family:var(--font-mono);color:var(--foreground)}.missing{font-size:10px;line-height:9px;color:var(--muted-foreground);white-space:nowrap}@media(max-width:430px){.row{grid-template-columns:100px minmax(0,1fr);gap:8px}.legend{gap:8px 12px}.label{font-size:12px}}
</style></head><body><p>Compute time per record. Earlier POC = 100; lower is better. Means of two accepted invocations on Apple M4 Max.</p><div class="legend"><span><i style="background:var(--muted-foreground);opacity:.45"></i>Earlier POC</span><span><i style="background:var(--chart-1)"></i>After Go work</span><span><i style="background:var(--chart-2)"></i>Miguel</span><span><i style="background:var(--chart-3)"></i>bid754</span></div><div class="chart" role="img" aria-label="Application compute time, normalized to the earlier proof of concept">${rowsHTML}</div><p>POC changes include kernel and adapter work. Risk and banking remain unsupported. Shared-host measurements; one flagged timing invocation is archived and excluded.</p></body></html>`;
writeFileSync(new URL("comparison.html", import.meta.url), html);
console.log(JSON.stringify(comparisons, null, 2));
