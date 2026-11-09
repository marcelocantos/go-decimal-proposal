# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json
report=Path(__file__).parent.parent
m=json.loads((report/'measurements.json').read_text())
prior=(report.parent/'compiler-rounding/relative.html').read_text()
html=prior.split('</style></head><body>')[0]+'</style></head><body>'
html+='<p>Compute time relative to Miguel’s library. <strong>100 = parity; lower is better.</strong><br>Four accepted complete runs on Apple M4 Max. The dashed line marks parity.</p>'
labels={'euro_conversion':'Euro conversion','tax_preparation/fed':'Federal tax','tax_preparation/ca':'California tax','tax_preparation/nc':'North Carolina tax','telco':'Telco'}
ratios={}
for key,label in labels.items():
 row=next(r for r in m['comparisons'] if r['scenario']==key)
 ratio=row['optimized_mean']/row['references']['miguel-decimal128-go']['mean'];ratios[key]=ratio
 color='success' if ratio<1 else 'chart-1'
 html+=f'<div class="row"><div>{label}</div><div class="track"><div class="bar" style="width:{100*ratio/1.4}%;background:var(--{color})"><span>{100*ratio:.1f}</span></div></div></div>'
html+=f'<p class="note">Telco: {1/ratios["telco"]:.2f}× Miguel’s throughput. North Carolina is effectively tied (0.04% behind). Shared-host measurements; all four accepted runs passed the original output and timing gates. POC absolute times rose versus the previous cohort; relative standings alone do not prove an optimization gain. Risk and banking remain unsupported.</p></body></html>'
for key,value in {'font-sans':'system-ui','font-mono':'monospace','foreground':'CanvasText','muted-foreground':'GrayText','border':'GrayText','chart-1':'Highlight','success':'Highlight'}.items():html=html.replace('var(--'+key+')','var(--'+key+','+value+')')
(report/'relative.html').write_text(html)
