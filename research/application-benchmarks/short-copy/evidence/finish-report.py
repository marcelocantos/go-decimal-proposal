# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
import re
import shutil
import statistics

base = Path(__file__).parent
report = Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/short-copy')
readme = (report / 'README.md').read_text()

def block(name, text):
    global readme
    pattern = '<!-- ' + name + ':start -->' + r'[\s\S]*?<!-- ' + name + ':end -->'
    readme = re.sub(pattern, '<!-- ' + name + ':start -->\n' + text + '\n<!-- ' + name + ':end -->', readme)

validation = json.loads((base / 'validation.json').read_text())
assert len(validation) == 10 and all(v['exit_code'] == 0 for v in validation)
block('validation', '''All ten validation groups pass on the coherently rebuilt clean revision:
affected enabled packages; fresh million-case digit references per width
(seed 647); fresh million-case Append references per width (seed 653);
runtime decimal; language and ARM64/AMD64 code generation; experiment-off
packages; explicit formatting, carry, capacity and round-trip tests; published
vectors; long independent compiled comparison/rounding references (seed 659);
and the unchanged 221-row kernel performance ratchet. Published vectors report
114,915 passing, zero failing and 111,327 skipped outside the supported kernel
scope. No gate, slack, baseline, workload, dependency or output golden changed.''')

probes = json.loads((base / 'primitive-summary.json').read_text())
assert len(probes) == 37
lines = ['| Probe | Before ns | After ns | Median paired change |', '|---|---:|---:|---:|']
for name, row in probes.items():
    label = re.sub(r'-\d+$', '', name).removeprefix('Benchmark')
    before = statistics.median(v['ns'] for v in row['before'])
    after = statistics.median(v['ns'] for v in row['after'])
    lines.append(f"| {label} | {before:.2f} | {after:.2f} | {row['medianPercent']:+.1f}% |")
block('primitive', '\n'.join(lines) + '\n\nSix alternating pairs; all paired byte and allocation counts are unchanged.\nThe kernel, decoder and float rows are controls: this source change is only\nin strconv layout, so their movement is not credited to direct placement.')

apps = json.loads((base / 'paired-apps/summary.json').read_text())
lines = ['| Workload | Best-sample change | Median-sample change |', '|---|---:|---:|']
for name, row in apps.items():
    lines.append(f"| {name} | {row['minNs']['medianPercent']:+.2f}% | {row['medianNs']['medianPercent']:+.2f}% |")
block('paired', '\n'.join(lines) + '\n\nMedians of six alternating paired changes. Every binary passed nine original\noutput goldens; telco retains the original digest and totals. These diagnostics\ndo not replace the full runner clock gate. The application source is identical\nbetween the pinned benchmark commits, which differ only in recorded results.')

measurements = json.loads((report / 'measurements.json').read_text())
labels = {'euro_conversion': 'Euro', 'tax_preparation/fed': 'Federal tax', 'tax_preparation/ca': 'California tax', 'tax_preparation/nc': 'North Carolina tax', 'telco': 'Telco'}
lines = []
for row in measurements['comparisons']:
    if row['status'] != 'ok':
        continue
    ratio = row['optimized_mean'] / row['references']['miguel-decimal128-go']['mean']
    lines.append(f"{labels[row['scenario']]} uses {100 * abs(ratio - 1):.2f}% {'less' if ratio < 1 else 'more'} time than Miguel")
status = json.loads((base / 'cohort-status.json').read_text())
assert sum(v['accepted'] for v in status) == 4
rejected = sum(not v['accepted'] for v in status)
block('conclusion', '; '.join(lines) + f'.\n\nFour complete invocations passed every original output and timing gate.\nThere were {rejected} excluded complete invocations; all attempts remain archived.\nSmall relative differences remain uncertain on the shared host. The original\nunsupported scenarios remain outside these five supported-workload comparisons.')

sizes = json.loads((base / 'application-sizes.json').read_text())
lines = ['| Application | Before text bytes | After text bytes | Change |', '|---|---:|---:|---:|']
for name in sorted({r['app'] for r in sizes}):
    a = next(r for r in sizes if r['app'] == name and r['stage'] == 'before')['textSymbolBytes']
    b = next(r for r in sizes if r['app'] == name and r['stage'] == 'after')['textSymbolBytes']
    lines.append(f'| {name} | {a:,} | {b:,} | {100 * (b / a - 1):+.2f}% |')
block('size', '\n'.join(lines) + '\n\nText sizes sum T/t symbols from go tool nm -size. Complete file sizes and\nappendDecimal disassemblies are retained in evidence.')

profiles = json.loads((base / 'profiles/summary.json').read_text())
a, b = profiles['before'], profiles['after']
block('profile', f'''Fresh California profiles use the same final compiler, with the baseline
formatting source supplied through a byte-verified overlay. Both pass the
original golden. String accounts for {a['stringPercent']:.1f}% before and
{b['stringPercent']:.1f}% after of samples within the timed BestOf subtree;
memmove accounts for {a['memmovePercent']:.1f}% and {b['memmovePercent']:.1f}%.
These diagnostic samples and their total times do not replace uninstrumented
timings or establish the cause of the preceding reciprocal-split regression.
Raw CPU profiles, all-node listings, source overlays and provenance are retained.

The final three-pair length matrix repeats every supported coefficient length
against baseline source under the final compiler. It is separate from the
37-row primary probes and the unchanged 221-row acceptance ratchet. All matrix
allocations remain zero; capacity checks run before each timed invocation.''')

(report / 'README.md').write_text(readme)
allowed = {'.py', '.go', '.log', '.txt', '.json', '.asm', '.patch', '.stdout', '.stderr', '.cpu'}

def archive(source, target):
    target.mkdir(parents=True, exist_ok=True)
    for p in source.iterdir():
        if p.is_symlink() or 'commit-review' in p.name:
            continue
        if p.is_file() and p.suffix in allowed:
            shutil.copy2(p, target / p.name)
    for name in ['paired-apps', 'profiles']:
        if (source / name).is_dir():
            archive(source / name, target / name)

archive(base, report / 'evidence')
archive(base.parent, report / 'evidence/development/unbounded')
for name in ['verb-only', 'bounded']:
    archive(base.parent / name, report / 'evidence/development' / name)
print('Final report and evidence archived')
