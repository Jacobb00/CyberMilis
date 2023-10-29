unset MAKEJOBS
patch -Np1 -i ${SRC}/ca-dir_openssl3.1.patch

./Configure --prefix=/usr \
--openssldir=/etc/ssl \
--libdir=lib \
shared enable-ktls enable-ec_nistp_64_gcc_128 linux-x86_64 \
"-Wa,--noexecstack ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"

make depend
make -j1
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
