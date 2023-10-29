gcc_surum="13.2.0"
linux_surum="6.4.12"
cd $SRC/linux-${linux_surum}
make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
mkdir -p $PKG/usr/include
cp -rv usr/include/* $PKG/usr/include


cd $SRC/glibc-$surum
patch -Np1 -i $SRC/glibc-$surum-fhs-1.patch || exit 1
patch -Np1 -i $SRC/glibc-2.38-memalign_fix-1.patch


cd $SRC
mkdir -p glibc-build lib32-glibc-build

[[ -d glibc-$surum ]] && ln -s glibc-$surum glibc
cd glibc

# Re-enable `--hash-style=both` for building shared objects due to issues with EPIC's EAC
# which relies on DT_HASH to be present in these libs.
# reconsider 2023-01
patch -Np1 -i "${SRC}"/reenable_DT_HASH.patch

patch -Np1 -i "${SRC}"/fix-malloc-p1.patch
patch -Np1 -i "${SRC}"/fix-malloc-p2.patch


_configure_flags=(
--prefix=/usr
--with-headers=$PKG/usr/include
--enable-bind-now
--enable-cet
--enable-fortify-source
--enable-kernel=4.4
--enable-multi-arch
--enable-stack-protector=strong
--disable-profile
--disable-werror
--disable-timezone-tools
)

  cd "${SRC}"/glibc-build

  echo "slibdir=/usr/lib" >> configparms
  echo "rtlddir=/usr/lib" >> configparms
  echo "sbindir=/usr/bin" >> configparms
  echo "rootsbindir=/usr/bin" >> configparms

  # Credits @allanmcrae
  # https://github.com/allanmcrae/toolchain/blob/f18604d70c5933c31b51a320978711e4e6791cf1/glibc/PKGBUILD
  # remove fortify for building libraries
  # CFLAGS=${CFLAGS/-Wp,-D_FORTIFY_SOURCE=2/}

  "${SRC}"/glibc/configure \
      --libdir=/usr/lib \
      --libexecdir=/usr/lib \
      "${_configure_flags[@]}"

  make -O

  cd "${SRC}"/lib32-glibc-build
  export CC="gcc -m32 -mstackrealign"
  export CXX="g++ -m32 -mstackrealign"

  echo "slibdir=/usr/lib32" >> configparms
  echo "rtlddir=/usr/lib32" >> configparms
  echo "sbindir=/usr/bin" >> configparms
  echo "rootsbindir=/usr/bin" >> configparms

  "${SRC}"/glibc/configure \
      --host=i686-pc-linux-gnu \
      --libdir=/usr/lib32 \
      --libexecdir=/usr/lib32 \
      "${_configure_flags[@]}"

  make -O

# sdt.h gerekli
#--enable-systemtap
