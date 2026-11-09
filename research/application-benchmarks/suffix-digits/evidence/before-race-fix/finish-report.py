from pathlib import Path
import json,re,shutil,statistics
base=Path(__file__).parent
report=Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/suffix-digits')
readme=(report/'README.md').read_text()
def block(name,text):
 global readme
 readme=re.sub('<!-- '+name+':start -->[\\s\\S]*?<!-- '+name+':end -->','<!-- '+name+':start -->\n'+text+'\n<!-- '+name+':end -->',readme)
v=json.loads((base/'validation.json').read_text());assert len(v)==9 and all(x['exit_code']==0 for x in v)
block('validation','All nine coherent gates pass on their first invocation: affected enabled\npackages; fresh million-case digit references per width (seed 521); fresh\nmillion-case Append references per width (seed 523); runtime decimal tests;\nlanguage/ARM64/AMD64 codegen; experiment-off packages; explicit strconv\nformatting, carry and round-trip tests; published vectors; and the unchanged\n221-row performance ratchet. Published vectors report 114,915 passing, zero\nfailing and 111,327 skipped outside the supported kernel scope. The prior\nbaseline, slack, band, sample count and retry policy are unchanged.')
p=json.loads((base/'primitive-summary.json').read_text());assert len(p)==37
lines=['| Probe | Before ns | After ns | Median paired change |','|---|---:|---:|---:|']
for name,r in p.items():
 label=re.sub(r'-\d+$','',name).removeprefix('Benchmark')
 lines.append(f"| {label} | {statistics.median(x['ns'] for x in r['before']):.2f} | {statistics.median(x['ns'] for x in r['after']):.2f} | {r['medianPercent']:+.1f}% |")
block('primitive','\n'.join(lines))
p=json.loads((base/'paired-apps/summary.json').read_text())
block('paired','\n'.join(['| Workload | Best-sample change | Median-sample change |','|---|---:|---:|']+[f"| {name} | {r['minNs']['medianPercent']:+.2f}% | {r['medianNs']['medianPercent']:+.2f}% |" for name,r in p.items()]))
sizes=json.loads((base/'application-sizes.json').read_text());lines=['| Application | Before text bytes | After text bytes | Text change |','|---|---:|---:|---:|']
for name in sorted({r['app'] for r in sizes}):
 a=next(r for r in sizes if r['app']==name and r['stage']=='before')['textSymbolBytes'];b=next(r for r in sizes if r['app']==name and r['stage']=='after')['textSymbolBytes']
 lines.append(f'| {name} | {a:,} | {b:,} | {100*(b/a-1):+.2f}% |')
block('size','\n'.join(lines)+'\n\nText counts sum T/t symbols from go tool nm -size. Complete file sizes are\nin evidence/application-sizes.json. Fast paths add branches; their resulting\ncode and allocation costs remain part of the application comparison.')
prof=json.loads((base/'profiles/summary.json').read_text())
block('profile',f"Fresh golden-checked profiles put String conversion, including adaptation and\nallocation, at {prof['euro']['string_timed_percent']:.1f}% of euro and {prof['fed']['string_timed_percent']:.1f}% of federal-tax timed\nsamples. These percentages divide String's cumulative samples by BestOf's\ncumulative samples, not whole-process samples. Source overlays only wrap the\noriginal entrypoints with runtime/pprof. Their diffs, provenance and raw profiles\nare retained under evidence/profiles.")
measurements=json.loads((report/'measurements.json').read_text());labels={'euro_conversion':'Euro','tax_preparation/fed':'Federal tax','tax_preparation/ca':'California tax','tax_preparation/nc':'North Carolina tax','telco':'Telco'}
lines=[]
for row in measurements['comparisons']:
 if row['status']!='ok':continue
 ratio=row['optimized_mean']/row['references']['miguel-decimal128-go']['mean']
 lines.append(f"{labels[row['scenario']]} uses {100*abs(ratio-1):.1f}% {'less' if ratio<1 else 'more'} time than Miguel")
status=json.loads((base/'cohort-status.json').read_text());rejected=sum(not x['accepted'] for x in status)
block('conclusion','; '.join(lines)+f'.\n\nFour complete invocations passed every original output and timing gate.\n{rejected} complete invocations were excluded by unchanged clock checks and remain\narchived. This is not an across-the-board performance lead. Small cohort\ndifferences remain uncertain on the shared host.')
(report/'README.md').write_text(readme)
e=report/'evidence';e.mkdir(exist_ok=True)
for f in base.iterdir():
 if f.is_file() and f.suffix in ['.py','.log','.txt','.json','.asm','.patch'] and 'commit-review' not in f.name:shutil.copy2(f,e/f.name)
for folder in ['paired-apps','suffix-only-paired-apps','word-paired-apps','baseline-overlay']:shutil.copytree(base/folder,e/folder,dirs_exist_ok=True)
p=e/'profiles';p.mkdir(exist_ok=True)
for f in (base/'profiles').iterdir():
 if f.is_file() and f.suffix in ['.txt','.json','.patch','.stdout','.stderr','.cpu']:shutil.copy2(f,p/f.name)
print('Final report and raw evidence updated')
