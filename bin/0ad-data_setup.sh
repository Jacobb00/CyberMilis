#!/usr/bin/env bash
# 0ad veri dosyasını indirir ve kurar

# root kontrol
[[ $UID -ne 0 ]] && exit 1
# sürüm değerini al
surum=`mps ara -t 0ad | cut -d# -f2 | cut -d- -f1`
# veri dosyasını indir
wget https://releases.wildfiregames.com/0ad-${surum}-alpha-unix-data.tar.xz
# dışarı çıkar
[ -f 0ad-${surum}-alpha-unix-data.tar.xz ] && tar xf 0ad-${surum}-alpha-unix-data.tar.xz
# hedef dizine taşı
[ -d 0ad-${surum}-alpha/binaries/data ] && mv 0ad-${surum}-alpha/binaries/data/* /usr/share/0ad/data/
