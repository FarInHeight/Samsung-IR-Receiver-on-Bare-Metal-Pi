#! /usr/bin/python3

import sys
import re

with open('program.f', 'a') as f:
    for line in sys.stdin:
        line = line.strip()
        if line and line[0] != '\\':
            reg = re.search("\s+\(\s+\w*\s*-*\w*\s*--\s*\w*-*\w*\s+\)", line)
            if hasattr(reg, 'start') and hasattr(reg, 'end'):
                idx1 = reg.start()
                idx2 = reg.end()
                line = line[:idx1] + line[idx2:]
            line = ' '.join( re.split('\s+', line) )
            print(line, file=f, end=' ')
