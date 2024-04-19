cd $SRC
cmake -B build -S qtwebengine-everywhere-src-$surum -G Ninja \
$CMAKE_OPT \
-D QT_USE_CCACHE=ON \
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS \
-DQT_FEATURE_webengine_system_ffmpeg=ON \
-DQT_FEATURE_webengine_system_icu=ON \
-DQT_FEATURE_webengine_system_libevent=ON \
-DQT_FEATURE_webengine_proprietary_codecs=ON \
-DQT_FEATURE_webengine_kerberos=ON \
-DQT_FEATURE_webengine_webrtc_pipewire=ON
cmake --build build $MAKEJOBS
