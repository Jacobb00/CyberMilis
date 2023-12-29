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
- Giriş yöneticisi arayüzü:[milis-greeter](https://gitlab.com/milisarge/milis-greeter)
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
- PDF görüntüleyici: [mpdf](https://gitlab.com/milislinux/milis23/src/branch/master/bin/mpdf)
- Terminal uygulaması:[sakura](https://github.com/dabisu/sakura)
- Görev yöneticisi: [lxtask](https://wiki.lxde.org/en/LXTask),[htop](https://github.com/htop-dev/htop)
- Resim uygulaması: [mypaint](https://mypaint.app)
- Görüntü işleme uygulaması: [gimp](https://www.gimp.org)
- Medya oynatıcısı: [celluloid](https://celluloid-player.github.io)
- Tema ve simge seti: [milis-gtk-theme](https://github.com/sonakinci41/milis-gtk-theme),[milis-simge](https://github.com/sonakinci41/Milis-Simge)
- Resim gösterici: [resimlik](https://gitlab.com/milislinux/milis23/src/branch/master/bin/resimlik)
- Ekran boyutlandırma: [ayar merkezi](https://gitlab.com/milislinux/ayguciui)
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
- Paket yönetici arayüzü: [mservice](https://gitlab.com/milislinux/mpsui)

#### Masaüstü Ortamının Ayarlanması

Masaüstü ortamının ayarları sistem canlı imaj ile ilk açıldığında yapılır.
Giriş yöneticisinde kullanıcı giriş yaptıktan sonra Milis'in masaüstü ayarları aktarılarak çalıştırılır.
Bu ayarların atanması [dinit](https://gitlab.com/milislinux/milis23/-/blob/main/bin/dinit) betiği tarafından *.config/masa.ini* ayar dosyası ile yapılır.
Bu dosya içinde yer alan ilgili ayar sekmeleri elle veya ayar merkezi yardımıyla düzenlenebilir.
Bu ayarlar imaj üretilirken */etc/skel* altında gelir ve kullanıcı *.config* dizini altına gerekli kontroller yapılarak kopyalanır.
Bu ayarların kontrolü her oturum açıldığında yapılmaktadır. 
Kullanıcı masaüstü ayarlarını varsayılan ayarlara döndürmek için ilgili ayar dizini silinerek oturum yeniden başlatılır.
