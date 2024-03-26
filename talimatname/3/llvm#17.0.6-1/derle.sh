export CC=gcc
export CXX=g++

export CFLAGS=${CFLAGS/-g /-g1 }
export CXXFLAGS=${CXXFLAGS/-g /-g1 }

cd $SRC

rename -v -- "-$surum.src" '' {cmake,third-party}-$surum.src

cd $isim-$surum.src

mkdir build
cd build

cmake .. -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DLLVM_INSTALL_UTILS=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_USE_PERF=ON \
-DLLVM_HOST_TRIPLE=$CHOST \
-DLLVM_BUILD_LLVM_DYLIB=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_INSTALL_UTILS=ON \
-DLLVM_ENABLE_RTTI=ON \
-DLLVM_ENABLE_FFI=ON \
-DLLVM_INCLUDE_EXAMPLES=OFF \
-DLLVM_INCLUDE_TESTS=OFF \
-DLLVM_BUILD_DOCS=OFF \
-DLLVM_ENABLE_SPHINX=OFF \
-DLLVM_ENABLE_DOXYGEN=OFF \
-DLLVM_ENABLE_OCAMLDOC=OFF \
-DFFI_INCLUDE_DIR=$(pkg-config --variable=includedir libffi) \
-DLLVM_BINUTILS_INCDIR=/usr/include
ninja all