#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install morphmg                || exit 1
xmg install framemg                || exit 1
xmg install compat                 || exit 1
xmg install tfcompiler        || exit 1
cd tfcompiler/compilers/tf
xmg build                          || exit 1
