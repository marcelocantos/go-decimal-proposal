# Copyright 2026 Marcelo Cantos
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import difflib
import json
import os
import re
import subprocess

base = Path(__file__).parent
p = base / 'profiles'
root = Path('/Users/marcelo/work/github.com/migueldecimal128/go-decimal128-app-benchmark')
fork = Path('/Users/marcelo/work/wt/gd-survey')
go = str(fork / 'bin/go')
env = os.environ | dict(GOEXPERIMENT='decimal', GOWORK='off', GOTOOLCHAIN='local', CGO_ENABLED='0')
source = root / 'apps/tax_preparation/cmd/tax-ca/main.go'
target = p / 'ca.go.txt'
text = source.read_text().replace('"os"', '"os"\n "runtime/pprof"')
text = text.replace('func main() { os.Exit(tax.RunCA()) }', '''func main() {
 f,err:=os.Create(os.Getenv("DECIMAL_DIAGNOSTIC_PROFILE"));if err!=nil {panic(err)}
 if err=pprof.StartCPUProfile(f);err!=nil {panic(err)}
 code:=tax.RunCA()
 pprof.StopCPUProfile();if err=f.Close();err!=nil {panic(err)}
 os.Exit(code)
}''')
target.write_text(text)
(p / 'ca.patch').write_text(''.join(difflib.unified_diff(source.read_text().splitlines(True), text.splitlines(True), fromfile=str(source), tofile=str(target))))
original = subprocess.check_output(['git', 'show', '4c3fdc578b71df72dc1fe854d42a3ffc0cdd6bf5:src/internal/bid/coef128.go'], cwd=fork)
assert (base / 'baseline-coef128.go').read_bytes() == original
for stage in ['before', 'after']:
    name = 'ca-' + stage
    replace = {str(source): str(target)}
    if stage == 'before':
        replace[str(fork / 'src/internal/bid/coef128.go')] = str(base / 'baseline-coef128.go')
    overlay = p / (name + '-overlay.json')
    overlay.write_text(json.dumps({'Replace': replace}, indent=2) + '\n')
    binary = p / (name + '.bin')
    subprocess.run([go, 'build', '-overlay', str(overlay), '-tags=go_decimal_poc', '-o', str(binary), './apps/tax_preparation/cmd/tax-ca'], cwd=root, env=env, check=True)
    r = subprocess.run([str(binary), 'testGen/bin/Tax.CA.bin.BID128', str(p / (name + '.out')), '1'],
                       cwd=root / 'data/tax_preparation',
                       env=env | dict(DECIMAL_DIAGNOSTIC_PROFILE=str(p / (name + '.cpu')), D128_COMPUTE_ITERS='60000', D128_COMPUTE_BATCH='400'),
                       capture_output=True, check=True)
    (p / (name + '.stdout')).write_bytes(r.stdout)
    (p / (name + '.stderr')).write_bytes(r.stderr)
    assert re.sub(rb'compute-sink -?\d+\n$', b'', r.stderr) == (root / 'data/tax_preparation/golden/Tax.CA.stderr.golden').read_bytes()
    for order in ['flat', 'cum']:
        out = subprocess.check_output([go, 'tool', 'pprof', '-top', '-' + order, '-nodecount=80', '-focus=internal/harness.BestOf', str(binary), str(p / (name + '.cpu'))], env=env, text=True)
        (p / (name + '-' + order + '.txt')).write_text(out)
    print(name + ' profile passed original golden', flush=True)
(p / 'ca-provenance.json').write_text(json.dumps(dict(compiler=json.loads((base / 'candidate.json').read_text())['fork'], baseline_coefficient_source='4c3fdc578b71df72dc1fe854d42a3ffc0cdd6bf5', iterations=60000, batch=400, goldens_passed=True, use='Diagnostic CPU attribution only, not headline timings.'), indent=2) + '\n')
