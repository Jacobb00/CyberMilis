### Masaüstü Paylaşımı

İnternet üzerinden toplantı ve eğitim oturumlarında kullanılmak üzere video konferans uygulamalarına ihtiyaç duyulmaktadır.
Video konferans uygulamalarında kullanılan bir özellik de masaüstü paylaşımı olmaktadır.
Milis Linux 2.1 sürümü grafik sunucusu olarak Wayland kullandığı için masaüstü paylaşımı X sunucuya göre farklı olmaktadır.
Milis Linux sisteminde iki yönteme başvurulmaktadır:

Birinci yönteme göre; masaüstü işlevlerine erişim için masaüstü portal API'si sunan [xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal) uygulamasından yararlanılmaktadır. 
Wayland için ise [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) uygulaması kullanmaktadır. 
Bu uygulama arkaplanda xdg-desktop-portal ı kullanmakta olup masaüstü açılışında başlatılmalıdır. 
Milis Linux'ta bu ayar öntanımlı gelmekte olup kullanıcı bu yöntemi kullanacaksa bu uygulamayı kurmalıdır.

```
	mps kur xdg-desktop-portal-wlr 
```

İkinci yönteme göre; masaüstü ekran kaydı sanal bir kamera aygıtına yönlendirilerek ilgili video konferans uygulamasından da
bu kamera seçilerek olmaktadır. Aşağıda bu işlem ayrıntılı olarak anlatılmıştır.

- Sanal kamera kernel modülünün derlenip kurulması.
(farklı kernel sürümleri için derleme/kurma önerilmektedir)
```
	mps der v4l2loopback --kur
```

- Kernel modulü tanıtılır ve yüklenir.
```
	modprobe v4l2loopback card_label='V4L2 Loopback' video_nr=9 exclusive_caps=1
```

- Ekran kayıt uygulaması kurulur. 
```
	mps kur wf-recorder
```

- Ekran kayıt uygulamasının çıktısı sanal kameraya yönlendirilerek başlatılır.
```
	wf-recorder --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file=/dev/video9
```

- İlgili video konferans uygulamasından sanal video aygıtı seçilerek paylaşım yapılır.

- Açılışta sanal video aygıtın otomatik yüklenmesi için
```
	servis yaz kmods v4l2loopback "card_label='V4L2 Loopback' video_nr=9 exclusive_caps=1"
```

Not-1: Yukarıdaki yöntemler Firefox Zoom ve Jitsi Web istemci sürümleri ile test edilmiştir.
