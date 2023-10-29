### Eduroam Bağlantısı

Milis Linux öntanımlı olarak Connman ağ bağlantı uygulaması kullanmaktadır.
Üniversitelerin ortak kablosuz ağ noktası olan Eduroam bağlantısı için,
*/var/lib/connman/eduroam.config* dosyası oluşturularak aşağıdaki içerik ile kayıt edilmelidir.
Sonrasında Connman otomatik şekilde ağı algılayıp bağlanacaktır.

```
	[service_eduroam]
	Type=wifi
	Name=eduroam
	EAP=peap
	CACertFile=
	Phase2=MSCHAPV2
	Identity=universite_mail
	Passphrase=universite_mail_şifre
```
veya */usr/milis/ayarlar/connman/eduroam.config* dosyası */var/lib/connman*
altına kopyalanarak *mail_adres* ve *mail_şifre sahaları* güncellenerek te kullanılabilir.

```
	sudo cp -f /usr/milis/ayarlar/connman/eduroam.config /var/lib/connman && nano /var/lib/connman/eduroam.config
```
