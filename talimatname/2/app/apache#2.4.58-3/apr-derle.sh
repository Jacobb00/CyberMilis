patch -Np1 -i ../apr-1.7.0-autoconf-2.70.patch
patch -Np1 -i ../fix_apr-config.patch
patch -Np1 -i ../ship_find_apr.m4.patch
patch -Np1 -i ../fix-apr.pc.patch
patch -Np1 -i ../omit_extra_libs.patch
patch -Np1 -i ../dont_override_external_buildflags
./buildconf

./configure --prefix=/usr --includedir=/usr/include/apr-1 \
--with-installbuilddir=/usr/share/apr-1/build \
--enable-nonportable-atomics \
--with-devrandom=/dev/urandom --disable-static

make $MAKEJOBS
make install DESTDIR=$PKG
