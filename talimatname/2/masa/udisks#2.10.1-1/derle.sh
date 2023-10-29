export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"

cd $SRC/libbytesize-2.9
NO_CONFIGURE=1 ./autogen.sh
sed -i 's/==/=/g' docs/Makefile.in
./configure --prefix=/usr
make $MAKEJOBS && make DESTDIR=$PKG install


cd $SRC/volume_key-0.3.12
 autoreconf -fiv
find . -name ".pyc" -delete
export CFLAGS+=" $(python3-config --includes)"
./configure --prefix=/usr
 sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS && make DESTDIR=$PKG install

cd $SRC/libblockdev-3.0.2
export BYTESIZE_CFLAGS="-I$PKG/usr/include/bytesize"
export BYTESIZE_LIBS="-lbytesize"
export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
export CPPFLAGS="$CFLAGS"
aclocal && automake
sed -i 's#${CC} -c $GLIB_CFLAGS $NSS_CFLAGS $temp_file#${CC} -c $GLIB_CFLAGS $NSS_CFLAGS -I$PKG/usr/include $temp_file#g' configure
./configure ${CONF_OPT}
make $MAKEJOBS && make DESTDIR=$PKG install
rm -f $PKG/usr/lib/*.la


cd $SRC/libatasmart-0.19
patch -Np1 -i $SRC/0001-Dont-test-undefined-bits.patch
patch -Np1 -i $SRC/0002-Drop-our-own-many-bad-sectors-heuristic.patch
./configure ${CONF_OPT}
make $MAKEJOBS && make DESTDIR=$PKG install


cd $SRC/udisks-$surum

PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/ \
GLIB_LIBS="-lglib-2.0 -L$PKG/usr/lib/ -lblockdev -L$PKG/usr/lib/ -lbd_utils" \
GLIB_CFLAGS="-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include  -I$PKG/usr/include" \
./configure ${CONF_OPT} \
--disable-static \
--with-udevdir=/usr/lib/udev \
--enable-lvm2 \
--enable-btrfs \
--enable-bcache \
--enable-vdo \
--enable-lvmcache \
--enable-man=no

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PKG/usr/lib make $MAKEJOBS

