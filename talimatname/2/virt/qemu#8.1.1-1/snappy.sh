cd $SRC
patch -d snappy-1.1.10 -p1 -i $SRC/snappy-thirdparty.patch
patch -d snappy-1.1.10 -p1 -i $SRC/snappy-do-not-disable-rtti.patch

cmake -S snappy-1.1.10 -B build-snappy -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
-D BUILD_SHARED_LIBS=ON \
-D SNAPPY_BUILD_TESTS=OFF \
-D SNAPPY_BUILD_BENCHMARKS=OFF \
-D HAVE_LIBZ=NO \
-D HAVE_LIBLZO2=NO \
-D HAVE_LIBLZ4=NO \
-Wno-dev
cmake --build build-snappy
DESTDIR=$PKG cmake --install build-snappy

cat <<- EOF > snappy.pc
prefix=/usr
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib

isim: snappy
Description: A fast compression/decompression library
Version: 1.1.10
Cflags: -I\${includedir}
Libs: -L\${libdir} -lsnappy
EOF

install -Dm644 snappy.pc $PKG/usr/lib/pkgconfig/snappy.pc
