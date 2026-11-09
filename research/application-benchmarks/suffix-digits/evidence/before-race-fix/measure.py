from pathlib import Path
import subprocess,json,os,datetime
base=Path(__file__).parent;go=Path('/Users/marcelo/work/wt/gd-survey');bench=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
env=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0',PATH=str(go/'bin')+':/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin')
checks=json.loads((base/'validation.json').read_text());assert len(checks)==9 and all(r['exit_code']==0 for r in checks)
assert subprocess.check_output(['git','status','--porcelain'],cwd=go)==b''
assert subprocess.check_output(['git','status','--porcelain'],cwd=bench)==b''
def call(args,cwd=bench,log=None):
 if log:
  with (base/log).open('w') as f:subprocess.run(args,cwd=cwd,env=env,stdout=f,stderr=subprocess.STDOUT,check=True)
 else:subprocess.run(args,cwd=cwd,env=env,check=True)
def probe(*args):return subprocess.check_output(args,text=True).strip()
machine=dict(captured_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),os=probe('sw_vers','-productVersion'),os_build=probe('sw_vers','-buildVersion'),arch=probe('uname','-m'),cpu=probe('sysctl','-n','machdep.cpu.brand_string'),cores=int(probe('sysctl','-n','hw.ncpu')),ram_gib=int(probe('sysctl','-n','hw.memsize'))//2**30,provenance='Fresh sw_vers and sysctl probes before application cohort.')
(base/'machine.json').write_text(json.dumps(machine,indent=2)+'\n')
call(['go','test','-tags=go_decimal_poc','./internal/decimal','-count=1','-v'],log='adapter-correctness.log')
call(['python3',str(base/'trial.py')],log='final-trial.log')
print('Six final native/mixed/adapter and original application pairs passed',flush=True)
keep=False
with (base/'adapter-costs.txt').open('w') as f:
 for line in (base/'primitive-pairs.txt').read_text().splitlines(True):
  if line.startswith('pair='):keep='stage=after kind=adapter' in line
  if keep:f.write(line)
call(['python3',str(base/'application-cohort.py')]);print('Full cohort complete',flush=True)
