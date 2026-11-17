// Command driver is the Go side of the kernel probe: it reads requests as JSON
// lines, runs each through internal/bid and through the public types, and
// writes the raw results for probe.py to judge. run.sh copies it into the
// fork's src/cmd to build it, because it imports internal/bid.
package main

import (
 "bufio"
 "encoding/json"
 "fmt"
 "internal/bid"
 "io"
 "math/decimal"
 "os"
 "strconv"
)

type Request struct { Op string; X, Y uint64; Mode bid.Mode; Text string }
type Response struct { Bits uint64; Public uint64; HasPublic bool; Text string; RoundTrip uint64; Status bid.Status; Error string }
func main() {
 in := json.NewDecoder(bufio.NewReader(os.Stdin))
 out := bufio.NewWriter(os.Stdout)
 defer out.Flush()
 enc := json.NewEncoder(out)
 for {
  var q Request
  if err := in.Decode(&q); err == io.EOF { return } else if err != nil { panic(err) }
  var r Response
  a,b := decimal.BID64frombits(q.X), decimal.BID64frombits(q.Y)
  var p decimal64
  switch q.Op {
  case "add": r.Bits = bid.Add64(q.X,q.Y,q.Mode); p = a+b
  case "sub": r.Bits = bid.Sub64(q.X,q.Y,q.Mode); p = a-b
  case "mul": r.Bits = bid.Mul64(q.X,q.Y,q.Mode); p = a*b
  case "div": r.Bits = bid.Div64(q.X,q.Y,q.Mode); p = a/b
  case "quantize": r.Bits = bid.Quantize64(q.X,q.Y,q.Mode); p = decimal.QuantizeMode(a,b,decimal.RoundingMode(q.Mode))
  case "parse": r.Bits,r.Status = bid.Parse64(q.Text,q.Mode)
  case "string": r.Bits = q.X
  default: panic("bad operation")
  }
  // The operators round to nearest, ties to even; QuantizeMode takes every mode.
  if q.Op == "quantize" || q.Mode == bid.ToNearestEven && q.Op != "parse" && q.Op != "string" { r.Public=decimal.BID64bits(p); r.HasPublic=true }
  r.Text = string(bid.Append64(nil,r.Bits))
  r.RoundTrip,_ = bid.Parse64(r.Text,bid.ToNearestEven)
  if q.Op == "string" {
   r.Text = fmt.Sprint(a)
   parsed,err := strconv.ParseDecimal(r.Text,64)
   if err != nil { r.Error=err.Error() }
   r.RoundTrip=decimal.BID64bits(decimal64(parsed))
  }
  if err := enc.Encode(r); err != nil { panic(err) }
 }
}
