#!/bin/bash
# bash --rcfile bashrc-onsistem
# onsistemi derle-kur
# link önemli = [ ! -d /tools ] && ln -s $ONSISTEM_CHROOT/tools /

hata_olustu(){
	if [ ! -z "$1" ];then 
		echo "$1"
		exit 1
	fi
}

# 1- # bash --rcfile bashrc-onsistem

# kontroller

echo "ortam değişkenlerinin kontrolü"

[ -z $MILIS_HOME ] && hata_olustu "MILIS_HOME tanmlı değil!"
[ -z $MILIS_REPO ] && hata_olustu "MILIS_REPO tanmlı değil!"
[ -z $TALIMATNAME ] && hata_olustu "TALIMATNAME tanmlı değil!"
[ -z $ONSISTEM_CHROOT ] && hata_olustu "ONSISTEM_CHROOT tanmlı değil!"
[ -z $MPS_PATH ] && hata_olustu "MPS_PATH tanımlı değil!"
[ ! -d $MPS_PATH ] && hata_olustu "MPS_PATH dizini mevcut değil!"

mkdir -p ${ONSISTEM_CHROOT}/tools

if [ -L /tools ];then
	[ "`readlink /tools`" != "${ONSISTEM_CHROOT}/tools" ] && hata_olustu "/tools $ONSISTEM_CHROOT uyuşmuyor, yeniden linkleyin."
else
	hata_olustu "ln -s $ONSISTEM_CHROOT/tools /"
fi

echo "-----------------------------"

echo "gerekli ikililerin kontrolü" # döngüde yapılsın!!!
# gcc kontrol 
command -v gcc > /dev/null 2>&1
[ ! $? -eq 0 ] && hata_olustu "gcc gerekli/needs !"
# make kontrol 
command -v make > /dev/null 2>&1
[ ! $? -eq 0 ] && hata_olustu "make gerekli/needs !"
# bsdtar kontrol 
command -v bsdtar > /dev/null 2>&1
[ ! $? -eq 0 ] && hata_olustu "bsdtar gerekli/needs !"
# lua kontrol 
command -v slua > /dev/null 2>&1
[ ! $? -eq 0 ] && hata_olustu "slua gerekli/needs !"
# lzip kontrol 
command -v lzip > /dev/null 2>&1
[ ! $? -eq 0 ] && hata_olustu "lzip gerekli/needs !"

echo "-----------------------------"
mps -v
# mps chroot önsistem yapılandırılması
mps --ilk --kok=$ONSISTEM_CHROOT
echo "-----------------------------"

echo "order dosyasına göre derlenip kurulması"
trap 'echo ; exit 0' EXIT HUP QUIT ABRT TERM

# Paketlerin toplanacağı dizin
mkdir -p $MILIS_HOME/onpaketleme 
cd $MILIS_HOME/onpaketleme 

# önsistem için 0 grubu talimatlar kullanılacak.
for paket in `cat $MILIS_REPO/ayarlar/pliste/mlfs.list`;do
	zorla=""
	# kurulu değilse derlet
	if [ ! -d $ONSISTEM_CHROOT/var/lib/mps/db/$paket ];then
		# derleme
		if [ ! -z $paket ];then
			# yeni mpsd egöre güncellenecek
			# mpsd tekil derleyecek, mps kuracak
			mps der $paket -t
		fi
		# paket üretim kontrol
		paketlz=$(find $PWD -name "${paket}#*.mps.lz" -print0)
		# kurma
		zorla="--zorla"
		if [ ! -z ${paketlz}  ];then
			mps kur ${paketlz} --kok=$ONSISTEM_CHROOT ${zorla}
			# log dosyalarını al
			# mv -v /tmp/${paket}-*.log .
		else
			hata_olustu "${paket} paketi bulunmadı!"
		fi
	fi

done
cd -
echo "-----------------------------"
exit 0
