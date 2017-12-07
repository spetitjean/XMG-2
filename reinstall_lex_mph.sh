#! /bin/bash

cd contributions                   || exit 1
xmg install core                   || exit 1
xmg install lemmamg                || exit 1
xmg install lexCompiler            || exit 1
xmg install morphomg               || exit 1
xmg install mphCompiler            || exit 1
cd lexCompiler/compilers/lex
xmg build                          || exit 1
cd ../../../mphCompiler/compilers/mph
xmg build                          || exit 1
