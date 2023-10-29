### Ayguci - Modüler Ayar Sistemi 

Milis Linux'un amaçlarından biri de sistem ayarlarını kullanıcı için kolaylaştırmaktır. 
Bunun için ilk sürümlerde Komutan adlı web tabanlı uygulama geliştirilmeye çalışılmıştır.
Fakat zamanla yapılan arge çalışmaları sonucu kod altyapısı daha esnek bir çalışma modeline çevrilerek C ve Lua ile yeniden yazılmıştır.
Bu yeni uygulama, eski Türk yönetim sisteminde kağandan sonra en yetkili kişi anlamına gelen Ayguçi olarak adlandırılmıştır.

Ayguci uygulamasının amacı, sisteme dönük tüm ayarların modüler bir şekilde kullanıcı tarafından yapılabilmesini sağlamaktır.
Bu ayarlar sistem, ağ, ekran, ses, zaman vb. gibi gruplar altında yer alabilir.
Her bir ayarlama Ayguci'de işlev olarak bir grup altında yer alır. 
Dolayısıyla kullanıcı bir ayara önce grubunu sonra işlevini seçerek erişir.
Bu erişim sonucu ilgili ayara ilişkin durum verisi gösterilir.
Bu veri gerekirse kullanıcı tarafından düzenlenip güncellenebilir.
Örnek vermek gerekirse; saati ayarlama için datetime grubu altından manual işlevine erişmek gerekmektedir.
İlk erişimde kullanıcıya güncel saat ve tarih bilgisi gösterilecektir.
Kullanıcı ilgili sahayı düzenleyerek onayladığı zaman, saat/tarih ayarlama işlemi tamamlanmış olacaktır.
Kullanıcıya ayar arayüzü; komut satırı, konsol arayüzü ve grafik arayüzü olmak üzere üç farklı şekilde sunulmaktadır.

Ayguci'nin çalışma yapısı, IPC haberleşme mekanizması kullanan sunucu/istemci modelindedir.
Ayguci sunucu betiği, servis olarak arkaplanda ilgili işlev isteklerini dinlerken
istemci uygulamalar farklı arayüzler üzerinden sunucu ile haberleşmektedir. 
Ayguci'de her grup moduller altında birer dizin olarak yer alırken işlevler de grup dizini altında
Lua betikleri olarak yer almaktadır. 
Her işlev içinde kullanıcıya gösterilecek çıktı(get) ve alınacak girdi(set) tanımlanmaktadır.
Kullanıcının işleve erişiminde Ayguci dinamik bir şekilde konsol veya grafiksel arayüz üretmektedir.

Aşağıda kurulum ve kullanımı bilgileri yer almaktadır.


#### İlk Kurulum ve Güncelleme:
```
	mpsc -b ayguci @ayguci
	mps gun
	servis ekle ayguci
	servis kos ayguci
```

#### Kabuk Arayüz Erişimi:
```
	ayguci shell
```

#### Grafik Arayüzü Kurulum ve Başlatma:

```
	mpsc -b ayguciui @ayguciui
	mps gun
	# Masa yebaşlat yapılır.
	# Menüden Ayguci açılır.
```

