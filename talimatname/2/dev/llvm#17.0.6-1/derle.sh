cd $SRC
mv $isim-$surum.src $isim
cp -r cmake-$surum.src/Modules/* $isim/cmake/modules/.
mv cmake-$surum.src/ cmake
mv third-party-$surum.src/ third-party

mv clang-tools-extra-$surum.src clang-$surum.src/tools/extra
mv clang-$surum.src clang
mv compiler-rt-$surum.src compiler-rt
mv lld-$surum.src lld


grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'

patch -d lld -p2 -i $SRC/0002-PATCH-lld-Import-compact_unwind_encoding.h-from-libu.patch
patch -Np2 -d $isim -i $SRC/llvm-rust-feature-tables.patch
patch -Np2 -d $isim -i $SRC/llvm-install-prefix.patch

LC_ALL=C cmake -S $isim -B build -G Ninja -D LLVM_CCACHE_BUILD=ON \
	-D CMAKE_INSTALL_PREFIX=/usr \
	-D CMAKE_BUILD_TYPE=Release \
	-D CMAKE_C_FLAGS_RELEASE="$CFLAGS" \
	-D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
	-D LLVM_BINUTILS_INCDIR=/usr/include \
	-D LLVM_BUILD_LLVM_DYLIB=ON \
	-D LLVM_LINK_LLVM_DYLIB=ON \
	-D LLVM_PARALLEL_COMPILE_JOBS="$(nproc)" \
	-D LLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
	-D LLVM_INCLUDE_EXAMPLES=OFF \
	-D LLVM_INCLUDE_TESTS=OFF \
	-D LLVM_ENABLE_FFI=ON \
	-D LLVM_ENABLE_RTTI=ON \
	-D LLVM_ENABLE_OCAMLDOC=OFF \
	-D LLVM_INCLUDE_UTILS=ON \
	-D LLVM_INSTALL_UTILS=ON \
	-D LLVM_UTILS_INSTALL_DIR=/usr/bin \
	-D LLVM_ENABLE_LIBCXX=OFF \
	-D LLVM_ENABLE_LLD=OFF \
	-D LLVM_OPTIMIZED_TABLEGEN=ON \
	-D LLVM_INCLUDE_BENCHMARKS=OFF \
	-D LLVM_APPEND_VC_REV=OFF \
	-D LLVM_ENABLE_PROJECTS="compiler-rt;clang;lld" \
	-D COMPILER_RT_INSTALL_PATH=/usr/lib/clang/${surum:0:2} \
	-D CMAKE_INSTALL_LIBEXECDIR=lib/clang \
	-Wno-dev

cmake --build build
DESTDIR=$PKG cmake --install build

# multilib stub
mv $PKG/usr/include/llvm/Config/llvm-config{,-64}.h
install -m 0644 $SRC/llvm-config.h $PKG/usr/include/llvm/Config/

install -d $PKG/usr/lib/bfd-plugins
ln -s ../LLVMgold.so $PKG/usr/lib/bfd-plugins/
ln -s ../libLTO.so $PKG/usr/lib/bfd-plugins/

/usr/bin/python3 $isim/utils/lit/setup.py build
/usr/bin/python3 $isim/utils/lit/setup.py install --prefix=/usr --root=$PKG
/usr/bin/python3 -m compileall -d $isim/utils/lit $PKG
/usr/bin/python3 -O -m compileall -d $isim/utils/lit $PKG
/usr/bin/python3 -OO -m compileall -d $isim/utils/lit $PKG

# clang install prefix hack - qt6-tools 
sed -i '8i set(CLANG_INSTALL_PREFIX "/usr")' $PKG/usr/lib/cmake/clang/ClangConfig.cmake
