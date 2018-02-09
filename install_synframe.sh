#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install treemg                 || exit 1
xmg install framemg                || exit 1
xmg install compat                 || exit 1
xmg install synframeCompiler       || exit 1
cd synframeCompiler/compilers/synframe
xmg build                          || exit 1
