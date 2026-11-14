# perf-d64: decimal64 beside float64

Measures the fork's built-in `decimal64` operators beside `float64`, with
`decimal128` for reference, on identical operand classes. Feeds 🎯T23 (fork
ledger): `decimal64` tuned to `decimal128`'s standard, measured against the
hardware binary type. Measurement only; no other library is involved.

## Operand sets

Defined in `d64_test.go`.

- **money**: `1234.56` and `78.90`.
- **full**: `1234567890123456` and `9876543210987654E-4` (16 digits each,
  exponents 0 and −4). The aligned sum has 20 digits and the product 32, so
  both round. For `decimal128` the same values are exact, so its row is a
  reference for the digits, not the same work.
- **far**: `1.23456789E+30` and `9.87654321E-30` (9 digits each).
- **pow10**: `123456.789 / 1000` (Div only; exact quotient).
- **drawn-money**: pools of 1,024 amounts of 3 to 9 digits with two places,
  random signs.
- **drawn-plus**: the same amounts, all positive, as in a running total.
- **drawn-full**: 16 random digits each, exponents 1 to 12 apart either way,
  random signs.

Fixed sets have four variants that differ in the last digit, indexed with
`i&3`, so nothing folds; a branch predictor learns them. Drawn sets are
indexed by a xorshift step that no predictor can learn; every drawn row,
`float64`'s included, carries the generator's cost, about 1.2 ns.
`TestOperandsExact` checks that the fixed `decimal64` operands parse
without rounding.

## Rerun

With a built checkout of the fork (`make.bash`) at the commit under test:

```sh
export GOROOT=$FORK PATH=$FORK/bin:$PATH GOTOOLCHAIN=local GOEXPERIMENT=decimal
go test -count=1 -run TestOperandsExact .
go test -c -o after.test .
# build before.test the same way with the toolchain before the change, then
# alternate the two:
for r in 1 2 3 4 5 6; do
  ./before.test -test.run '^$' -test.bench BenchmarkD64 -test.benchtime 300ms >> results/before.txt
  ./after.test  -test.run '^$' -test.bench BenchmarkD64 -test.benchtime 300ms >> results/after.txt
done
benchstat results/before.txt results/after.txt
```

## Results

See `results/` (raw benchmark output, benchstat, the load during the rounds)
and the account in [`docs/performance.md`](../../docs/performance.md).
