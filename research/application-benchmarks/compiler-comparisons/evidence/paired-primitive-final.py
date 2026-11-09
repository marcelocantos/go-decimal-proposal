from pathlib import Path
import subprocess,re,json,statistics
base=Path(__file__).parent
assert 'UMULH' not in (base/'before-compare.asm').read_text()
rows=[]
with (base/'final-primitive-paired.txt').open('w') as log:
 for pair in range(6):
  for stage in (['before','after'] if pair%2==0 else ['after','before']):
   p=subprocess.run([str(base/(stage+'-expanded.test')),'-test.run=^$','-test.bench=^BenchmarkOperatorCompare(Raw)?$','-test.benchmem','-test.benchtime=150ms','-test.count=1'],capture_output=True,text=True,check=True)
   log.write(f'pair={pair+1} stage={stage}\n'+p.stdout);log.flush()
   for name,ns,allocated,allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op',p.stdout,re.M):
    assert allocated=='0' and allocs=='0'
    rows.append(dict(pair=pair+1,stage=stage,name=name,ns=float(ns)))
summary={}
for name in sorted({r['name'] for r in rows}):
 values={s:[r['ns'] for r in rows if r['name']==name and r['stage']==s] for s in ['before','after']}
 assert len(values['before'])==len(values['after'])==6
 delta=[100*(a/b-1) for a,b in zip(values['after'],values['before'])]
 summary[name]=dict(**values,pairedPercent=delta,medianPercent=statistics.median(delta))
assert len(summary)==28
(base/'final-primitive-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:round(v['medianPercent'],1) for k,v in summary.items()},indent=2))
