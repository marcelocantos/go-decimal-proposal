from pathlib import Path
import subprocess,os,re,json,statistics
b=Path(__file__).parent;go=Path('/Users/marcelo/work/wt/gd-survey');root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
e=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0',PATH=str(go/'bin')+':/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin')
def run(args,cwd=go):subprocess.run(args,cwd=cwd,env=e,check=True)
run(['go','test','-c','internal/bid','-o',str(b/'after-bid.test')]);run(['go','test','-c','-tags=go_decimal_poc','./internal/decimal','-o',str(b/'after-adapter.test')],root)
a=b/'after-apps';a.mkdir(exist_ok=True)
for name,folder in [('euro','euro_conversion'),('tax-fed','tax_preparation'),('tax-ca','tax_preparation'),('tax-nc','tax_preparation'),('telco','telco')]:run(['go','build','-tags=go_decimal_poc','-o',str(a/name),'./apps/'+folder+'/cmd/'+name],root)
rows=[]
with (b/'primitive-pairs.txt').open('w') as log:
 for pair in range(6):
  for stage in (['before','after'] if pair%2==0 else ['after','before']):
   for kind,pattern in [('bid','^Benchmark(Kernel|UnpackDigitsCases)$/^(Append|UnpackDigits|decimal64|decimal128)$'),('adapter','^BenchmarkAdapter(Cost|FormatCases)$')]:
    r=subprocess.run([str(b/(stage+'-'+kind+'.test')),'-test.run=^$','-test.bench='+pattern,'-test.benchmem','-test.benchtime=150ms','-test.count=1'],cwd=root,env=e,capture_output=True,text=True,check=True)
    log.write(f'pair={pair+1} stage={stage} kind={kind}\n'+r.stdout);log.flush()
    for name,ns,allocated,allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op',r.stdout,re.M):rows.append(dict(pair=pair+1,stage=stage,name=name,ns=float(ns),bytes=int(allocated),allocs=int(allocs)))
summary={}
for name in sorted({r['name'] for r in rows}):
 v={s:[r for r in rows if r['stage']==s and r['name']==name] for s in ['before','after']}
 assert len(v['before'])==len(v['after'])==6
 assert all(x['allocs']==y['allocs'] and x['bytes']==y['bytes'] for x,y in zip(v['before'],v['after']))
 delta=[100*(y['ns']/x['ns']-1) for x,y in zip(v['before'],v['after'])]
 summary[name]=dict(before=v['before'],after=v['after'],pairedPercent=delta,medianPercent=statistics.median(delta))
assert len(summary)==37,len(summary)
(b/'primitive-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:round(v['medianPercent'],1) for k,v in summary.items()},indent=2),flush=True)
run(['python3',str(b/'paired-apps.py')])
