autoconf
./configure \
--prefix=/usr \
--libexecdir=/usr/lib \
--sysconfdir=/etc \
--localstatedir=/var/lib/openldap \
--sbindir=/usr/bin \
--enable-syslog \
--with-threads \
--with-tls \
--with-cyrus-sasl \
--enable-spasswd \
--enable-dynamic \
--enable-ipv6 \
--enable-modules \
--enable-crypt \
--enable-rewrite \
--enable-bdb \
--enable-hdb \
--enable-ldap \
--enable-meta \
--enable-monitor \
--enable-dnssrv \
--enable-null \
--enable-perl \
--enable-dynacl \
--enable-aci \
--enable-shared

make depend
make
