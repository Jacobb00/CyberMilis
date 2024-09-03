cd $SRC/hyprland-source
find src \( -name '*.h' -o -name '*.hpp' \) -exec install -Dm0644 {} "$PKG/usr/include/hyprland/{}" \;
pushd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
popd
install -Dm0644 -t "$PKG/usr/share/pkgconfig" build/hyprland.pc
install -Dm0755 -t "$PKG/usr/bin/" build/Hyprland build/hyprctl/hyprctl build/hyprpm/hyprpm
install -Dm0644 -t "$PKG/usr/share/$isim/" assets/*.png
install -Dm0644 -t "$PKG/usr/share/wayland-sessions/" "example/$isim.desktop"
install -Dm0644 -t "$PKG/usr/share/$isim/" "example/$isim.conf"
