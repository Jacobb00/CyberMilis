
## Derleme Ortamı Üretme - Milis Linux 2.3

Milis Linux’ta paketleri temiz bir ortamda üretebilmek için squash filesystem ile sıkıştırılmış bir sistem kalıbı kullanılır. 
Aşağıdaki komutlarla bu sistem kalıbını üretebiliriz. 
Eğer hazır üretilmiş sistem kalıbını kullanmak isterseniz mpsdo komutunu kullanabilirsiniz.
Not: Aynı sürümlü Milis Linux kullanıyorsanız; 2, 3 ve 4 adımlarını atlayınız.

1- Gerekli dizin ve çevre değişkenleri ayarlanır:

```
mkdir /opt/milis-calisma
cd /opt/milis-calisma
export MSYS=/opt/milis-calisma/sys

export MPS_PATH=/opt/milis-calisma/mps
# Sistem Milis Linux ise
export MPS_PATH=/usr/milis/mps

export MILIS_PATH=$MSYS/usr/milis
```

2- Güncel MPS kaynak kodu indirilir:

```
git clone https://gitlab.com/milislinux/mps3.git $MPS_PATH
```

3- MPS komut satırında gözükmesi için PATH e eklenir.

```
export PATH=$MPS_PATH/bin:$PATH
```

Sürüm kontrolü yapıldığında aşağıdaki çıktı alınmalıdır:

```
mps --v

MPS 3.0 - Milis Paket Yöneticisi - milisarge 2024
```

4- Özel MPS ayarları kullanılacaksa MPS deposundan ayarlar özelleştirilir:

```
cp $MPS_PATH/mps.ini /opt/milis-calisma/mps-ozel.ini
```

5- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
cd /opt/milis-calisma
mps ilk $MSYS --config $MPS_PATH/mps.ini
```

6- Gerekli güncellemeler yapılır:

```
mps gun --kok $MSYS --config $MPS_PATH/mps.ini
```

7- Taban ortamı kurmak için gerekli paketler indirilir ve yüklenir:

```
mps kur @$MSYS/usr/milis/ayarlar/pliste/base.list --kurkos 0 --koskur 0 --kok $MSYS --config $MPS_PATH/mps.ini
```

8- Gerekli işlemler yapılarak chroot içine girilir:

```
chroot $MSYS bash -c "sed -i 's/#tr_TR\.UTF-8 UTF-8/tr_TR\.UTF-8 UTF-8/g' /etc/locale.gen"
chroot $MSYS bash -c "sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/g' /etc/locale.gen"
chroot $MSYS bash -c "locale-gen"

enter-chroot $MSYS
```

9- Gerekli güncellemeler çalıştırılır:

```
update-ca-certificates --fresh && make-ca -g
ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

10- Önbellekteki paket arşivleri temizlenir, ortamdan çıkılır ve komut tarihçesi temizlenir:

```
exit
rm -rf $MSYS/var/cache/mps/depo/*
rm -f $MSYS/root/.bash_history
```

11- Ortam içindeki sources dizini silinir çünkü sonra mpsdo ile güncel sources dizini bağlanacak:

```
rm -rf $MSYS/sources
```

12- Yeni sistem squash filesystem ile sıkıştırılır:

```
mksquashfs $MSYS milis23-"$(date -d "$D" '+%m-%d')"-base.sfs -comp xz
```
