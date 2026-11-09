from pathlib import Path
import hashlib,json,os,re,statistics,subprocess
base=Path(__file__).parent
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
out=base/'format-paired-apps';out.mkdir(exist_ok=True)
# Same original programs, datasets and output goldens. Only output-file names
# differ to avoid overwriting the runner's files. Settings fixed before timing.
suites=[('euro','euro_conversion','testGen/bin/Euro.bin.BID128','golden/Euro.output.DECNUMBER_FIXED128',100,1000,4)]
for tax in ['fed','ca','nc']:suites.append(('tax-'+tax,'tax_preparation','testGen/bin/Tax.'+tax.upper()+'.bin.BID128','golden/Tax.'+tax.upper()+'.stderr.golden',1,1000,400))
suites.append(('telco','telco','expon180.1e6b','golden/expon180.1e6.expected.sha256',1000000,5,1))
env={k:v for k,v in os.environ.items() if not k.startswith('D128_COMPUTE_')}
rows=[];gates=[]
for name,folder,data,golden,records,samples,batch in suites:
 cwd=root/'data'/folder
 expected=(cwd/golden).read_bytes()
 totals=(cwd/'golden/expon180.1e6.totals').read_bytes().splitlines() if name=='telco' else []
 def run(stage,compute=False):
  args=[str(base/('format-'+stage+'-apps')/name),data]
  if name=='euro':args.append('codex-format-trial-euro.out')
  elif name.startswith('tax-'):args.extend([str(out/name),'1'])
  e=env.copy()
  if compute:e.update(D128_COMPUTE_ITERS=str(samples),D128_COMPUTE_BATCH=str(batch))
  p=subprocess.run(args,cwd=cwd,env=e,capture_output=True,check=True)
  stderr=re.sub(rb'compute-sink -?\d+\n$',b'',p.stderr) if compute else p.stderr
  if name=='telco':assert hashlib.sha256(stderr).hexdigest()==expected.decode().split()[0]
  else:assert stderr==expected,(name,stage,len(stderr),len(expected),stderr[-100:])
  for line in totals:assert line in p.stdout.splitlines()
  return p
 for stage in ['before','after']:
  for i in range(9):
   p=run(stage);gates.append(dict(app=name,stage=stage,run=i+1,passed=True,stderrSHA256=hashlib.sha256(p.stderr).hexdigest()))
 (out/'whole-gates.json').write_text(json.dumps(gates,indent=2)+'\n')
 for pair in range(6):
  for stage in (['before','after'] if pair%2==0 else ['after','before']):
   p=run(stage,True)
   (out/f'{name}-{pair+1}-{stage}.stdout').write_bytes(p.stdout)
   # Preserve smaller transcripts; telco's repeated 6MB output is represented
   # by the original immutable golden and its verified digest.
   if name!='telco':(out/f'{name}-{pair+1}-{stage}.stderr').write_bytes(p.stderr)
   actualBatch=int(re.search(rb'^COMPUTE_BATCH=(\d+)$',p.stdout,re.M)[1]);assert actualBatch==batch
   ns=[int(x) for x in re.search(rb'^COMPUTE_SAMPLES_NS=([\d,]+)$',p.stdout,re.M)[1].split(b',')];assert len(ns)==samples
   values=[x/(records*batch) for x in ns]
   rows.append(dict(app=name,pair=pair+1,stage=stage,records=records,batch=batch,samples=ns,minNs=min(values),medianNs=statistics.median(values),golden=True,stderrSHA256=hashlib.sha256(p.stderr).hexdigest()))
  (out/'runs.json').write_text(json.dumps(rows,indent=2)+'\n')
 print(name+' passed nine goldens per binary and six compute pairs',flush=True)
summary={}
for name,*_ in suites:
 summary[name]={}
 for metric in ['minNs','medianNs']:
  before=[r[metric] for r in rows if r['app']==name and r['stage']=='before'];after=[r[metric] for r in rows if r['app']==name and r['stage']=='after']
  delta=[100*(a/b-1) for a,b in zip(after,before)]
  summary[name][metric]=dict(before=before,after=after,pairedPercent=delta,medianPercent=statistics.median(delta))
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:{m:round(v['medianPercent'],2) for m,v in x.items()} for k,x in summary.items()},indent=2))
