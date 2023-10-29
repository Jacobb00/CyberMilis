export  LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export  CFLAGS="$CFLAGS -I$PKG/usr/include"
export  PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
#export  LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib

cd $SRC
cmake_options=(
    -DPORT=GTK
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=/usr
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_LIBEXECDIR=lib
    -DCMAKE_SKIP_RPATH=ON
    -DUSE_AVIF=ON
    -DUSE_SOUP2=ON
    -DENABLE_DOCUMENTATION=OFF
    -DENABLE_MINIBROWSER=ON
    -DENABLE_JOURNALD_LOG=OFF
    -DUSE_JPEGXL=OFF
)

export CC=clang CXX=clang++
LDFLAGS+=" -fuse-ld=lld"

# Produce minimal debug info: 4.3 GB of debug data makes the
# build too slow and is too much to package for debuginfod
CFLAGS+=' -g1'
CXXFLAGS+=' -g1'

cmake -S webkitgtk-$surum -B build -G Ninja "${cmake_options[@]}"
cmake --build build $MAKEJOSB
