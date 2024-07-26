cd $SRC/glew-2.2.0

patch -Np1 -i $SRC/glew-install.patch
patch -Np1 -i $SRC/egl+glx.patch
  
sed -i 's|lib64|lib|' config/Makefile.linux
sed -i '/^.PHONY: .*\.pc$/d' Makefile
echo "CFLAGS.EXTRA += -I$PKG/usr/include" >> config/Makefile.linux

make STRIP= glew.bin
mv bin/glewinfo bin/glxewinfo
rm glew.pc

make STRIP= SYSTEM=linux-egl glew.lib.shared bin/glewinfo
mv bin/glewinfo bin/eglewinfo

make GLEW_DEST="$PKG/usr" STRIP= SYSTEM=linux-egl install
install -D -m755 -t "$PKG/usr/bin" bin/eglewinfo bin/glxewinfo bin/visualinfo
ln -s eglewinfo "$PKG/usr/bin/glewinfo"
  
