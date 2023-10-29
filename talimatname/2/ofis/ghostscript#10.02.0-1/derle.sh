# force it to use system libs.
rm -rf tesseract leptonica
rm -rf cups/libs expat freetype jpeg lcms2mt libpng openjpeg tiff zlib ijs  #jbig2dec

# jbig2dec, ijs arsiv kullan
mv ../ijs-0.35 ijs

rm -rf gpdl

# Remove internal CMaps (CMaps from poppler-data are used instead)
rm -r Resource/CMap

# build jbig2dec
cd jbig2dec
./autogen.sh
./configure --prefix=/usr && make ${MAKEJOBS}
cd ..

# build libijs
cd ijs
./configure ${CONF_OPT} --enable-shared --disable-static
make ${MAKEJOBS}
rm -rf *.la
cd ..

 ./configure --prefix=/usr \
--with-ijs \
--with-jbig2dec \
--with-x \
--with-drivers=ALL \
--with-fontpath=/usr/share/fonts/gsfonts \
--without-versioned-path \
--enable-fontconfig \
--enable-freetype \
--enable-openjpeg \
--with-system-libtiff \
--with-libpaper \
--disable-compile-inits #--help # needed for linking with system-zlib

# build ghostscript
make ${MAKEJOBS} so
