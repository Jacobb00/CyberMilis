cd $SRC
mv libunwind{-$surum.src,}
mv cmake{-$surum.src,}

cd lld-$surum.src
mkdir build

# https://github.com/llvm/llvm-project/issues/83529
patch -Np2 -i /sources/$isim-internalize-enum.patch

cd build
cmake .. -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_SKIP_RPATH=ON \
-DBUILD_SHARED_LIBS=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_BUILD_TESTS=OFF \
-DLLVM_BUILD_DOCS=OFF \
-DLLVM_ENABLE_SPHINX=OFF \
-DLLVM_MAIN_SRC_DIR="${SRC}/llvm-${surum}.src"
ninja
