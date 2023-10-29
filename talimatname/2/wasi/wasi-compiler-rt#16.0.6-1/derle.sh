mv llvm-$surum.src llvm
mv cmake-$surum.src cmake
install -D WASI.cmake cmake/Platform/WASI.cmake

cmake -S compiler-rt-$surum.src/lib/builtins -B build -G Ninja \
-D CMAKE_INSTALL_PREFIX="/usr/lib/clang/${surum%%.*}" \
-D COMPILER_RT_INSTALL_PATH="/usr/lib/clang/${surum%%.*}" \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_C_FLAGS_RELEASE='-O3 -DNDEBUG -fno-exceptions --sysroot=/usr/share/wasi-sysroot' \
-D CMAKE_MODULE_PATH="$SRC/cmake" \
-D CMAKE_TOOLCHAIN_FILE="$SRC/wasi-toolchain.cmake" \
-D COMPILER_RT_BAREMETAL_BUILD=ON \
-D COMPILER_RT_INCLUDE_TESTS=OFF \
-D COMPILER_RT_HAS_FPIC_FLAG=OFF \
-D COMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-D COMPILER_RT_OS_DIR=wasi \
-D WASI_SDK_PREFIX=/usr

cmake --build build
