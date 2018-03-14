from distutils.ccompiler import new_compiler
try:
    from distutils.ccompiler import customize_compiler
except:
    from distutils.sysconfig import customize_compiler
import os
cxx = new_compiler()
customize_compiler(cxx)
pid = os.getpid()
file_hh = "_gecode_version_%d.hh" % pid
file_txt = "_gecode_version_%d.txt" % pid
f = open(file_hh,"w")
f.write("""#include "gecode/support/config.hpp"
@@GECODE_VERSION""")
f.close()
cxx.preprocess(file_hh,output_file=file_txt)
f = open(file_txt)
version = ""
for line in f:
    if line.startswith("@@"):
        version = line[3:-2]
        break
# for versions <4, the following is necessary
if version=="":
    version=f.readlines()[len(f.readlines())+1][2:-2]

print(version)
f.close()
os.remove(file_hh)
os.remove(file_txt)
