make DESTDIR="$PKG" install

# install libRmath.so
  cd src/nmath/standalone
  make DESTDIR="$PKG" install

# Fixup R wrapper scripts.
  sed -i "s|$PKG ||" "${PKG}/usr/bin/R"
  rm "$PKG"/usr/lib/R/bin/R
  cd "$PKG"/usr/lib/R/bin
  ln -s ../../../bin/R

# move the config directory to /etc and create symlinks
  install -d "$PKG"/etc/R
  cd "$PKG"/usr/lib/R/etc
  for _i in *; do
    mv -f $_i "$PKG"/etc/R
    ln -s /etc/R/$_i $_i
  done

# Install ld.so.conf.d file to ensure other applications access the shared lib
  install -Dm644 "$SRC"/R.conf -t "$PKG"/etc/ld.so.conf.d

# Add provides for bundled packages
  for _f in "$PKG"/usr/lib/R/library/*/DESCRIPTION; do
    _pkg=$(grep '^Package:' $_f | cut -d' ' -f2)
    _ver=$(grep '^Version:' $_f | cut -d' ' -f2)
    _prov="r-${_pkg,,}=${_ver//-/.}"
    provides+=($_prov)
  done
