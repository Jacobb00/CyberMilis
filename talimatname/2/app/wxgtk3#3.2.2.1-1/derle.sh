cd $SRC
cmake -B build-gtk3 -S wxWidgets-$surum \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=None \
-DwxBUILD_TOOLKIT=gtk3 \
-DwxUSE_OPENGL=ON \
-DwxUSE_REGEX=sys \
-DwxUSE_ZLIB=sys \
-DwxUSE_EXPAT=sys \
-DwxUSE_LIBJPEG=sys \
-DwxUSE_LIBPNG=sys \
-DwxUSE_LIBTIFF=sys \
-DwxUSE_LIBLZMA=sys \
-DwxUSE_LIBMSPACK=OFF \
-DwxUSE_PRIVATE_FONTS=ON \
-DwxUSE_GTKPRINT=ON

cmake --build build-gtk3

cd wxWidgets-$surum
./configure --prefix=/usr
