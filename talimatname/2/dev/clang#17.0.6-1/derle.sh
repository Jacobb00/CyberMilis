cd $SRC
mv cmake{-$surum.src,}
mv third-party{-$surum.src,}

cd clang-$surum.src
mkdir build

mv "$SRC/clang-tools-extra-$surum.src" tools/extra
#patch -p1 -i ${SRC}/0003-PATCH-clang-Don-t-install-static-libraries.patch
patch -Np2 -i $SRC/enable-fstack-protector-strong-by-default.patch

# https://github.com/clangd/clangd/issues/1559
cp /sources/clangd-handle-missing-ending-brace.patch $SRC/
sed 's|clang-tools-extra|clang/tools/extra|' $SRC/clangd-handle-missing-ending-brace.patch | patch -Np2

# Attempt to convert script to Python 3
LC_ALL=C 2to3 -wn --no-diffs tools/extra/clang-include-fixer/find-all-symbols/tool/run-find-all-symbols.py

cd build
#cd ..
# Build only minimal debug info to reduce size
export CFLAGS=${CFLAGS/-g /-g1 }
export CXXFLAGS=${CXXFLAGS/-g /-g1 }

#cmake -B build -S ${isim}-${surum}.src \
#        -DCMAKE_BUILD_TYPE:STRING=Release \
#        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
#        -DCMAKE_INSTALL_LIBEXECDIR=lib/clang \
#        -DLLVM_COMMON_CMAKE_UTILS="${SRC}/cmake" \
#        -DCMAKE_MODULE_PATH="${SRC}/cmake" \
#        -DCLANG_BUILT_STANDALONE=ON \
#        -DCLANG_LINK_CLANG_DYLIB=ON \
#        -DENABLE_LINKER_BUILD_ID=ON \
#        -DLLVM_INCLUDE_TESTS=OFF
#    cmake --build build

ln -s /usr/include/llvm ../include/llvm

LC_ALL=C cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_SKIP_RPATH=ON \
    -DCLANG_DEFAULT_PIE_ON_LINUX=ON \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DENABLE_LINKER_BUILD_ID=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_INCLUDE_DOCS=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_MAIN_SRC_DIR="$SRC/llvm-$surum.src"
LC_ALL=C ninja
