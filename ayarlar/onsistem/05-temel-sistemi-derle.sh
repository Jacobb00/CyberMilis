#!/bin/bash
[ -z $TALIMATNAME ] && hata_olustu "TALIMATNAME tanımlı değil!"
[ ! -d $TALIMATNAME ] && hata_olustu "$TALIMATNAME dizini mevcut değil!"
VT="/var/lib/mps/db"

mkdir -p /opt/paketler 
cd /opt/paketler

echo "order dosyasına göre derlenip kurulması"
trap 'echo ; exit 1' EXIT HUP QUIT ABRT TERM
for paket in `cat /tools/share/ayarlar/pliste/base.list`;do
        # kurulu değilse derlet
        if [ ! -d $VT/$paket ];then
                # derleme
                if [ ! -z $paket ];then
                        #mps.lua derle $paket
                        mps der $paket -t
                fi
                # paket üretim kontrol
                paketlz=$(find $PWD -name "${paket}#*.mps.lz" -print0)
                # kurma
                if [ ! -z ${paketlz}  ];then
                        mps kur ${paketlz} --zorla
                else
                        hata_olustu "${paket} paketi bulunmadı!"
                fi
                if [ $paket == "bash" ];then
                  echo "bash_refresh  komutu verip tekrar devam edin!"
                  exit 0
                fi
                #if [ $paket == "gcc" ];then
				#  mps sil gcc --ona && mps kur ${paketlz} --zorla
                #fi
        
        fi
		if [ ! -d $VT/$paket ];then
			echo "$paket kurulumunda hata oluştu!!!"
			break
		fi
done
cd -
echo "-----------------------------"
exit 0
