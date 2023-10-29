cd $SRC
patch -d audacity-Audacity-$surum -N -p 1 -i "/sources/e181ee115e727b4754619b04aa6e8ad872113592.patch"

cmake_options=(
    -B build
    #-D CMAKE_BUILD_TYPE=None
    #-D CMAKE_INSTALL_PREFIX=/usr
    $CMAKE_OPT
    -D AUDACITY_BUILD_LEVEL=2
    -D audacity_conan_enabled=OFF
    -D audacity_has_networking=OFF
    -D audacity_has_crashreports=OFF
    -D audacity_has_updates_check=OFF
    -D audacity_has_sentry_reporting=OFF
    -D audacity_lib_preference=system
    -D audacity_obey_system_dependencies=ON
    -D audacity_use_vst3sdk=system
    -D audacity_use_portsmf=local
    -S audacity-Audacity-$surum
    -W no-dev
)
  #export VST3_SDK_DIR="$PKG/usr/src/vst3sdk"
export  LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"

  export VST3SDK="$PKG/usr/src/vst3sdk" 
  export CFLAGS="$CFLAGS -I$PKG/usr/include"
  export CPPFLAGS="$CFLAGS"
  export CXXFLAGS="$CFLAGS"
  
  export CFLAGS+=" -DNDEBUG"
  export CXXFLAGS+=" -DNDEBUG"
  cmake "${cmake_options[@]}"

sed -i "s#LIB_sbsms-NOTFOUND#/tmp/work/pkg/usr/lib/libsbsms.so#" build/CMakeCache.txt
sed -i "s#LIB_vamp-hostsdk-NOTFOUND#/tmp/work/pkg/usr/lib/libvamp-hostsdk.so#" build/CMakeCache.txt

cmake --build build $MAKEJOBS
DESTDIR=$PKG cmake --install build
