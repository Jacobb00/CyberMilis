# git clone https://code.qt.io/qt/qtwebengine /sources/qtwebengine
# git clone https://code.qt.io/qt/qtwebengine-chromium /sources/qtwebengine-chromium

cd $SRC

cp -r /sources/qtwebengine qtwebengine
cd qtwebengine
git checkout $surum
git pull
cd -

cp -r /sources/qtwebengine-chromium $SRC/
cd qtwebengine-chromium
git pull
cd -

cd qtwebengine
git submodule init
git submodule set-url src/3rdparty $SRC/qtwebengine-chromium
git -c protocol.file.allow=always submodule update
cd -

LC_ALL=C cmake -B build -S qtwebengine -G Ninja \
-D QT_USE_CCACHE=ON \
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS \
-DCMAKE_TOOLCHAIN_FILE=/usr/lib/cmake/Qt6/qt.toolchain.cmake \
-DQT_FEATURE_webengine_system_ffmpeg=ON \
-DQT_FEATURE_webengine_system_icu=ON \
-DQT_FEATURE_webengine_system_libevent=ON \
-DQT_FEATURE_webengine_proprietary_codecs=ON \
-DQT_FEATURE_webengine_kerberos=ON \
-DQT_FEATURE_webengine_webrtc_pipewire=ON
cmake --build build $MAKEJOBS
