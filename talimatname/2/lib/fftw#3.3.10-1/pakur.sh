cd $SRC
_build_types=(single double long-double quad)

for _name in "${_build_types[@]}"; do
	make DESTDIR="$PKG" install -C $isim-$surum-$_name
done

# install missing FFTW3LibraryDepends.cmake
install -vDm 644 build/FFTW3LibraryDepends.cmake -t "$PKG/usr/lib/cmake/fftw3/"
rm -rf $PKG/usr/lib/*.a
