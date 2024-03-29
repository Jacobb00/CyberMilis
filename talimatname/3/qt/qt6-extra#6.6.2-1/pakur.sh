# qt5-tool
cd $SRC/qttools/build
make INSTALL_ROOT=${PKG} install

# Add menu entries for all those hidden but great Qt applications:
# # Qt5 logo:
install -d $PKG/usr/share/icons/hicolor/48x48/apps
# requires imagemagick
#convert qtdoc/doc/src/images/qt-logo.png  -resize 48x48 $PKG/usr/share/icons/hicolor/48x48/apps/qt5-logo.png
install -m 0644 $SRC/qt5-logo.png $PKG/usr/share/icons/hicolor/48x48/apps/qt5-logo.png

# Assistant icons
install -m 0644 -D $SRC/qttools/src/assistant/assistant/images/assistant.png \
	$PKG/usr/share/icons/hicolor/32x32/apps/qt5-assistant.png
install -m 0644 -D $SRC/qttools/src/assistant/assistant/images/assistant-128.png \
	$PKG/usr/share/icons/hicolor/128x128/apps/qt5-assistant.png

# Designer icon
install -m 0644 -D $SRC/qttools/src/designer/src/designer/images/designer.png \
	$PKG/usr/share/icons/hicolor/128x128/apps/qt5-designer.png

# QDbusViewer icons
install -m 0644 $SRC/qttools/src/qdbus/qdbusviewer/images/qdbusviewer.png \
	$PKG/usr/share/icons/hicolor/32x32/apps/qt5-qdbusviewer.png
install -m 0644 $SRC/qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
	$PKG/usr/share/icons/hicolor/128x128/apps/qt5-qdbusviewer.png

# Linguist icons
for icon in $SRC/qttools/src/linguist/linguist/images/icons/linguist-*-32.png ; do
	size=$(echo $(basename ${icon}) | cut -d- -f2)
	install -m 0644 -D ${icon} $PKG/usr/share/icons/hicolor/${size}x${size}/apps/qt5-linguist.png
done

	# And the .desktop files too:
	install -d $PKG/usr/share/applications
	cat <<EOF > $PKG/usr/share/applications/qt5-designer.desktop
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=designer-qt5
Icon=qt5-designer
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
	cat <<EOF > $PKG/usr/share/applications/qt5-assistant.desktop
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=assistant-qt5
Icon=qt5-assistant
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF
	cat <<EOF > $PKG/usr/share/applications/qt5-linguist.desktop
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=linguist-qt5
Icon=qt5-linguist
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
	cat <<EOF > $PKG/usr/share/applications/qt5-qdbusviewer.desktop
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=Qt5 D-Bus Debugger
Comment=Debug D-Bus applications
Exec=qdbusviewer-qt5
Icon=qt5-qdbusviewer
Terminal=false
Type=Application
Categories=Qt;Development;Debugger;
EOF



# qt5-plugins
for pk in qtsvg qtquickcontrols qtquickcontrols2 qtscript qtwayland qtlocation qtwebchannel qtxmlpatterns qtwebsockets qtgraphicaleffects qtconnectivity qtcharts qtserialport;do
	cd $SRC/${pk}/build
	make INSTALL_ROOT=${PKG} install
done

# genel link işleri

for b in "$PKG"/usr/bin/*; do
	ln -s $(basename $b) "$PKG"/usr/bin/$(basename $b)-qt5
done

# Drop QMAKE_PRL_BUILD_DIR because reference the build dir
find "$PKG/usr/lib" -type f -name '*.prl' \
-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
