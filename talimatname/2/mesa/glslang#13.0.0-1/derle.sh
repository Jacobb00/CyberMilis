CXXFLAGS+=" -ffat-lto-objects"
cmake \
-Bbuild-shared \
-GNinja \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=None \
-DBUILD_SHARED_LIBS=ON \
-DCMAKE_INSTALL_LIBDIR=/usr/lib
ninja -Cbuild-shared

cmake \
-Bbuild-static \
-GNinja \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=None \
-DBUILD_SHARED_LIBS=OFF \
-DCMAKE_INSTALL_LIBDIR=/usr/lib
ninja -Cbuild-static
