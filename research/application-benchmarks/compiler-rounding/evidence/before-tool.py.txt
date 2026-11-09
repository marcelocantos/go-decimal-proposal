#!/usr/bin/env python3
import os
import sys
from pathlib import Path
args = sys.argv[1:]
if Path(args[0]).name == 'compile':
    os.execv(str(Path(__file__).with_name('before.compile')), ['compile'] + args[1:])
os.execv(args[0], args)
