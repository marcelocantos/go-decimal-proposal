# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import json

base = Path(__file__).parent
profiles = base / 'profiles'
summary = {}
for name in ['euro', 'fed']:
    rows = [line.split() for line in (profiles / (name + '-cum.txt')).read_text().splitlines()]
    def cumulative(suffix):
        matches = [row for row in rows if len(row) >= 6 and row[-1].endswith(suffix)]
        assert len(matches) == 1, (name, suffix, matches)
        return float(matches[0][-3].removesuffix('s'))
    timed = cumulative('internal/harness.BestOf')
    string = cumulative('internal/decimal.Decimal128.String')
    summary[name] = dict(timed_seconds=timed, string_cumulative_seconds=string,
                         string_timed_percent=100 * string / timed)
(profiles / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
pins = json.loads((base / 'candidate.json').read_text())
provenance = dict(**pins, golden_checked=True, compute_iterations=12000,
                  instrumentation='Original entrypoints wrapped with runtime/pprof using source overlays.',
                  use='Diagnostic CPU samples only; not headline timing measurements.')
(profiles / 'provenance.json').write_text(json.dumps(provenance, indent=2) + '\n')
print(json.dumps(summary, indent=2))
