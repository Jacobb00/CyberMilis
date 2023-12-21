cd $SRC/nspr-*/nspr
./configure --prefix=/usr --libdir=/usr/lib --includedir=/usr/include/nspr --enable-optimize="$CFLAGS" --enable-debug --enable-ipv6 --enable-64bit
make $MAKEJOBS
make DESTDIR=$PKG install
ln -s nspr.pc "$PKG/usr/lib/pkgconfig/mozilla-nspr.pc"
rm -r "$PKG"/usr/bin/{compile-et.pl,prerr.properties} "$PKG"/usr/include/nspr/md
rm -f "$PKG"/usr/lib/*.a

cd $SRC/nss-$surum
#patch -Np1 -i $SRC/nss-3.54-standalone-2.patch

export NSPR_INCLUDE_DIR=$PKG/usr/include/nspr
export NSPR_LIB_DIR=$PKG/usr/lib
export NSS_USE_SYSTEM_SQLITE=1
export USE_SYSTEM_ZLIB=1
export NSS_ENABLE_ECC=1
export NSS_ENABLE_TLS_1_3=1
export BUILD_OPT=1
export NSS_ENABLE_WERROR=0
export NSS_DISABLE_GTESTS=1
export USE_64=1

make -C nss
