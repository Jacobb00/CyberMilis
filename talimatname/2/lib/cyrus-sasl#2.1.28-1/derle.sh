export CFLAGS="$CFLAGS -fPIC"

patch -Np1 < ../sasl-653.patch
patch -Np1 < ../54f69880fa92bb0d0cf4d55bab0914822a873d8d.patch
patch -Np1 < ../725df6cdadc11cf1bbbfa3a57982ec19624c6fbe.patch
autoreconf -fiv

./configure --prefix=/usr \
--disable-krb4 \
--disable-macos-framework \
--disable-otp \
--disable-passdss \
--disable-srp \
--disable-srp-setpass \
--disable-static \
--enable-alwaystrue \
--enable-anon \
--enable-auth-sasldb \
--enable-checkapop \
--enable-cram \
--enable-digest \
--enable-gssapi \
--enable-login \
--enable-ntlm \
--enable-plain \
--enable-shared \
--infodir=/usr/share/info \
--mandir=/usr/share/man \
--sbin=/usr/bin \
--sysconfdir=/etc \
--with-dblib=gdbm \
--with-devrandom=/dev/urandom \
--with-configdir=/etc/sasl2:/etc/sasl:/usr/lib/sasl2 \
--with-pam \
--with-saslauthd=/var/run/saslauthd \

sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make
