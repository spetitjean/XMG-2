#! /usr/bin/python3

from subprocess import check_output
output = check_output(["find", "." , "-name", '.install',  "-prune",
                       "-o", "-name", '*.yap', "-exec", "egrep",
                       r'\bmodule\(', "{}", ";", "-print"],
                      universal_newlines=True)

import re
PAT = re.compile(r"^\s*:-\s*module\(\s*(\w+).*\n(\./.*)$", re.MULTILINE)

files = tuple((m.group(1), m.group(2)) for m in PAT.finditer(output))
#print(files)
#for x,y in files:
#    print(x,y)

FPAT = re.compile(r"^\./contributions/\w+/(\w+)/(\w+)/(\w+)/(\w+)\.yap$")

def module_name(kind, name, subdir, file):
    # what should be the rules?
    if kind=="bricks":
        return "xmg_brick_%s_%s" % (name, file)
    # I don't know
    return None

for x,y in files:
    m      = FPAT.match(y)
    if m is None:
        print("???", x, y)
        continue
    kind   = m.group(1)
    name   = m.group(2)
    subdir = m.group(3)
    file   = m.group(4)
    mod    = module_name(kind, name, subdir, file)
    if mod is None:
        print("?", x, y)
    elif mod==x:
        print("+", x, y)
    else:
        print("-", x, "EXPECTED:", mod, y)
