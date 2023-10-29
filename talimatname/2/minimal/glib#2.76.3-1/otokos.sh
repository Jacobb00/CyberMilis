# glib için schema içeren paketlerin otomatik şema derleme işlemidir.
kur=1
sil=1

kontrol="ls usr/share/glib-2.0/schemas/*.gschema.xml"
betik="/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas"
