export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PKG/usr/lib"
export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig

openexr_dir="openexr-3.2.0"
libraw_dir="LibRaw-0.21.1"
jasper_dir="jasper-version-4.0.0"
raqm_dir="raqm-0.10.1"
libwmf_dir="libwmf-0.2.13"
liblqr_dir="liblqr-1-0.4.2"
libheif_dir="libheif-1.16.2"
djvu_dir="djvulibre-3.5.28"

cd $SRC

### openexr
# imath ve libdeflate kendi indirilecek
cmake -B build -S ${openexr_dir} $CMAKE_OPT -DCMAKE_BUILD_TYPE=None
cmake --build build $MAKEJOBS
DESTDIR=$PKG cmake --install build

export CFLAGS="$CFLAGS -I$PKG/usr/include/OpenEXR"

### jasper
cd $jasper_dir

patch -p1 < "${SRC}/jasper-1.900.1-fix-filename-buffer-overflow.patch"
sed -r 's|(CMAKE_SKIP_BUILD_RPATH) FALSE|\1 TRUE|g' -i CMakeLists.txt

cmake \
-B buildx \
$CMAKE_OPT \
-DCMAKE_C_FLAGS="$CFLAGS -ffat-lto-objects" \
-DJAS_ENABLE_OPENGL=ON \
-DJAS_ENABLE_LIBJPEG=ON \
-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=OFF \
-DCMAKE_SKIP_RPATH=ON \
-DJAS_ENABLE_SHARED=ON
cmake --build buildx $MAKEJOBS
make -C buildx DESTDIR="${PKG}" install
cd -

export CFLAGS="$CFLAGS -I$PKG/usr/include/jasper"

### libraw
cd $libraw_dir
patch -Np1 -i /sources/477e0719ff.patch
CPPFLAGS=$CFLAGS ./configure --prefix=/usr && make $MAKEJOBS
make DESTDIR=$PKG install
cd -

export CFLAGS="$CFLAGS -I$PKG/usr/include/libraw"

### libraqm
meson build $raqm_dir --prefix=/usr -D docs=false
meson compile -C buildrq
meson install -C buildrq --destdir "$PKG"

### libwmf
cd $libwmf_dir
autoreconf -fi
./configure --prefix=/usr \
--with-gsfontdir=/usr/share/fonts/Type1 \
--with-fontdir=/usr/share/fonts/Type1 \
--with-gsfontmap=/usr/share/ghostscript/Resource/Init/Fontmap.GS
make $MAKEJOBS
make DESTDIR="${PKG}" install -j1
#Remove fonts, these are in gsfonts
rm -rf "${PKG}/usr/share/fonts"
rm -rf $PKG/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/*.a
cd -

export CFLAGS="$CFLAGS -I$PKG/usr/include/libwmf"

### liblqr
cd $liblqr_dir
./configure --prefix=/usr && make $MAKEJOBS
make DESTDIR=$PKG install
cd -

export CFLAGS="$CFLAGS -I$PKG/usr/include/lqr-1"

### djvulibre
cd $djvu_dir
for _patch in $SRC/djvulibre-*.patch; do
	patch -Np1 -i $_patch
done
./configure --prefix=/usr && make $MAKEJOBS
make DESTDIR=$PKG install
cd -
export CFLAGS="$CFLAGS -I$PKG/usr/include/libdjvu"

#
#rm -rf $PKG/usr/lib/*.la
export CPPFLAGS="$CFLAGS"

cd ImageMagick-${surum%.*}-${surum##*.}
### imagemagick
./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --enable-shared \
    --disable-static \
    --with-dejavu-font-dir=/usr/share/fonts/TTF \
    --with-gs-font-dir=/usr/share/fonts/gsfonts \
    PSDelegate=/usr/bin/gs \
    XPSDelegate=/usr/bin/gxps \
    PCLDelegate=/usr/bin/gpcl6 \
    --enable-hdri \
    --enable-opencl \
    --with-gslib \
    --with-djvu \
    --with-fftw \
    --with-jxl \
    --with-lqr \
    --with-modules \
    --with-openexr \
    --with-openjp2 \
    --with-perl \
    --with-perl-options=INSTALLDIRS=vendor \
    --with-rsvg \
    --with-webp \
    --with-wmf \
    --with-xml \
    --without-autotrace \
    --without-dps \
    --without-fpx \
    --without-gcc-arch \
    --without-gvc

  sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
  make $MAKEJOBS
