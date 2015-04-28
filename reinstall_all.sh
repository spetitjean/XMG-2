#! /bin/bash

rm -rf .install
xmg bootstrap                      || exit 1
cd contributions                   || exit 1
for contrib in `ls`; do
  echo 'Installing '$contrib
  xmg install $contrib                || exit 1
done
