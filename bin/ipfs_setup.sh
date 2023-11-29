#!/bin/sh
# Milis Linux Hızlı IPFS Kurucu 2023
[ $UID -ne 0 ] && exit 1

version="0.24.0"
mkdir -p $HOME/{.cache,.local}
cd $HOME/.cache

if [ ! -f kubo_v${version}_linux-amd64.tar.gz ];then
  wget https://dist.ipfs.tech/kubo/v${version}/kubo_v${version}_linux-amd64.tar.gz
fi

tar -xvzf kubo_v${version}_linux-amd64.tar.gz
cd kubo
cp -f ipfs /usr/local/bin/
chmod +x /usr/local/bin/ipfs
cd ..; rm -rf kubo
# ipfs init-daemon

