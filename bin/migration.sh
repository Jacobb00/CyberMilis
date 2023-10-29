#!/bin/bash

# Milis Liux Git Depoları Göç Betiği 2023

# Bu betik, git depo adresleri güncellendiğinde yeni adresleri bu betik üzerinden güncellenerek
# curl/bash ile kullanıcının güncel git depolarını almasını sağlamaktadır.

# eski depo dizinleri silinir
rm -rf /usr/milis

# yeni milis dizin
mkdir -p /usr/milis

# mps güncel depo adresi ile güncellenir
git clone https://gitlab.com/milislinux/mps23 /usr/milis/mps

# mps ayar güncellenir
curl https://gitlab.com/milislinux/milis23/-/raw/main/ayarlar/mps/mps.ini > /usr/milis/mps/conf/mps.ini.sablon

# ilkleme - 2.3 görülmeli
/usr/milis/mps/bin/mps -v

# mps guncellemeri alınır
/usr/milis/mps/bin/mps gun
