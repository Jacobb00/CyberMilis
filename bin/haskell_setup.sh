#!/bin/sh
# Milis Linux Hızlı Haskell Dili Geliştirme Ortamı Kurucu 2024

mkdir -p $HOME/.local/bin
cd $HOME/.local/bin

rm -rf ghcup.sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org  > ghcup.sh
[ ! -f ghcup.sh ] && exit 1
chmod +x ghcup.sh
BOOTSTRAP_HASKELL_NONINTERACTIVE=1 ./ghcup.sh
[ ! -d $HOME/.ghcup/env ] && exit 1
echo "source $HOME/.ghcup/env" >> $HOME/.bashrc
