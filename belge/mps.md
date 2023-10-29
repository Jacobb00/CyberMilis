### MPS (Milis Paket Yöneticisi)

Milis Paket Sistemi (MPS) Milis Linux işletim sisteminin kendine özgü paket yöneticisidir.
MPS paketlerin birbiriyle kararlı bir şekilde kurulum, silme ve güncelleme işlemlerini gerçekleştirir.
MPS paket yönetiminde talimatname dizin yapısını kullanarak kaynak koddan derleme ve paket üretimini gerçekleştirirken
paket depo bilgi dosyalarındaki paket bilgileriyle ikili paket yönetimini sağlar. Böylelikle hem derleme sistemine hem de
derlenmiş paket sistemini uygulamış olur. MPS i kullanmak için merkezi depoya erişmenize gerek yoktur, kendi yerel deponuzu da
kurarak gerekli paket güncelleme işlemlerini gerçekleştirebilirsiniz. Aşağıda MPS için komutlar açıklanmıştır, 
@paket yazan yere uygulama/kütüphane ile ilgili paket adı girilmelidir.  

### Uçbirim Komutları

#### Yardım

```
	mps -h
	mps --help
	mps işlev -h # ilgili işlev ile ilgili yardım menüsü
```

#### Güncelleme:
```
	mps gun     # tüm depoların güncellemesi
	mps gun -M  # paket yöneticisi güncellemesi
	mps gun -P  # paket depo güncellemesi
	mps gun -G  # talimat depo güncellemesi
	mps gun -B  # betik depo güncellemesi
	mps gun -S  # sistem güncellemesi

	mps gun -S --durum # sistem güncelleme bilgisi
```

#### Kurulum:
```
	mps kur @paket / paket_adı.mps.lz
	mps kur @paket1 @paket2 
	mps kur -d paket_listesi_dosyasi # Dosyadan kurar
```

#### Silme:
```
	mps sil @paket
	mps sil @paket --ona # onay almadan siler
```

#### Derleme:

```
	mps der @paket     # gerekleriyle derler
	mps der @paket -t  # tekil paket derleme

	mps der -d paket_liste_dosyası # Dosyadan derler		
```

#### Arama:
```
	mps ara @paket -t # talimatnamede arar
	mps ara @paket    # paket depolarında arar
	mps ara @paket -a # açıklamalarda arar
```

#### Bilgi:

```
	mps bil @paket       # paket veya talimat hakkında bilgi sağlar
	mps bil @paket --kk  # paketin kurulu olma durum bilgisi verir
	mps bil @paket --kdl # paketin kurulu dosyalarını gösterir
	mps bil @paket --pkd # paket kurulum doğrulaması yapılır
```

#### Sorgulama:

```
	mps sor -L         # sistemdeki kurulu paket listesini verir
	mps sor --hp dosya # dosyanın hangi kurulu paketlerde yer aldığını bulur.
	mps sor --dpl      # depolardaki paket listesinin verir.
```

#### İndirme:

```
	mps in @paket      # paketi önbellek paket dizinine (/var/cache/mps/depo) indirir.
```

### Arayüz Uygulaması

MPS için ayrıca Python programlama dilinde GTK arayüz kütüphanesi kullanılarak yazılmış bir arayüz uygulaması mevcuttur.
Aşağıdaki komut ile kurulabilir. Arayüz uygulaması güncel geliştirilmektedir. 
Sorun ve istekler için [sayfasından](https://mls.akdeniz.edu.tr/git/milislinux/mps-ui/issues/new>) hata kaydı oluşturunuz.

```
	mps kur mps-ui
```

### Yapılandırma

MPS paket yöneticisinin ayarları /usr/milis/mps/conf dizini altında conf.lua dosyası içinde bulunmaktadır. 
Lua programlama dili sözdiziminin ayar dosyası biçimine uygun olmasından dolayı ayar dosyasının kendisi de bir Lua programıdır.
Aşağıda yer alan varsayılan ayar içeriği üzerinden ayrıntılı olarak ilgili alt ayarlar açıklanmıştır.

```

#!/usr/bin/env lua

local mpsconf={
	repo_dizin="/sources",
	sunucu={
		[1]="https://mls.akdeniz.edu.tr/paketler",
	},
	talimatdepo={
		[1]={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="talimatname/1"},
	[2]={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="talimatname/2"},
	-- -- ile başlayan satırlar Lua'da yorum satırıdır. 
	-- [3]={
	--	["https://notabug.org/abc/milis"]="2/pentest",
	-- ["https://notabug.org/def/milis"]="2/games",
	--},
	},
	betikdepo={
	bin={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="bin"},
	ayarlar={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="ayarlar"},
	ayguci={["https://mls.akdeniz.edu.tr/git/milislinux/ayguci"]=""},
	},
}

return mpsconf
```
 
Milis Linux'ta özgün kodlar ve talimatname Git sürüm kontrol sistemi üzerinden yürütülür. 
Dolayısıyla Git depolarının kayıt edildiği bir yerel dizin değişkeni vardır. 
Bu değişken ayar dosyasında **repo_dizin** olarak yer alır ve yerel dizinde **/sources** altında toplanır.
Örneğin Milis resmi Git deposu /sources altında mls.akdeniz.edu.tr.git.milislinux.milis21 olarak kayıt edilir.
Bu dizin üzerinden Git güncellemesi yapılır ve sisteme (/usr/milis/ altına) kopyalanır.
 
Ayar dosyasında ikili paket deposu **sunucu** tablo değişkeni üzerinden ikili depoların ayarlarını kayıt etmektedir.
Tablo tipi değişken kullanılmasının nedeni birden fazla ikili depo desteğinin sunulabilmesidir.
MPS talimatnamedeki önceliğe göre paket bağımlılıklarını hesapladıktan sonra ikili depo sırasına göre gerekli paketleri sunuculardan çeker.
Bunun için **[sırano]=** biçiminde ikili depo sunucu adresi tanımlanmalıdır. Örneğin:

```
sunucu={
	[1]="https://mls.akdeniz.edu.tr/paketler",
	[2]="https://sunucum.org/paketlerim",
	[3]="http://localhost:8888",
},

```

Sunucu adresleri IPv4 ve IPv6 biçim kuralına uygun olmalıdır.
Sunucu adresi tanımlanırken dikkat edilmesi gereken bir noktada sunucu kök dizin altında paket.vt dosyasının bulunması gerekliliğidir.
Yukarı örneğe göre paket veritabanı **http://localhost:8888/paket.vt** ve **https://sunucum.org/paketlerim/paket.vt** şeklinde indirilebilir olmalıdır.

Çoklu ikili depo desteği gibi talimatname düzeyinde de MPS çoklu talimatnameleri desteklemektedir. 
Aynı şekilde **talimatdepo** değişkeni de tablo tipi değişkeni şeklinde tanımlanmaktadır. 
Fakat buradaki [] ayraçları arasındaki sıra numaraları talimatname içindeki seviyeleri ifade etmektedir.
Talimatname Git depoları /sources (repo_dizin) altına toplu şekilde klonlanır ve güncellenir. Fakat
**[1]={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="talimatname/1"}** satırında belirtildiği şekilde,
https://mls.akdeniz.edu.tr/git/milislinux/milis21 Git deposu altından talimatname dizini altındaki 1 dizini /usr/milis/talimatname 
altına kopyalanır. Varsayılan olarak 1.seviye temel sistem paketlerini, 2.seviye ise resmi diğer talimatları ifade etmektedir. 
Bu arada **talimatdepo** değişkeni içinde  **[sırano]={}** şeklinde değişken tanımlaması kullanılmıştır.
Bu esnek değişken tanımlaması sayesinde talimat seviyeleri farklı Git depolarıyla beslenebilmektedir.

```
[3]={
	["https://notabug.org/abc/milis"]="2/oyun",
	["https://notabug.org/def/milis"]="2/pentest",
},
```

Örneğin yukarıdaki **talimatdepo** ayarına göre, /usr/milis/talimatname/3 dizini altına https://notabug.org/abc/milis Git deposunda
2 dizini altındaki oyun ve https://notabug.org/def/milis Git deposunda 2 dizini altındaki pentest dizinlerinde bulunan talimatlar 
kopyalanır.

Ayrıca ayar dosyası içinde Milis sisteminde kullanılan betik ve ayarları tanımlayan **betikdepo** değişkeni bulunmaktadır.
Bu değişken /usr/milis/ altında yerleşecek dizin isimleri değişken adı olmak kaydıyla çoklu Git depolarını tanımlamaktadır.

```
betikdepo={
	bin={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="bin"},
	ayarlar={["https://mls.akdeniz.edu.tr/git/milislinux/milis21"]="ayarlar"},
	ayguci={["https://mls.akdeniz.edu.tr/git/milislinux/ayguci"]=""},
},
```

Yukarıdaki örneğe göre https://mls.akdeniz.edu.tr/git/milislinux/milis21 Git deposu altından bin dizini /usr/milis/bin altına kopyalanacaktır.
İstenirse farklı Git depolarıyla bin, ayarlar dizini beslenebilir.
