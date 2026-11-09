# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import subprocess,re,json,statistics
base=Path(__file__).parent
rows=[]
with (base/'precision-pairs.txt').open('w') as log:
 for pair in range(6):
  for stage in (['before','after'] if pair%2==0 else ['after','before']):
   p=subprocess.run([str(base/('length-'+stage+'.test')),'-test.run=^$','-test.bench=^BenchmarkFormatDecimal64$','-test.benchmem','-test.benchtime=150ms'],capture_output=True,text=True,check=True)
   log.write(f'pair={pair+1} stage={stage}\n'+p.stdout);log.flush()
   for name,ns,allocated,allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op',p.stdout,re.M):
    rows.append(dict(pair=pair+1,stage=stage,name=name,ns=float(ns),bytes=int(allocated),allocs=int(allocs)))
summary={}
for name in sorted({r['name'] for r in rows}):
 before=[r for r in rows if r['name']==name and r['stage']=='before'];after=[r for r in rows if r['name']==name and r['stage']=='after']
 assert len(before)==len(after)==6
 assert all(x['bytes']==y['bytes'] and x['allocs']==y['allocs'] for x,y in zip(before,after))
 delta=[100*(y['ns']/x['ns']-1) for x,y in zip(before,after)]
 summary[name]=dict(before=before,after=after,pairedPercent=delta,medianPercent=statistics.median(delta))
(base/'precision-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print({k:round(v['medianPercent'],2) for k,v in summary.items()})
