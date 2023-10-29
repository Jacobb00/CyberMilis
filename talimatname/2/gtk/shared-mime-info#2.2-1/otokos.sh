# mime kayıtları için mime veritabanı güncelleme işlemidir.
kur=1
sil=1

kontrol="ls usr/share/mime/packages/*.xml"
betik="/usr/bin/env PKGSYSTEM_ENABLE_FSYNC=0 /usr/bin/update-mime-database /usr/share/mime"
