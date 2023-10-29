export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include" 
export CFLAGS="$CFLAGS -I$PKG/usr/include/xfce4" 
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
export LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib
export XDG_DATA_DIRS=/usr/share:$PKG/usr/share

cd $SRC

cd libxfce4util-*
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--sbindir=/usr/bin \
--localstatedir=/var \
--disable-debug
make $MAKEJOBS && make install DESTDIR=$PKG
cd -
rm -f $PKG/usr/lib/*.la
export CFLAGS="$CFLAGS -I$PKG/usr/include/xfce4" 

cd tumbler-*
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--disable-debug \
--disable-gstreamer-thumbnailer
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

cd xfconf-*
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--sbindir=/usr/bin \
--localstatedir=/var \
--disable-debug
make $MAKEJOBS && make install DESTDIR=$PKG
cd -
rm -f $PKG/usr/lib/*.la
export CFLAGS="$CFLAGS -I$PKG/usr/include/xfce4/xfconf-0" 

cd libxfce4ui-*
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--sbindir=/usr/bin \
--localstatedir=/var \
--disable-debug --disable-introspection
make $MAKEJOBS && make install DESTDIR=$PKG
cd -
rm -f $PKG/usr/lib/*.la
export CFLAGS="$CFLAGS -I$PKG/usr/include/xfce4/libxfce4ui-2" 
export CFLAGS="$CFLAGS -I$PKG/usr/include/xfce4/libxfce4kbd-private-3" 

cd exo-*
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--disable-debug --disable-introspection
make $MAKEJOBS && make install DESTDIR=$PKG
cd -
rm -f $PKG/usr/lib/*.la
export CFLAGS="$CFLAGS -I$PKG/usr/include/exo-2"

cd thunar-$surum
./configure $CONF_OPT --enable-gio-unix --enable-gudev --enable-exif --enable-pcre --enable-notifications --disable-debug
make $MAKEJOBS && make DESTDIR=$PKG install
cd -
export CFLAGS="$CFLAGS -I$PKG/usr/include/thunarx-3"

# arşiv yönetimi
cd thunar-archive-plugin-0.5.1
./configure $CONF_OPT --libexecdir=/usr/lib/xfce4
make $MAKEJOBS && make DESTDIR=$PKG install
cd -

# harici diskler
#cd thunar-volman-4.18.0
#./configure $CONF_OPT
#make $MAKEJOBS && make DESTDIR=$PKG install
