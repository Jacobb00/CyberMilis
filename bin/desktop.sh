#!/bin/sh

# xdg-runtime-dir ayarı
export XDG_RUNTIME_DIR=/tmp/runtime-$UID
mkdir -p $XDG_RUNTIME_DIR
chown $UID:$UID $XDG_RUNTIME_DIR 
chmod 700 $XDG_RUNTIME_DIR

# varsayılan export değerleri
export XKB_DEFAULT_LAYOUT="tr"
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
# waybar tray destek
export XDG_CURRENT_DESKTOP=Unity
 
# drm_kms_helper kontrolü
#drmkms=`lsmod | grep drm_kms_helper | head -n1 | awk '{print $4}' | cut -d, -f1`
#[ "${drmkms}" == "qxl" ] && 
export WLR_RENDERER_ALLOW_SOFTWARE=1

# fare imleci gözükmeme sorun tamiri
[ -f /sys/class/dmi/id/board_name ] && [[ $(cat /sys/class/dmi/id/board_name) =~ VirtualBox|PAV10 ]] && export WLR_NO_HARDWARE_CURSORS=1


mkdir -p ~/.config


