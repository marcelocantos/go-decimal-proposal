# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
report = Path(__file__).parent.parent
measurements = json.loads((report / 'measurements.json').read_text())
# Reuse the preceding report's presentation; all numbers come from this cohort.
prior = (report.parent / 'compiler-rounding/relative.html').read_text()
html = prior.split('</style></head><body>')[0] + '</style></head><body>'
html += '<p>Compute time relative to Miguel’s library. <strong>100 = parity; lower is better.</strong><br>Four accepted complete runs on Apple M4 Max. The dashed line marks parity.</p>'
labels = {'euro_conversion': 'Euro conversion', 'tax_preparation/fed': 'Federal tax', 'tax_preparation/ca': 'California tax', 'tax_preparation/nc': 'North Carolina tax', 'telco': 'Telco'}
for key, label in labels.items():
    row = next(r for r in measurements['comparisons'] if r['scenario'] == key)
    relative = 100 * row['optimized_mean'] / row['references']['miguel-decimal128-go']['mean']
    color = 'success' if relative < 100 else 'chart-1'
    html += f'<div class="row"><div>{label}</div><div class="track"><div class="bar" style="width:{relative / 1.4}%;background:var(--{color})"><span>{relative:.1f}</span></div></div></div>'
html += '<p class="note">Telco retains about 2.09× Miguel’s throughput. Euro and tax workloads remain behind. Shared-host measurements; all original output and timing gates passed. Risk and banking remain unsupported.</p></body></html>'
(report / 'relative.html').write_text(html)
