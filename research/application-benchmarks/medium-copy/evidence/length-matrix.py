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
pins = {'prior': '082f0305dd29cbefbc22deedc336eef078a75e8c',
        'before': 'a8c82228ec485fbd13f8766a19e7c7a27b937781',
        'after': json.loads((base / 'candidate.json').read_text())['fork']}
old_test = (base.parent / 'length-test.go').read_text()
benchmark = old_test[old_test.index('// Diagnostic matrix:'):]
test = base / 'length-test.go'
test.write_text((root / 'src/strconv/decimal_bid_test.go').read_text() + '\n' + benchmark)
for stage, revision in pins.items():
    source = base / (stage + '-decimal_bid.go')
    source.write_bytes(subprocess.check_output(['git', 'show', revision + ':src/strconv/decimal_bid.go'], cwd=root))
    overlay = base / ('length-' + stage + '.json')
    overlay.write_text(json.dumps({'Replace': {
        str(root / 'src/strconv/decimal_bid.go'): str(source),
        str(root / 'src/strconv/decimal_bid_test.go'): str(test),
    }}, indent=2) + '\n')
    subprocess.run([go, 'test', '-overlay', str(overlay), '-c', 'strconv', '-o', str(base / ('length-' + stage + '.test'))], cwd=root, env=env, check=True)
rows = []
orders = [['prior', 'before', 'after'], ['before', 'after', 'prior'], ['after', 'prior', 'before']]
with (base / 'length-pairs.txt').open('w') as log:
    for pair, order in enumerate(orders, 1):
        for stage in order:
            p = subprocess.run([str(base / ('length-' + stage + '.test')), '-test.run=^TestAppendDecimalCanonicalCapacity$', '-test.bench=^BenchmarkCanonicalLength$', '-test.benchmem', '-test.benchtime=75ms'], cwd=root, env=env, capture_output=True, text=True, check=True)
            log.write(f'pair={pair} stage={stage}\n' + p.stdout)
            log.flush()
            for name, ns, allocated, allocs in re.findall(r'^(Benchmark\S+)\s+\d+\s+([\d.]+) ns/op\s+(\d+) B/op\s+(\d+) allocs/op', p.stdout, re.M):
                assert int(allocated) == int(allocs) == 0
                rows.append(dict(pair=pair, stage=stage, name=name, ns=float(ns)))
summary = {}
for name in sorted({r['name'] for r in rows}):
    values = {s: [r['ns'] for r in rows if r['name'] == name and r['stage'] == s] for s in pins}
    assert all(len(v) == len(orders) for v in values.values())
    row = dict(samples=values)
    for stage in ['prior', 'before']:
        delta = [100 * (a / b - 1) for a, b in zip(values['after'], values[stage])]
        row[stage] = dict(pairedPercent=delta, medianPercent=statistics.median(delta))
    summary[name] = row
(base / 'length-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
(base / 'length-provenance.json').write_text(json.dumps(dict(revisions=pins, orders=orders, samples=3, benchtime='75ms', purpose='Diagnostic, separate from acceptance and headline application timings'), indent=2) + '\n')
for name, row in summary.items():
    print(name, 'vs current:', round(row['before']['medianPercent'], 2), 'vs pre-short:', round(row['prior']['medianPercent'], 2), flush=True)
