<!-- title: Sistem Testleri -->

### Sistem Test Maddeleri

Milis Linux çalışan ve kurulu sistem testi aşağıdaki maddelere göre yapılmaktadır. 

1. **Donanım**
    * Ağ
        - Kablolu bağlantı sağlayabilme
            - Dinamik ve statik IP adres temini
        - Kablosuz bağlantı sağlayabilme
            - Dinamik ve statik IP adres temini
        - Sürücü desteklememe
            - Hangi sürücü ve kernel modülü gerekli (istenilen bilgi)
        - Minimal sürümde konsoldan bağlantı sorunu
            - Arayüz
            - Connman komut arayüzü	          

    * Ekran
        - Grafik arayüzü açılması/yırtılma vs (fiziksel, sanal makine) video sürücüsü bilgisi


    * Ses
        - Farklı ses formatlarının çalınabilmesi
            - mpg123 ile mp3
        - Tarayıcı üzerinden ses alabilme
        - Medya oynatıcısı ile ses alabilme
        - Farklı ses giriş/çıkışların tanıması


    * Fare    
        - Kablolu/kablosuz fare durumu ve genel çalışması
        - Özel işlevlerin çalışması


    * Bluetooth
        - Bir bluettoh aygıtına bağlanabilme
        - Servis başlatabilme
        - Kulaklık ile ses alabilme


    * Yazıcı
        - Yazıcı tanıma ve erişebilme
        - Test çıktısı alma
        - Sorunlu yazıcı modeli, destek durumu


    * Klavye
        - Klavyenin yerleşiminin tanınması ve yerel ayarla başlaması
        - Numlock aktif olması

	* Kamera
		- Dahili kamera
		- USB kamera
		
    * Gösterge
        - RAM ve CPU tüketim değerleri
        - Sıcaklık sensör çıktısı

2. **Dosya Sistemi**

    - Yanlış isimlendirilen dosya/dizin
    - Boş dosya/dizin
    - İzinleri arızalı olan dosya/dizin
    - Yeniden başlatımda sıfırlanması gerekenler /tmp gibi dizinler
    - Desteklenmesi gereken dosya sistemleri
    - Bağlamasında(mount) sorunlu olan aygıtlar(usb, harici disk, telefon)

3. **Servisler**
 
    - Sistem açılırken hata veren veya çalışmayan servisler

4. **Uygulamalar**

    - Menuden açılmayan uygulama, konsoldan çalıştırılınca alınan hatalar
    - Sorunlu uygulama, konsoldan çalıştırılınca alınan hatalar
    - Öntanımlı uygulamaların atanması, çalışması
    - Uygulamaların bildirim iletimi (notify-send test)
    - Uygulamaların kaynak tüketimi

5. **Kapanış modları**
    - Ekran kitleme, uyku, askıya alma, yebaşlat, kapatma modların çalışması
    
6. **Yerelleştirme**
	- Sistem dili
    - Sistem saati
    - Çeviri eksiklikleri
    
