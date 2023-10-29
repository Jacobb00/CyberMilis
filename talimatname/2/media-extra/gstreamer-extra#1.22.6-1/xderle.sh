# gst-plugins good-bad
cd $SRC/gstreamer-main

meson_options=(
    # Superproject options
    -D devtools=disabled
    -D doc=disabled
    -D examples=disabled
    -D gobject-cast-checks=disabled
    -D gpl=enabled
    -D gst-examples=disabled
    -D libnice=disabled
    -D qt5=disabled
    -D qt6=disabled
    -D orc=disabled
    -D base=enabled
    -D good=enabled
    -D bad=enabled
    -D ugly=disabled
    -D libav=enabled
    -D vaapi=enabled
    # bad
    -D gstreamer:bash-completion=disabled
    -D gstreamer:dbghelp=disabled
    -D gstreamer:ptp-helper=disabled    
    #-D gstreamer:ptp-helper-permissions=capabilities
    -D gst-plugins-good:rpicamsrc=disabled
    -D gst-plugins-good:aalib=disabled
    -D gst-plugins-good:libcaca=disabled
    -D gst-plugins-bad:opencv=disabled
    -D gst-plugins-bad:webrtc=disabled
    -D gst-plugins-bad:msdk=disabled
    -D gst-plugins-bad:curl-ssh2=disabled
    -D gst-plugins-bad:ladspa=disabled
    -D gst-plugins-bad:musepack=disabled
    -D gst-plugins-bad:qt6d3d11=disabled
    -D gst-plugins-bad:teletext=disabled
    -D gst-plugins-bad:zxing=disabled
    -D gst-plugins-bad:zbar=disabled
    -D gst-plugins-bad:lc3=disabled
    -D gst-plugins-bad:amfcodec=disabled
    -D gst-plugins-bad:directfb=disabled
    -D gst-plugins-bad:directshow=disabled
    -D gst-plugins-bad:directsound=disabled
    -D gst-plugins-bad:flite=disabled
    -D gst-plugins-bad:gs=disabled
    -D gst-plugins-bad:iqa=disabled
    -D gst-plugins-bad:isac=disabled
    -D gst-plugins-bad:magicleap=disabled
    -D gst-plugins-bad:onnx=disabled
    -D gst-plugins-bad:openh264=disabled
    -D gst-plugins-bad:openni2=disabled
    -D gst-plugins-bad:opensles=disabled
    -D gst-plugins-bad:tinyalsa=disabled
    -D gst-plugins-bad:voaacenc=disabled
    -D gst-plugins-bad:voamrwbenc=disabled
    -D gst-plugins-bad:wasapi2=disabled
    -D gst-plugins-bad:wasapi=disabled
    -D gst-plugins-bad:wic=disabled
    -D gst-plugins-bad:win32ipc=disabled
    -D gst-plugins-ugly:sidplay=disabled
    -D gst-editing-services:validate=disabled
    -D gst-editing-services:bash-completion=disabled

    -D gst-plugins-base:tremor=disabled
    -D gst-plugins-base:libvisual=disabled
)
pip3 install gitlint
meson setup \
  --prefix         /usr \
  --libexecdir    lib \
  --sbindir       bin \
  --buildtype     plain \
  --auto-features enabled \
  -D              b_lto=true \
  -D              b_pie=true \
. ../build "${meson_options[@]}"

meson configure ../build
meson compile -C ../build
#   --wrap-mode     nodownload \
