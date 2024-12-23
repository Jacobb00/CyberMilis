export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib LDFLAGS+=' -fuse-ld=lld'

cmake -S $isim-$surum.src -B build -G Ninja \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
-Wno-dev

cmake --build build
