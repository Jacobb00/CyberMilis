mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc

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

make $MAKEJOBS && make install
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > /tools/lib/gcc/x86_64-milis-linux-gnu/13.2.0/include/limits.h


# lfsde yok
#--with-local-prefix=/tools                      \
#--with-native-system-header-dir=/tools/include  \
