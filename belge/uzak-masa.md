### Uzak Masaüstü Bağlantısı

Şu an için iki Milis Linux masaüstü sistemi arasında [wayvnc](https://github.com/any1/wayvnc) uygulaması üzerinden uzak masaüstü bağlantısı sağlanmaktadır.
Milis Linux 2.1 kullandığı Wlroots tabanlı pencere yöneticisinden dolayı her VNC uygulaması destekleyememektedir.
Bağlantı için **wayvnc** uygulaması kurulmalıdır. 

```
	# sunucu / bağlanılacak Milis Linux tarafı
	wayvnc adres port
	# istemci / bağlanacak Milis Linux tarafı
	wlvncc sunucu_adres port
```

Port erişimi için bağlanılacak makinanın port erişiminin açık olması gerekmektedir.
Ayrıca bağlantı şifresiz olarak direk açılmaktadır.
Güvenli bağlantı için SSH ile port yönelendirmesi yapılarak bağlantı kurulması tavsiye edilmektedir.
