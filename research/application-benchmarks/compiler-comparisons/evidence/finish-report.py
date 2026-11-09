from pathlib import Path
import json,re,shutil,statistics
base=Path(__file__).parent
report=Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/compiler-comparisons')
readme=(report/'README.md').read_text()
def block(name,text):
 global readme
 pat='<!-- '+name+':start -->[\\s\\S]*?<!-- '+name+':end -->'
 readme=re.sub(pat,'<!-- '+name+':start -->\n'+text+'\n<!-- '+name+':end -->',readme)
validation=json.loads((base/'validation.json').read_text());assert len(validation)==9 and all(x['exit_code']==0 for x in validation)
block('validation','All nine coherent gates pass: enabled package tests, independent long operator\nreferences, long kernel/operator comparisons, runtime decimal tests, language\nand ARM64/AMD64 codegen, experiment-off packages, scoped rounding intrinsic\ndisabling, published vectors and the unchanged 221-row ratchet. Published\nvectors report 114,915 passing, zero failing and 111,327 outside-scope cases.\n\nThe first ratchet invocation failed 25 rows, including an unchanged float64\ncontrol. The saved baseline and provisional candidate each then passed all\n221 rows. A fresh invocation through the coherent rebuilt toolchain also\npassed. No source, baseline, threshold, retry count or acceptance rule changed.\nThe initial failure and all three diagnostic/recheck logs are retained; the\ntransient cause was not established.')
p=json.loads((base/'final-primitive-summary.json').read_text())
lines=['| Probe | Before ns | After ns | Median paired change |','|---|---:|---:|---:|']
for name,row in p.items():
 label=re.sub(r'-\d+$','',name).replace('BenchmarkOperatorCompareRaw/','Raw/').replace('BenchmarkOperatorCompare/','')
 lines.append(f"| {label} | {statistics.median(row['before']):.2f} | {statistics.median(row['after']):.2f} | {row['medianPercent']:+.1f}% |")
block('primitive','\n'.join(lines))
p=json.loads((base/'paired-apps/summary.json').read_text())
block('paired','\n'.join(['| Workload | Best-sample change | Median-sample change |','|---|---:|---:|']+[f"| {name} | {r['minNs']['medianPercent']:+.2f}% | {r['medianNs']['medianPercent']:+.2f}% |" for name,r in p.items()]))
sizes=json.loads((base/'application-sizes.json').read_text())
lines=['| Application | Before text bytes | After text bytes | Text growth |','|---|---:|---:|---:|']
for name in sorted({r['app'] for r in sizes}):
 a=next(r for r in sizes if r['app']==name and r['stage']=='before')['textSymbolBytes'];b=next(r for r in sizes if r['app']==name and r['stage']=='after')['textSymbolBytes']
 lines.append(f'| {name} | {a:,} | {b:,} | {100*(b/a-1):+.2f}% |')
block('size','\n'.join(lines)+'\n\nText counts sum T/t symbols from go tool nm -size. Native comparison code is\nlarger because it includes several paths in the caller; wider decimal128\ncomparisons also retain a helper. See application-sizes.json for complete file\nsizes. These costs are reported alongside speed, not hidden by the arithmetic\nprobe gains.')
measurements=json.loads((report/'measurements.json').read_text());supported=[r for r in measurements['comparisons'] if r['status']=='ok']
lines=[]
for row in supported:
 ratio=row['optimized_mean']/row['references']['miguel-decimal128-go']['mean']
 lines.append(f"{row['scenario']}: {100*abs(ratio-1):.1f}% {'less' if ratio<1 else 'more'} time than Miguel")
status=json.loads((base/'cohort-status.json').read_text());rejected=sum(not x['accepted'] for x in status)
block('conclusion','; '.join(lines)+f'.\n\nFour full invocations passed every original output and timing gate; {rejected} complete\ninvocations were excluded by unchanged timing checks and remain archived.\nThe change does not establish an across-the-board performance lead.\nUse the alternating application pairs below for stronger attribution to this\ncompiler change; historical-cohort differences include host drift.')
(report/'README.md').write_text(readme)
e=report/'evidence';e.mkdir(exist_ok=True)
for f in base.iterdir():
 if f.is_file() and f.suffix in ['.py','.log','.txt','.json','.asm'] and 'commit-review' not in f.name:shutil.copy2(f,e/f.name)
for folder in ['paired-apps','finite-paired-apps']:
 shutil.copytree(base/folder,e/folder,dirs_exist_ok=True)
p=e/'profiles';p.mkdir(exist_ok=True)
for f in (base/'profiles').iterdir():
 if f.is_file() and f.suffix in ['.txt','.json','.patch','.stdout','.stderr','.cpu']:shutil.copy2(f,p/f.name)
print('Report tables and raw evidence updated')
