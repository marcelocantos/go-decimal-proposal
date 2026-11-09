# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
import subprocess

base = Path(__file__).parent
go = '/Users/marcelo/work/wt/gd-survey/bin/go'
p = base / 'profiles'
p.mkdir(exist_ok=True)
summary = {}
for stage in ['before', 'after']:
    binary = base / ('length-' + stage + '.test')
    profile = p / (stage + '.cpu')
    result = subprocess.run([str(binary), '-test.run=^$', '-test.bench=^BenchmarkCanonicalLength$/^31$/^drop15$', '-test.benchtime=2s', '-test.cpuprofile=' + str(profile)], capture_output=True, text=True, check=True)
    (p / (stage + '.stdout')).write_text(result.stdout)
    (p / (stage + '.stderr')).write_text(result.stderr)
    top = subprocess.check_output([go, 'tool', 'pprof', '-top', '-cum', '-nodecount=0', '-nodefraction=0', '-edgefraction=0', '-focus=BenchmarkCanonicalLength', str(binary), str(profile)], text=True)
    (p / (stage + '-top.txt')).write_text(top)
    values = {}
    for line in top.splitlines():
        fields = line.split()
        if len(fields) >= 6 and fields[3].endswith('s'):
            try:
                values[fields[5]] = float(fields[3][:-1])
            except ValueError:
                pass
    timed = sum(v for name, v in values.items() if name.endswith('BenchmarkCanonicalLength.func1'))
    assert timed > 0
    memmove = values.get('runtime.memmove', 0)
    summary[stage] = dict(timedSeconds=timed, memmoveSeconds=memmove, memmovePercent=100 * memmove / timed)
    assembly = subprocess.check_output([go, 'tool', 'objdump', '-s', '^strconv.appendDecimal$', str(binary)], text=True)
    (base / (stage + '-append.asm')).write_text(assembly)
(p / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
print(summary)
