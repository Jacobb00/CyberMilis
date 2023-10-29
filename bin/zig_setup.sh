#!/bin/sh
# Milis Linux Hızlı Zig Derleyici Kurucu 2023
[ -z $1 ] && exit 1

version=$1
mkdir -p $HOME/{.cache,.local}
cd $HOME/.cache

if [ ! -f zig-linux-x86_64-${version}.tar.xz ];then
  wget https://ziglang.org/download/${version}/zig-linux-x86_64-${version}.tar.xz
fi

rm -rf ../.local/zig && bsdtar -C ../.local -xzf zig-linux-x86_64-${version}.tar.xz
cd ../.local

mv zig-linux-x86_64-${version} zig

echo 'export PATH=$PATH:$HOME/.local/zig' >> ~/.bashrc
