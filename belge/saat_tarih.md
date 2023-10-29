### Tarih/Saat Ayarı

Milis Linux'ta tarih/saat ayarı yapmak için üç yol kullanılabilir:

1. Saat dilimi
2. Yerel saat
3. Ağ saat sunucusu


#### 1. Saat Dilimi
Küresel saat dilimleri kullanılarak yer alınan saat dilimi ayarı ile saatin ve tarihin ayarlanması sağlanabilir.
Bunun için, */etc/init/config.lua* içindeki *clock* bölümü içindeki *timezone* değeri ilgili dilime göre ayarlanırken
*utc* değeri ise *true* olmalıdır.

```
  clock = {
    timezone = "Turkey",
    utc = true,
  },
```

#### 2. Yerel Saat  
Saat ayarları elle *hwclock* veya *Ayguci* uygulaması kullanılarak yapılabilir.
Ayrıca *utc* ayarı *false* olmalıdır.
Bu ayar Windows ve Linux'un çift önyüklemeli(dual-boot) olarak kullanıldığı sistemler için de geçerlidir.

```
  clock = {
    timezone = "Turkey",
    utc = false,
  },
```

#### 3. Ağ Saat Sunucusu
Saat ayarı internet üzerinden saat sunucusu kullanılarak ta ayarlanabilir. 
Bunun için *chrony* paketi kurularak servisi aktif edilmelidir.

```
  mps kur chrony
  servis ekle chrony
  servis aktif chrony
``` 
