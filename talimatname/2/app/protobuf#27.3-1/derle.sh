cd $SRC
local cmake_options=(
-B build
-D CMAKE_BUILD_TYPE=None
-D CMAKE_INSTALL_PREFIX=/usr
-D CMAKE_C_FLAGS="$CFLAGS -ffat-lto-objects" 
-D CMAKE_CXX_FLAGS="$CXXFLAGS -ffat-lto-objects"
-D protobuf_BUILD_TESTS=OFF
-D protobuf_BUILD_SHARED_LIBS=ON
-D protobuf_ABSL_PROVIDER=package
-S "$isim-$surum"
-W no-dev
)

cmake "${cmake_options[@]}"
cmake --build build --verbose

#-D protobuf_USE_EXTERNAL_GTEST=OFF

