make INSTALL_DIR="$PKG"/usr/share/wasi-sysroot install

cd $PKG/usr/share/wasi-sysroot/lib/wasm32-wasi
for f in *.a; do
	/usr/bin/llvm-ranlib $f
	/usr/bin/llvm-strip --strip-debug $f
done
