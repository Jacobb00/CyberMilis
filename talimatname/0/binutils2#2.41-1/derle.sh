mkdir -v build
cd       build

CC=$ONSISTEM_TARGET-gcc                \
AR=$ONSISTEM_TARGET-ar                 \
RANLIB=$ONSISTEM_TARGET-ranlib         \
../configure                   \
--prefix=/tools            \
--disable-nls              \
--disable-werror           \
--with-lib-path=/tools/lib \
--with-sysroot \
--enable-gprofng=no 
make $MAKEJOBS
make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib:/usr/lib32
cp -v ld/ld-new /tools/bin

# _isoc23_strtol libfd derlerken
# --enable-gprofng=no 
