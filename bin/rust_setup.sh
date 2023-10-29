#!/bin/sh
if [ -z $1 ];then
  curl https://sh.rustup.rs -sSf | sh
else
  curl https://sh.rustup.rs -sSf | sh -s -- $@
fi
