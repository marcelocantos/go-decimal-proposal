from pathlib import Path
import re,json,statistics
b=Path(__file__).parent;rows=[]
for line in (b/'fallback-pairs.txt').read_text().splitlines():
 if line.startswith('pair='):pair,stage=[x.split('=')[1] for x in line.split()]
 m=re.match(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+0 B/op\s+0 allocs/op',line)
 if m:rows.append(dict(pair=int(pair),stage=stage,name=m[1],ns=float(m[2])))
s={}
for name in sorted({x['name'] for x in rows}):
 v={stage:[r['ns'] for r in rows if r['name']==name and r['stage']==stage] for stage in ['before','after']}
 assert len(v['before'])==len(v['after'])==3
 delta=[100*(a/b-1) for a,b in zip(v['after'],v['before'])]
 s[name]=dict(**v,pairedPercent=delta,medianPercent=statistics.median(delta))
assert len(s)==10
(b/'fallback-summary.json').write_text(json.dumps(s,indent=2)+'\n');print(json.dumps({k:round(v['medianPercent'],1) for k,v in s.items()},indent=2))
