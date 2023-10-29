export ONSISTEM_TARGET32=i686-milis-linux-gnu
mkdir -v build32
cd       build32

echo slibdir=/tools/lib32 > configparms
../configure                             \
  --prefix=/tools                    \
  --host=$ONSISTEM_TARGET32                  \
  --build=$(../scripts/config.guess) \
  --libdir=/tools/lib32              \
  --enable-kernel=4.14                \
  --with-headers=/tools/include      \
  CC="$ONSISTEM_TARGET-gcc -m32"             \
  CXX="$ONSISTEM_TARGET-g++ -m32"
make $MAKEJOBS
cd -

mkdir -v build
cd       build

../configure                             \
  --prefix=/tools                    \
  --host=$ONSISTEM_TARGET                    \
  --build=$(../scripts/config.guess) \
  --enable-kernel=4.14            \
  --with-headers=/tools/include
make $MAKEJOBS
