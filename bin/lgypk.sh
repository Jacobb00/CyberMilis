#!/bin/bash
# Libgerekler dosyasındaki kütüphanelere göre paket listesi oluşturur.
[ -z $1 ] && exit 1
cat $1 | xargs -I {} grep -rli {} --include=\pktlibler /usr/milis/talimatname | cut -d# -f1 | xargs -I {} basename {} | sort | uniq | sed -z 's/\n/ /g'
