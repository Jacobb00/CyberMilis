export M4=m4
patch -p0 -i ${SRC}/php-apache.patch
patch -p0 -i ${SRC}/php-fpm.patch
patch -p0 -i ${SRC}/php.ini.patch
autoconf

rm tests/output/stream_isatty_*.phpt

cd $SRC

CPPFLAGS+=' -DU_USING_ICU_NAMESPACE=1'

_phpconfig="--srcdir=../${isim}-${surum} \
	--config-cache \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--sysconfdir=/etc/php \
	--localstatedir=/var \
	--with-layout=GNU \
	--with-config-file-path=/etc/php \
	--with-config-file-scan-dir=/etc/php/conf.d \
	--disable-rpath \
	--mandir=/usr/share/man \
	"

_phpextensions="\
--enable-bcmath=shared \
		--enable-calendar=shared \
		--enable-dba=shared \
		--enable-exif=shared \
		--enable-ftp=shared \
		--enable-gd=shared \
		--enable-intl=shared \
		--enable-mbstring \
		--enable-pcntl \
		--enable-shmop=shared \
		--enable-soap=shared \
		--enable-sockets=shared \
		--enable-sysvmsg=shared \
		--enable-sysvsem=shared \
		--enable-sysvshm=shared \
		--with-bz2=shared \
		--with-curl=shared \
		--with-enchant=shared \
		--with-external-gd \
		--with-external-pcre \
		--with-ffi=shared \
		--with-gdbm \
		--with-gettext=shared \
		--with-gmp=shared \
		--with-iconv=shared \
		--with-kerberos \
		--with-ldap=shared \
		--with-ldap-sasl \
		--with-mhash \
		--with-mysql-sock=/run/mysqld/mysqld.sock \
		--with-mysqli=shared \
		--with-openssl \
		--with-password-argon2 \
		--with-pdo-mysql=shared \
		--with-pdo-odbc=shared,unixODBC,/usr \
		--with-pdo-pgsql=shared \
		--with-pdo-sqlite=shared \
		--with-pgsql=shared \
		--with-readline \
		--with-snmp=shared \
		--with-sodium=shared \
		--with-sqlite3=shared \
		--with-unixODBC=shared \
		--with-xsl=shared \
		--with-zip=shared \
		--with-zlib \
	"

EXTENSION_DIR=/usr/lib/php/modules
export EXTENSION_DIR

mkdir ${SRC}/build
cd ${SRC}/build
ln -s ../${isim}-${surum}/configure
[ ! -f /usr/lib/pkgconfig/enchant.pc ] && \
ln -sfv enchant-2.pc /usr/lib/pkgconfig/enchant.pc
./configure ${_phpconfig} \
	--enable-cgi \
	--enable-fpm \
	--with-fpm-acl \
	--with-fpm-user=www-data \
	--with-fpm-group=www-data \
	--enable-embed=shared \
	${_phpextensions}
LC_ALL=C make

cp -a ${SRC}/build ${SRC}/build-apache
cd ${SRC}/build-apache
./configure ${_phpconfig} \
	--with-apxs2 \
	${_phpextensions}
LC_ALL=C make
