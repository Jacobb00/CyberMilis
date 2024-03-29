# qt5-qttranslations
cd $SRC
mv qttranslations-* qttranslations;cd qttranslations
mkdir build;cd build
qmake ../
make $MAKEJOBS
