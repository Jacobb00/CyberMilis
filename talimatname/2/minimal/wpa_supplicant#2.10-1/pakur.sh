cd "$isim"
make LIBDIR=/usr/lib BINDIR=/usr/bin DESTDIR="$PKG" install
install -Dm755 eapol_test "$PKG/usr/bin/eapol_test"
install -d -m755 "$PKG/etc/wpa_supplicant"

install -d -m755 "$PKG/usr/share/dbus-1/system-services"
install -m644 dbus/fi.w1.wpa_supplicant1.service "$PKG/usr/share/dbus-1/system-services/"

install -Dm644 dbus/dbus-wpa_supplicant.conf "$PKG/etc/dbus-1/system.d/wpa_supplicant.conf"

install -d -m755 "$PKG/usr/share/man/man"{5,8}
install -m644 doc/docbook/*.5 "$PKG/usr/share/man/man5/"
install -m644 doc/docbook/*.8 "$PKG/usr/share/man/man8/"
rm -f "$PKG/usr/share/man/man8/wpa_"{priv,gui}.8
