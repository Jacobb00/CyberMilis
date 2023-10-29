[ -f /tools/bin/ld ] && mv /tools/bin/ld /tools/bin/ld.eski
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

[ -L /usr/lib/gcc ] && rm -f /usr/lib/gcc

mkdir -v build
cd build

unset CFLAGS
unset CPPFLAGS
unset LDFLAGS

../configure --prefix=/usr \
--libexecdir=/usr/lib \
--enable-languages=c,c++,fortran \
--disable-multilib \
--disable-bootstrap \
--with-system-zlib

make
