# qt6-plugins
#yamalar
sed -e '/qt_internal_set_exceptions_flags/d' -e '/qt_disable_warnings/d' -i $SRC/qttools-everywhere-src-$surum/src/assistant/CMakeLists.txt
patch -d $SRC/qttools-everywhere-src-$surum -p1 < $TDIR/zstd-target.patch 


for pk in qttools qtsvg qtquicktimeline qtquick3d qtwayland qtwebsockets qtwebchannel qtconnectivity qtcharts qtserialport qtdatavis3d qtlottie qtremoteobjects qtserialbus qtpositioning qtquickeffectmaker;do
  cd $SRC
  mv ${pk}-* ${pk}
  cmake -S ${pk} -B build-${pk} -G Ninja $CMAKE_OPT -D INSTALL_PUBLICBINDIR=usr/bin -D QT_USE_CCACHE=ON -DCMAKE_MESSAGE_LOG_LEVEL=STATUS -DCMAKE_MODULE_PATH=/usr/lib/cmake:$PKG/usr/lib/cmake
  cmake --build build-${pk} $MAKEJOBS
  DESTDIR=$PKG cmake --install build-${pk}

  if [ -f $SRC/build-${pk}/user_facing_tool_links.txt ];then
    cd $PKG
    mkdir usr/bin
    while read _line; do
      ln -s $_line
    done < $SRC/build-${pk}/user_facing_tool_links.txt
  fi
done
