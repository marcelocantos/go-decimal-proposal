# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
import re
import shutil
import statistics

base = Path(__file__).parent
report = Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/medium-copy')
readme = (report / 'README.md').read_text()

def block(name, text):
    global readme
    pattern = '<!-- ' + name + ':start -->' + r'[\s\S]*?<!-- ' + name + ':end -->'
    readme = re.sub(pattern, '<!-- ' + name + ':start -->\n' + text + '\n<!-- ' + name + ':end -->', readme)

validation = json.loads((base / 'validation.json').read_text())
assert len(validation) == 10 and all(v['exit_code'] == 0 for v in validation)
block('validation', '''All ten validation groups pass on the coherently rebuilt clean revision:
affected enabled packages; fresh million-case digit references per width
(seed 673); fresh million-case Append references per width (seed 677);
runtime decimal; language and ARM64/AMD64 code generation; experiment-off
packages; explicit formatting, carry, capacity and round-trip tests; published
vectors; long independent compiled comparison/rounding references (seed 683);
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

lengths = json.loads((base / 'length-summary.json').read_text())
lines = ['| Digits / fractional digits | Versus preceding build | Versus pre-short-copy build |', '|---|---:|---:|']
for n, drop in [(9, 4), (31, 15), (32, 16), (34, 17)]:
    row = next(v for k, v in lengths.items() if k.startswith(f'BenchmarkCanonicalLength/{n}/drop{drop}-'))
    lines.append(f"| {n} / {drop} | {row['before']['medianPercent']:+.2f}% | {row['prior']['medianPercent']:+.2f}% |")
for stage, label in [('before', 'preceding'), ('prior', 'pre-short-copy')]:
    name, row = max(lengths.items(), key=lambda pair: pair[1][stage]['medianPercent'])
    lines.append(f"\nThe largest positive median in the full matrix versus the {label} build is {row[stage]['medianPercent']:+.2f}% at `{name}`.")
block('lengths', '\n'.join(lines) + '\n\nThe three-revision diagnostic runs three balanced rotations of all 2–34 digit\nlengths at two point placements. All source overlays are byte-for-byte git\nsnapshots under the same final compiler. All allocations are zero and the\nexpanded capacity oracle passes before every timed invocation. It does not\nreplace the original 37-row primary protocol or the 221-row ratchet. Full\nrows, pair deltas and provenance are retained in evidence/length-summary.json\nand evidence/length-provenance.json. Positive changes are costs, not omitted cases.')
precision = json.loads((base / 'precision-summary.json').read_text())
lines = ['| Existing formatting probe | Median paired change |', '|---|---:|']
for name, row in precision.items():
    lines.append(f"| {name} | {row['medianPercent']:+.2f}% |")
block('precision', '\n'.join(lines) + '\n\nSix alternating pairs of the existing decimal64 formatting probes, including\nexplicit precision Fixed3. Byte and allocation counts are unchanged. These\nadditional diagnostics remain separate from the fixed primary protocol.')
profiles = json.loads((base / 'profiles/summary.json').read_text())
block('profile', f"For the formerly regressing 31-digit / 15-fractional-digit append, runtime.memmove\naccounts for {profiles['before']['memmovePercent']:.1f}% of the benchmark subtree's CPU samples before and\n{profiles['after']['memmovePercent']:.1f}% after. These profiles verify execution of the targeted path; they\nare diagnostics, not headline timing. Missing samples do not prove a function\nhas zero cost for other inputs. Source still retains general copy fallbacks.\nThe raw profiles and complete node listings are archived.")

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
archive(base.parent, report / 'evidence/development/cold-state')
for name in ['word4', 'word8', 'head-tail']:
    archive(base.parent / name, report / 'evidence/development' / name)
print('Final report and evidence archived')
