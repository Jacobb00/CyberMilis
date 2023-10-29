gcc_surum="13.2.0"
linux_surum="6.4.12"
cd $SRC/linux-${linux_surum}
make mrproper
make INSTALL_HDR_PATH=dest headers_install;
mkdir -p $PKG/usr/include
cp -rv dest/include/* $PKG/usr/include
rm -rf $SRC/linux-${linux_surum}

cd $SRC/glibc-$surum
patch -Np1 -i $SRC/glibc-$surum-fhs-1.patch || exit 1
patch -Np1 -i $SRC/glibc-2.38-memalign_fix-1.patch

# glibc'in son halinde tools a link olmaması için
ln -sfv /tools/lib/gcc /usr/lib

#[ -f /usr/include/limits.h ] && rm -f /usr/include/limits.h

# 64bit için gerekli kısayollar
mkdir -p $PKG/usr/lib

GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/${gcc_surum}/include
ln -s ../lib/ld-linux-x86-64.so.2 $PKG/usr/lib
ln -s ../lib/ld-linux-x86-64.so.2 $PKG/usr/lib/ld-lsb-x86-64.so.3

mkdir -v build
cd       build

echo "slibdir=/usr/lib" >> configparms
echo "rtlddir=/usr/lib" >> configparms
echo "sbindir=/usr/bin" >> configparms
echo "rootsbindir=/usr/bin" >> configparms

# remove stack protector for libs
CFLAGS=${CFLAGS/-fstack-protector/}
CPPFLAGS=${CPPFLAGS/-D_FORTIFY_SOURCE=2/}

#CC="gcc -ffile-prefix-map=/tools=/usr" \

CC="gcc -isystem $GCC_INCDIR -isystem /usr/include"  \
${SRC}/glibc-${surum}/configure --prefix=/usr \
--libdir=/usr/lib --libexecdir=/usr/lib \
--with-headers=$PKG/usr/include \
--disable-werror                \
--enable-kernel=4.14             \
--enable-stack-protector=strong \
--enable-bind-now \
--enable-multi-arch \
--disable-profile \
--disable-timezone-tools

# build libs without stack protector
echo "build-programs=no" >> configparms
make

# build bins with stack protector
sed -i "/build-programs=/s#no#yes#" configparms
echo "CC += -fstack-protector -D_FORTIFY_SOURCE=2" >> configparms
echo "CXX += -fstack-protector -D_FORTIFY_SOURCE=2" >> configparms
make

# no stack protector for running tests
sed -i '5,7d' configparms
sed -i '/FORTIFY/d' configparms

unset GCC_INCDIR
