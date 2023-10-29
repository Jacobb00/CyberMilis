export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
export LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib
#export PYTHONPATH=/usr/lib/python3.11/site-packages:$PKG/usr/lib/python3.11/site-packages
#export INCLUDES=$PKG/usr/include
export PYTHON_CPPFLAGS=" -I//usr/include/python3.11"
export PYTHON_LDFLAGS=" -L/usr/lib -lpython3.11"

cd $SRC

cd libplist-*
./configure --prefix=/usr
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

cd libusbmuxd-*
./configure --prefix=/usr
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

rm -f $PKG/usr/lib/*.la 

cd libimobiledevice-$surum
patch -Np1 -i ../libimobiledevice-libplist-2.3.0.patch
autoreconf -fi
./configure --prefix=/usr
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS
