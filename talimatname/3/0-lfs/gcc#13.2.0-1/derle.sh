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

case $(uname -m) in
    x86_64)
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
    ;;
esac

mkdir -v build
cd build

../configure                  \
    --target=$ONSISTEM_TARGET \
    --prefix=/tools           \
    --with-glibc-version=2.38 \
    --with-sysroot=$ONSISTEM_CHROOT \
    --with-newlib             \
    --without-headers         \
    --with-local-prefix=/tools                      \
    --with-native-system-header-dir=/tools/include  \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make $MAKEJOBS
