## arm64

unknown · go1.27.3 · all rows measured in one run, 2026-11-09 11:45 UTC · benchmark code `9986cf2`

Startup baseline: **2.67 ms** (fastest of 45 launches between the whole runs, measured 2026-11-09 11:45 UTC).

| app | library | compute | median | p10–p90 | xcheck | whole | startup | correct |
|---|---|--:|--:|--:|--:|--:|--:|:--:|
| euro_conversion | miguel-decimal128-go `073024a` | 891.7 | 927.5 | 904.4–991.2 | 1.05 | 33,586.7 | 26,662.5 | ✓ |
| euro_conversion | bid754 `v0.2.0` | 2,560.8 | 2,712.1 | 2,650.0–2,967.3 | 1.08 | 35,547.1 | 26,662.5 | ✓ |
| risk_management | miguel-decimal128-go `073024a` | 12,704.1 | 13,364.5 | 13,152.1–14,331.6 | 1.05 | 238,541.7 | 133,312.5 | 20/20 |
| risk_management | bid754 `v0.2.0` | not supported | — | — | — | — | — | — |
| tax_preparation fed | miguel-decimal128-go `073024a` | 2,617.7 | 2,769.8 | 2,707.3–2,904.2 | 1.08 | 3,154,750.0 | 2,666,250.0 | ✓ |
| tax_preparation fed | bid754 `v0.2.0` | 10,462.1 | 11,469.7 | 11,242.5–11,954.5 | 1.09 | 3,188,792.0 | 2,666,250.0 | ✓ |
| tax_preparation ca | miguel-decimal128-go `073024a` | 472.5 | 510.4 | 492.5–527.3 | 1.13 | 3,067,917.0 | 2,666,250.0 | ✓ |
| tax_preparation ca | bid754 `v0.2.0` | 2,050.8 | 2,286.7 | 2,237.5–2,362.5 | 1.18 | 3,027,166.0 | 2,666,250.0 | ✓ |
| tax_preparation nc | miguel-decimal128-go `073024a` | 783.5 | 855.4 | 826.4–896.5 | 1.10 | 3,034,208.0 | 2,666,250.0 | ✓ |
| tax_preparation nc | bid754 `v0.2.0` | 3,225.6 | 3,662.4 | 3,553.2–3,936.8 | 1.11 | 3,171,083.0 | 2,666,250.0 | ✓ |
| banking | miguel-decimal128-go `073024a` | 850.5 | 909.3 | 879.0–1,097.2 | 2.04 | 7,013.5 | 4,146.6 | ✓ |
| banking | bid754 `v0.2.0` | not supported | — | — | — | — | — | — |
| telco | miguel-decimal128-go `073024a` | 84.9 | 87.2 | 85.9–88.5 | 1.05 | 93.7 | 2.7 | ✓ |
| telco | bid754 `v0.2.0` | not supported | — | — | — | — | — | — |

> bid754 does not run risk_management: bid754 has no power function.
> bid754 does not run banking: bid754 has no logarithm or compound.
> bid754 does not run telco: bid754 quantizes ties-to-even only; telco truncates its taxes.
