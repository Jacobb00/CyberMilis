
## Sandık (Container) Üretimi ve Kullanımı - Milis Linux 2.1

Eğer hazır üretilmiş sistem kalıbını kullanmak isterseniz mpsdo komutunu kullanabilirsiniz.
Not: Aynı sürümlü Milis Linux kullanıyorsanız; 2, 3 ve 4 adımlarını atlayınız.

1- Gerekli dizin ve çevre değişkenleri ayarlanır:

```
mkdir /opt/milis-calisma
cd /opt/milis-calisma
export MSYS=/opt/milis-calisma/sys
export MPS_PATH=/opt/milis-calisma/mps
export MILIS_PATH=$MSYS/usr/milis

# Sistem Milis Linux ise
export MPS_PATH=/usr/milis/mps

```

2- Güncel MPS kaynak kodu indirilip derlenir:

```
git clone https://mls.akdeniz.edu.tr/git/milislinux/mps $MPS_PATH
cd $MPS_PATH
./derle.sh
```

3- MPS gerekli konfigürasyon ayarlarını yaptğınından dolayı ilk çalıştığında:

```
export PATH=$MPS_PATH/bin:$PATH
mps
MPS öntanımlı ayarlar yüklendi.
Lütfen mps'i yeniden çalıştırın!
```

uyarısını verecektir. Bu adımdan sonra mps kurulumu tamamlanmış olur. Kontrol etmek için:

```
mps -v

MPS 2.x.x - Milis Paket Sistemi milisarge@gmail.com
```

4- MPS’in paketleri nereden alacağını belirlemek için gerekli ayarlar yapılır:

```
nano conf/conf.lua
# talimatdepoları milis19->milis21 çevrilir.
# sunucu yerel depo için [1]="http://localhost:9900" ayarlanır.
```

5- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
cd /opt/milis-calisma
mps --ilkds --ilk --kok=$MSYS
rm -f $MSYS/etc/sysconfig/*
```

6- Gerekli güncellemeler yapılır; talimatname, depo ve betik:

```
mps gun -GPB --kok=$MSYS
```

7- Minimal bir sistem ortamı kurmak için gerekli paketler indirilir ve yüklenir:

```
mps kur --dosya=$MSYS/usr/milis/ayarlar/pliste/base.list --kurkos=0 --koskur=0 --kok=$MSYS
```

8- MPS kurulum dizininin altına kopyalanır:

```
cp -r $MPS_PATH $MSYS/usr/milis/mps
```

9- Konak sistemin hosts dosyası kullanılmak istenirse:

```
cp -f /etc/hosts $MSYS/etc/
```

10- chroot içine girilir:

```
enter-chroot $MSYS
```

11- mps dizini altındaki lua modulleri derlenir:
Not: Milis 2.1 Lua 5.4 kullandığı için ilgili derleme betiği kullanılacaktır.
Not: MPS 2.2 için bu işlem atlanılacaktır.

```
cd /usr/milis/mps
./derle.sh
cd /opt
```

12- Gerekli güncellemeler çalıştırılır:

```
update-ca-certificates --fresh && make-ca -g
ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

13- Sandık sistemi için gerekli paket listesi kurulur.

```
mps kur --dosya=/usr/milis/ayarlar/pliste/sandik.list
```

14- Milis servis sistemi aşağıdaki yönergeye göre kurulur. /etc/init/config.lua kontrol edilir.

```
cd /usr/milis/ayarlar/init
# minimal kurulum için desktop parametresi kullanılmayacak!
./setup.sh sandik
cd -
```

15- /usr/milis/mps/conf/conf.lua ve /etc/hosts ayarları kontrol edilir.

16- Önbellekteki paket arşivleri temizlenir, ortamdan çıkılır ve komut tarihçesi temizlenir:

```
rm -rf /var/cache/mps/depo/*
rm -rf /tmp/*
exit
rm -f $MSYS/root/.bash_history
```

17- Sandık sıkıştırılarak hazırlanır:

```
cd $MSYS
tar -cJf ../rootfs.tar.xz .
```

18- LXC kurulması ve ayarlanması:
```
mps kur lxc
servis ekle lxc
servis kos lxc
```

19- Sandığın LXC dizinlerine kurulması:
```
export sandik="milis-s1"

mkdir -p /var/lib/lxc/${sandik}/rootfs

cat << EOF >> /var/lib/lxc/${sandik}/config
lxc.include = /usr/share/lxc/config/common.conf
lxc.arch = linux64
lxc.rootfs.path = dir:/var/lib/lxc/${sandik}/rootfs
lxc.uts.name = ${sandik}
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
EOF

tar xf rootfs.tar.xz -C /var/lib/lxc/${sandik}/rootfs
```

20- Sandığa LXC ile erişimi yeni bir terminalden yapılmalıdır:
```
lxc-start -n ${sandik}
lxc-attach -n ${sandik}

[root@milis21 /]
```

21- Sandık içi ayarlar:
```
# passwd ile parola ayarları
# top ile süreçler kontrol edilir.
```

22- Sandık durdurmak için:
```
lxc-stop -n ${sandik}
```
