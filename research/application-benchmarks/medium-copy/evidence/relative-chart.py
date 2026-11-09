# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
import statistics

report = Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/medium-copy')
m = json.loads((report / 'measurements.json').read_text())
prior = (report.parent / 'reciprocal-split/relative.html').read_text()
html = prior.split('</style></head><body>')[0] + '</style></head><body>'
html += '<p>Compute time relative to Miguel’s library. <strong>100 = parity; lower is better.</strong><br>Four accepted complete runs on Apple M4 Max. The dashed line marks parity.</p>'
labels = {'euro_conversion': 'Euro conversion', 'tax_preparation/fed': 'Federal tax', 'tax_preparation/ca': 'California tax', 'tax_preparation/nc': 'North Carolina tax', 'telco': 'Telco'}
ratios = {}
for key, label in labels.items():
    row = next(r for r in m['comparisons'] if r['scenario'] == key)
    ratio = row['optimized_mean'] / row['references']['miguel-decimal128-go']['mean']
    ratios[key] = ratio
    color = 'muted-foreground' if abs(ratio - 1) < 0.001 else ('success' if ratio < 1 else 'chart-1')
    html += f'<div class="row"><div>{label}</div><div class="track"><div class="bar" style="width:{100 * ratio / 1.4}%;background:var(--{color})"><span>{100 * ratio:.1f}</span></div></div></div>'
html += f'<p class="note">Telco: {1 / ratios["telco"]:.2f}× Miguel’s throughput. All four accepted runs passed the original output and timing gates. Small relative gaps remain uncertain on this shared host. This pass targets long-format regressions; application timings are mixed versus the preceding build. Risk and banking remain unsupported.</p></body></html>'
html = html.removesuffix('</body></html>')
html += '<p>Long-format regression check: <strong>100 = the pre-short-copy build.</strong><br>Gray: preceding build. Green: current. Three balanced repetitions; lower is better.</p>'
lengths = json.loads((report / 'evidence/length-summary.json').read_text())
for n, drop in [(31, 15), (32, 16), (34, 17)]:
    row = next(v for k, v in lengths.items() if k.startswith(f'BenchmarkCanonicalLength/{n}/drop{drop}-'))
    before = statistics.median(100 * b / p for b, p in zip(row['samples']['before'], row['samples']['prior']))
    after = 100 + row['prior']['medianPercent']
    for label, value, color in [('before', before, 'muted-foreground'), ('after', after, 'success')]:
        html += f'<div class="row"><div>{n} digits · {label}</div><div class="track"><div class="bar" style="width:{value / 1.4}%;background:var(--{color})"><span>{value:.1f}</span></div></div></div>'
html += '<p class="note">The decimal point leaves 15, 16 and 17 fractional digits respectively. Other matrix cases retain costs up to 5.1% versus the preceding build; all rows are archived.</p></body></html>'
(report / 'relative.html').write_text(html)
