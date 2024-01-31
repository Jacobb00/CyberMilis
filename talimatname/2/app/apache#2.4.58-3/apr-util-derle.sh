cd $SRC/apr-util-1.6.3
patch -Np1 -i ../disable_failing_test.patch

cp $PKG/usr/bin/apr-1-config $PKG/usr/bin/apr-1-config-ydk

sed -i 's#installbuilddir="/usr/share/apr-1/build"#installbuilddir="/tmp/work/pkg/usr/share/apr-1/build"#g' $PKG/usr/bin/apr-1-config
sed -i 's#includedir="/usr/include/apr-1"#includedir="/tmp/work/pkg/usr/include/apr-1"#g' $PKG/usr/bin/apr-1-config
sed -i 's#libdir="#libdir="/tmp/work/pkg/#g' $PKG/usr/bin/apr-1-config

./configure --prefix=/usr --with-apr=$PKG/usr/bin/apr-1-config --with-ldap --with-crypto --with-gdbm=/usr --with-sqlite3=/usr --with-nss=/usr --with-odbc=/usr --with-pgsql=/usr --with-mysql=/usr --with-oracle=/usr --with-openssl=/usr

sed -i 's#apr_builddir=/usr/share/apr-1/build#apr_builddir=/tmp/work/pkg/usr/share/apr-1/build#g' build/rules.mk
sed -i 's#apr_builders=/usr/share/apr-1/build#apr_builders=/tmp/work/pkg/usr/share/apr-1/build#g' build/rules.mk
sed -i 's#top_builddir=/usr/share/apr-1/build#top_builddir=/tmp/work/pkg/usr/share/apr-1/build#g' build/rules.mk


make $MAKEJOBS
make install DESTDIR=$PKG

rm -f $PKG/usr/lib/*.la
