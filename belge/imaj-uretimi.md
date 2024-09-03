
## Canlı/Kurulum İmaj Üretimi - Milis Linux 2.3

Eğer hazır üretilmiş sistem kalıbını kullanmak isterseniz mpsdo komutunu kullanabilirsiniz.
Not: Aynı sürümlü Milis Linux kullanıyorsanız; 2, 3 ve 4 adımlarını atlayınız.

1- Gerekli dizin ve çevre değişkenleri ayarlanır:

```
mkdir /opt/milis-calisma

cd /opt/milis-calisma

export MSYS=/opt/milis-calisma/sys
export MPS_PATH=/opt/milis-calisma/mps3
export MILIS_PATH=$MSYS/usr/milis

# Sistem Milis Linux ise
export MPS_PATH=/usr/milis/mps

```

2- MPS komut satırında gözükmesi için PATH e eklenir.

```
git clone https://gitlab.com/milislinux/mps3.git
export PATH=$MPS_PATH/bin:$PATH
```

Sürüm kontrolü yapıldığında aşağıdaki çıktı alınmalıdır:

```
mps --v

MPS 3.0 - Milis Paket Yöneticisi - milisarge 2024
```

3- Özel MPS ayarları kullanılacaksa MPS deposundan ayarlar özelleştirilir:

```
cp $MPS_PATH/mps.ini /opt/milis-calisma/mps-ozel.ini
```

4- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
mps ilk $MSYS --config $MPS_PATH/mps.ini
```

5- Gerekli güncellemeler yapılır:

```
mps gun --kok $MSYS --config $MPS_PATH/mps.ini
```

6- Taban ortamı kurmak için gerekli paketler indirilir ve yüklenir:

```
mps kur @$MSYS/usr/milis/ayarlar/pliste/base.list --kurkos 0 --koskur 0 --kok $MSYS --config $MPS_PATH/mps.ini
```

7- Gerekli işlemler yapılarak chroot içine girilir:

```
chroot $MSYS bash -c "sed -i 's/#tr_TR\.UTF-8 UTF-8/tr_TR\.UTF-8 UTF-8/g' /etc/locale.gen"
chroot $MSYS bash -c "sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/g' /etc/locale.gen"
chroot $MSYS bash -c "locale-gen"

enter-chroot $MSYS
```

8- Gerekli güncellemeler çalıştırılır:

```
update-ca-certificates --fresh && make-ca -g
ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

11- Minimal sistem için gerekli paket listesi kurulur.

```
cd /opt
mps gun
mps sor -gtl minimal > minimal.liste
mps sor -gtl masa > masa.liste
mps sor -gtl ofis > ofis.liste
mps kur @minimal.liste
mps kur @masa.liste
mps kur @ofis.liste

# minimal sistem + limine + xfs destek + tmux
mps kur udisks xfsprogs tmux limine
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
mps yaz betik mservice https://gitlab.com/milislinux/mservice.git
mps yaz betik ayguci https://gitlab.com/milislinux/ayguci.git
mps yaz betik mpsui https://gitlab.com/milislinux/mpsui.git
mps gun -B
#
servis ekle ayguci
servis aktif ayguci
mps kur jc jq lshw acpi lm_sensors
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

16- /etc/mps.ini , /etc/hosts ayarları ve kırık bileşen(revdep-rebuild) kontrol edilir.

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
