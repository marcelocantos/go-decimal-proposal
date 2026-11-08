# Text-conversion evidence

The native and unchanged GDA adapter probes run over the benchmark's existing
FormatCases inputs. Each matrix has six repetitions of 150 ms, alternating
before/candidate order. Formatting candidates use the same b163d98ee4 compiler; only
standard-library formatter source changes. All allocation counts remain one
returned string per operation.

The initial scan and scan-short trials retain their short-exponent regressions.
The scan-canonical matrix measures the retained implementation. These are
per-input diagnostic costs, separate from the application comparisons. Small
non-significant differences do not establish equivalence.

The final candidate's short suites, native decimal/GDA adapter cohort tests,
rebuilt runtime/language/experiment-off checks and both fresh round-trip fuzz
logs are included. The existing independent rounding reference is exercised
by the strconv suite. No copied library implementation is in these changes.

The parser audit compares 545bd7a4be and f90197f3d3 using the same f90197f3d3
compiler. The word-scan trial uses an extra per-digit bound check; the retained
word-keep version precomputes min(keep, 19). Both matrices have six alternating
200 ms repetitions, including float controls. The parser's original provisional
ratchet failure is retained; its 20% band and 0.5 ns slack are unchanged. The
wrong-cwd invocation explicitly skipped and does not count as a pass. The
properly run retained candidate passes all 219 rows from src/internal/bid.
