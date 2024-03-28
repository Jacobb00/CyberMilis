#mv llvm-$surum.src llvm
mv cmake-$surum.src cmake
install -D WASI.cmake cmake/Platform/WASI.cmake

cmake -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_WORKS=ON \
    -DCMAKE_CXX_COMPILER_WORKS=ON \
    -DCMAKE_MODULE_PATH="${SRC}"/cmake \
    -DCMAKE_TOOLCHAIN_FILE="${SRC}"/wasi-toolchain.cmake \
    -DCOMPILER_RT_BAREMETAL_BUILD=On \
    -DCOMPILER_RT_INCLUDE_TESTS=OFF \
    -DCOMPILER_RT_HAS_FPIC_FLAG=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=On \
    -DCOMPILER_RT_OS_DIR=wasi \
    -DWASI_SDK_PREFIX=/usr \
    -DCMAKE_C_FLAGS="-fno-exceptions --sysroot=/usr/share/wasi-sysroot" \
    -DCMAKE_INSTALL_PREFIX=/usr/lib/clang/${surum%%.*}/ \
    compiler-rt-${surum}.src/lib/builtins
  cmake --build build -v
