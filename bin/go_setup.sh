#!/bin/sh
# Milis Linux Hızlı Go Derleyici Kurucu 2022
[ -z $1 ] && exit 1

version=$1
mkdir -p $HOME/{.cache,.local}
cd $HOME/.cache
[ ! -f go${version}.linux-amd64.tar.gz ] && wget https://go.dev/dl/go${version}.linux-amd64.tar.gz

rm -rf ../.local/go && tar -C ../.local -xzf go${version}.linux-amd64.tar.gz

echo 'export PATH=$PATH:$HOME/.local/go/bin' >> ~/.bashrc
