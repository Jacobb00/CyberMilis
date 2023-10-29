sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

CFLAGS="$CFLAGS -fPIC"
./configure --prefix=/usr \
--disable-static
toollib=""
[ -d /tools ] && toollib="-L/tools/lib"
make SHLIB_LIBS="$toollib -lncursesw"
#make SHLIB_LIBS="-lncursesw"
