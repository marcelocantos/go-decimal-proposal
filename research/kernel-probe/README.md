# Kernel probe: decimal64 against Python's decimal module

A differential test of the fork's `decimal64` arithmetic, written outside the
kernel's own test suite and judged by a reference that shares no code with
it.

## Origin

The probe was written on 3 November 2026 by a GPT-6 Astra session asked to
red-team the proposal, as "Independent decimal64 conformance probe". The
kernel and its tests were written mostly by Claude models. The brief asked
the session not to take the repository's tests or conformance claims as
given, and to choose cases from the IEEE 754-2019 decimal64 rules rather
than from the repository's suites. "Independent" here means a different
model, working from the standard and Python's `decimal` module; no person
wrote or reviewed it. It ran then at fork commit `3395b13718` and found no
discrepancy in 97,130 cases on each of three targets.

## What it checks

For add, subtract, multiply, divide and quantize, in every rounding mode:

- 900 pairs from 30 boundary values: signed and exponent-varying zeros, both
  finite extremes, subnormals, neighbours of the normal boundary,
  coefficient carries, infinities, quiet and signalling NaN;
- 360 pairs aimed at half ties, near ties, carries, cancellation and gradual
  underflow;
- 2,500 seeded random pairs (seed 20261103) over both BID encoding forms.

It also checks 20 parse cases per mode, with their Inexact, Overflow and
Underflow status, and 3,030 round trips through `fmt.Sprint` and
`strconv.ParseDecimal`. `probe.py` encodes operands to BID and decodes
results with its own formulas, never the fork's parser or unpacker, and
compares sign, coefficient digits and exponent, so the quantum and the sign
of a zero count. Expected results come from Python's `decimal` module at
precision 16 with decimal64's exponent range and clamping. `driver.go` runs
each case through `internal/bid` and, where there is one, through the public
path: the operators for ties to even, and `decimal.QuantizeMode` in every
mode.

## Changes since 3 November

The sources are the original's, with these changes for the current fork:

- `math.Decimal64frombits`, `math.Decimal64bits` and `math.Decimal64Quantize`
  became `decimal.BID64frombits`, `decimal.BID64bits` and
  `decimal.QuantizeMode`;
- the kernel's rounding modes now have `math/big`'s order and include
  AwayFromZero, so `probe.py` lists Python's modes in that order and adds
  `ROUND_UP`, which raises the cases per operation from 18,800 to 22,560;
- the quantize cases are checked through `QuantizeMode` in every mode, not
  only through `Quantize` for ties to even;
- `run.sh` replaces the commands the session ran by hand, and the two small
  programs that printed observations, which checked nothing, are left out.

## Results at the pin

```sh
FORK=$HOME/go-decimal ./run.sh
```

At fork commit `5032fd7754`, with Python 3.13.0 and libmpdec 2.5.1:

| Target | Execution | Cases | Public-path checks | Failures |
|---|---|---:|---:|---:|
| darwin/arm64 | native | 115,950 | 37,600 | 0 |
| linux/386 | Docker (`debian:bookworm-slim`), emulated | 115,950 | 37,600 | 0 |
| linux/s390x | Docker (`debian:bookworm-slim`), emulated, big-endian | 115,950 | 37,600 | 0 |

The linux binaries are statically linked, built with `CGO_ENABLED=0`, and run
with no network and a read-only mount. Emulated execution exercises the
32-bit and big-endian code paths; it is not a test on physical i386 or IBM
hardware. The probe covers `decimal64` only, and is bounded differential
evidence, not proof of IEEE 754 conformance. `run.sh` writes each target's
summary and any failures to `out/` (ignored by git).
