### Servis Yönetimi

Milis Linux başlatıcı(init) sistemi olarak 2.1 sürümünden itibaren Militer adlı kendi init sistemini kullanmaktadır.
Militer başlatıcı sistemi, *init* ikili dosyasını Busybox'tan kullanmak üzere geri kalan işlemler için Lua sözdizimli dosyaları kullanmaktadır.
Init ikilisi */etc/inittab* dosyasında tanımlanmış olan */etc/init/init.lua* betiğini sistem başlarken ve kapatılırken çalıştırır.
Sistem ve uygulamalar ile ilgili bütün servisler init.lua tarafından yönetilmektedir.
Servisler belli bir sırayla başlamaktadır. Servis sıralaması ve çalışma seviyeleri (runlevels) */etc/init/config.lua* içinden ayarlanmaktadır.

Servisler, sistem açılırken bir kereye mahsus veya devamlı çalışması gereken uygulamaların görev dosyalarını ifade eder.
Bir servis dosyası genel olarak bir uygulama için çalışma, durma, oto-başlama ve devre dışı olma durumlarına dönük işlevleri sunmaktadır.
Uygulamalar için servis dosyaları paket içeriği ile gelmeyip betik deposuyla beraber gelmektedir. 
Servis dosyaları */usr/milis/ayarlar/init/* altında yer almakta olup servis betiği ile */etc/init* altına kopyalanarak kurulmaktadır.
Bir uygulamanın sistem açılırken çalışması gerekiyorsa ilgili servis dosyası kurularak - etkinleştirilmelidir.
Kullanıcı tanımlı servisler de oluşturulduktan sonra */etc/init* altına kopyalanarak kullanılabilir.

Milis Linux 2.1'de servis yönetimi, Lua dilinde yazılmış 
[servis.lua](https://mls.akdeniz.edu.tr/git/milislinux/milis21/src/branch/master/bin/servis.lua) betiğiyle sağlanmaktadır.
Aşağıda **servis** komutunun uçbirimde alt komutları incelenmektedir. 
 
- Servisi sisteme kurar. Kurulacak servis */usr/milis/ayarlar/init/* altında yer almalıdır.
```
	servis ekle @servis
```

- Servisin durum bilgisini verir.
```
	servis bil @servis
```

- Servisi başlatır. 
```
	servis kos @servis 
```

- Servisi durdurur.
```
	servis dur @servis
```

- Servisi yeniden başlatır.
```
	servis dur @servis && servis kos @servis
```

- Servisi etkilenleştirerek sistem açılırken oto-başlaması sağlanır.
```
	servis aktif @servis
```

- Servisi devre dışı bırakarak sistem açılırken oto-başlaması iptal edilir. 
```
	servis pasif @servis
```

- Servisi kaldırır.
```
	servis sil @servis
```

- Betik deposuyla gelen servis listesini verir.
```
	servis dliste @servis
```

- Sistemde kurulu servis listesini verir.
```
	servis eliste @servis
```

- Sistemdeki aktif(açılışta başlayan) servis listesini verir.
```
	servis liste @servis
```
