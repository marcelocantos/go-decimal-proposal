"""The kernel probe: an independent differential test of decimal64 arithmetic.

Expected results come from Python's decimal module; operands are encoded to
BID and results decoded with this file's own formulas. See README.md for its
origin and what was changed for the current fork.
"""
import collections
import decimal as D
import json
import os
import pathlib
import random
import subprocess
import sys

ROOT = pathlib.Path(os.environ.get('KERNEL_PROBE_OUT', '.'))
# Index i is the kernel's bid.Mode(i): ToNearestEven, ToNearestAway,
# TowardZero, AwayFromZero, TowardNegative, TowardPositive.
MODES = [D.ROUND_HALF_EVEN, D.ROUND_HALF_UP, D.ROUND_DOWN, D.ROUND_UP, D.ROUND_FLOOR, D.ROUND_CEILING]
CTX = [D.Context(prec=16, Emin=-383, Emax=384, clamp=1, rounding=m, traps=[]) for m in MODES]

def encode(s):
    d = D.Decimal(s)
    t = d.as_tuple()
    sign = t.sign << 63
    if d.is_snan(): return sign | 0x7e00000000000000
    if d.is_nan(): return sign | 0x7c00000000000000
    if d.is_infinite(): return sign | 0x7800000000000000
    c = int(''.join(map(str,t.digits)))
    q = t.exponent
    assert 0 <= c < 10**16 and -398 <= q <= 369, (s,c,q)
    if c < 2**53: return sign | ((q+398)<<53) | c
    return sign | (3<<61) | ((q+398)<<51) | (c-(1<<53))

def decode(u):
    sign = u >> 63
    if u & 0x7c00000000000000 == 0x7c00000000000000: return D.Decimal('NaN')
    if u & 0x7800000000000000 == 0x7800000000000000: return D.Decimal('-Infinity' if sign else 'Infinity')
    if u & (3<<61) == 3<<61:
        c = (u & ((1<<51)-1)) | (1<<53)
        q = ((u>>51)&1023)-398
    else:
        c = u & ((1<<53)-1)
        q = ((u>>53)&1023)-398
    if c >= 10**16: c=0
    return D.Decimal((sign,tuple(map(int,str(c))),q))

def same(a,b):
    if a.is_nan() or b.is_nan(): return a.is_nan() and b.is_nan()
    return a.as_tuple() == b.as_tuple()

cases=[]
def add(op,x='0',y='0',mode=0,text=''):
    cases.append(dict(Op=op,X=encode(x),Y=encode(y),Mode=mode,Text=text))

# Constructed from format boundaries and preferred exponents, not repo tests.
edge=['0','-0','0E-398','-0E+369','1','-1','1.00','1.50','2','3','10','1E+369','1E-398','-1E-398','5E-398','9E-398','999999999999999E-398','1000000000000000E-398','9999999999999999E+369','-9999999999999999E+369','9999999999999999','1000000000000000','1000000000000001','0.5','0.5000000000000001','0.4999999999999999','Infinity','-Infinity','NaN','sNaN']
for mode in range(len(MODES)):
    for op in ['add','sub','mul','div','quantize']:
        for x in edge:
            for y in edge: add(op,x,y,mode)
        # Nearby ties, power-of-ten carries, cancellation, and subnormal double-rounding.
        for c in [1,2,5,9,10**15-1,10**15,10**15+1,10**16-2,10**16-1]:
            for q in [-398,-397,-384,-383,-16,-1,0,1,368,369]:
                for small in ['0.5','0.5000000000000001','0.4999999999999999','1E-398']:
                    add(op,f'{c}E{q}',small,mode)
# Seeded independent operand distribution includes both BID encoding forms.
rng=random.Random(20261103)
exponents=[-398,-397,-384,-383,-382,-20,-16,-1,0,1,15,16,368,369]
for mode in range(len(MODES)):
    for op in ['add','sub','mul','div','quantize']:
        for _ in range(2500):
            operands=[]
            for _ in range(2):
                c=rng.randrange(10**16)
                q=rng.choice(exponents) if rng.randrange(2) else rng.randrange(-398,370)
                operands.append(f'{rng.choice(["","-"])}{c}E{q}')
            add(op,*operands,mode)
for mode in range(len(MODES)):
    for s in ['1E385','-1E385','9.9999999999999994E384','9.9999999999999995E384','1E-399','-1E-399','5E-399','5.000000000000001E-399','4.999999999999999E-399','9.999999999999995E-384','0E999999','-0E-999999','1.2345678901234565','1.2345678901234575','1E370','1E-398','NaN','sNaN','Infinity','-Infinity']:
        add('parse',mode=mode,text=s)
for s in edge:
    add('string',s)
for _ in range(3000):
    add('string',f'{rng.choice(["","-"])}{rng.randrange(10**16)}E{rng.randrange(-398,370)}')

input_text=''.join(json.dumps(q)+'\n' for q in cases)
proc=subprocess.run(json.loads(os.environ.get('AUDIT_COMMAND', json.dumps([str(ROOT/'probe')]))),input=input_text,text=True,capture_output=True,check=True)
rows=[json.loads(s) for s in proc.stdout.splitlines()]
assert len(rows)==len(cases)
failures=[]
counts=collections.Counter()
for q,r in zip(cases,rows):
    ctx=CTX[q['Mode']]
    ctx.clear_flags()
    x,y=decode(q['X']),decode(q['Y'])
    # Restore sNaN classification, which decode intentionally canonicalizes for result comparison.
    if q['X'] & 0x7e00000000000000 == 0x7e00000000000000: x=D.Decimal('sNaN')
    if q['Y'] & 0x7e00000000000000 == 0x7e00000000000000: y=D.Decimal('sNaN')
    if q['Op']=='parse': expected=ctx.create_decimal(q['Text'])
    elif q['Op']=='string': expected=x
    else: expected=getattr(ctx,dict(add='add',sub='subtract',mul='multiply',div='divide',quantize='quantize')[q['Op']])(x,y)
    actual=decode(r['Bits'])
    problems=[]
    if not same(actual,expected): problems.append('result/value-or-quantum')
    if actual.is_nan() and q['Op'] != 'string' and r['Bits'] & (1 << 57): problems.append('signaling-result')
    if actual.is_finite() and r['RoundTrip'] != r['Bits']: problems.append('finite-bit-roundtrip')
    if r['HasPublic'] and not same(decode(r['Public']),expected): problems.append('public-result')
    if not same(decode(r['RoundTrip']),actual): problems.append('roundtrip')
    if q['Op']=='parse' and not expected.is_nan():
        flags=int(ctx.flags[D.Inexact])+2*int(ctx.flags[D.Overflow])+4*int(ctx.flags[D.Underflow])
        if r['Status']!=flags: problems.append(f'parse-status:{flags}')
    if problems:
        failures.append(dict(request=q,x=str(x),y=str(y),expected=str(expected),actual=str(actual),response=r,problems=problems))
    counts[q['Op']]+=1
summary=dict(python=sys.version,decimal_version=D.__libmpdec_version__,seed=20261103,cases=len(cases),counts=dict(counts),failures=len(failures),public_checks=sum(r['HasPublic'] for r in rows))
(ROOT/('probe-results'+os.environ.get('AUDIT_LABEL','')+'.json')).write_text(json.dumps(dict(summary=summary,failures=failures),indent=2)+'\n')
print(json.dumps(summary,indent=2))
for f in failures[:20]: print(json.dumps(f))
