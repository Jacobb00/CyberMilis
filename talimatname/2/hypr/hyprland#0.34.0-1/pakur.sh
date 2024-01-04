find src -name '*.hpp' -exec install -Dm0644 {} "$PKG/usr/include/hyprland/{}" \;
pushd subprojects/wlroots/include
find . -name '*.h' -exec install -Dm0644 {} "$PKG/usr/include/hyprland/wlroots/{}" \;
popd
pushd subprojects/wlroots/build/include
find . -name '*.h' -exec install -Dm0644 {} "$PKG/usr/include/hyprland/wlroots/{}" \;
popd
mkdir -p "$PKG/usr/include/hyprland/protocols"
cp protocols/*-protocol.h "$PKG/usr/include/hyprland/protocols"
pushd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
popd
install -Dm0644 -t "$PKG/usr/share/pkgconfig" build/hyprland.pc
install -Dm0755 -t "$PKG/usr/bin" build/Hyprland
install -Dm0755 -t "$PKG/usr/bin" hyprctl/hyprctl
install -Dm0644 -t "$PKG/usr/share/$isim" assets/*.png
install -Dm0644 -t "$PKG/usr/share/wayland-sessions" "example/$isim.desktop"
install -Dm0644 -t "$PKG/usr/share/$isim" "example/$isim.conf"
install -Dm0755 -t "$PKG/usr/lib" "$SRC/tmpwlr/lib/libwlroots.so.13032"
