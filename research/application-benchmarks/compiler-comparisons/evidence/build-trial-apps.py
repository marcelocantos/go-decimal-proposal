from pathlib import Path
import os,subprocess
base=Path(__file__).parent
root=Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
go=Path('/Users/marcelo/work/wt/gd-survey/bin/go')
env=os.environ|dict(GOEXPERIMENT='decimal',GOWORK='off',GOTOOLCHAIN='local',CGO_ENABLED='0')
out=base/'after-apps';out.mkdir(exist_ok=True)
for name,folder in [('euro','euro_conversion'),('tax-fed','tax_preparation'),('tax-ca','tax_preparation'),('tax-nc','tax_preparation'),('telco','telco')]:
 subprocess.run([str(go),'build','-tags=go_decimal_poc','-o',str(out/name),'./apps/'+folder+'/cmd/'+name],cwd=root,env=env,check=True)
