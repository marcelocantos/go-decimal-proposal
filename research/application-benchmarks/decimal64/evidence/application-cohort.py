from pathlib import Path
import json,os,subprocess
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
out=Path(__file__).parent
pins=json.loads((out/'candidate.json').read_text());fork=pins['fork'];bench=pins['benchmark']
env=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0',PATH='/Users/marcelo/work/wt/gd-survey/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin')
def records():
 return [json.loads(line) for p in (root/'results/data').glob('*.jsonl') if p.name!='startup.jsonl' for line in p.read_text().splitlines() if line]
shape=sorted((lib,app,sub) for lib in ['go-decimal-poc64','go-decimal-poc'] for app,sub in [('euro_conversion',''),('risk_management',''),('tax_preparation','fed'),('tax_preparation','ca'),('tax_preparation','nc'),('banking',''),('telco','')])
accepted=0;attempts=[]
for attempt in range(1,13):
 existing=sorted({r['timestamp_utc'] for r in records() if r.get('bench_commit')==bench and r.get('go_source_commit')==fork and not r.get('bench_dirty') and r['impl'] in ['go-decimal-poc64','go-decimal-poc']})
 if attempt<=len(existing):
  new=[r for r in records() if r['timestamp_utc']==existing[attempt-1]]
 else:
  prior={r['timestamp_utc'] for r in records()}
  with (out/f'apps-{attempt}.log').open('w') as log:
   subprocess.run(['go','run','./cmd/bench','-lib','go-decimal-poc64,go-decimal-poc' if attempt%2 else 'go-decimal-poc,go-decimal-poc64'],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
  new=[r for r in records() if r['timestamp_utc'] not in prior]
 assert len({r['timestamp_utc'] for r in new})==1
 assert sorted((r['impl'],r['app'],r.get('sub') or '') for r in new)==shape
 assert all(r['go_source_commit']==fork and r['bench_commit']==bench and not r['bench_dirty'] and not r['go_source_dirty'] for r in new)
 supported=[r for r in new if r['compute_status']!='unsupported']
 assert all(r['correct'] and r['gate_runs']==9 and r['gate_runs_passed']==9 for r in supported),'Output gate failure'
 failures=[(r['impl'],r['app'],r.get('sub') or '') for r in supported if r['compute_status']!='ok' or r.get('compute_xcheck_flag',False) or r.get('compute_ns_per_record',0)<=0]
 if not failures:accepted+=1
 attempts.append(dict(attempt=attempt,timestamp=new[0]['timestamp_utc'],accepted=not failures,failures=failures))
 (out/'cohort-status.json').write_text(json.dumps(attempts,indent=2)+'\n')
 print(f'Application attempt {attempt}: '+('accepted' if not failures else 'excluded '+str(failures))+f'; {accepted}/4 accepted',flush=True)
 if accepted==4:break
else:raise RuntimeError('No four accepted complete invocations within 12 attempts')
