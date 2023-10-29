cd $SRC
_build_types=(single double long-double quad)

# fix wrong soname in FFTW3LibraryDepends.cmake
sed -e 's/3.6.9/3.6.10/' -i ${isim}-${surum}/CMakeLists.txt

mv -v ${isim}-${surum} ${isim}-${surum}-single
for _i in {1..3}; do
	cp -av ${isim}-${surum}-single ${isim}-${surum}-"${_build_types[$_i]}"
done

_configure=(
	./configure
	--prefix=/usr
	--enable-shared
	--enable-threads
	--enable-mpi
	--enable-openmp
)

_configure_single=(
	--enable-sse
	--enable-avx
	--enable-single
)

_configure_double=(
	--enable-sse2
	--enable-avx
)

_configure_long_double=(
	--enable-long-double
)

_configure_quad=(
	--disable-mpi
	--enable-quad-precision
)

_cmake_options=(
	-B build
	-S ${isim}-${surum}-$_build_types
	-D CMAKE_INSTALL_PREFIX=/usr
	-D CMAKE_BUILD_TYPE=None
	-D ENABLE_OPENMP=ON
	-D ENABLE_THREADS=ON
	-D ENABLE_FLOAT=ON
	-D ENABLE_LONG_DOUBLE=ON
	-D ENABLE_QUAD_PRECISION=ON
	-D ENABLE_SSE=ON
	-D ENABLE_SSE2=ON
	-D ENABLE_AVX=ON
	-D ENABLE_AVX2=ON
)

# create missing FFTW3LibraryDepends.cmake
# https://bugs.archlinux.org/task/67604
cmake "${_cmake_options[@]}"
# fix broken IMPORTED_LOCATION: https://github.com/FFTW/fftw3/issues/130#issuecomment-1030280157
sed -e 's|\(IMPORTED_LOCATION_NONE\).*|\1 "/usr/lib/libfftw3.so.3"|' -i build/FFTW3LibraryDepends.cmake

export F77='gfortran'
# use upstream default CFLAGS while keeping our -march/-mtune
CFLAGS+=" -O3 -fomit-frame-pointer -malign-double -fstrict-aliasing -ffast-math"

for _name in "${_build_types[@]}"; do
(
  cd ${isim}-${surum}-$_name
  case $_name in
	single)
	"${_configure[@]}" "${_configure_single[@]}"
	;;
	double)
	"${_configure[@]}" "${_configure_double[@]}"
	;;
	long-double)
	"${_configure[@]}" "${_configure_long_double[@]}"
	;;
	quad)
	"${_configure[@]}" "${_configure_quad[@]}"
	;;
  esac
  # fix overlinking because of libtool
  sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
)
done

for _name in "${_build_types[@]}"; do
	make -C ${isim}-${surum}-$_name $MAKEJOBS
done
