from pathlib import Path
import subprocess
b=Path(__file__).parent
with (b/'fallback-pairs.txt').open('w') as f:
 for pair in range(3):
  for stage in (['before','after'] if pair%2==0 else ['after','before']):
   f.write(f'pair={pair+1} stage={stage}\n');f.flush()
   subprocess.run([str(b/(stage+'-bid.test')),'-test.run=^$','-test.bench=^BenchmarkUnpackDigitsCases$','-test.benchtime=150ms','-test.benchmem'],stdout=f,stderr=subprocess.STDOUT,check=True)
subprocess.run(['python3',str(b/'fallback-summary.py')],check=True)
