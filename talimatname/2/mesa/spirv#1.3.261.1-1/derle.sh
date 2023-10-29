cd $SRC
cmake -S SPIRV-Headers-sdk-$surum -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DSPIRV_HEADERS_SKIP_EXAMPLES=ON
cmake --build build
DESTDIR=$PKG cmake --install build

CONF_SPIRV_TOOLS+=" \
-G Ninja \
-S SPIRV-Tools-sdk-$surum \
-D CMAKE_INSTALL_PREFIX=/usr \
-D CMAKE_INSTALL_LIBDIR=lib \
-D CMAKE_BUILD_TYPE=Release \
-D SPIRV_WERROR=OFF \
-D SPIRV-Headers_SOURCE_DIR=$PKG/usr \
-D PYTHON_EXECUTABLE=/usr/bin/python3 \
-D SPIRV_TOOLS_BUILD_STATIC=OFF \
-Wno-dev"

cmake -B build-static $CONF_SPIRV_TOOLS \
	-D CMAKE_C_FLAGS_RELEASE="${CFLAGS} -ffat-lto-objects" \
	-D CMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS} -ffat-lto-objects" \
	-D BUILD_SHARED_LIBS=OFF
cmake --build build-static -j $MAKEJOBS

cmake -B build-shared $CONF_SPIRV_TOOLS \
	-D CMAKE_C_FLAGS_RELEASE="${CFLAGS} -ffat-lto-objects" \
	-D CMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS} -ffat-lto-objects" \
	-D BUILD_SHARED_LIBS=ON
cmake --build build-shared -j $MAKEJOBS
