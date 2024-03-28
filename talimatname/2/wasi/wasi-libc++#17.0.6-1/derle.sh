cd $SRC
mv llvm-project-${surum}.src llvm
mkdir -p llvm/cmake/Platform
cp WASI.cmake llvm/cmake/Platform

# Build options are derived from here https://github.com/WebAssembly/wasi-sdk/blob/main/Makefile
# remove compiler options not supported by the wasm32-wasi target
export CFLAGS="$(echo $CFLAGS | sed "s/-mtune=generic//;s/-fstack-clash-protection//; s/-fcf-protection//; s/-fexceptions//; s/-march=x86-64//")"
export CXXFLAGS="$(echo $CXXFLAGS | sed "s/-mtune=generic//;s/-fstack-clash-protection//; s/-fcf-protection//; s/-fexceptions//; s/-march=x86-64//")"

cmake -B build -G Ninja \
    -DCMAKE_C_COMPILER_WORKS=ON \
    -DCMAKE_CXX_COMPILER_WORKS=ON \
    -DCMAKE_AR=/usr/bin/ar \
    -DCMAKE_MODULE_PATH="${SRC}"/cmake \
    -DCMAKE_TOOLCHAIN_FILE="${SRC}"/wasi-toolchain.cmake \
    -DCMAKE_STAGING_PREFIX=/usr/share/wasi-sysroot \
    -DLIBCXX_ENABLE_THREADS:BOOL=OFF \
    -DLIBCXX_HAS_PTHREAD_API:BOOL=OFF \
    -DLIBCXX_HAS_EXTERNAL_THREAD_API:BOOL=OFF \
    -DLIBCXX_BUILD_EXTERNAL_THREAD_LIBRARY:BOOL=OFF \
    -DLIBCXX_HAS_WIN32_THREAD_API:BOOL=OFF \
    -DLLVM_COMPILER_CHECKED:BOOL=ON \
    -DLLVM_RUNTIMES_LINKING_WORKS:BOOL=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DLIBCXX_ENABLE_SHARED:BOOL=OFF \
    -DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF \
    -DLIBCXX_ENABLE_FILESYSTEM:BOOL=OFF \
    -DLIBCXX_CXX_ABI=libcxxabi \
    -DLIBCXX_HAS_MUSL_LIBC:BOOL=ON \
    -DLIBCXX_ABI_VERSION=2 \
    -DLIBCXXABI_ENABLE_EXCEPTIONS:BOOL=OFF \
    -DLIBCXXABI_ENABLE_SHARED:BOOL=OFF \
    -DLIBCXXABI_SILENT_TERMINATE:BOOL=ON \
    -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF \
    -DLIBCXXABI_HAS_PTHREAD_API:BOOL=OFF \
    -DLIBCXXABI_HAS_EXTERNAL_THREAD_API:BOOL=OFF \
    -DLIBCXXABI_BUILD_EXTERNAL_THREAD_LIBRARY:BOOL=OFF \
    -DLIBCXXABI_HAS_WIN32_THREAD_API:BOOL=OFF \
    -DWASI_SDK_PREFIX=/usr \
    -DUNIX:BOOL=ON \
    -DCMAKE_SYSROOT=/usr/share/wasi-sysroot \
    -DLIBCXX_LIBDIR_SUFFIX=/wasm32-wasi \
    -DLIBCXXABI_LIBDIR_SUFFIX=/wasm32-wasi \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
    -DCXX_SUPPORTS_CLASS_MEMACCESS_FLAG:BOOL=OFF \
    -DCXX_SUPPORTS_COVERED_SWITCH_DEFAULT_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_EHA_FLAG:BOOL=OFF \
    -DCXX_SUPPORTS_EHS_FLAG:BOOL=OFF \
    -DCXX_SUPPORTS_FALIGNED_ALLOCATION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_FDATA_SECTIONS:BOOL=ON \
    -DCXX_SUPPORTS_FNO_EXCEPTIONS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_FSTRICT_ALIASING_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_FVISIBILITY_EQ_HIDDEN_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_FVISIBILITY_INLINES_HIDDEN_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_IMPLICIT_FALLTHROUGH_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_MISLEADING_INDENTATION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_MISSING_FIELD_INITIALIZERS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_NOEXCEPT_TYPE_FLAG:BOOL=OFF \
    -DCXX_SUPPORTS_NOSTDINCXX_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_NOSTDLIBXX_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_PEDANTIC_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_STRING_CONVERSION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_SUGGEST_OVERRIDE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_UNWINDLIB_EQ_NONE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WALL_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WCHAR_SUBSCRIPTS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WCONVERSION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WERROR_DATE_TIME:BOOL=ON \
    -DCXX_SUPPORTS_WERROR_EQ_RETURN_TYPE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WERROR_UNGUARDED_AVAILABILITY_NEW:BOOL=ON \
    -DCXX_SUPPORTS_WEXTRA_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WEXTRA_SEMI_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WFORMAT_NONLITERAL_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WMISMATCHED_TAGS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WMISSING_BRACES_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNEWLINE_EOF_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_COVERED_SWITCH_DEFAULT_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_ERROR_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_LONG_LONG_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_SUGGEST_OVERRIDE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_UNUSED_PARAMETER_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WNO_USER_DEFINED_LITERALS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSHADOW_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSHORTEN_64_TO_32_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSIGN_COMPARE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSIGN_CONVERSION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSTRICT_ALIASING_EQ_2_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WSTRICT_OVERFLOW_EQ_4_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WUNDEF_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WUNUSED_FUNCTION_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WUNUSED_PARAMETER_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WUNUSED_VARIABLE_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WWRITE_STRINGS_FLAG:BOOL=ON \
    -DCXX_SUPPORTS_WX_FLAG:BOOL=OFF \
    -DCXX_SUPPORTS_W_FLAG:BOOL=ON \
    -DCXX_WONT_WARN_ON_FINAL_NONVIRTUALDTOR:BOOL=ON \
    -DCXX_WSUGGEST_OVERRIDE_ALLOWS_ONLY_FINAL:BOOL=ON \
    -DLINKER_SUPPORTS_COLOR_DIAGNOSTICS:BOOL=ON \
    -DSUPPORTS_FVISIBILITY_INLINES_HIDDEN_FLAG:BOOL=ON \
    llvm/runtimes

    ninja -C build
