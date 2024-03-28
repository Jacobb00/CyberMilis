# qt5-declarative
cd $SRC
mv qtdeclarative-* qtdeclarative;cd qtdeclarative
mkdir build;cd build
qmake ../ CONFIG+=fat-static-lto
make $MAKEJOBS
