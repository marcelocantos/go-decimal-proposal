# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
import os
import re
import statistics
import subprocess

base = Path(__file__).parent
root = Path('/Users/marcelo/work/wt/gd-survey')
env = os.environ | dict(GOEXPERIMENT='decimal', GOWORK='off', GOTOOLCHAIN='local', CGO_ENABLED='0')
go = str(root / 'bin/go')
original = subprocess.check_output(['git', 'show', '8af808ccf2b98a1b1216dd3037f54af10f719eb9:src/strconv/decimal_bid.go'], cwd=root)
assert (base / 'decimal_bid.go').read_bytes() == original
overlay = {'Replace': {str(root / 'src/strconv/decimal_bid.go'): str(base / 'decimal_bid.go')}}
(base / 'precision-overlay.json').write_text(json.dumps(overlay, indent=2) + '\n')
rows = []
with (base / 'precision-probes.txt').open('w') as log:
    for stage in ['before', 'after']:
        args = [go, 'test', '-c', 'strconv', '-o', str(base / (stage + '-strconv.test'))]
        if stage == 'before':
            args += ['-overlay', str(base / 'precision-overlay.json')]
        subprocess.run(args, cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
        subprocess.run([str(base / (stage + '-strconv.test')), '-test.run=^Test(AppendDecimalCanonicalCapacity|FormatDecimalAllocs)$', '-test.count=1'],
                       cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
    for pair in range(6):
        for stage in (['before', 'after'] if pair % 2 == 0 else ['after', 'before']):
            r = subprocess.run([str(base / (stage + '-strconv.test')), '-test.run=^$',
                                '-test.bench=^BenchmarkFormatDecimal64$', '-test.benchmem',
                                '-test.benchtime=150ms', '-test.count=1'],
                               cwd=root, env=env, capture_output=True, text=True, check=True)
            log.write(f'pair={pair + 1} stage={stage}\n' + r.stdout)
            log.flush()
            for name, ns, allocated, allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op', r.stdout, re.M):
                rows.append(dict(pair=pair + 1, stage=stage, name=name, ns=float(ns), bytes=int(allocated), allocs=int(allocs)))
summary = {}
for name in sorted({r['name'] for r in rows}):
    v = {s: [r for r in rows if r['stage'] == s and r['name'] == name] for s in ['before', 'after']}
    assert len(v['before']) == len(v['after']) == 6
    assert all(a['allocs'] == b['allocs'] and a['bytes'] == b['bytes'] for a, b in zip(v['before'], v['after']))
    delta = [100 * (b['ns'] / a['ns'] - 1) for a, b in zip(v['before'], v['after'])]
    summary[name] = dict(**v, pairedPercent=delta, medianPercent=statistics.median(delta))
assert len(summary) == 5
(base / 'precision-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps({k: v['medianPercent'] for k, v in summary.items()}, indent=2))
