make DESTDIR=${PKG} install

chmod 755 ${PKG}/usr/lib/pppd/${surum}/*.so

mkdir -p $PKG/etc/ppp/{ip-up.d,ip-down.d,ipv6-up.d}

install -m 644 ${SRC}/$isim-options $PKG/etc/ppp/options
install -m 755 ${SRC}/$isim-ip-up $PKG/etc/ppp/ip-up
install -m 755 ${SRC}/$isim-ip-down $PKG/etc/ppp/ip-down
install -m 755 ${SRC}/$isim-ipv6-up $PKG/etc/ppp/ipv6-up
install -m 755 ${SRC}/$isim-ipv6-down $PKG/etc/ppp/ipv6-down

install -m 755 ${SRC}/$isim-ip-up.d.dns.sh $PKG/etc/ppp/ip-up.d/00-dns.sh
install -m 755 ${SRC}/$isim-ip-down.d.dns.sh $PKG/etc/ppp/ip-down.d/00-dns.sh
install -m 755 ${SRC}/$isim-ipv6-up.d.iface-config.sh $PKG/etc/ppp/ipv6-up.d/00-iface-config.sh

install -D -m755 scripts/pon  "${PKG}/usr/bin/pon"
install -D -m755 scripts/poff "${PKG}/usr/bin/poff"
install -D -m755 scripts/plog "${PKG}/usr/bin/plog"
install -D -m600 etc.ppp/pap-secrets  "${PKG}/etc/ppp/pap-secrets"
install -D -m600 etc.ppp/chap-secrets "${PKG}/etc/ppp/chap-secrets"
