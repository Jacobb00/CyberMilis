### MPS (Milis Paket Yöneticisi)

Milis Paket Sistemi (MPS) Milis Linux işletim sisteminin kendine özgü paket yöneticisidir.
MPS paketlerin birbiriyle kararlı bir şekilde kurulum, silme ve güncelleme işlemlerini gerçekleştirir.
MPS paket yönetiminde talimatname dizin yapısını kullanarak kaynak koddan derleme ve paket üretimini gerçekleştirirken
paket depo bilgi dosyalarındaki paket bilgileriyle ikili paket yönetimini sağlar. Böylelikle hem derleme sistemine hem de
derlenmiş paket sistemini uygulamış olur. MPS i kullanmak için merkezi depoya erişmenize gerek yoktur, kendi yerel deponuzu da
kurarak gerekli paket güncelleme işlemlerini gerçekleştirebilirsiniz. 
Ayrıntılı bilgi için [yardım](https://gitlab.com/milislinux/mps3/-/blob/main/HELP.md) dosyasına bakabilirsiniz.

### Arayüz Uygulaması

MPS için ayrıca Python programlama dilinde GTK arayüz kütüphanesi kullanılarak yazılmış bir arayüz uygulaması mevcuttur.
Aşağıdaki komut ile kurulabilir. Arayüz uygulaması güncel geliştirilmektedir. 
Arayüz uygulaması mps ayarlarında betik bölümünde mpsui anahtarı ile yer alır ve MPS güncellemeleriyle güncellenir.
Sorun ve istekler için [sayfasından](https://gitlab.com/milislinux/mpsui/-/issues) hata kaydı oluşturunuz.

### Yapılandırma

MPS paket yöneticisinin ayarları /usr/milis/mps/conf dizini altında mps.ini dosyası içinde bulunmaktadır. 
INI biçimine ait ayar yapısı içeren ayar dosyası elle veya mps oku/yaz komutlarıyla düzenlenebilir.
Aşağıda yer alan varsayılan ayar içeriği üzerinden ayrıntılı olarak ilgili alt ayarlar açıklanmıştır.

```
[sunucu]
1 = https://gitlab.com/milislinux/depo/-/raw/main
;2 = https://mls.akdeniz.edu.tr/mkd23
;3 = http://localhost:9900

[betik]
ayarlar  = https://gitlab.com/milislinux/milis23::ayarlar
bin      = https://gitlab.com/milislinux/milis23::bin
mservice = https://gitlab.com/milislinux/mservice
ayguci   = https://gitlab.com/milislinux/ayguci
mpsui    = https://gitlab.com/milislinux/mpsui

[talimat]
1   = https://gitlab.com/milislinux/milis23::talimatname/1
2   = https://gitlab.com/milislinux/milis23::talimatname/2
;3   = https://gitlab.com/milislinux/mkd23

[repo]
dizin = /sources
resmi = https://gitlab.com/milislinux
```
 
Milis Linux'ta özgün kodlar ve talimatname Git sürüm kontrol sistemi üzerinden yürütülür. 
Dolayısıyla Git depolarının kayıt edildiği bir yerel dizin değişkeni vardır. 
Bu değişken ayar dosyasında **repo** bölümünde **dizin** anahtarı olarak yer alır ve yerel dizinde **/sources** altında toplanır.
Örneğin Milis resmi Git deposu /sources altında gitlab.com.milislinux.milis23 olarak kayıt edilir.
Bu dizin üzerinden Git güncellemesi yapılır ve sisteme (/usr/milis/ altına) kopyalanır.
 
Ayar dosyasında ikili paket deposu bilgileri **sunucu** bölümünde sayısal öncelik sağlayacak şekilde 1,2,3.. şeklinde anahtar değerlere ayarlanır.
MPS talimatnamedeki önceliğe göre paket bağımlılıklarını hesapladıktan sonra ikili depo sırasına göre gerekli paketleri sunuculardan çeker.
Sunucu adresleri IPv4 ve IPv6 biçim kuralına uygun olmalıdır.
Sunucu adresi tanımlanırken dikkat edilmesi gereken bir noktada sunucunun kök dizininde paket.vt dosyasının bulunması gerekliliğidir.
Yukarı örneğe göre paket veritabanı **http://localhost:8888/paket.vt** ve **https://sunucum.org/paketlerim/paket.vt** şeklinde indirilebilir olmalıdır.

Çoklu ikili depo desteği gibi talimatname düzeyinde de MPS çoklu talimatnameleri desteklemektedir. 
Aynı şekilde **talimat** bölümü altında anahtar değerler ile tanımlanmaktadır. 
Fakat buradaki sayısal değerli anahtar değerler talimatname içindeki seviyeleri ifade etmektedir.
Talimatname Git depoları /sources (repo_dizin) altına toplu şekilde klonlanır ve güncellenir. 
Buna göre **1 = https://gitlab.com/milislinux/milis23::talimatname/1** satırında belirtildiği şekilde,
https://gitlab.com/milislinux/milis23 Git deposu altından talimatname dizini altındaki 1 dizini /usr/milis/talimatname 
altına kopyalanır. Varsayılan olarak 1.seviye temel sistem paketlerini, 2.seviye ise resmi diğer talimatları ifade etmektedir.
Bu arada **talimat** bölümünde **sayısal sıra** şeklinde değişken tanımlaması kullanılmaktadır.
Bu esnek değişken tanımlaması sayesinde talimat seviyeleri farklı Git depolarıyla beslenebilmektedir.

```
3a   = https://gitlab.com/milislinux/mkd23
3b   = https://gitlab.com/aliveli/repo::talimatlar
```

Örneğin yukarıdaki **talimat** depoları ayarına göre, /usr/milis/talimatname/3a dizini altına https://gitlab.com/milislinux/mkd23 Git deposunda
kök dizin altında yer alan talimatlar kopyalanmaktadır.
Alttaki ayara göre de 3b dizini altına https://gitlab.com/aliveli/repo Git deposunda yer alan talimatlar dizini içeriği kopyalanmaktadır. 
Dikkat edildiği üzere **::** ayracı bir Git deposu altındaki dizini ifade etmektedir.

Ayrıca ayar dosyası içinde Milis sisteminde kullanılan betik ve ayarları tanımlayan **betik** bölümü bulunmaktadır.
Bu değişken /usr/milis/ altında yerleşecek dizin isimleri değişken adı olmak kaydıyla çoklu Git depolarını tanımlamaktadır.

```
[betik]
ayarlar  = https://gitlab.com/milislinux/milis23::ayarlar
bin      = https://gitlab.com/milislinux/milis23::bin
mservice = https://gitlab.com/milislinux/mservice
ayguci   = https://gitlab.com/milislinux/ayguci
mpsui    = https://gitlab.com/milislinux/mpsui
```

Yukarıdaki örneğe göre https://gitlab.com/milislinux/milis23 Git deposu altından yer alan bin ve ayarlar dizinleri anahtar değere göre 
sırasıyla /usr/milis/bin ve /usr/milis/ayarlar olarak kopyalanacaktır. İstenirse farklı Git depolarıyla bin, ayarlar dizini beslenebilir.
Alttaki diğer anahtar değerler de sistem için gerekli olan uygulamaların eklenerek MPS üzerinden güncellenmesini sağlamak için kullanılmaktadır.
