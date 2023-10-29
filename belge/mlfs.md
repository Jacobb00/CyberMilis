### Milis 2.3 Sıfırdan Yapım Rehberi (Milis Linux From Stratch) ###

0- Önsistem oluşturmak için gerekli paketleri kurunuz.
```
# Milis 2.1
Birşey kurmanıza gerek yok. Araçlar hazır sistemde bulunmaktadır.
# ------------------------
# Arch
pacman -S base-devel
pacman -S bison
pacman -S texinfo
pacman -S libarchive
pacman -S squashfs-tools
pacman -S xorriso
# ------------------------
#  Ubuntu ve türevleri için
apt install build-essential
apt install bison
apt install texinfo
apt install bsdtar
apt install squashfs-tools
apt install xorriso
```

1- Yetkili komut satırına geçerek Milis LFS kullanıcı dizinlerini ayarlıyoruz.
```
sudo su

groupadd mlfs
useradd -s /bin/bash -g mlfs -m -k /dev/null mlfs
passwd mlfs
```

2- Milis 2.1 Depoyu klonlayıp önsistem için gerekli dizinleri oluşturuyoruz.
```
git clone https://notabug.org/milislinux/milis23 /home/mlfs/milis
git clone https://notabug.org/milislinux/mps /home/mlfs/mps

cp /home/mlfs/milis/ayarlar/onsistem/bashrc-onsistem.temp /home/mlfs/.bashrc
cp /home/mlfs/milis/ayarlar/onsistem/bash_profile.temp /home/mlfs/.bash_profile

mkdir -p /home/mlfs/{onsistem,sources}
mkdir -p /home/mlfs/onsistem/tools
ln -sv /home/mlfs/onsistem/tools /
# Milis Linux olmayan sistemde
ln -sv /home/mlfs/sources /
# Milis Linux'ta
ln -sv /sources /home/mlfs/sources
chown -R mlfs:mlfs /home/mlfs
chmod 777 /tmp
chmod 777 /sources
```

3- Önsistemi oluşturmayı başlatmak için mlfs kullanıcısıyla giriş yaparız.
```
su - mlfs

source ~/.bash_profile
```

4- Aşağıdaki komutları vererek izin ve ortam değişkenlerini kontrol ediniz.
```
mlfs@makine1:~$ ls -al

drwxr-xr-x 7 mlfs mlfs 4096 May  5 15:09 .
drwxr-xr-x 4 root root 4096 May  5 14:32 ..
-rw------- 1 mlfs mlfs  166 May  5 15:17 .bash_history
-rw-r--r-- 1 mlfs mlfs   59 May  5 14:55 .bash_profile
-rwxr-xr-x 1 mlfs mlfs  327 May  5 15:17 .bashrc
drwxr-xr-x 4 mlfs mlfs 4096 May  5 15:15 milis
drwxr-xr-x 2 mlfs mlfs 4096 May  5 15:06 mps
drwxr-xr-x 3 mlfs mlfs 4096 May  5 15:06 onsistem
drwxr-xr-x 2 mlfs mlfs 4096 May  5 15:09 sources

mlfs@makine1:~$ export
declare -x HOME="/home/mlfs"
declare -x LC_ALL="POSIX"
declare -x MILIS_HOME="/home/mlfs"
declare -x MILIS_REPO="/home/mlfs/milis"
declare -x MPS_NOROOT="yes"
declare -x MPS_PATH="/home/mlfs/mps"
declare -x OLDPWD
declare -x ONSISTEM_CHROOT="/home/mlfs/onsistem"
declare -x ONSISTEM_TARGET="x86_64-milis-linux-gnu"
declare -x PATH="/home/mlfs/mps/static:/home/mlfs/mps/bin:/tools/bin:/usr/local/bin:/bin:/sbin:/usr/sbin:/usr/bin:/root/bin"                                               
declare -x PS1="\${debian_chroot:+(\$debian_chroot)}\\u@\\h:\\w\\\$ "
declare -x PWD="/home/mlfs"
declare -x SHLVL="1"
declare -x TALIMATNAME="/home/mlfs/milis/talimatname"
declare -x TERM="screen"
```

5- Aşağıdaki komutlarla MPS i önsistem hazırlayıp kontrol ederiz.
```
cd ~/mps
bash derle.sh

mlfs@makine1:~/mps$ mps -v
MPS 2.2 - Milis Paket Sistemi milisarge@gmail.com

```

6- Aşağıdaki komutlarla önsistemi derlemeye başlarız. 

```
cd ~/milis/ayarlar/onsistem
./01-onsistem.sh

# sertifika sorunu olursa
export WGET_GENEL_PARAM="--no-check-certificate"
# komutu verip tekrar komutlayın.
```

7- Önsistem derlemesi Lua ile bittiğinde, talimatname/0/order dosyası 
içindeki paketlerin kurulduğundan emin olduktan sonra önsistemi sıkıştırarak yedekleyin.
```
./onsistem_sfs.sh
```


8- Temel sistem paketlerinin hazırlanması için yeni derleme ortamına gireriz.
8a- Eğer temel sistem üretimi ertelemek veya sfs kullanarak yapmak isterseniz.Bu adımı uygulayın.
```
# # 8a adımı
[ -d ${ONSISTEM_CHROOT} ] && rm -rf ${ONSISTEM_CHROOT}
unsquashfs ${MILIS_HOME}/onsistem-tarih-saat-degeri.sfs
mv squashfs-root ${ONSISTEM_CHROOT}
```
8a uygulanmazsa direk burdan devam.
Burdan sonraki işlemler sudo yetkili yapılmalıdır.
```
exit
cd ${MILIS_REPO}/ayarlar/onsistem
sudo su
bash --rcfile ${MILIS_HOME}/.bashrc

./02-enter-chroot-tools

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

9- Temel sistem içine girdikten sonra aşağıdaki komut satırına ulaşmanız gerekir.
```
(temel) I have no name!:/#
```

10- Aşağıdaki komutu verip 2.satırdaki komut satırına ulaşılır.
```
(temel) I have no name!:/# 03-temel-dosya-sistemi-hazirla
bash-5.0#
```

11- Aşağıdaki komutu mps.lua -v komutu verilip sürüm bilgisi alınmalıdır.
```
bash-5.0# mps -v
MPS 2.2 - Milis Paket Sistemi milisarge@gmail.com

```

12- Aşağıdaki komutu verip temel sistemi derlemeye başlarız.
```
bash-5.0# 05-temel-sistemi-derle.sh

```

13- Bash derlenip kurulduktan sonra aşağıdaki çıktı ile derleme duracaktır.
```
# bash_refresh  komutu verip tekrar devam edin!

```

14- Aşağıdaki komutu vererek, derleme yeni bash ile kaldığımız yerden devam edecektir.
```
bash-5.0# bash_refresh
bash-5.0# 05-temel-sistemi-derle.sh

```

14a- Yeni bash ten sonra ortamdan çıkma durumu olursa yeniden ortam girmek için, aşağıdaki komutu kullanınız.
```
./02.1-enter-chroot
bash-5.0# 05-temel-sistemi-derle.sh
```

15- Temel sistem derlemesi bittikten sonra derleme logları ve temel sistem incelenir.
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

16- Derleme ortamı için gerekli paketler üretilmiştir. Sistemden çıkılarak paketler yedeklenir.
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
bash-5.0# pwd
/home/mlfs/milis/ayarlar/onsistem

cd /home/mlfs
cp -r onsistem/opt/paketler paketler23_base

```

17- Derleme ortamı paketleri kullanılarak yerel paket deposu veritabanı hazırlanır ve sunulur.
```
root [ /home/mlfs ]# cd /opt/
root [ /opt ]# mkdir paketler23
root [ /opt ]# cp /home/mlfs/paketler23_base/*.mps.lz paketler23/
root [ /opt ]# cp /home/mlfs/paketler23_base/*.mps.lz.bilgi paketler23/
root [ /opt ]# cd paketler23
root [ /opt/paketler23 ]# cat *.mps.lz.bilgi > paket.vt
root [ /opt/paketler23 ]# yps.py -p 9999
çalışma dizini:  /opt/paketler23
```

18- Yerel depo hazırlandıktan sonra derleme ortamı üretme belgesinden devam edilir.
