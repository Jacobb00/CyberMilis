
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
git clone https://gitlab.com/milislinux/mps23 $MPS_PATH
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
nano conf/mps.ini
# talimatdepoları milis21->milis23 çevrilir.
# sunucu yerel depo için [1]="http://localhost:9911" ayarlanır.
```

5- Dizin sistemi ve MPS’nin ilklenmesini kok değerine göre verilen dizinde oluşturulur:

```
cd /opt/milis-calisma
mps --ilkds --ilk --kok=$MSYS
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

9- chroot içine girilir:

```
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

11- Önbellekteki paket arşivleri temizlenir, ortamdan çıkılır ve komut tarihçesi temizlenir:

```
rm -rf /var/cache/mps/depo/*
exit
rm -f $MSYS/root/.bash_history
```

12- Ortam içindeki sources dizini silinir çünkü sonra mpsdo ile güncel sources dizini bağlanacak:

```
rm -rf $MSYS/sources
```

13- Yeni sistem squash filesystem ile sıkıştırılır:

```
mksquashfs $MSYS milis23-"$(date -d "$D" '+%m-%d')"-base.sfs -comp xz
```
