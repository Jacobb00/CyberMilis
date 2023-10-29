#libid3tag
cmake -S $SRC/libid3tag -B build-libid3tag -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
-Wno-dev
cmake --build build-libid3tag
DESTDIR=$PKG cmake --install build-libid3tag

#libmad
cmake -S $SRC/libmad -B build-libmad -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
-Wno-dev
cmake --build build-libmad
DESTDIR=$PKG cmake --install build-libmad
  
#webrtc-audio-processing
cd $SRC/webrtc-audio-processing-0.3.1
#NOCONFIGURE=1 ./autogen.sh
autoreconf -fiv
./configure --prefix /usr --disable-static
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS
make DESTDIR="$PKG" install

#webrtc-audio-processing-1
cd $SRC/webrtc-audio-processing-1.3
meson setup build -Dprefix=$PKG/usr
meson compile -C build
meson install -C build

# neon
cd $SRC/neon-0.32.5
./configure --prefix=/usr --enable-shared --with-ssl=openssl --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
make $MAKEJOBS
make DESTDIR="$PKG" install

# libfreeaptx
#cp -r /sources/libfreeaptx $SRC/
#cd $SRC/libfreeaptx
cd $SRC/libfreeaptx-0.1.1
CC="gcc -std=c99" make CPPFLAGS="$CPPFLAGS" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" PREFIX=/usr
make CPPFLAGS="$CPPFLAGS" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" PREFIX=/usr DESTDIR="$PKG" install

# libdca
cd $SRC/libdca-0.0.7
sed -i '/DESTDIR/ s/\.1/.1.gz/g' src/Makefile.am
sed -i '/libdts.a/d' libdca/Makefile.am
./bootstrap
./configure --prefix=/usr
make $MAKEJOBS
make DESTDIR="$PKG" install

#libgme
cd $SRC/
cmake -S game-music-emu-0.6.3 -B buildgme -G Ninja -DCMAKE_INSTALL_PREFIX='/usr' -DCMAKE_BUILD_TYPE=Release
cmake --build buildgme
DESTDIR="$PKG" cmake --install buildgme

# liblrdf
# raptor gereği çözülmeli

# libltc
cd $SRC/libltc-1.3.2
autoreconf -fiv
./configure --prefix=/usr
make $MAKEJOBS
make DESTDIR="$PKG" install

# libavtp-0.2.0
# libmicrodns-0.2.0

# musepack

cd $SRC/musepack_src_r475

# disable mpcenc (broken when built against recent glibc)
# and any targets whose dependencies are not present
sed -e '/add_subdirectory(mpcenc)/d' \
	-e '/add_subdirectory(mpcpsy)/d' \
	-i CMakeLists.txt
[ -e /usr/lib/libcuefile.so ] || \
	sed '/add_subdirectory(mpcchap)/d' -i CMakeLists.txt
[ -e /usr/lib/libreplaygain.so ] || \
	sed '/add_subdirectory(mpcgain)/d' -i CMakeLists.txt

# fix the headers
sed -i 's/^const /extern const /' libmpcdec/requant.h
sed -e '/^# ifdef USE_TERMIOS/i\#include <sys/time.h>\ \ ' \
	-i mpcenc/keyboard.c
for INC in $(grep -lrE "^#include <cuetools/" .); do
	sed -i 's|^#include <cuetools|#include <cuefile|' $INC
done

mkdir build && cd build
cmake -G Ninja -Wno-dev	\
	-DCMAKE_INSTALL_PREFIX="/usr" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS="$CFLAGS" ..

ninja ${MAKEJOBS:-1}
DESTDIR=$PKG ninja install
rm -rf $PKG/usr/include/mpc/.svn

install -d "$PKG/usr/lib"
install -m 0755 libmpcdec/libmpcdec.so $PKG/usr/lib/libmpcdec.so.6
ln -s libmpcdec.so.6 $PKG/usr/lib/libmpcdec.so

# libopenmpt
cd $SRC/libopenmpt-0.7.3+release.autotools
autoreconf -fiv
./configure --prefix=/usr
# prevent excessive overlinking due to libtool
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS
make DESTDIR="$PKG" install

# libsrtp-2.5.0

# mjpegrools
cd $SRC/mjpegtools-2.2.1
./configure --prefix=/usr
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS
make DESTDIR="$PKG" install

# qrencode-4.1.1

# rtmpdump

cd $SRC/rtmpdump-*

sed \
-e '/^CRYPTO=/s/OPENSSL/GNUTLS/' \
-i Makefile -i librtmp/Makefile

sed \
-e 's|OPT=|&-fPIC |' \
-e 's|OPT|OPTS|' \
-e 's|CFLAGS=.*|& $(OPT)|' \
-i librtmp/Makefile

install -d $PKG/usr/lib

[ "$CC" ] || CC=gcc

make CC="$CC" $MAKEJOBS OPT="$CFLAGS" XLDFLAGS="$LDFLAGS" SYS=posix
make prefix=/usr sbindir=/usr/bin DESTDIR=$PKG install

# soundtouch
cd $SRC
cmake -S soundtouch -B buildsoundtouch -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_LIBDIR=lib \
-D BUILD_SHARED_LIBS=ON \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS -DNDEBUG"

ninja -C buildsoundtouch
DESTDIR=$PKG ninja -C buildsoundtouch install

# spandsp
cd $SRC/spandsp-0.0.6
./configure --prefix=/usr
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make $MAKEJOBS
make DESTDIR="$PKG" install

# svt-hrvc
cd $SRC
LDFLAGS="$LDFLAGS -Wl,-z,noexecstack" cmake -S SVT-HEVC-1.5.1 -B buildsvt -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
-D BUILD_SHARED_LIBS=ON \
-D NATIVE=OFF \
-Wno-dev
LDFLAGS="$LDFLAGS -Wl,-z,noexecstack" cmake --build buildsvt
DESTDIR=$PKG cmake --install buildsvt

# taglib
cd $SRC
cmake -B buildtaglib -S taglib-1.13.1 $CMAKE_OPT \
-DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS="$CXXFLAGS -DNDEBUG"
cmake --build buildtaglib
DESTDIR=$PKG cmake --install buildtaglib

# twolame
cd $SRC/twolame-0.4.0
autoreconf -fiv
./configure --prefix=/usr --disable-static
make
make DESTDIR="$PKG" install

# wavpack-5.6.0

# wildmidi
cd $SRC
cmake -S wildmidi-wildmidi-0.4.5 -B buildwildmidi -G Ninja $CMAKE_OPT
cmake --build buildwildmidi
DESTDIR="$PKG" cmake --install buildwildmidi
ln -s wildmidi.pc "$PKG/usr/lib/pkgconfig/WildMIDI.pc"

# libao
cd $SRC/libao-1.2.2
autoreconf -fiv
./configure --prefix=/usr --enable-alsa-mmap
make
make DESTDIR="$PKG" install
install -vDm 644 $SRC/libao.conf -t "$PKG/etc/"
