# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json, statistics
out=Path(__file__).parent
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
cs=json.loads((out/'cohort-status.json').read_text())
accepted=[x['timestamp'] for x in cs if x['accepted']]
assert len(accepted)==4
allrows=[json.loads(l) for p in (root/'results/data').glob('*.jsonl') for l in p.read_text().splitlines()]
rows=[r for r in allrows if r['timestamp_utc'] in [x['timestamp'] for x in cs]]
(out/'records.json').write_text(json.dumps(rows,indent=2)+'\n')
comparisons=[]
for app,sub in [('euro_conversion',None),('tax_preparation','fed'),('tax_preparation','ca'),('tax_preparation','nc'),('telco',None)]:
 x={}
 for width in [64,128]:
  rs=[next(r for r in rows if r['timestamp_utc']==ts and r.get('app')==app and r.get('sub')==sub and r['impl']==('go-decimal-poc64' if width==64 else 'go-decimal-poc')) for ts in accepted]
  x[str(width)]=dict(bestSamples=[r['compute_ns_per_record'] for r in rs],meanBestNs=statistics.mean(r['compute_ns_per_record'] for r in rs),meanMedianNs=statistics.mean(r['compute_median'] for r in rs))
 delta=100*(x['64']['meanBestNs']/x['128']['meanBestNs']-1)
 comparisons.append(dict(app=app,sub=sub,widths=x,percentTime64vs128=delta))
 print(app,sub,round(x['64']['meanBestNs'],2),round(x['128']['meanBestNs'],2),round(delta,2))
(out/'measurements.json').write_text(json.dumps(dict(accepted=accepted,attempts=cs,comparisons=comparisons),indent=2)+'\n')
