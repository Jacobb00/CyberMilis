CFLAGS+=" -ffat-lto-objects" \
CXXFLAGS+=" -ffat-lto-objects" \
./configure  --prefix=/usr \
--libdir=/usr/lib \
--sysconfdir=/etc/R \
--datarootdir=/usr/share \
rsharedir=/usr/share/R/ \
rincludedir=/usr/include/R/ \
rdocdir=/usr/share/doc/R/ \
--without-x \
--enable-R-shlib \
--enable-memory-profiling \
--with-lapack \
--with-blas \
F77=gfortran \
LIBnn=lib
make
cd src/nmath/standalone
make shared
