export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
export LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib
export PATH=$PATH:$PKG/usr/bin
export XDG_DATA_DIRS="/usr/share/:/usr/locale/share/:$PKG/usr/share/"
export CFLAGS="$CFLAGS -I$PKG/usr/include/orc-0.4"
export CFLAGS="$CFLAGS -I$PKG/usr/include/gstreamer-1.0"
export CPPFLAGS=$CFLAGS

cd $SRC/gstreamer-$surum

options=(
-D doc=disabled
-D dbghelp=disabled
-D bash-completion=disabled
#-D ptp-helper=disabled
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
. ../build-gst "${options[@]}"

meson configure ../build-gst
meson compile -C ../build-gst
DESTDIR=$PKG ninja -C ../build-gst install

########

cd $SRC/gst-plugins-base-$surum

base_options=(
-D doc=disabled
-D qt5=disabled
-D libvisual=disabled
-D tremor=disabled
-D tests=disabled
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
. ../build-base "${base_options[@]}"

meson configure ../build-base
meson compile -C ../build-base
DESTDIR=$PKG ninja -C ../build-base install
