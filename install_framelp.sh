#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install morphmg                || exit 1
xmg install framemg                || exit 1
xmg install compat                 || exit 1
xmg install framelpcompiler        || exit 1
cd framelpcompiler/compilers/framelp
xmg build                          || exit 1
