
## Canlı/Kurulum İmaj Üretimi - Milis Linux 2.3

Eğer hazır üretilmiş sistem kalıbını kullanmak isterseniz mpsdo komutunu kullanabilirsiniz.
Not: Aynı sürümlü Milis Linux kullanıyorsanız; 2, 3 ve 4 adımlarını atlayınız.

1- Gerekli dizin ve çevre değişkenleri ayarlanır:

```
mkdir /opt/milis-calisma
cd /opt/milis-calisma
export MSYS=/opt/milis-calisma/sys
export MPS_PATH=/opt/milis-calisma/mps23
export MILIS_PATH=$MSYS/usr/milis

# Sistem Milis Linux ise
export MPS_PATH=/usr/milis/mps

```

2- MPS gerekli konfigürasyon ayarlarını yaptğınından dolayı ilk çalıştığında:

```
export PATH=$MPS_PATH/bin:$PATH
mps
MPS öntanımlı ayarlar yüklendi.
Lütfen mps'i yeniden çalıştırın!
```

uyarısını verecektir. Bu adımdan sonra mps kurulumu tamamlanmış olur. Kontrol etmek için:

```
mps -v

MPS 2.3 - Milis Paket Sistemi milisarge@gmail.com
```

3- MPS’in paketleri nereden alacağını belirlemek için gerekli ayarlar yapılır:

```
nano conf/mps.ini
# talimatdepoları milis21->milis23 çevrilir.
# sunucu yerel depo için 
mps yaz sunucu 1 http://localhost:9911
```

4- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
cd /opt/milis-calisma
mps --ilkds --ilk --kok=$MSYS
```

5- Gerekli güncellemeler yapılır; talimatname, depo ve betik:

```
mps gun -GPB --kok=$MSYS
```

6- Minimal bir sistem ortamı kurmak için gerekli paketler indirilir ve yüklenir:

```
mps kur --dosya=$MSYS/usr/milis/ayarlar/pliste/base.list --kurkos=0 --koskur=0 --kok=$MSYS
```

7- MPS kurulum dizininin altına kopyalanır:

```
cp -r $MPS_PATH $MSYS/usr/milis/mps
```

8- Konak sistemin hosts dosyası kullanılmak istenirse:

```
cp -f /etc/hosts $MSYS/etc/
```

9- chroot içine girilir:

```
cp /usr/lib/locale/locale-archive $MSYS/usr/lib/locale/ 
enter-chroot $MSYS
```

10- Gerekli güncellemeler çalıştırılır:

```
sed -i 's/#tr_TR\.UTF-8 UTF-8/tr_TR\.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
update-ca-certificates --fresh && make-ca -g
ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

11- Minimal sistem için gerekli paket listesi kurulur.

```
cd /opt
mps gun
mps sor --gtl minimal > minimal.liste
mps sor --gtl masa > masa.liste
mps sor --gtl ofis > ofis.liste
mps kur --dosya minimal.liste
mps kur --dosya masa.liste
mps kur --dosya ofis.liste

# minimal sistem + limine için
mps kur udisks
```

12- Milis servis sistemi aşağıdaki yönergeye göre kurulur. /etc/init/system.ini kontrol edilir.

```
#minimal sistem için
/usr/milis/ayarlar/init/setup.sh console

# grafik sistem için
/usr/milis/ayarlar/init/setup.sh desktop

# ek servisler
servis ekle bluetooth
ipfs_setup.sh
servis ekle ipfs
```

13- MPS ile kurulacak Milis uygulamaları eklenir.

```
mps yaz betik mservice @mservice.git
mps yaz betik ayguci @ayguci.git
mps yaz betik mpsui @mpsui.git
mps gun -B
#
servis ekle ayguci
servis aktif ayguci
mps kur jc jq lshw acpi lm_sensors limine
```

14- mls kullanıcısı oluşturulur.(Canlı masaüstü kullanımı için test kullanıcısı)
```
ko mls mls
```

15- Canlı sistem için initramfs üretilir:

```
dracut -N --force --xz --add 'dmsquash-live pollcdrom' --omit systemd /boot/initrd_live `ls /usr/lib/modules`
rm /boot/initrd.img-*
```

16- /usr/milis/mps/conf/mps.ini , /etc/hosts ayarları ve kırık bileşen(revdep-rebuild) kontrol edilir.

17- Önbellekteki paket arşivleri temizlenir, ortamdan çıkılır ve komut tarihçesi temizlenir:

```
exit
rm -rf $MSYS//var/cache/mps/depo/*
rm -rf $MSYS//tmp/*
rm -f $MSYS/root/.bash_history
```

18- İmajın hazırlanacağı dizinin altına girilir ve imaj üretici indirilir:

```
cd /opt
git clone https://gitlab.com/milislinux/imaj-uretici23
```

19- Imaj oluşturma betiğiyle imaj oluşturma işlemi başlatılır:

```
cd /opt/imaj-uretici23
bash iso_olustur.sh $MSYS
```
