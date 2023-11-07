Paketleme-1
===========

Giriş
-----

Milis Linux, paket yönetimini kaynak koddan derleme ve ikili paket
depolarını kullanarak iki yolla gerçekleştirir. Sistemin çalışması için
gerekli olan paketlerin tanımlamaları özelleştirilmiş INI biçemindeki
talimat dosyaları ile tutulur. Talimatların oluşturduğu hiyerarşik dizin
yapısına da talimatname denir. Talimatname BSD sistemlerdeki ports
yapısı gibi düşünülebilir.

Paket yöneticisinin alt bir uygulaması olan mpsd aracı ile talimatname
kullanılarak paketlerin üretimi sağlanır. Mps paket yöneticisi ise
üretilen paketlerin sisteme kurulması, silinmesi gibi paket yönetim
işlemlerine bakar. Dolayısıyla Milis Linux ikili paket deposu olmasa da
kaynak koddan derleme yoluyla çalışabilecek yapıdadır. Fakat günümüz
işletim sistemi kullanımında her paketin kullanıcı tarafından derlenmesi
beklenemez. Bunun için ikili paket depoları kullanılır. Merkezi derleme
sunucusunda üretilen paketler buraya aktarılır. Mps paket yöneticisi de
ikili depoyu kullanarak son kullanıcının paket yönetimini sağlar.

Talimatname
-----------

Milis Linux talimatname dizini /usr/milis/talimatname yolunda bulunur.
Talimatlar düzeylere göre alt dizinlerde bulunur. Resmi olarak 1 ve 2
numaralı dizinler bulunur. 1 numaralı dizin temel sistem için gerekli
talimatları tutarken 2 numaralı dizin diğer paketleri ilgili
kategorilere göre barındırır. Düzey sayısı artırabilinir, örneğin GIT
depo altındaki 3 numaralı düzey MPS ayar dosyasına eklenerek yeni
talimatların MPS tarafından tanınması sağlanır veya kişisel GIT depoları
da yeni düzey altına eklenebilir. Burada dikkat edilmesi gereken MPS
talimatları düzey numaralarına göre tarar, onun için önceliği düzey
numaraları ve altındaki kategorilerin alfabetik sıralamasına göre
verecektir.

Talimatnamede paket temsilleri talimat dizini olarak yer alır. Örneğin
Geany metin düzenleyici paketi talimatname altında
/usr/milis/talimatname/2/app-text/geany#1.36-1 olarak yer alır. Talimat
dizinleri paket_adı#sürüm#devir biçiminde adlandırılmalıdır. Talimat
dizinin altında ise başta talimat dosyası olmak üzere ilişkili dosyalar
bulunur. Bu dosyalar koşuk/derleme betikleri, yama, servis ve ayar
dosyaları olabilir. Genelde internetten çekilebilecek dosyaların talimat
dizini içinde bulunmasına gerek yoktur. Daha çok Milis ilişkili
dosyalara yer verilir. Aşağıda örnek bir talimat dizini gösterilmiştir.

    geany#1.36-1
    ├── talimat
    ├── xyz.patch
    ├── kurkos.sh
    └── pakur.sh

Talimat
-------

Talimat dosyaları Milis Linux paket yapımında kullanılan INI dosya
biçeminde özel dosyalardır. Talimat dosyası, bir paketin nasıl
üretilebileceğine ilişkin bilgileri içermektedir. Talimat dizini
altında 'talimat' adıyla yer alır. 
Bilindiği üzere INI dosya biçeminde '[' ve ']' karakterleri ile gösterilen
bölümler vardır. Bu bölümler altında da anahtar-değer şeklinde ifadeler
yer alır. Bölümler paket için üst bilgi ve derleme aşamalarını gösterir.
Anahtar ve değerleri ise her bölüm için özel işlevleri ifade etmektedir.
Yorum satırları **;** başlatılarak yazılabilir. Bu arada INI dosya
biçeminde her anahtar bir değere karşılık gelmektedir. Bir anahtar için
çoklu satıra sahip değer ifade edilemez. Aşağıda bir talimat dosyasında
yer alana her bölüm ayrıntılı olarak ele alınmıştır.

### Paket Bölümü

Bir talimat için gerekli kimlik bilgilerini içerir. Bu bilgiler paketin
üstbilgilerini oluşturur.

    [paket]
    tanim   = Paketi tanımlayan kısa cümle
    paketci = Paketi hazırlayan sorumlu kisi
    grup    = Paket grubu
    url     = Paket ile ilgili site 

örnek:

    [paket]
    tanim   = Bilgisayarla görme ve makine öğrenimi yazılım kütüphanesi
    paketci = milisarge
    grup    = kütüphane
    url     = https://opencv.org

### Gerek Bölümü

Bir talimatın derleme ve çalışma gereklerinin belirtildiği bölümdür. MPS
birbirine bağlı derlemelerde derleme satırındaki paketlere göre derleme
listesini oluşturur. Aynı zamanda bir paketin kurulumunda çalışma
gerekleri ve libgerekler (daha sonra anlatılacak) dosyası kullanılır.
Çalışma gerekleri eğer libgerekler dosyası ile sağlanmayan gerekli paket
varsa ifade edilir. Gerekler yanyana ve arada bir boşluk bırakılarak
yazılır.

    [gerek]
    derleme = Bir paketin derlenmesi için kurulması gereken kütüphane ve derleme araçları paketleri
    calisma = Paketin sistemde çalışırken ihtiyacı olan paketler  

örnek:

    [gerek]
    derleme = pkg-config cmake lapack eigen ffmpeg libpng python-numpy
    calisma = python-numpy

### Kaynak Bölümü

Bir paketin oluşturulmasında kullanılan kaynak dosya, arşiv, yama, ayar
vs bilgilerin ifade edildiği bölümdür. Derleme başlarken buradaki
değerlere göre kaynak dosyaları **/sources** dizini altına indirilir.
İndirildikten sonra arşiv dosyaları **$SRC(/tmp/work/src)** altına açılır, normal dosyalar ise kopyalanır. 
Normalde sayısal veya url anahtarı ile arşiv dosyasının internet adresi belirtilir. Kaynaklar
ifade edilirken isim, surum, devir, url değişkenleri başına $ konularak
kullanılabildiği gibi Bash kabuk diline uygun çevrimler de
kullanılabilir. Bu bölüm için bazı özel anahtarlar kullanılabilir. Bu
anahtarlar shell değişken sözdizimine uygun değer dönüşümlerinde
kullanılır.

**Arşiv kısaltmaları** Arşiv kısaltmaları için son ek ifadeleri kullanılır:

	gz     = Değerin sonuna $isim-$surum.tar.gz ekler.
	xz     = Değerin sonuna $isim-$surum.tar.xz ekler.
	bz2    = Değerin sonuna $isim-$surum.tar.bz2 ekler.
	tgz    = Değerin sonuna $isim-$surum.tgz ekler.
	github = github_hesabı/git_deposu
	git    = Git depo adresi

örnek:

    [paket]
    ....
    url = https://opencv.org

    [kaynak]
    gz     = $url/releases
    ; https://opencv.org/releases/$isim-$surum.tar.gz olarak çevrilir.
    github = milisarge/abc
    ; /sources altına github.com/milisarge/abc deposu yoksa klonlanır varsa güncellenir.
    git    = https://notabug.org/milisarge/def
    ; /sources altına ilgili git deposu yoksa klonlanır varsa güncellenir. 

**Site Değişkenleri** Eğer kaynak adresi bu şablona uyuyorsa
kullanılabilir:

    KERNEL_SITE   = https://www.kernel.org/pub/linux
    GNU_SITE      = https://ftp.gnu.org/gnu
    GNOME_SITE    = https://download.gnome.org/sources
    PYPI_SITE     = https://files.pythonhosted.org/packages/source
    XFCE4_SITE    = https://archive.xfce.org/src
    CPAN_SITE     = https://www.cpan.org/modules/by-module
    SOURCEFORGE_SITE = https://downloads.sourceforge.net/sourceforge
    FREEDESKTOP_SITE = https://www.freedesktop.org/software

örnek:

    [kaynak]
    1 = ${KERNEL_SITE}/kernel/v5.x/linux-$surum.tar.xz
    ; http://www.kernel.org/pub/linux/kernel/v5.x/linux-5.4.tar.xz olarak çevrilir.

**Dosya anahtarı** Talimat dizininde yer alan dosyaların belirtilmesi
için **dosya** anahtarı kullanılır. İlgili dosya derleme dizinine
kopyalanacağından $SRC/dosya_adi ile kullanılabilir.

örnek:

    [kaynak]
    1     = ${KERNEL_SITE}/kernel/v5.x/linux-$surum.tar.xz
    dosya = security-fix.patch
    ; bu dosyanın talimat dizini içinde yer alması gerekir. 
    ; Mpsd $SRC altına kopyalacaktır.

**Farklı Ad Kaydı** Kaynak dosyasını /sources altına farklı bir isim
ile kayıt etmek istersek, kaynak adresinden sonra **::** eklenerek
istenilen yeni isim yazılır.

örnek:

    [kaynak]
    url = https://download.com/Xyz_123.tar.gz::$isim-$surum.tar.gz
    ; paket isminin xyz sürümünün 1.2.3 olduğu kabul edilirse, 
    ; arşiv /sources altına xyz-1.2.3.tar.gz olarak indirilecektir.

**Arşivi Dışarı Çıkarmama** Kaynak arşiv dosyaları indikten sonra
otomatik olarak $SRC(/tmp/work/src) altına açılmaktadır. Arşivi sadece
indirmek ve dışarı çıkarılması istenmezse, arşiv değerinin sonuna **!**
eklenir. Böylelikle arşiv sadece /sources altına indirilir. Dolayısıyla
arşiv için gerekli işlemlerin elle yapılması gerekecektir.

örnek:

    [kaynak]
    url = https://download.com/xyz_123.tar.gz!

### Doğrulama Bölümü

Kaynakların /sources altına indirilmesi veya kopyalanmasından sonraki
dosya doğrulama değerlerinin ifade edildiği bölümdür. Şu an sadece
**sha256** ve **sha512** doğrulama değerleri desteklenmektedir. Bölüm bu
değer adlarıyla yazılmalıdır. Kaynakların sıra numaraları dikkate
alınmak şartıyla sha256 ve sha512 ayrı bölümler halinde kullanılabilir.
Bazı kaynaklar için doğrulama pas geçilebilir.

örnek:

    [kaynak]
    1       = https://github.com/opencv/${isim}/archive/${surum}.tar.gz::$isim-$surum.tar.gz
    2       = https://github.com/opencv/opencv_contrib/archive/$surum.tar.gz::opencv_contrib-$surum.tar.gz
    dosya   = opencv-includedir.patch

    [sha256]
    1       = 68bc40cbf47fdb8ee73dfaf0d9c6494cd095cf6294d99de445ab64cf853d278a
    3       = a96e35c9592e655b21a62cfe04e864a10e21535ad900e5de67356b9e9f40ca10
    ; opencv-includedir.patch için

    [sha512]
    2       = 10ecc7480a82338463e797b5916e6a02e810c923523b574aff0be38fda19adea996067363a73120f1aab943598c6ed28ecf4a777e2d3015bdc83c953478081a2

### Derle Bölümü

Talimatın derleme ile ilgili işlemlerinin ifade edildiği bölümdür. Derle
bölümünde ifade edilen anahtarların değerleri **sırasıyla** shell
betiğine dönüştürülecektir. MPSD elde ettiği bu derleme işlevini
çalıştıracaktır. Derleme işlemi **$SRC** yani /tmp/work/src dizini
altında çalıştırılacaktır. Derleme işlemi otomatik olarak eğer kaynak
arşivi $isim-$surum şeklinde açıldıysa bu dizine girerek başlatılır.
Aynı şekilde derle bölümü de bazı özel anahtarlar içermektedir. Bu
anahtarlar yardımıyla belli şablonlara sahip derleme tipleri ifade
edilebilir.

**Betik Anahtarı** Bash kabuk(shell) betiklerini ifade etmek için
kullanılır.

örnek:

    [derle]
    betik = cd $SRC/xyz123
    ; arşiv xyz-123 şeklinde açılmadığı için arşiv dizinine girmek için

    betik = rm abc.gereksiz.txt
    ; derleme için gereksiz bir dosya silinebilir.

**Tip Anahtarı** Paket derlemelerinde bazı programlama dilleri ile
yazılan uygulamalar/kütüphaneler için derleme davranışları belli şablon
ile işlemektedir. Örneğin genelde GNU paketleri ./configure
--prefix=/usr && make şeklinde bir derleme şablonuna sahiptir.
Dolayısyla Milis Linux'ta derlemeler bu tip şablonlar için derleme
tipleri kullanılmaktadır. Tip değişkenlerini kabuk betiklerine
dönüşümleri derleme sisteminin kullandığı global değişkenleri kullanarak
yapar. Bu global değişkenler aşağıdaki şekilde tanımlıdır:

    CARCH     = x86_64 
    CHOST     = x86_64-pc-linux-gnu         
    CPPFLAGS  = -D_FORTIFY_SOURCE=2
    CFLAGS    = -march=x86-64 -mtune=generic -O2 -pipe -fno-plt
    CXXFLAGS  = -march=x86-64 -mtune=generic -O2 -pipe -fno-plt
    LDFLAGS   = -Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now
    MAKEJOBS  = -j$((`nproc`+1))
    CONF_OPT  = --prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib --bindir=/usr/bin --sbindir=/usr/bin --sysconfdir=/etc --mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share --localstatedir=/var --disable-static
    CMAKE_OPT = -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib 

Derleme tipleri ise:

    autogen = "./autogen.sh && ./configure ${CONF_OPT} ${EXT_OPT} && make ${MAKEJOBS}"
    gnu   = "./configure ${CONF_OPT} ${EXT_OPT} && make ${MAKEJOBS}"
    cmake = "mkdir -p build;cd build;cmake ${CMAKE_OPT} $extopt ../ && make ${MAKEJOBS}"
    py3   = "python3 setup.py build"
    py2   = "python2 setup.py build" 
    perl  = "perl Makefile.PL INSTALLDIRS=vendor && make"
    meson = "cd $SRC && milis-meson $isim-$surum build ${EXT_OPT}"
    ninja = "mkdir -p build && ninja -C build"
    waf   = "python3 waf configure --prefix=/usr ${EXT_OPT} && python3 waf build" 
    go    = "go build -o $isim" 

Ayrıca ekconf anahtarı derleme tipleri için ek ayarları tanımlar. Tip
anahtarından önce yazılmalıdır.

    ekconf = export EXT_OPT="eklenen ek ayarlar"

örnek:

    [derle]
    tip = gnu
    ; GNU derleme şablonuna göre derler. Karşılık gelen betiğe çevrilir.
    ;---------
    ekconf = --disable-abc
    tip    = gnu
    ; abc özelliği kapatılarak derleme yapılır
    ;---------
    tip    = py
    ; Python kütüphaneleri derleme gerekiyorsa kullanılabilir.

Derleme şablonuna uymayan derlemeler için betik anahtarından
yararlanılır.

**Yama Anahtarı** Yama dosyalarını pratik olarak yapmak için
kullanılır. İlgili yama dosyasının $SRC (/tmp/work/src) altında olması
gerekmektedir.

    yama = xyz.patch
    ; patch -Np1 -i $SRC/xyz.patch

**Dosya Anahtarı** Her ne kadar derleme tipleriyle derleme süreci
belli bir şablona çevrilmeye çalışılsa da bazı derlemeler ek ayarlar,
komutlara gerek duyabilir. Dolayısıyla çoklu komutların kullanımı
gerekecektir. Derle bölümüne betik anahtarı ile tekli satırlar halinde
eklenebilir fakat çoğaldıkça okunabilirlik azalır. Bunun için derle
bölümü için dosya anahtarı kullanılarak talimat dizini içindeki bir
kabuk betik dosyası derlemeye dahil edilebilir. Genel kullanım olarak
derle.sh adıyla bir betik hazırlanır. Bu betik talimat dizini içerisinde
yer almalıdır.

örnek:

    [derle]
    dosya = derle.sh

**Varsayılan Derleme Dizini Değiştirme** Derleme için kaynak arşivi
açıldığında $SRC altında $isim-$surum dizini açılıyorsa, varsayılan
olarak bu dizine girilerek derleme başlatılır. Eğer başka bir dizine
girilmesi istenirse [paket] bölümünde bu dizin belirtilebilir.

örnek:

    [paket]
    tanim   = Bilgisayarla görme ve makine öğrenimi yazılım kütüphanesi
    paketci = milisarge     
    grup    = kütüphane
    url     = https://opencv.org
    arsiv   = Opencv-$surum

### Pakur Bölümü

Talimatın derlendikten sonra paketinin hazırlanması ile ilgili
işlemlerinin ifade edildiği bölümdür. Pakete kurma işleminin
kısaltmasıdır. Aslında bu işlem derlenen veya hazırlanan paket
içeriğinin sisteme kurulması için gerekli dizin düzenini ifade eder.
Aynı şekilde pakur bölümünde de ifade edilen anahtarların değerleri
**sırasıyla** shell betiğine dönüştürülecektir. MPSD elde ettiği bu
pakur işlevini çalıştıracaktır. Pakur işlemi **$SRC** yani
/tmp/work/src dizini altında çalıştırılacaktır. Pakur işlemi otomatik
olarak eğer kaynak arşivi $isim-$surum şeklinde açıldıysa bu dizine
girerek başlatılır. Aynı şekilde pakur bölümü de bazı özel anahtarlar
içermektedir. Bu anahtarlar yardımıyla belli şablonlara sahip pakur
tipleri ifade edilebilir. Fakat burada yapılacak işlemlerin **$PKG**
(/tmp/work/pkg) dizini için yazılması gerekmektedir. Çünkü MPSD pakur
aşamasından sonra bu dizini kullanarak paket arşiv dosyası üretecektir.

**Betik Anahtarı** Bash kabuk(shell) betiklerini ifade etmek için
kullanılır.

örnek:

    [pakur]
    betik = install -Dm755 runner $PKG/usr/bin/runner
    ; derlenmiş runner ikilisini $PKG/usr/bin/ altına çalıştırabilir kopyalayacaktır.

    betik = rm abc.gereksiz.txt
    ; pakur için gereksiz bir dosya silinebilir.

**Tip Anahtarı** Paket derlemelerinde bazı programlama dilleri ile
yazılan uygulamalar/kütüphaneler için pakur davranışları belli şablon
ile işlemektedir. Örneğin genelde GNU paketleri
make DESTDIR=$PKG install şeklinde bir pakur şablonuna sahiptir.
Dolayısyla Milis Linux'ta pakete kurma işlemlerinde pakur tipleri
kullanılmaktadır. Tip değişkenlerini kabuk betiklerine dönüşümleri
derleme sisteminin kullandığı global değişkenleri kullanarak yapar. Bu
global değişkenler için derle bölümüne bakılabilir. Pakur tipleri
aslında derleme tiplerinin devamı niteliğindedir:

    gnu   = "make DESTDIR=$PKG install $EXT_OPT"
    cmake = "cd build;make DESTDIR=$PKG install"
    py3   = "python3 setup.py install --root=${PKG} --optimize=1 --skip-build $EXT_OPT"
    py2   = "python2 setup.py install --root=${PKG} --optimize=1 --skip-build $EXT_OPT"
    ninja = "DESTDIR=$PKG ninja -C build install"  
    meson = "cd $SRC && DESTDIR=$PKG ninja -C build install"
    waf   = "python3 waf install --destdir=$PKG"
    bin   = "install -Dm755 $isim -t $PKG/usr/bin/"

Ayrıca ekconf anahtarı pakur tipleri için de ek ayarları tanımlar. Tip
anahtarından önce yazılmalıdır.

    ekconf = export EXT_OPT="eklenen ek ayarlar"

örnek:

    [pakur]
    tip = gnu
    ; GNU pakur şablonuna göre pakete kurar.
    ;---------
    tip    = py
    ; Python kütüphaneleri için kullanılır.

pakur şablonuna uymayan pakur işlemleri için betik anahtarından
yararlanılır.

**Dosya Anahtarı** Her ne kadar pakur tipleriyle pakur süreci belli
bir şablona çevrilmeye çalışılsa da bazı pakete kurma işlemleri ek
ayarlar, komutlara gerek duyabilir. Dolayısıyla çoklu komutların
kullanımı gerekecektir. Bunun için pakur bölümü için dosya anahtarı
kullanılarak talimat dizini içindeki bir kabuk betik dosyası pakur
işlevine dahil edilebilir. Genel kullanım olarak pakur.sh adıyla bir
betik hazırlanır. Bu betik talimat dizini içerisinde yer almalıdır.

örnek:

    [pakur]
    dosya = pakur.sh

**Strip Anahtarı** Pakete kurma işleminden sonra paket hazırlanırken
varsayılan olarak ikili dosya ve kütüphanelere strip işlemi uygulanır.
Strip işlemi ilgili dosyanın sembol tablosunu silerek dosyanın hacmini
azaltır. Fakat bazı paketler için strip işlemi yapılmamalıdır. Bunun
için strip anahtarı kullanılır. 0 ,yok, no değerlerinden biri
kullanılabilir.

    [pakur]
    tip   = cmake 
    strip = 0

Özel Betikler
-------------

Talimat dizini içerisinde bazı özel betikler yer alabilmektedir. Bu
betikler çalıştırılacakları duruma göre sabit adlarla kayıt edilirler.
MPSD tarafından paket üretilirken otomatik olarak pakete dahil
edilirler. MPS ise bunların çalıştırılmasından sorumludur. Bunlar:

kurkos.sh
:   Paket kurulduktan sonra çalışacak betik.

koskur.sh
:   Paket kurulmadan önce çalışacak betik.

silkos.sh
:   Paket silindikten sonra çalışacak betik.

kossil.sh
:   Paket silinmeden önce çalışacak betik.

Paket üretildikten sonra bağımlılık takibinde kullanılmak üzere iki kütüphane liste dosyası üretilir.

libgerekler
:   Paketin hangi kütüphanelere ihtiyacı olduğunu belirtir.

pktlibler
:   Paketin sisteme sunduğu kütüphaneleri belirtir.


Paketleme-2
===========

Milis Linux'ta paketler talimat dizininde belirtilen verilere göre derlenir ve paketlenir. 
Bu başlıkta sıfırdan bir paketin nasıl oluşturulduğu ayrıntılı örnek paket ile açıklanmaktadır.
Örnek paket olarak 'htop' adlı işlem gözlem uygulamasının paketlenmesi anlatılmaktadır.


Talimat dizininin oluşturulması
-------------------------------

Talimat dosyası hazırlanmadan önce talimat dosyası ve gerekli dosyaların yer alacağı talimat dizini oluşturulmalıdır.
Talimat dizininin adının biçimi, paket_adı#sürüm_numarası-devir_numarası şeklindedir.
Örnek 'htop' paketi için 3.0.5 sürümü ve bu paketin ilk derlenmesi olduğu için de devir numarası olarak 1 kullanılacaktır.
Dolayısıyla talimat dizin adı 'htop#3.0.5-1' olacaktır. 
Sürümde herhangi bir değişiklik yok ama yama vs işlemler yapılağı zaman devir numarası artıtılarak dizin adı güncellenmektedir.
Hazırlanacak talimat dosyası bu dizin altında oluşturulacaktır.


Talimatın hazırlanması
-----------------------

Bir paketin talimatının hazırlanması için aşağıdaki talimat kısımları altında gerekli bilgilerin sağlanması gerekmektedir. 


### Paket

Paket için temel bilgiler aşağıdaki biçemde hazırlanır:

    [paket]
    tanim   = Gerçek zamanlı sistem işlem izleyicisi
    paketci = paketci_rumuz
    grup    = sistem
    url     = https://github.com/htop-dev/htop

### Gerek

Sonraki aşama olarak paketin derlenmesi ve çalışması için gereklerin yazılması gerekmektedir.
Derleme ve çalışma gereklerinin tespiti için aşağıdaki yöntemlerden yararlanılır:
	
	- Uygulamanın sitesi, kaynak kod deposu ve derleme tipi incelenerek ihtiyaç duyulan gerekler hakkında bilgi toplanabilir.
	- Farklı dağıtımların hangi paketleri kullandığına bakılabilir.
	- Derleme yapılarak derleme çıktısına göre gerekler tespit edilebilir.

Fakat her yöntemde de toplanan kütüphane, uygulamaların Milis Linux paket karşılıkları bulunmalı ve onlar yazılmalıdır.
Talimatnamede yer almayan paketler için yeni talimat hazırlanarak aynı işlemler yapılmalıdır.
Örnek 'htop' uygulaması için sitesinden elde ettiğimiz bilgilere göre, 
GNU tipinde oto ayarlı (autoconf) derleme tipi kullanmaktadır.
Dolayısıyla derleme gereklerinden biri 'automake' olacaktır.
Bu uygulama ayrıca konsol arayüz kütüphanesi olarak ncurses kullanmaktadır.
İkinci gerek te 'ncurses' paketi olacaktır.
Ayrıca netlink soketlerini de kullandığı için son gereğimiz 'libnl' olacaktır.
Bulunan üç gereklerden herhangi biri eğer temel sistem gereği yani 1.seviye talimat dizini altında yer alıyorsa yazılmayabilir.
Çünkü bu gerek her durumda sistemde kurulu gelmektedir.
Fakat yazılmasında herhangi bir sakınca yoktur.
Bu uygulama derlemeli bir dil ile geliştirildiği için çalışma gerek tespitini derleme sonucu üretilen libgerekler dosyasından yapacaktır.
Dolayısıyla çalışma gereği yazılmayacaktır.
Sonuç olarak talimatın gerek kısmı aşağıdaki gibi olacaktır.


    [gerek]
    derleme = automake ncurses libnl
    calisma = 

### Kaynak

Paketleme için gerekli diğer bilgi de kaynak kod adresleri ve yama dosyalarıdır.
Bu bilgiler kaynak kısmı altına uygun biçimde yazılmalıdır.
Htop için bu değer aşağıdaki gibi olacaktır.

    [kaynak]
    gz	= $url/archive/$surum

### Hash

Kaynaklar kısmındaki dosyaların doğrulama bilgileri de hash tipine göre talimat dosyasında yer almalıdır. 
Bunlar MPS tarafından derlemeden önce kontrol edilir.
Doğrulama yapılamaması durumunda derleme başlamayacaktır.
Hash bilgisini önden kaynak dosyasını indirerek veya resmi sitesinden elde edebilirsiniz.
Bu bilgi talimatın derleneceği başka bir sistem için kaynak güvencesi vermesi bakımından önemlidir.
Hash bilgilerin hangi dosyaya ait olduğunu belirtmek için de dosyanın kaynak kısmı altındaki sırası kullanılır.

    [sha256]
    1       = 4c2629bd50895bd24082ba2f81f8c972348aa2298cc6edc6a21a7fa18b73990c

### Derle

Bu kısımda paketin hangi derleme tipiyle derlenildiği veya derlenmesi için gerekli betikler belirtilecektir.
Örnek paket Htop uygulaması autoconf ile GNU tipinde derlemeye sahip olduğu için 
autoconf işlemi için `betik   = autoreconf -fi` ifadesi kullanılacaktır.
Sonrasında ek ayarlar var ise onlar belirtilmelidir.
Bu paket için `ekconf  = --enable-cgroup --enable-delayacct --enable-openvz --enable-unicode --enable-vserver`
ifadesi kullanılacaktır. 
Ek ayarların tespiti için gerekler kısmındaki yöntemlerden yararlanılabilir.
Sonrasında `tip=gnu` ifadesiyle derleme tipi ifade edilecektir.
Genellikle arşiv dosyaları otomatik olarak $SRC dizini altına
açılacaktır. MPS otomatik olarak $isim-$surum dizini varsa içine
gireceği için herhangi bir kaynak dizine girme ifadesine gerek yoktur.
Arşivlerin dışarı çıkardığı dizin adlarının farklı olduğu durumlarda
`betik = cd arsiv_dizin` ifadesi kullanılmalıdır.
Sonuç olarak örnek paketin derle kısmı aşağıdaki gibi olacaktır.

    [derle]
	betik   = autoreconf -fi
	ekconf  = --enable-cgroup --enable-delayacct --enable-openvz --enable-unicode --enable-vserver
	tip 	= gnu

Eğer ilgili paketin hazırlanmasında derleme işlemi yoksa aşağıdaki şekilde ifade edilebilir. 

    [derle]
    betik   = echo "derleme yok"

### Pakur

Bu kısımda derleme sonucu elde edilen sisteme kurulacak paket içeriğinin geçici paket dizinine kurulum bilgisi belirtilir.
Dolayısıyla paket içeriği */tmp/work/pkg* altına kopyalanacaktır.
Bu örnekte GNU tipi derleme kullanıldığı için pakur için de aynı tip kullanılarak paket kurma işlemi sağlanabilir.

    [pakur]
    tip     = gnu

Bu örnek için derleme ve pakur tipi uygun olsa da bazı paketler için tip yeterli gelmeyebilir. 
Eğer yapılacak işlemler birkaç satır betiği aşmıyorsa, bunları betik anahtarları ile talimat içinde,
diğer durumlarda ise derle.sh ve pakur.sh dosyaları ile belirtilebilir.

Paket üretimi
--------------------------------

Oluşturulan talimat ile hedef paketin üretilmesi, ana sistem ve derleme ortamı kullanılmak üzere iki şekilde olmaktadır.
Ana sistemde yapılacak derlemeler, derleme gerekleri belli ve küçük paketler için ideal olmaktadır.
Paketin hızlı testi için bu yöntem kullanılabilir.
Derleme ve çalışma gerekleri karışık olan paketler için ana sistem üzerinde paket üretimi yanıltıcı olabilmektedir.
Sistemde mevcut olan bir kütüphane gözden kaçabilir ve derleme gereklerine eklenmeyebilir.
Ayrıca sisteme belki bir daha kullanılamayacak derleme gerekleri de kurulmuş olur.
Diğer bir açıdan ana sistemi derleme sistemi ile güncel tutmak isteyen deneyimli kullanıcılar için de ana sistemde derleme yapmak avantajlı olmaktadır.
Bu durum için kullanıcının belli bir paketleme deneyimine sahip olması gerekmektedir.
Diğer bir yöntem olan derleme ortamı kullanılarak yapılan paket üretimi en sağlıklı yöntemdir.
Bu yöntemde paket, izole bir chroot ortamında gerekleri tam tespit edilerek ana sistemden bağımsız derlenmektedir.
Ana sistemin belli dizinleri altına overlayfs dosya sistemi ile bağlanan dizinler paketlerin sıralı üretimini ve toplanmasını sağlamaktadır.
Milis Linux deposunda yer alan her paket derleme ortamında üretilerek derlenmektedir.
Böylelikle aynı derleme ortamı kullanan başka bir sistemde de aynı MPS paketi üretilmiş olacaktır.
Anlatılan her iki yöntem için de talimat dizini yerelden veya Git depoya konularak kullanılabilir.


Derleme dizini ile derleme
--------------------
Hazırlanan bir talimat dizini için en pratik derleme yöntemi mpsd komutu kullanılarak yapılan derlemedir.
Bu derlemede talimatın derleme gereklerinin sisteme kurulmuş olması gerekmektedir.
Örnek paket *htop* için *libnl* ve *automake* paketlerinin sisteme kurulmuş olması gerekmektedir.
Derleme gerekleri sisteme kurulduktan sonra,
```
mpsd ...../htop#3.0.5-1
```

komutu ile tekli paket derlemesi yapılabilir.
Bu komut hem ana sistem hem derleme ortam derlemesi için kullanılabilir.
Bu komut ile paket üretim süreci başlayacak ve paketleme çıktıları konsola yazılacaktır.
Bu çıktıların incelenerek derleme aşamasının doğru işlediği gözlemlenmelidir.
Paket üretimi sorunsuz bir şekilde bittikten sonra komutu verdiğiniz dizinde *htop#3.0.5-1-x86_64.mps.lz* paketi oluşacaktır.
Paket üretildikten sonra kuruluma geçmeden önce içerik kontrolü yapılmalıdır.
Üretilen paketin içeriği arşiv uygulamaları ile konsol veya arayüz uygulaması ile görülebilir.
Eğer derleme gereklerinden de derlenmesi gerekenler varsa önce onlar derlenip paketleri üretilmelidir.
Derleme gereklerine ait üretilen paketler kurulduktan sonra hedef paketin derlenmesine geçilebilir.


Git depodan derleme
---------------------------
Aşağıda anlatılan işlemlerin doğru anlaşılması için Git kullanım bilgisine sahip olunmalıdır.
Git depodan derleme, talimat dizinlerinin bir Git deposu altında toplanarak organize bir şekilde derlemesini sağlamaktadır.
Tekli derlemede talimat dizini yerel dizinde yer alırken Git depodan derlemede talimat dizinleri */usr/milis/talimatname* altında yer almaktadır.
Örnek *htop* uygulamamız için Git depo derlemesi için *notabug.org* git sunucusu, *aliveli* hesabı ve *talimatname* deposu kullanılacaksa,
*htop#3.0.5-1* adlı talimat dizini *https://notabug.org/aliveli/talimatname* deposu altında *sistem* dizini altına kopyalanmalıdır.
Depo altında ayrıca bir *sistem* dizin ioluşturmamızın amacı talimatların gruplanmasını sağlamaktır.
Talimat dizini için gerekli Git konuşlandırması yyapıldıktan sonra MPS için gerekli ayar, /usr/milis/mps/conf/mps.ini dosyasına belirtilmelidir.
Örnek için gerekli MPS ayarı:

    ...
    [talimat]
    3 =https://notabug.org/aliveli/talimatname::sistem
    ...

şeklinde olacaktır. 
Anahtar değerin 3 verilmesi genellikle test ve topluluk talimatlarının, talimatnamede 3.seviye dizini olarak toplanmasıdır.
Dolayıyla yukarıdaki ayara göre *https://notabug.org/aliveli/talimatname* deposu */sources* altına kopyalanarak(clone/pull)
*sistem* dizini altında yer alan talimat_dizinleri */usr/milis/talimatname/3* altına kopyalanacaktır. 
Yapılan ayarın işleme alınması için betikdepo güncellemesi yapılmalıdır.

```
mps gun -G
```

Bu işlemden sonra yeni eklenen talimatlara erişebilir.
Test etmek için *ara -t* kullanılabilir.
Bir sonraki adım olarak paketlerin oluşturulacağı dizine geçilerek, paket üretim işlemleri başlatılabilir.
Derleme dizini ile derleme yönteminden farklı olarak bu yöntemde mps komutu kullanılmaktadır.
(Aslında mps komutu da arkaplanda `mpsd /usr/milis/talimatname/3/talimat_dizini` işlemi yürütmektedir.)
Normal kullanıcı ile ana sistemde derlemenin yetkisiz(sudo'suz) yapılabilemesi için kullanıcının */sources* dizinine yazma yetkisi olmalıdır.
`sudo chmod chmod -R a+rw /sources` ile bu yetki verilebilir.

Direk hedef paketi derlemek için:

```
cd ~/paketleme
mps der -t htop
```

Sıralı derle-kur-paketle işlemleri için:

```
mps der htop
```


Derleme ortamı ile derleme (mpsdo)
--------------------------------

Paket üretimi bölümünde değinildiği gibi paketlerin sağlıklı bir şekilde derlenebilmesi için derleme ortamı kullanılmaktadır.
Milis Linux, derleme ortamı olarak overlayfs dosya sistemi ile oluşturduğu özel bir chroot ortamı kullanmaktadır.
Derleme ortamının ilk kullanımında resmi siteden bir kereye mahsus derleme ortam imajı indirilecektir.
Eğer derleme ortamı güncellenirse yeni derleme ortam imajı indirilir.
Derleme ortamına girmek için:

```
sudo mpsdo
```

komutu verilir ve bu adımdan sonra yapacağınız işlemler yalıtılmış derleme ortamında gerçekleşecektir.
Ortama her çıkıp girildiğinde mpsdo birkaç dizin hariç ortamı her zaman sıfırlayacaktır. 
Sıfırlanmayan dizinler:

	- /opt
	- /sources
	- /var/cache/mps/depo 
	
Sıfırlanmayan dizinlerin ana sistem bağlantı dizinleri:

	- /mnt/mpsdo23/rw/opt
	- /mnt/mpsdo23/rw/sources
	- /mnt/mpsdo23/rw/cache

Bu dizinlerin ana sisteme bağlanma amacı oluşturulmuş paket, arşiv ve diğer dosyaların muhafaza edilmesidir.
Ortama her girişte sıfırlama olacağı için MPS her girişte güncellenmelidir.
MPS sürekli klonlama yapmayıp sonraki girişlerde sadece eşleme işlemi ile ortamı güncelleyecektir.
Ortamda paket derlemek için konak bilgisayarın /mnt/mpsdo23/system/usr/milis/talimatname altındaki sayısal dizinler kullanılır. 

Paketlerin oluşturulacağı */opt* dizinine geçilerek, paket üretim işlemleri başlatılabilir.
Derleme dizini ile derleme yönteminden farklı olarak bu yöntemde mps komutu kullanılmaktadır.
(Aslında mps komutu da arkaplanda `mpsd /usr/milis/talimatname/3/talimat_dizini` işlemi yürütmektedir.)

Direk hedef paketi derlemek için:
```
cd /opt
mps der -t htop
```

Sıralı derle-kur-paketle işlemleri için:

```
mps der htop
```

Ortamdan çıkmak için:

```
exit
```


Bu adımdan sonra uygulama, */mnt/mpsdo23/rw/opt* altından ana sisteme aktarılıp kurulup test edilebilir.
Eğer çalışması için başka paketler de üretilmişse onlar da aynı şekilde kurulup hedef paket kurulup test edilmelidir.

```
mps kur htop#3.0.5-1-x86_64.mps.lz
```
