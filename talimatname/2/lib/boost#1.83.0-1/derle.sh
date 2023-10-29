_boostver=${surum//./_}

export _stagedir="${SRC}/stagedir"

cd $SRC/${isim}_${_boostver}

# https://github.com/boostorg/phoenix/issues/111
patch -Np1 -i ../boost-1.81.0-phoenix-multiple-definitions.patch

# https://github.com/boostorg/signals2/issues/68
# https://github.com/boostorg/function/issues/46
patch -Np2 -i <(sed 's#test/#asd/libs/function/test/#' \
 /sources/$isim-support-fn.contains-f-where-f-is-a-function.patch)

# https://github.com/boostorg/ublas/pull/97
patch -Np2 -i /sources/$isim-ublas-c++20-iterator.patch

./bootstrap.sh \
 --with-toolset=gcc \
 --with-icu \
 --with-python=/usr/bin/python3 \

install -Dm755 tools/build/src/engine/b2 "${_stagedir}"/bin/b2

# boostbook is needed by quickbook
install -dm755 "${_stagedir}"/share/boostbook
cp -a tools/boostbook/{xsl,dtd} "${_stagedir}"/share/boostbook/

# default "minimal" install: "release link=shared,static
# runtime-link=shared threading=single,multi"
# --layout=tagged will add the "-mt" suffix for multithreaded libraries
# and installs includes in /usr/include/boost.
# --layout=system no longer adds the -mt suffix for multi-threaded libs.
# install to ${_stagedir} in preparation for split packaging
"${_stagedir}"/bin/b2 \
  variant=release \
  debug-symbols=off \
  threading=multi \
  runtime-link=shared \
  link=shared,static \
  toolset=gcc \
  python=3.11 \
  cflags="$CPPFLAGS $CFLAGS -fPIC -O3 -ffat-lto-objects" \
  cxxflags="$CPPFLAGS $CXXFLAGS -fPIC -O3 -ffat-lto-objects" \
  linkflags="${LDFLAGS}" \
  --layout=system \
  ${MAKEJOBS} \
  \
  --prefix="${_stagedir}" \
  install
