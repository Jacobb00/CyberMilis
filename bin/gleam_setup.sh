#!/bin/sh
# gleam programming language installer
[ ! -d /var/lib/mps/db/erlang ] && sudo mps kur erlang
version="0.34.1"
file="gleam-v${version}-x86_64-unknown-linux-musl.tar.gz"
cd ~/.cache
if [ ! -f ${file} ];then
  wget https://github.com/gleam-lang/gleam/releases/download/v${version}/${file}
fi
tar xf $file
chmod +x gleam
sudo mv -v gleam /usr/local/bin/gleam
