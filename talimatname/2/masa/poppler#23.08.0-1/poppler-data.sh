cd $SRC/poppler-data-0.4.12
make prefix=/usr DESTDIR=${PKG} install

# additional cMaps for ghostscript - FS#76416
cp ../poppler-data-poppler-data-0.4.11-2-extra/Identity-* ${PKG}/usr/share/poppler/cMap

# add symlinks to cMaps - FS#76565
pushd ${PKG}/usr/share/poppler/cMap
find ../cMap -type f -exec ln -s {} . \;
popd
