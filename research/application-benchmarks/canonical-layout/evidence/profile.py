from pathlib import Path
import subprocess,os,re,json,difflib
base=Path(__file__).parent;p=base/'profiles'
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
go='/Users/marcelo/work/wt/gd-survey/bin/go'
env=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0')
for source,target in json.loads((p/'overlay.json').read_text())['Replace'].items():
 diff=''.join(difflib.unified_diff(Path(source).read_text().splitlines(True),Path(target).read_text().splitlines(True),fromfile=source,tofile=target))
 (p/(Path(target).stem+'.patch')).write_text(diff)
suites=[('euro','euro_conversion','euro','testGen/bin/Euro.bin.BID128','golden/Euro.output.DECNUMBER_FIXED128',4),('fed','tax_preparation','tax-fed','testGen/bin/Tax.FED.bin.BID128','golden/Tax.FED.stderr.golden',400)]
for name,folder,cmd,data,golden,batch in suites:
 binary=p/(name+'.bin')
 subprocess.run([go,'build','-overlay',str(p/'overlay.json'),'-tags=go_decimal_poc','-o',str(binary),'./apps/'+folder+'/cmd/'+cmd],cwd=root,env=env,check=True)
 args=[str(binary),data,str(p/(name+'.out'))]
 if name=='fed':args.append('1')
 r=subprocess.run(args,cwd=root/'data'/folder,env=env|dict(DECIMAL_DIAGNOSTIC_PROFILE=str(p/(name+'.cpu')),D128_COMPUTE_ITERS='12000',D128_COMPUTE_BATCH=str(batch)),capture_output=True,check=True)
 (p/(name+'.stdout')).write_bytes(r.stdout);(p/(name+'.stderr')).write_bytes(r.stderr)
 assert re.sub(rb'compute-sink -?\d+\n$',b'',r.stderr)==(root/'data'/folder/golden).read_bytes()
 for order in ['flat','cum']:
  text=subprocess.check_output([go,'tool','pprof','-top','-'+order,'-nodecount=30','-focus=internal/harness.BestOf',str(binary),str(p/(name+'.cpu'))],text=True,env=env)
  (p/(name+'-'+order+'.txt')).write_text(text)
 print(name+' profile passed original golden',flush=True)
