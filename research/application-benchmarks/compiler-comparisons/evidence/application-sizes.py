from pathlib import Path
import subprocess,json
base=Path(__file__).parent
go='/Users/marcelo/work/wt/gd-survey/bin/go'
rows=[]
for stage in ['before','after']:
 for p in sorted((base/(stage+'-apps')).iterdir()):
  if not p.is_file():continue
  raw=subprocess.check_output([go,'tool','nm','-size',str(p)],text=True)
  textbytes=sum(int(s[1]) for line in raw.splitlines() if len(s:=line.split())>=4 and s[2] in ('T','t'))
  rows.append(dict(stage=stage,app=p.name,textSymbolBytes=textbytes,fileBytes=p.stat().st_size))
(base/'application-sizes.json').write_text(json.dumps(rows,indent=2)+'\n')
