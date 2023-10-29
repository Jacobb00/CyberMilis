configure_options=(
    --prefix=/usr
    --enable-builtin-atomics
    --disable-memchecker
    --enable-mpi-cxx
    --enable-mpi-fortran=all
    --enable-pretty-print-stacktrace
    --libdir=/usr/lib
    --sysconfdir=/etc/openmpi
    --with-hwloc=internal
    --with-libevent=external
    --with-pmix=external
    --without-valgrind
)
./configure "${configure_options[@]}"
# prevent excessive overlinking due to libtool
sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make V=1
