export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
export LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib
#export PATH=$PATH:$PKG/usr/bin
export XDG_DATA_DIRS="/usr/share/:/usr/locale/share/:$PKG/usr/share/"
export CFLAGS="$CFLAGS -I$PKG/usr/include/gstreamer-1.0"
export CPPFLAGS=$CFLAGS

# gst-plugins good-bad
cd $SRC/gst-plugins-good-$surum

good_opt=(
-Ddoc=disabled
-Drpicamsrc=disabled 
-Daalib=disabled 
-Dlibcaca=disabled
-Dqt5=disabled
-Dqt6=disabled
)

meson setup \
  --prefix         /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
. ../build-good "${good_opt[@]}"

meson configure ../build-good
meson compile -C ../build-good
DESTDIR=$PKG ninja -C ../build-good install
#   --wrap-mode     nodownload \


cd $SRC/gst-plugins-bad-$surum

bad_opt=(
-D gpl=enabled
-D doc=disabled
-D wpe=disabled
-D opencv=disabled
-D webrtc=disabled
-D msdk=disabled
-D curl-ssh2=disabled
-D ladspa=disabled
-D musepack=disabled
-D teletext=disabled
-D zxing=disabled
-D zbar=disabled
-D amfcodec=disabled
-D directfb=disabled
-D directshow=disabled
-D directsound=disabled
-D flite=disabled
-D gs=disabled
-D iqa=disabled
-D isac=disabled
-D magicleap=disabled
-D onnx=disabled
-D openh264=disabled
-D openni2=disabled
-D opensles=disabled
-D tinyalsa=disabled
-D voaacenc=disabled
-D voamrwbenc=disabled
-D wasapi2=disabled
-D wasapi=disabled
-D wic=disabled
-D win32ipc=disabled
)

meson setup \
  --prefix         /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
. ../build-bad "${bad_opt[@]}"

meson configure ../build-bad
meson compile -C ../build-bad
DESTDIR=$PKG ninja -C ../build-bad install
#   --wrap-mode     nodownload \

########

cd $SRC/gst-editing-services-$surum

edit_options=(
-D doc=disabled
-D validate=disabled
-D bash-completion=disabled
)

meson setup \
  --prefix         /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
  --wrap-mode     nodownload \
. ../build-edit "${edit_options[@]}"

meson configure ../build-edit
meson compile -C ../build-edit
DESTDIR=$PKG ninja -C ../build-edit install

########

cd $SRC/gst-libav-$surum

libav_options=(
-D doc=disabled
-D tests=disabled
)

meson setup \
  --prefix        /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
  --wrap-mode     nodownload \
. ../build-libav "${libav_options[@]}"

meson configure ../build-libav
meson compile -C ../build-libav
DESTDIR=$PKG ninja -C ../build-libav install

########

cd $SRC/gstreamer-vaapi-$surum

vaapi_options=(
-D doc=disabled
-D tests=disabled
-D examples=disabled
)

meson setup \
  --prefix        /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
  --wrap-mode     nodownload \
. ../build-vaapi "${vaapi_options[@]}"

meson configure ../build-vaapi
meson compile -C ../build-vaapi
DESTDIR=$PKG ninja -C ../build-vaapi install

########

cd $SRC/gst-rtsp-server-$surum

rtsp_options=(
-D doc=disabled
-D tests=disabled
)

meson setup \
  --prefix        /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
  --wrap-mode     nodownload \
. ../build-rtsp "${rtsp_options[@]}"

meson configure ../build-rtsp
meson compile -C ../build-rtsp
DESTDIR=$PKG ninja -C ../build-rtsp install
