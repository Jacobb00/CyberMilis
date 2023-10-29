### Milis 2.3 Sıfırdan Yapım Rehberi (Milis Linux From Stratch) ###

0- MPS derleme ortamına girerek önsistem için gerekli paketleri kurunuz.
```
mpsdo
# Milis 2.1 Chroot
mps gun
#binutils-0
mps kur texinfo 
#glibc-0
mps kur python
```

1- Milis 2.3 Depoyu klonlayıp önsistem için gerekli dizinleri oluşturuyoruz.
```
cd /opt
git clone https://mls.akdeniz.edu.tr/git/milislinux/milis23
git clone https://mls.akdeniz.edu.tr/git/milislinux/mps23

source milis23/ayarlar/onsistem/mpsdo.bashrc

# export
#MILIS_HOME="/opt"
#MILIS_REPO="$MILIS_HOME/milis23"
#MPS_PATH="/opt/mps23"
#ONSISTEM_CHROOT="$MILIS_HOME/onsistem"
#TALIMATNAME="$MILIS_REPO/talimatname"
#MPS_NOROOT="yes"
#LC_ALL=C
#ONSISTEM_TARGET=x86_64-milis-linux-gnu
#PATH=$MPS_PATH/static:$MPS_PATH/bin:/tools/bin:/usr/local/bin:/bin:/sbin:/usr/sbin:/usr/bin:/root/bin:/usr/milis/bin
#export ONSISTEM_CHROOT LC_ALL ONSISTEM_TARGET PATH MILIS_HOME MILIS_REPO MPS_PATH TALIMATNAME MPS_NOROOT


mkdir -p $ONSISTEM_CHROOT/tools
ln -sv $ONSISTEM_CHROOT/tools /
```

2- Önsistem için MPS ilklemesi yapılır.
```
mps --ilk --kok=$ONSISTEM_CHROOT
```

3- Aşağıdaki komutlarla önsistemi derlemeye başlarız. 

```
$MILIS_REPO/ayarlar/onsistem/01-onsistem.sh
```

4- Önsistem derlemesi rsync ile bittiğinde, mlfs.list dosyası 
içindeki paketlerin kurulduğundan emin olduktan sonra önsistemi sıkıştırarak yedekleyin.
```
$MILIS_REPO/ayarlar/onsistem/onsistem_sfs.sh
```


5- Temel sistem paketlerinin hazırlanması için yeni derleme ortamına gireriz.
5a- Eğer temel sistem üretimi ertelemek veya sfs kullanarak yapmak isterseniz.Bu adımı uygulayın.
```
# # 5a adımı
[ -d ${ONSISTEM_CHROOT} ] && rm -rf ${ONSISTEM_CHROOT}
unsquashfs ${MILIS_HOME}/onsistem-tarih-saat-degeri.sfs
mv squashfs-root ${ONSISTEM_CHROOT}
```
5a uygulanmazsa direk burdan devam.
Burdan sonraki işlemler sudo yetkili yapılmalıdır.
```
$MILIS_REPO/ayarlar/onsistem/02-enter-chroot-tools

# aşağıdaki çıktıyı görmeniz gerekir.
Chroot ortamı bağlanıyor...
mount: /dev bound on /home/mlfs/onsistem/dev.
mount: devpts mounted on /home/mlfs/onsistem/dev/pts.
mount: proc mounted on /home/mlfs/onsistem/proc.
mount: sysfs mounted on /home/mlfs/onsistem/sys.
mount: tmpfs mounted on /home/mlfs/onsistem/run.
temel sistem talimatları kopyalandı.
'/etc/ssl/certs/ca-certificates.crt' -> '/home/mlfs/onsistem/tools/etc/ssl/certs/ca-certificates.crt'
'/etc/resolv.conf' -> '/home/mlfs/onsistem/tools/etc/resolv.conf'
......
......
```

6- Temel sistem içine girdikten sonra aşağıdaki komut satırına ulaşmanız gerekir.
```
(temel) I have no name!:/#
```

7- Aşağıdaki komutu verip 2.satırdaki komut satırına ulaşılır.
```
(temel) I have no name!:/# 03-temel-dosya-sistemi-hazirla
bash-5.0#
```

8- Aşağıdaki komutu mps.lua -v komutu verilip sürüm bilgisi alınmalıdır.
```
bash-5.0# mps -v
MPS 2.2.1 - Milis Paket Sistemi milisarge@gmail.com

```

9- Aşağıdaki komutu verip temel sistemi derlemeye başlarız.
```
bash-5.0# 05-temel-sistemi-derle.sh

```

10- Bash derlenip kurulduktan sonra aşağıdaki çıktı ile derleme duracaktır.
```
# bash_refresh  komutu verip tekrar devam edin!

```

11- Aşağıdaki komutu vererek, derleme yeni bash ile kaldığımız yerden devam edecektir.
```
bash-5.0# bash_refresh
bash-5.0# 05-temel-sistemi-derle.sh

```

12a- Yeni bash ten sonra ortamdan çıkma durumu olursa yeniden ortam girmek için, aşağıdaki komutu kullanınız.
```
./02.1-enter-chroot
bash-5.0# 05-temel-sistemi-derle.sh
```

13- Temel sistem derlemesi bittikten sonra derleme logları ve temel sistem incelenir.
```
# çıktı olmamalı, olursa etkileri incelenecek
bash-5.0# grep -l 'compilation terminated' *.log
bash-5.0# grep -l '.h: No such file or directory' *.log

# paket sayıları kontrol edilir.
bash-5.0# ls /usr/milis/talimatname/1/ | wc -l
66
bash-5.0# ls /var/lib/mps/db/ | wc -l
132

# çıktı olmamalı
find /var/lib/mps -name kurulan -size 0

# kırık linklerin kontrolü, çıktı olmamalı
rm -rf /tools
find /usr -xtype l
```

14- Derleme ortamı için gerekli paketler üretilmiştir. Sistemden çıkılarak paketler yedeklenir.
```
bash-5.0# exit
logout
bash-5.0# exit
logout
(temel) I have no name!:/# exit
logout

Çözülüyor /home/mlfs/onsistem/sources ...
Çözülüyor /home/mlfs/onsistem/sys ...
Çözülüyor /home/mlfs/onsistem/proc ...
Çözülüyor /home/mlfs/onsistem/dev/pts ...
Çözülüyor /home/mlfs/onsistem/dev ...
Çözülüyor /home/mlfs/onsistem/run ...
bash-5.0# exit

```

15- Derleme ortamından çıkılarak üretilen paketler kullanılarak yerel paket deposu veritabanı hazırlanır ve sunulur.
```
root [ /opt ]# cd /opt
root [ /opt ]# mkdir paketler23
root [ /opt ]# cp /mnt/mpsdo21/rw/opt/onsistem/opt/paketler/*.mps.lz* paketler23/
root [ /opt ]# cd paketler23
root [ /opt/paketler23 ]# for bilgi in `ls *.mps.lz.bilgi`; do echo `cat $bilgi` ;done > paket.vt
root [ /opt/paketler23 ]# yps.py -p 9911
çalışma dizini:  /opt/paketler23
```

16- Yerel depo hazırlandıktan sonra derleme ortamı üretmek için tekrar derleme ortamına girilir.
```
mps gun
export MSYS=/opt/sys23
export MPS_PATH=/opt/mps
export MILIS_PATH=$MSYS/usr/milis
export PATH=$MPS_PATH/bin:$PATH
```

17- MPS’in paketleri nereden alacağını belirlemek için gerekli ayarlar yapılır:

```
nano /opt/mps/conf/conf.lua
# talimatdepoları milis21->milis23 çevrilir.
# sunucu yerel depo için [1]="http://localhost:9911" ayarlanır.
```

18- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
mps --ilkds --ilk --kok=$MSYS
# MPS ilkleme yapıldı: /opt/sys23/
# Milis taban dosya sistemi hazırlandı: /opt/sys23/
```

19- Gerekli güncellemeler yapılır; talimatname, depo ve betik:

```
mps gun -GPB --kok=$MSYS
```

20- Minimal bir sistem ortamı kurmak için gerekli paketler indirilir ve yüklenir:

```
mps kur --dosya=$MSYS/usr/milis/ayarlar/pliste/base.list --kurkos=0 --koskur=0 --kok=$MSYS
```

21- MPS kurulum dizininin altına kopyalanır:

```
cp -r $MPS_PATH $MSYS/usr/milis/mps
```

22- Chroot için geçici locale-archive yüklenir ve chroot içine girilir:

```
cp /usr/lib/locale/locale-archive $MSYS/usr/lib/locale/ 
enter-chroot $MSYS
```

23- Gerekli güncellemeler çalıştırılır:

```
sed -i 's/#tr_TR\.UTF-8 UTF-8/tr_TR\.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
update-ca-certificates --fresh && make-ca -g
ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

24- Önbellekteki paket arşivleri temizlenir, ortamdan çıkılır ve komut tarihçesi temizlenir:

```
exit
rm -rf $MSYS/var/cache/mps/depo/*
rm -f $MSYS/root/.bash_history
```

25- Ortam içindeki sources dizini silinir çünkü sonra mpsdo ile güncel sources dizini bağlanacak:

```
rm -rf $MSYS/sources
```

26- Yeni sistem squash filesystem ile sıkıştırılır:

```
mksquashfs $MSYS milis23-"$(date -d "$D" '+%m-%d')"-base.sfs -comp xz
```

27- Derleme ortamında çıkılır ve yeni derleme ortamı mpsdo23 kullanılarak yeni paket üretimi için hazırlanır.

```
cd /mnt
cp mpsdo21/rw/opt/milis23-07-03-base.sfs .
cd /opt
git clone https://mls.akdeniz.edu.tr/git/milislinux/milis23
git clone https://mls.akdeniz.edu.tr/git/milislinux/mps23
cd -
cp /opt/milis23/bin/mpsdo mpsdo_2.3
cp /opt/milis23/ayarlar/mps/conf23.lua conf23.lua
./mpsdo_2.3 conf23.lua
```
