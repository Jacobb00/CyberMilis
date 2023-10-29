sed -i "/LDFLAGS=/d" src/build-tools/krb5-config.in
sed -i "/KRB5ROOT=/s/\/local//" src/util/ac_check_krb5.m4

cd src
export CFLAGS+=" -fPIC -fno-strict-aliasing -fstack-protector-all"
export CPPFLAGS+=" -I/usr/include/et"
export M4=m4
./configure --prefix=/usr \
--sbindir=/usr/bin \
--sysconfdir=/etc \
--localstatedir=/var/lib \
--enable-shared \
--with-system-et \
--with-system-ss \
--disable-rpath \
--without-tcl \
--enable-dns-for-realm \
--with-ldap \
--with-keyutils \
--without-system-verto
LC_ALL=C make $MAKEJOBS
