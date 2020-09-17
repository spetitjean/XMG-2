#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install treemg                 || exit 1
xmg install compat                 || exit 1
xmg install STAGCompiler         || exit 1
cd STAGCompiler/compilers/stag
xmg build                          || exit 1
