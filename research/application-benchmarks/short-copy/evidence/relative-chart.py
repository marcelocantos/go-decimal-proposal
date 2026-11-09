# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json

report = Path('/Users/marcelo/.cache/codex-decimal-gate/proposal-push/research/application-benchmarks/short-copy')
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
    color = 'muted-foreground' if key == 'tax_preparation/nc' else ('success' if ratio < 1 else 'chart-1')
    html += f'<div class="row"><div>{label}</div><div class="track"><div class="bar" style="width:{100 * ratio / 1.4}%;background:var(--{color})"><span>{100 * ratio:.1f}</span></div></div></div>'
html += f'<p class="note">Telco: {1 / ratios["telco"]:.2f}× Miguel’s throughput. All four accepted runs passed the original output and timing gates. North Carolina is effectively tied (0.04% less time). California’s 1.5% lead is small; relative gaps remain uncertain on this shared host. Risk and banking remain unsupported.</p></body></html>'
(report / 'relative.html').write_text(html)
