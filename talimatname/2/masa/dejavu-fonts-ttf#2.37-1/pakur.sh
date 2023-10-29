install -dm755 "${PKG}"/etc/fonts/conf.avail
install -dm755 "${PKG}"/etc/fonts/conf.d
install -dm755 "${PKG}"/usr/share/fonts/TTF

cd "${SRC}"/$isim-$surum
install -m644 ttf/*.ttf "${PKG}"/usr/share/fonts/TTF/
install -m644 fontconfig/*.conf "${PKG}"/etc/fonts/conf.avail/

pushd "${PKG}"/etc/fonts/conf.avail
for config in *; do
ln -sf ../conf.avail/${config} ../conf.d/${config}
done
popd
