#! /usr/bin/python3

import sys
import re

with open('program.f', 'a') as f:
    for line in sys.stdin:
        # delete leading and trailing extra spaces
        line = line.strip()
        # skip comment lines
        if line and line[0] != '\\':
            # delete inline comments such as ( i1 i2 ... -- o1 o2 ... )
            reg = re.search("\s+\(\s+[^-]*--[^-]*\s+\)$", line)
            if hasattr(reg, 'start') and hasattr(reg, 'end'):
                idx1 = reg.start()
                idx2 = reg.end()
                line = line[:idx1] + line[idx2:]
            # delete inline comments such as \ ...
            line = line[ : line.find('\\') - 1 ] if line.find('\\') != -1 else line
            # unify line by deleting extra spaces and skipping string containing only whitespaces
            line = ' '.join( filter( lambda x: not x.isspace(),  re.split('\s+', line) ) )
            print(line, file=f, end=' ')
