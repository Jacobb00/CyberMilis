cd $SRC
milis-meson pulseaudio-$surum build \
-D pulsedsp-location='/usr/lib/pulseaudio' \
-D stream-restore-clear-old-devices=true \
-D udevrulesdir=/usr/lib/udev/rules.d \
-Dvalgrind=disabled \
-Ddatabase=gdbm \
-Dasyncns=disabled \
-Dsystemd=disabled \
-Delogind=disabled  \
-Dtcpwrap=disabled \
-Dx11=disabled \
-Dfftw=disabled \
-Djack=disabled \
-Dlirc=disabled \
-Dwebrtc-aec=disabled \
-Dtests=false \
-Ddoxygen=false \
-Dbluez5-gstreamer=disabled \
-Dgtk=disabled 
meson compile -C build
