#!/bin/sh
# militer servis kurulum betiği

mod=$1
cwd=`dirname $0`

# Servis sistemi için gerekli dosya ve dizin işlemleri
[ ! -f /usr/bin/busybox ] && mps kur busybox
ln -v /usr/bin/busybox /usr/bin/init
ln -v /usr/bin/busybox /usr/bin/reboot
ln -v /usr/bin/busybox /usr/bin/halt
ln -v /usr/bin/busybox /usr/bin/poweroff
ln -v /usr/bin/busybox /usr/bin/getty

[ ! -f /usr/bin/slua ] && cp -v $cwd/slua /usr/bin/

# temel yönetim betiği servis.lua
mkdir -pv /etc/init
cp -fv $cwd/inittab /etc/
cp -fv $cwd/pseudo.fstab /etc/init/
cp -fv $cwd/system.ini /etc/init/
cp -fv $cwd/colors.lua /etc/init/
cp -fv $cwd/ini.lua /etc/init/
cp -fv $cwd/servis.lua /etc/init/
chmod +x /etc/init/servis.lua

# aktif servisin ayarlanması ve ilgili servislerin kopyalanması
/etc/init/servis.lua yaz system profile $mod
/etc/init/servis.lua list | xargs -I {} cp -v $cwd/{}.lua /etc/init/
