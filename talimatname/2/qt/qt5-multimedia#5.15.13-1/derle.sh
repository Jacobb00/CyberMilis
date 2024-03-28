# qt5-qtmultimedia
cd $SRC
mv qtmultimedia-* qtmultimedia;cd qtmultimedia
mkdir build;cd build
qmake ../
make $MAKEJOBS
