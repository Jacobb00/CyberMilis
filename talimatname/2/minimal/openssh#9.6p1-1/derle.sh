./configure \
--prefix=/usr \
--sbindir=/usr/bin \
--libexecdir=/usr/lib/ssh \
--sysconfdir=/etc/ssh \
--disable-strip \
--with-ssl-engine \
--with-pam \
--with-privsep-user=nobody \
--with-md5-passwords \
--with-pid-dir=/run \
--with-default-path='/usr/local/sbin:/usr/local/bin:/usr/bin' \
--without-zlib-version-check

make $MAKEJOBS
