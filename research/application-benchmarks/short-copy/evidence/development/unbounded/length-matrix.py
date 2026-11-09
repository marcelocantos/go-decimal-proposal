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
go = str(root / 'bin/go')
env = os.environ | dict(GOEXPERIMENT='decimal', GOWORK='off', GOTOOLCHAIN='local', CGO_ENABLED='0')
for stage, source in [('before', 'baseline-decimal_bid.go'), ('after', 'loop-decimal_bid.go')]:
    overlay = base / ('length-' + stage + '.json')
    overlay.write_text(json.dumps({'Replace': {
        str(root / 'src/strconv/decimal_bid.go'): str(base / source),
        str(root / 'src/strconv/decimal_bid_test.go'): str(base / 'length-test.go'),
    }}, indent=2) + '\n')
    subprocess.run([go, 'test', '-overlay', str(overlay), '-c', 'strconv', '-o', str(base / ('length-' + stage + '.test'))], cwd=root, env=env, check=True)
rows = []
with (base / 'length-pairs.txt').open('w') as log:
    for pair in range(3):
        for stage in (['before', 'after'] if pair % 2 == 0 else ['after', 'before']):
            p = subprocess.run([str(base / ('length-' + stage + '.test')), '-test.run=^TestAppendDecimalCanonicalCapacity$', '-test.bench=^BenchmarkCanonicalLength$', '-test.benchmem', '-test.benchtime=75ms'], cwd=root, env=env, capture_output=True, text=True, check=True)
            log.write(f'pair={pair + 1} stage={stage}\n' + p.stdout)
            log.flush()
            for name, ns, allocated, allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op', p.stdout, re.M):
                assert int(allocated) == int(allocs) == 0
                rows.append(dict(pair=pair + 1, stage=stage, name=name, ns=float(ns)))
summary = {}
for name in sorted({r['name'] for r in rows}):
    before = [r['ns'] for r in rows if r['name'] == name and r['stage'] == 'before']
    after = [r['ns'] for r in rows if r['name'] == name and r['stage'] == 'after']
    assert len(before) == len(after) == 3
    delta = [100 * (a / b - 1) for a, b in zip(after, before)]
    summary[name] = dict(before=before, after=after, pairedPercent=delta, medianPercent=statistics.median(delta))
(base / 'length-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
for n in range(2, 35):
    print(n, [round(v['medianPercent'], 2) for k, v in summary.items() if k.startswith(f'BenchmarkCanonicalLength/{n}/')], flush=True)
