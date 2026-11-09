# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import datetime, hashlib, json, shutil, subprocess
out=Path(__file__).parent
report=Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/decimal64')
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
report.mkdir(exist_ok=True); ev=report/'evidence';ev.mkdir(exist_ok=True)
m=json.loads((out/'measurements.json').read_text());a=json.loads((out/'adapter-costs.json').read_text());pins=json.loads((out/'candidate.json').read_text())
assert len(m['accepted'])==4
names={'euro_conversion':'Euro conversion','tax_preparation/fed':'Federal tax','tax_preparation/ca':'California tax','tax_preparation/nc':'North Carolina tax','telco':'Telco'}
rows=[];bars=[]
for r in m['comparisons']:
 key=r['app']+('/'+r['sub'] if r['sub'] else '');label=names[key]
 x,y=r['widths']['64']['meanBestNs'],r['widths']['128']['meanBestNs'];pct=r['percentTime64vs128'];ratio=100+pct
 rows.append(f'| {label} | {x:,.2f} | {y:,.2f} | {pct:+.2f}% |')
 color='success' if pct<0 else 'chart-1'
 bars.append(f'<div class="row"><div class="label">{label}<small>{x:,.1f} / {y:,.1f} ns</small></div><div><div class="track"><div class="bar" style="width:{ratio/2}%;background:var(--{color})">{ratio:.1f}</div><i></i></div><small>decimal64 takes {abs(pct):.1f}% {"less" if pct<0 else "more"} time</small></div></div>')
html='''<!doctype html><html><head><meta charset="utf-8"><style>
body{font-family:var(--font-sans);color:var(--foreground);margin:0}p{line-height:1.45;margin:0 0 18px}small{display:block;color:var(--muted-foreground);font-size:12px;margin-top:4px}.row{display:grid;grid-template-columns:150px minmax(0,1fr);gap:14px;margin-bottom:16px}.label{font-size:14px}.track{height:25px;position:relative;background:var(--muted);border-radius:4px}.bar{height:25px;min-width:36px;box-sizing:border-box;text-align:right;padding:3px 7px;color:var(--background);font-size:13px;font-weight:600;border-radius:4px}i{position:absolute;left:50%;top:-3px;bottom:-3px;border-left:2px dashed var(--muted-foreground)}.note{font-size:12px;color:var(--muted-foreground);margin-bottom:0}@media(max-width:450px){.row{grid-template-columns:115px minmax(0,1fr);gap:8px}.label{font-size:12px}}
</style></head><body><p>Decimal64 versus decimal128 on the same application suites.<br><strong>100 = decimal128 time. Lower is faster.</strong></p>'''+''.join(bars)+'''<p class="note">Apple M4 Max · four accepted interleaved runs · mean of each run’s fastest compute sample. Values below names are decimal64 / decimal128 ns per record. All output gates passed; two further runs failed timing checks and are retained. This compares 16-digit and 34-digit arithmetic, not equal precision.</p></body></html>'''
(report/'comparison.html').write_text(html)
adapterrows=[]
for op,v in a['summary']['64'].items():adapterrows.append(f"| {op} | {v['directNs']:.4g} | {v['wrapperNs']:.4g} | {v['medianPairedPercent']:+.2f}% |")
readme=f'''# Decimal64 application comparison

The earlier end-to-end comparisons measured decimal128. This batch adds the
same five supported application workloads at decimal64 precision. Existing
kernel and formatting suites already covered both widths.

Decimal64 is modestly faster on euro and materially slower on tax and telco
in this build. This is an implementation result, not an inherent advantage
of decimal128: compiler fast paths for addition/subtraction and multiplication
currently select decimal128, while decimal64 takes the runtime arithmetic path.
Both widths have comparison and integral-rounding compiler support. The public
strconv API also widens decimal64 before formatting. No compiler changes were
made for this comparison.

## Results

Mean of the fastest compute sample from each of four accepted complete
invocations. Both widths run interleaved on Apple M4 Max with the same compiler;
invocation order alternates. Units are ns per record (a conversion, tax-return
pass, or telephone call). Negative percentage means decimal64 takes less time.
These are **16-digit versus 34-digit** results, not equal-precision competition.

| Workload | Decimal64 ns | Decimal128 ns | Decimal64 time change |
|---|---:|---:|---:|
{chr(10).join(rows)}

[Chart](comparison.html) · [machine-readable results](measurements.json) ·
[all raw run records](evidence/records.json).

Six complete runs produced four accepted invocations. Runs 1 and 3 were
excluded because decimal64 California tax failed the unchanged independent
clock cross-check (allowed ratio 0.9–1.25). All six invocations passed every
application output gate: nine whole runs per supported row, plus compute
output checks. Exclusions are preserved in [cohort status](evidence/cohort-status.json).
These are shared-host measurements; do not overinterpret the small euro gap.
Banking/logarithm/compound and risk/power remain unsupported at both widths.

## Correctness and workload equivalence

- Both `go test -tags go_decimal_poc64 ./...` and the decimal128 equivalent pass.
  Logs: [64](evidence/contract64.log), [128](evidence/contract128.log).
- All 13,536 euro/tax input values match the original UW archive's decimal64
  BID fixtures **bit for bit after narrowing**, including their quantum.
  Named tax fields match; uninitialized C record padding is ignored.
- Conversion from the existing 128-bit input fixtures is outside the timed
  replay and rejects any finite value that cannot narrow exactly. Arithmetic
  and storage use native decimal64. An eight-byte storage check and a fixed
  16-digit rounding-boundary test prevent accidentally benchmarking decimal128.
- Euro uses the archive's original `Euro.output.DECNUMBER_FIXED`, copied verbatim
  as `Euro.output.DECNUMBER_FIXED64`. Its SHA-256 is
  `edeb9b2d5b2e5f390a4825f8a69268f2dd03f7d9ad0228a51bb0f41612cffa27`.
  The 128-bit euro run retains its original 128-bit golden.
- Tax retains the independently cross-checked existing goldens. Telco retains
  Cowlishaw's one-million-call dataset, output digest and control totals.
  No expected output was generated by the implementation under test.
- The normal adapter test command now includes the fixture, width, formatting,
  contract and inlining checks. Unsupported transcendental operations retain
  their explicit skips. No competitor implementation was consulted or copied.

## Adapter overhead

Three alternating width pairs, 300 ms per microbenchmark. Values are median
ns/op; changes are median paired percentages. These small probes explain
boundaries; application timings above remain the headline evidence.

| Decimal64 probe | Direct ns | Adapter ns | Adapter change |
|---|---:|---:|---:|
{chr(10).join(adapterrows)}

All arithmetic wrappers pass the compiler inlining check. Their small timing
movements include code layout/noise and are not evidence of an extra call.
The GDA formatting adapter adds about 12% to native formatting in this probe
(about 15% for decimal128). Both decimal64 formatting branches include the
public API's required widening, so that cost is not hidden. Microbenchmark
sub-nanosecond rows are optimizer-dependent steady-state loops, not isolated
operation latency. [All samples and both widths](adapter-costs.json).

[Telco64 disassembly](evidence/telco64.asm) and
[Telco128 disassembly](evidence/telco128.asm) retain the compiled evidence.
At compiler revision `{pins['fork']}`, see
`src/cmd/compile/internal/ssagen/dpd.go:137` (128-bit arithmetic fast-path
selection), `ssagen/bid.go` (fast-path implementations), and
`src/strconv/decimal.go` (public formatting signature).
Decimal128 still contains runtime fallback calls, behind its fast-path guards.
Attributing an exact fraction of application time to each mechanism would
require controlled compiler changes; the measurements here do not claim that.

## Reproduce and provenance

- Compiler: `{pins['fork']}` (unchanged, clean).
- Measured benchmark source: `{pins['benchmark']}` (clean).
- Results commit: `487bc7f9fc3cc45588f589e7ca6fb01b07eb82a4`.
- [Source/result bundle](benchmark.bundle) is based on
  `c166f9163b78d2c576beab20b41bd4903b177294`.
- [Cohort script](evidence/application-cohort.py),
  [summary script](evidence/summarize.py),
  [adapter measurement](evidence/adapter-measure.py), and
  [fixture member hashes](evidence/fixtures.json) preserve the process.

With the fork's `bin` first on PATH and `GOEXPERIMENT=decimal`, run the test
commands above, then `go run ./cmd/bench -lib go-decimal-poc64,go-decimal-poc`.
The reverse order is used on alternate invocations. Default shared Go cache;
no duplicate cache, remote publication, or new assembly.
'''
(report/'README.md').write_text(readme)
for name in ['measurements.json','adapter-costs.json']:
 shutil.copy2(out/name,report/name)
for pattern in ['*.log','*.txt','*.json','*.asm','*.py']:
 for p in out.glob(pattern):
  if p.name in ['commit-gather.txt','results-gather.txt']:continue
  shutil.copy2(p,ev/p.name)
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip() == '487bc7f9fc3cc45588f589e7ca6fb01b07eb82a4'
subprocess.run(['git','bundle','create',str(report/'benchmark.bundle'),'HEAD','^c166f9163b78d2c576beab20b41bd4903b177294'],cwd=root,check=True)
subprocess.run(['git','bundle','verify',str(report/'benchmark.bundle')],cwd=root,check=True)
(report/'benchmark.patch').write_bytes(subprocess.check_output(['git','diff','c166f9163b78d2c576beab20b41bd4903b177294','11f4b4f68c58f55fe3f8c07e7216759b837c4acd','--','.',':(exclude)results'],cwd=root))
machine={key:subprocess.check_output(cmd,text=True).strip() for key,cmd in {'os':['sw_vers','-productVersion'],'os_build':['sw_vers','-buildVersion'],'arch':['uname','-m'],'cpu':['sysctl','-n','machdep.cpu.brand_string']}.items()}
machine['captured_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();(report/'machine.json').write_text(json.dumps(machine,indent=2)+'\n')
print(report)
