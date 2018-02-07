#! /bin/bash
cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install frame                  || exit 1
xmg install compat                 || exit 1
xmg install synframeCompiler       || exit 1
cd synframeCompiler/compilers/synframe
xmg build                          || exit 1
