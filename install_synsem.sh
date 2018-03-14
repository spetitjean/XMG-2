#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install treemg                 || exit 1
xmg install compat                 || exit 1
xmg install synsemCompiler         || exit 1
cd synsemCompiler/compilers/synsem
xmg build                          || exit 1
