patch -Np1 -i ../disable_failing_test.patch
patch -Np1 -i ../buildconf_config.guess_sub_location.patch

./buildconf --with-apr=`apr-1-config --srcdir`
./configure --prefix=/usr --with-apr=/usr --with-ldap --with-crypto --with-gdbm=/usr --with-sqlite3=/usr --with-nss=/usr --with-odbc=/usr --with-berkeley-db=/usr --with-pgsql=/usr --with-mysql=/usr --with-oracle=/usr --with-openssl=/usr

make $MAKEJOBS
make install DESTDIR=$PKG
