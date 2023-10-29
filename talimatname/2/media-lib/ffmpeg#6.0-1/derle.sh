install -dm 755 $PKG/usr/include
cp -dr --no-preserve=ownership $SRC/AMF-1.4.30/amf/public/include $PKG/usr/include/AMF
export  CFLAGS="$CFLAGS -I$PKG/usr/include"

patch -Np1 -i $SRC/binutils241-ffmpeg.patch
patch -Np1 -i $SRC/add-av_stream_get_first_dts-for-chromium.patch

./configure \
--prefix='/usr' \
--disable-debug \
--disable-static \
--disable-stripping \
--enable-fontconfig \
--enable-gmp \
--enable-gnutls \
--enable-gpl \
--enable-amf \
--enable-ladspa \
--enable-libaom \
--enable-libass \
--enable-libbluray \
--enable-libdav1d \
--enable-libdrm \
--enable-libfreetype \
--enable-libfribidi \
--enable-libgsm \
--enable-libiec61883 \
--enable-libjack \
--enable-libpulse \
--enable-libbs2b \
--enable-libmodplug \
--enable-libmp3lame \
--enable-libopencore_amrnb \
--enable-libopencore_amrwb \
--enable-libopenjpeg \
--enable-libopus \
--enable-libsoxr \
--enable-libspeex \
--enable-librav1e \
--enable-libssh \
--enable-libsrt \
--enable-libtheora \
--enable-libv4l2 \
--enable-libvidstab \
--enable-libvorbis \
--enable-libvpx \
--enable-libwebp \
--enable-libx264 \
--enable-libx265 \
--enable-libxcb \
--enable-libxml2 \
--enable-libxvid \
--disable-nvdec \
--disable-nvenc \
--enable-omx \
--enable-shared \
--enable-libsvtav1 \
--enable-version3

make $MAKEJOBS
make tools/qt-faststart


