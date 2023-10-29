#!/bin/bash
[ -z $1 ] && exit 1
VT="/var/lib/mps/db"
liste=$1

echo "order dosyasına göre derlenip kurulması"
trap 'echo ; exit 1' EXIT HUP QUIT ABRT TERM
for paket in `cat $liste`;do
        # kurulu değilse derlet
        if [ ! -d $VT/$paket ];then
                # derleme
                if [ ! -z $paket ];then
                        mps der $paket
                fi
                # paket üretim kontrol
                paketlz=$(find $PWD -name "${paket}#*.mps.lz" -print0)
                # kurma
                if [ ! -z ${paketlz}  ];then
                        mps kur ${paketlz} --zorla
                else
                        hata_olustu "${paket} paketi bulunmadı!"
                fi
        fi
		if [ ! -d $VT/$paket ];then
			echo "$paket kurulumunda hata oluştu!!!"
			break
		fi
done
cd -
echo "-----------------------------"
exit 0
