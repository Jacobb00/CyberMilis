#export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib LDFLAGS+=' -fuse-ld=lld'

cd SPIRV-LLVM-Translator-$surum
patch -Np1 -i $SRC/spirv-llvm-translator-17.0.0-intel-capability.patch
cd -

cmake -S SPIRV-LLVM-Translator-$surum -B build -G Ninja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -D CMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_SKIP_RPATH=ON \
    -DLLVM_INCLUDE_TESTS=ON \
    -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr/include/spirv/ \
    -Wno-dev

cmake --build build
