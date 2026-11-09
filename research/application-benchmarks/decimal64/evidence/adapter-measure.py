# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json, os, re, statistics, subprocess
out = Path(__file__).parent
root = Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
env = os.environ | dict(GOEXPERIMENT='decimal', GOTOOLCHAIN='local', GOWORK='off', CGO_ENABLED='0', PATH='/Users/marcelo/work/wt/gd-survey/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin')
rows=[]
for width in [64,128]:
 tag='go_decimal_poc64' if width==64 else 'go_decimal_poc'
 subprocess.run(['go','test','-c','-tags',tag,'-o',str(out/f'adapter{width}.test'),'./internal/decimal'],cwd=root,env=env,check=True)
for pair in range(3):
 for width in ([64,128] if pair%2==0 else [128,64]):
  p=subprocess.run([str(out/f'adapter{width}.test'),'-test.run=^$','-test.bench=^BenchmarkAdapterCost$','-test.benchmem','-test.benchtime=300ms'],cwd=root,env=env,capture_output=True,text=True,check=True)
  (out/f'adapter-{pair+1}-{width}.txt').write_text(p.stdout+p.stderr)
  for m in re.finditer(r'^(BenchmarkAdapterCost/(\S+))-\d+\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op',p.stdout,re.M):
   rows.append(dict(pair=pair+1,width=width,name=m[2],ns=float(m[3]),bytes=int(m[4]),allocs=int(m[5])))
 assert len(rows)==(pair+1)*20
summary={}
for width in [64,128]:
 summary[width]={}
 for op in ['Add','Mul','Quantize','Integral','Format']:
  direct='native' if op=='Format' else 'direct';wrapper='GDAAdapter' if op=='Format' else 'wrapper'
  a=[r['ns'] for r in rows if r['width']==width and r['name']==op+'/'+direct]
  b=[r['ns'] for r in rows if r['width']==width and r['name']==op+'/'+wrapper]
  summary[width][op]=dict(directNs=statistics.median(a),wrapperNs=statistics.median(b),medianPairedPercent=statistics.median(100*(y/x-1) for x,y in zip(a,b)))
(out/'adapter-costs.json').write_text(json.dumps(dict(runs=rows,summary=summary),indent=2)+'\n')
print(json.dumps(summary,indent=2))
