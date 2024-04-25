cd ${SRC}/build
make -j1 INSTALL_ROOT=${PKG} PHP_SAPI=embed install-{modules,cli,cgi,build,headers,programs,pharcmd,fpm,sapi}
install -D -m644 ${SRC}/${isim}-${surum}/php.ini-production ${PKG}/etc/php/php.ini
install -d -m755 ${PKG}/etc/php/conf.d/

install -D -m755 ${SRC}/build-apache/libs/libphp8.so ${PKG}/usr/lib/httpd/modules/libphp8.so
install -D -m644 ${SRC}/apache.conf ${PKG}/etc/httpd/conf/extra/php8_module.conf

install -D -m755 ${SRC}/build/modules/enchant.so ${PKG}/usr/lib/php/modules/enchant.so

install -D -m755 ${SRC}/build/modules/sodium.so ${PKG}/usr/lib/php/modules/sodium.so

install -D -m755 ${SRC}/build/modules/odbc.so ${PKG}/usr/lib/php/modules/odbc.so
install -D -m755 ${SRC}/build/modules/pdo_odbc.so ${PKG}/usr/lib/php/modules/pdo_odbc.so

install -D -m755 ${SRC}/build/modules/pgsql.so ${PKG}/usr/lib/php/modules/pgsql.so
install -D -m755 ${SRC}/build/modules/pdo_pgsql.so ${PKG}/usr/lib/php/modules/pdo_pgsql.so

install -D -m755 ${SRC}/build/modules/snmp.so ${PKG}/usr/lib/php/modules/snmp.so

install -D -m755 ${SRC}/build/modules/sqlite3.so ${PKG}/usr/lib/php/modules/sqlite3.so
install -D -m755 ${SRC}/build/modules/pdo_sqlite.so ${PKG}/usr/lib/php/modules/pdo_sqlite.so
	
	
install -D -m755 ${SRC}/build/modules/xsl.so ${PKG}/usr/lib/php/modules/xsl.so


install -D -m755 ${SRC}/build/modules/tidy.so ${PKG}/usr/lib/php/modules/tidy.so

mkdir -p $PKG/var/www/
cp -f $SRC/info.php $PKG/var/www/

sed -i 's/^listen =.*/listen=127.0.0.1:9000/g' $PKG/etc/php/php-fpm.d/www.conf
