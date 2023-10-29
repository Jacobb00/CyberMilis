mkdir -v build32
cd       build32
export ONSISTEM_TARGET32="i686-milis-linux-gnu"
../libstdc++-v3/configure           \
--host=$ONSISTEM_TARGET32       \
--prefix=/tools                 \
--libdir=/tools/lib32           \
--disable-multilib              \
--disable-nls                   \
--disable-libstdcxx-threads     \
--disable-libstdcxx-pch         \
--with-gxx-include-dir=/tools/$ONSISTEM_TARGET/include/c++/$surum \
CC="$ONSISTEM_TARGET-gcc -m32"          \
CXX="$ONSISTEM_TARGET-g++ -m32"
make $MAKEJOBS
make install
cd -

mkdir -v build
cd       build

../libstdc++-v3/configure       \
--host=$ONSISTEM_TARGET         \
--prefix=/tools                 \
--disable-multilib              \
--disable-nls                   \
--disable-libstdcxx-threads     \
--disable-libstdcxx-pch         \
--with-gxx-include-dir=/tools/$ONSISTEM_TARGET/include/c++/$surum
make $MAKEJOBS
make install
