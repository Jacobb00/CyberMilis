mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc
	
case $(uname -m) in
  x86_64)
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
  ;;
esac
	
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build
cd build

../configure                                   \
--build=$(../config.guess)                     \
--host=$ONSISTEM_TARGET                        \
--target=$ONSISTEM_TARGET                      \
LDFLAGS_FOR_TARGET=-L$PWD/$ONSISTEM_TARGET/libgcc      \
--prefix=/tools                                  \
--with-build-sysroot=$ONSISTEM_CHROOT          \
--enable-default-pie                           \
--enable-default-ssp                           \
--disable-nls                                  \
--disable-multilib                             \
--disable-libatomic                            \
--disable-libgomp                              \
--disable-libquadmath                          \
--disable-libsanitizer                         \
--disable-libssp                               \
--disable-libvtv                               \
--enable-languages=c,c++

make $MAKEJOBS
