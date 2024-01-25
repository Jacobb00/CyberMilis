#!/bin/sh
# gleam programming language installer
[ ! -d /var/lib/mps/db/erlang ] && mps kur erlang 
version="0.34.1"
file="gleam-v${version}-x86_64-unknown-linux-musl.tar.gz"
cd ~/.cache
if [ ! -f ${file} ];then
  wget https://github.com/gleam-lang/gleam/releases/download/v${version}/${file}
fi
rm -rf /usr/local/bin/gleam
tar xf $file -C /usr/local/bin/
