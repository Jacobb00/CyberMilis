export MESON_PACKAGE_CACHE_DIR="$SRC"

cd $SRC/mesa-$surum

CFLAGS+=' -g1'
CXXFLAGS+=' -g1'

# mesa
milis-meson build \
-D b_lto=true \
-D b_ndebug=true \
-D android-libbacktrace=disabled \
-D platforms=x11,wayland \
-D gallium-drivers=i915,r300,r600,radeonsi,nouveau,virgl,svga,swrast,iris,crocus,zink \
-D vulkan-drivers=amd,intel,intel_hasvk,swrast,virtio,nouveau-experimental \
-D vulkan-layers=device-select,intel-nullhw,overlay \
-D dri3=enabled \
-D egl=enabled \
-D gallium-extra-hud=true \
-D gallium-nine=true \
-D gallium-omx=bellagio \
-D gallium-opencl=icd \
-D gallium-va=enabled \
-D gallium-vdpau=enabled \
-D gallium-xa=enabled \
-D gbm=enabled \
-D gles1=disabled \
-D gles2=enabled \
-D glvnd=true \
-D glx=dri \
-D libunwind=enabled \
-D llvm=enabled \
-D lmsensors=enabled \
-D osmesa=true \
-D shared-glapi=enabled \
-D microsoft-clc=disabled \
-D valgrind=disabled \
-D video-codecs=all

ninja -C build $MAKEJOBS
DESTDIR=$PKG ninja -C build install
