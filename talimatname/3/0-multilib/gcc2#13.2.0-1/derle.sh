mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc
	
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	`dirname $($ONSISTEM_TARGET-gcc -print-libgcc-file-name)`/include-fixed/limits.h
	
for file in gcc/config/linux.h gcc/config/i386/linux.h gcc/config/i386/linux64.h
do
  cp -uv $file $file.orig
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
	  -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

sed -i -e 's@/lib/ld-linux.so.2@/lib32/ld-linux.so.2@g' gcc/config/i386/linux64.h
sed -i -e '/MULTILIB_OSDIRNAMES/d' gcc/config/i386/t-linux64
echo "MULTILIB_OSDIRNAMES = m64=../lib m32=../lib32 mx32=../libx32" >> gcc/config/i386/t-linux64

#LFS
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build
cd       build

CC=$ONSISTEM_TARGET-gcc                        \
CXX=$ONSISTEM_TARGET-g++                       \
AR=$ONSISTEM_TARGET-ar                         \
RANLIB=$ONSISTEM_TARGET-ranlib                 \
../configure                                       \
    --prefix=/tools                                  \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --disable-nls                                  \
    --disable-bootstrap \
    --with-multilib-list=m32,m64
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libsanitizer                         \
    --disable-libssp                               \
    --disable-libvtv                               \
    --enable-languages=c,c++

#../configure                                   \
#--prefix=/tools                                \
#--with-local-prefix=/tools                     \
#--with-native-system-header-dir=/tools/include \
#--enable-languages=c,c++                       \
#--disable-libstdcxx-pch                        \
#--disable-bootstrap                            \
#--disable-libgomp                              \
#--with-multilib-list=m32,m64

make $MAKEJOBS
make install
ln -sv gcc /tools/bin/cc
