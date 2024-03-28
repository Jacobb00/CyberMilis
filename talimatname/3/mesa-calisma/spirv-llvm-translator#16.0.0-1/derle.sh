export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib LDFLAGS+=' -fuse-ld=lld'

cmake -S SPIRV-LLVM-Translator-$surum -B build -G Ninja \
    -D LLVM_ENABLE_LTO=ON \
    -D CMAKE_INSTALL_PREFIX=/usr \
    -D CMAKE_INSTALL_LIBDIR=lib \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
    -D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
    -D CMAKE_POSITION_INDEPENDENT_CODE=ON \
    -D CMAKE_SKIP_RPATH=ON \
    -D LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr/include/spirv \
    -D FETCHCONTENT_FULLY_DISCONNECTED=ON \
    -Wno-dev

cmake --build build
