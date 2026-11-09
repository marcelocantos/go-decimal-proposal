from pathlib import Path
import os,subprocess,json
base=Path(__file__).parent;root=Path('/Users/marcelo/work/wt/gd-survey')
go=str(root/'bin/go')
env=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0',PATH=str(root/'bin')+':/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin')
assert subprocess.check_output(['git','status','--porcelain'],cwd=root)==b''
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root).decode().strip()==json.loads((base/'candidate.json').read_text())['fork']
print(subprocess.check_output([go,'version'],env=env,text=True),flush=True)
checks=[
 ('rebuilt-short',['test','-short','internal/bid','math/decimal','strconv','reflect','fmt','encoding/json','cmd/compile/internal/ssagen','cmd/compile/internal/ssacompile'],{}),
 ('rebuilt-long',['test','internal/bid','-run','^TestUnpackDigits$','-bid.long','-bid.seed=577','-count=1','-v'],{}),
 ('rebuilt-append',['test','internal/bid','-run','^TestKernel$/^group$/^Append','-bid.long','-bid.seed=587','-count=1','-v'],{}),
 ('rebuilt-runtime',['test','runtime','-run','[Dd]ecimal','-count=1'],{}),
 ('rebuilt-language',['test','cmd/internal/testdir','-run','^Test/(decimal.*|codegen/decimal.go)$','-all_codegen','-count=1'],{}),
 ('rebuilt-off',['test','-short','strconv','reflect','fmt','encoding/json','cmd/compile/internal/ssagen','cmd/compile/internal/ssacompile'],{'GOEXPERIMENT':''}),
 ('rebuilt-format',['test','strconv','-run','^(TestFormatDecimal|TestAppendDecimal|TestDecimal.*Roundtrip)','-count=1','-v'],{}),
 ('published',['test','internal/bid','-run','^TestPublishedVectors$','-count=1','-v'],{'BID_DECTEST_DIR':'/Users/marcelo/work/github.com/anz-bank/decimal/dectest','BID_INTEL_READTEST':'/tmp/intel-vec/readtest.in','BID_FPGEN_DIR':'/tmp/fpgen-vectors/decimal'}),
 ('rebuilt-table-operators',['test','internal/bid','-run','^Test(OperatorCompareReference|CompiledRounding)','-bid.long','-bid.seed=593','-count=1','-v'],{}),
 ('ratchet',['test','internal/bid','-run','^TestBench(BaselineShape|CoversAPI|Ratchet)$','-bid.ratchet','-count=1','-v'],{})]
results=[]
for name,args,extra in checks:
 with (base/(name+'.log')).open('w') as f:
  p=subprocess.run([go]+args,cwd=root,env=env|extra,stdout=f,stderr=subprocess.STDOUT)
 results.append(dict(name=name,args=args,env=extra,exit_code=p.returncode))
 (base/'validation.json').write_text(json.dumps(results,indent=2)+'\n')
 print(name+': '+str(p.returncode),flush=True)
 if p.returncode:raise SystemExit(p.returncode)
