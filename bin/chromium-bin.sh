#!/bin/sh
if [ -d /usr/share/chromium ];then
	/usr/share/chromium/chrome --enable-features=UseOzonePlatform  --ozone-platform=wayland
else
	echo "mps kur chromium-bin"
	exit 1
fi
