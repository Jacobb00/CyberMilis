### Varsayılan Masaüstü Ortamı ve Uygulamalar

Milis Linux ilk sürümlerinden itibaren masaüstü ortamı olarak kararlı, sade ve az kaynak tüketimine sahip ortamları tercih etmiştir.
Milis 1.0 ve 2.0 sürümlerinde bu tercih XFCE4'ten yana kullanılmış ve varsayılan masaüstü ortamı olarak yer almıştır.
Fakat 2.1 sürümünde artık Wayland grafik sunucusu kullanılmaya başlandığı için masaüstü ortamı da yeniden gözden geçirildi.
Bu noktada Wayland desteği olan ve talepleri karşılayan bir masaüstü ortamı araştırıldı.
Wayland yapısının Xorg dan farklı olması nedeniyle hazır bir masaüstü ortamı yerine Wayland destekli pencere yöneticileri taban alınarak
kendi masaüstü ortamının oluşturulmasına karar verilmiştir. Bunun için farklı pencere yöneticilerini destekleyecek masaüstü yapılandırması geliştirilmiştir. 
Ayrıca bu sayede son kullanıcı için daha iyi bir masaüstü ortamının araştırılıp geliştirilmesi sağlanacaktır. 

Aşağıda masaüstü ortamının içerdiği bileşenler ve varsayılan olarak kullanılan uygulamalar yer almaktadır. 
Bu uygulamalar 2.3 sürümünde kullanılan mevcut uygulamar olup kullanıcı kullanılabilirliği ve sağladığı işlevsellik dikkate alınarak değiştirilebilir.

- Pencere yöneticisi(Döşeme): [wayfire](https://github.com/WayfireWM/wayfire)
- Pencere yöneticisi(Yığın): [labwc](https://github.com/labwc/labwc)
- Panel : [waybar](https://github.com/Alexays/Waybar)
- Menü: [nwg-drawer](https://github.com/nwg-piotr/nwg-drawer)
- Giriş yöneticisi arayüzü:[milis-greeter](https://gitlab.com/milislinux/milis-greeter)
- Giriş yöneticisi arkaucu:[greetd](https://sr.ht/~kennylevinsen/greetd)
- Oturum yöneticisi: [seatd](https://git.sr.ht/~kennylevinsen/seatd)
- Bildirim sunucusu: [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- Ses sunucusu: [Pulseaudio destekli Pipewire](https://pipewire.org)
- Ses aygıt ve düzey ayarlayıcı: [pavucontrol](https://github.com/pulseaudio/pavucontrol)
- Ağ yönetim arayüzü: [connman-gtk](https://github.com/milisarge/connman-gtk)
- Yazıcı yönetim arayüzü: [system-config-printer](https://github.com/OpenPrinting/system-config-printer)
- İnternet tarayıcısı: [firefox](mozilla.org)
- Dosya yöneticisi: [thunar](https://docs.xfce.org/xfce/thunar/start)
- Metin düzenleyici: [geany](https://geany.org)
- PDF görüntüleyici: [atril](https://directory.fsf.org/wiki/Atril)
- Terminal uygulaması:[sakura](https://github.com/dabisu/sakura)
- Görev yöneticisi: [lxtask](https://wiki.lxde.org/en/LXTask),[htop](https://github.com/htop-dev/htop)
- Resim uygulaması: [mypaint](https://mypaint.app)
- Görüntü işleme uygulaması: [gimp](https://www.gimp.org)
- Medya oynatıcısı: [celluloid](https://celluloid-player.github.io)
- Tema ve simge seti: [milis-gtk-theme](https://github.com/sonakinci41/milis-gtk-theme),[milis-simge](https://github.com/sonakinci41/Milis-Simge)
- Resim gösterici: [resimlik](https://gitlab.com/milislinux/milis23/src/branch/master/bin/resimlik)
- Ekran boyutlandırma: [ayar merkezi](https://gitlab.com/milislinux/ayguci)
- Ekran parlaklık: [light](https://github.com/haikarainen/light)
- Ekran kitleme: [gtklock](https://github.com/jovanlanik/gtklock)
- Ekran kayıt edici: [wf-recorder](https://github.com/ammen99/wf-recorder)
- Ekran yakalayıcı:[grim](https://github.com/emersion/grim)
- Ekran alanı seçicisi:[slurp](https://github.com/emersion/slurp)
- Ekran alıntılama: [meg](https://gitlab.com/milislinux/milis23/src/branch/master/bin/meg)
- Ekran alıntı düzenleyici: [swappy](https://github.com/jtheoof/swappy)
- Pano dinleyici: [clipman](https://github.com/yory8/clipman)
- Pano uygulaması: [wf-clipboard](https://github.com/bugaevc/wl-clipboard)
- Takvim yöneticisi: [osmo](https://osmo-pim.sourceforge.net)
- Servis yöneticisi: [mservice](https://gitlab.com/milislinux/mservice)
- Paket yönetici arayüzü: [mpsui](https://gitlab.com/milislinux/mpsui)

#### Masaüstü Ortamının Ayarlanması

Masaüstü ortamının ayarları sistem canlı imaj ile ilk açıldığında yapılır.
Giriş yöneticisinde kullanıcı giriş yaptıktan sonra Milis'in masaüstü ayarları aktarılarak çalıştırılır.
Bu ayarların atanması [dinit](https://gitlab.com/milislinux/milis23/-/blob/main/bin/dinit) betiği tarafından *.config/masa.ini* ayar dosyası ile yapılır.
Bu dosya içinde yer alan ilgili ayar sekmeleri elle veya ayar merkezi yardımıyla düzenlenebilir.
Bu ayarlar imaj üretilirken */etc/skel* altında gelir ve kullanıcı *.config* dizini altına gerekli kontroller yapılarak kopyalanır.
Bu ayarların kontrolü her oturum açıldığında yapılmaktadır. 
Kullanıcı masaüstü ayarlarını varsayılan ayarlara döndürmek için ilgili ayar dizini silinerek oturum yeniden başlatılır.

#### Tercih Edilen Pencere Yöneticisini Ayarlama

Birden fazla pencere yöneticisi kullanılma durumunda tercih edilenin giriş yöneticisinde ilk sırada gelmesi için;
*.config/masa.ini* dosyasında *[desktop]* bölümü altındaki *masa1* anahtarı istenen değere ayarlanır.
```
# 1.yol dosyadan
[desktop]
masa1 = labwc
# 2.yol komutla
dinit yaz desktop masa1 labwc
``` 
Atanan değerin /usr/share/wayland-sessions altında bulunan oturum isimlerinde biri olması gerekmektedir.

#### Masaüstü Çalışma Ortamı Yönetimi

Masaüstü ortamında farklı uygulamalar ile çalışılmaktadır. 
Bu uygulamalar normal şartlarda masaüstü yeniden başlatıldığında sonlanmaktadır.
Çalışma ortamının masaüstü açıldığında yeniden yüklenmesini ve oturum kaydı için ilgili uygulamaları aşağıda önerilen şekilde kullanabilir.
Ayrıca Bu sürecin otomatize edilmesi için de çalışma yapılmaktadır.

- **Web Tarayıcısı**: 
Firefox ve Chromium uygulamaları kendi oturumlarını yönetmektedir.
Masaüstü açılınca oturumu yeniden yükle ile tekrar oturumunuzu yükleyebilirsiniz.

- **Metin Düzenleyicisi**:
Geany uygulaması ile açılan dosyalar bir sonraki masaüstü açılışında tekrardan yüklenir.
Her açtığınız dosya sekmesi de otomatik kayıt edilir.

- **Uçbirim**:
Varsayılan olarak Sakura uçbirim uygulaması kullanılmaktadır.
Şu an için Sakura uygulamasının oturum yönetim özelliği yoktur.
Sakura ile ancak Tmux uygulamasının desteği kullanılarak terminal ortamları yönetilebilir.
Bir diğer tercih ise oturum ve profil yönetimine sahip olan Roxterm uygulamasının kullanılmasıdır.
Tmux ile de kullanılarak esnek bir uçbirim yönetimi sağlanabilir.
Örnek bir tmux oturum başlatma:
```
tmux a -t oturum1
```

- **Dosya Yöneticisi**:
Varsayılan olarak kullanılan Thunar dosya yöneticisi açılan sekmeleri güncel olarak kayıt etmekte ve bir sonraki açılışında yüklemektedir.
Bunun için düzenle->tercihler->davranış bölümünde yer alan "Başlangıçta sekmeleri geri yükle" özelliği seçili olmalıdır.
Thunar bu sekmeleri ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml dosyası üzerinden yönetmektedir.
Açılması istenen sekmelerin uçbirimden komut ile kaydı:

```
xfconf-query -c thunar -p /last-tabs-left -n -a -t string -s "file:///opt/work" -t string -s "file:///opt/work2"
```

#### Masaüstü Tema Arızası Giderme

Normal kullanıcının tema ayarlarında bir bozukluk meydana geldiğinde `tamir_tema.py` , eğer yetkili modda çalıştırılan bir uygulama sonucu meydana gelirse `tamir_tema.sh` komutu ile gerekli düzeltme yapılabilir.
