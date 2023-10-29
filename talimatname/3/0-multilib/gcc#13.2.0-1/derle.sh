mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc

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

mkdir -v build
cd       build

../configure \
	--target=$ONSISTEM_TARGET                              \
	--prefix=/tools                                \
	--with-glibc-version=2.38                      \
	--with-sysroot=$ONSISTEM_CHROOT          \
	--with-newlib                                  \
	--without-headers                              \
	--with-local-prefix=/tools                     \
	--with-native-system-header-dir=/tools/include \
	--disable-nls                                  \
	--disable-shared                               \
	--disable-decimal-float                        \
	--disable-threads                              \
	--disable-libatomic                            \
	--disable-libgomp                              \
	--disable-libmpx                               \
	--disable-libquadmath                          \
	--disable-libssp                               \
	--disable-libvtv                               \
	--disable-libstdcxx                            \
	--enable-languages=c,c++                       \
	--with-multilib-list=m32,m64

make $MAKEJOBS
