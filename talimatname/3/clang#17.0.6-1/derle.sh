cd $SRC
rename -v -- "-$surum.src" '' {cmake,third-party}-$surum.src
cd clang-$surum.src
mkdir build
mv "$SRC/clang-tools-extra-$surum.src" tools/extra
patch -Np2 -i ../enable-fstack-protector-strong-by-default.patch

# https://github.com/clangd/clangd/issues/1559
sed 's|clang-tools-extra|clang/tools/extra|' /sources/clangd-handle-missing-ending-brace.patch | patch -Np2

# Attempt to convert script to Python 3
2to3 -wn --no-diffs tools/extra/clang-include-fixer/find-all-symbols/tool/run-find-all-symbols.py

cd clang-$surum.src/build

# Build only minimal debug info to reduce size
export CFLAGS=${CFLAGS/-g /-g1 }
export CXXFLAGS=${CXXFLAGS/-g /-g1 }


cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_SKIP_RPATH=ON \
    -DCLANG_DEFAULT_PIE_ON_LINUX=ON \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DENABLE_LINKER_BUILD_ID=ON \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_BUILD_TESTS=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_SPHINX=OFF \
    -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_MAIN_SRC_DIR="$SRC/llvm-$surum.src"
ninja
