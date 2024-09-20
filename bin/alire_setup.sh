#!/bin/sh
# Milis Linux Hızlı Alire-Ada Derleyici Kurucu 2024
[ -z $1 ] && exit 1

# 2.0.1
version=$1
file="alr-${version}-bin-x86_64-linux.zip"
echo $file
mkdir -p $HOME/{.cache,.local}
cd $HOME/.cache
[ ! -f ${file} ] && wget https://github.com/alire-project/alire/releases/download/v${version}/${file}

rm -rf $HOME/.local/alire && \
mkdir -p $HOME/.local/alire && \
cd $HOME/.local/alire && unzip $HOME/.cache/${file}

echo 'export PATH=$PATH:$HOME/.local/alire/bin' >> ~/.bashrc
