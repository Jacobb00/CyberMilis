#!/bin/sh
# Milis Linux Hızlı V Dili Derleyici Kurucu 2023

mkdir -p $HOME/.local
cd $HOME/.local

if [ ! -d vlang ];then
  git clone https://github.com/vlang/v vlang
  cd vlang && make && echo "pathappend $HOME/.local/vlang" >> $HOME/.bashrc
else
  cd vlang && git pull
  make
fi
