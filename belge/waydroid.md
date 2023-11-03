[Waydroid](https://waydro.id), Linux konteyner altyapısını kullanarak Android imajını Linux üzerinde çalıştırmayı sağlayan uygulamadır.
Kurulum ve yapılandırma için aşağıdaki adımlar yetkili terminalde uygulanmalıdır.


#### Kurulum
```
[ ~ ]# mps kur waydroid
[ ~ ]# sh /usr/milis/talimatname/2/app/waydroid#1.1.4-1/binder-module.sh
```

#### Servis İşlemleri
```
[ ~ ]# servis ekle lxc && servis kos lxc
```

#### Waydroid Ayarları
```
[ ~ ]# waydroid init

[ ~ ]# nano /var/lib/waydroid/lxc/waydroid/config
#lxc.apparmor.profile = unconfined

```

#### Waydroid Başlatma
```
# normal kullanıcı
[ ~ ]$ waydroid show-full-ui

```
