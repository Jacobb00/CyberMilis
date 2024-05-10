#!/bin/sh

# xdg-runtime-dir ayarı
mkdir -p $XDG_RUNTIME_DIR
chown $UID:$UID $XDG_RUNTIME_DIR 
chmod 700 $XDG_RUNTIME_DIR

# varsayılan export değerleri
export XKB_DEFAULT_LAYOUT=`servis oku system.keyboard`
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

# tekli varsayılan ayarlar
[ ! -f ~/.config/user-dirs.dirs ] && user-dirs.sh
[ ! -f ~/.config/wayfire.ini ]   && cp /etc/skel/.config/wayfire.ini ~/.config/
#[ ! -f ~/.config/wf-shell.ini ]  && cp /etc/skel/.config/wf-shell.ini ~/.config/
[ ! -f ~/.bashrc ]  && cp /etc/skel/.bashrc ~/
[ -f /etc/skel/.config/mimeapps.list ] && [ ! -f ~/.config/mimeapps.list ]  && cp /etc/skel/.config/mimeapps.list ~/.config/

# dizinli varsayılan ayarlar
for cdir in waybar nwg-launchers gtk-3.0 geany fnott lxterminal libfm
do
    [ -d /etc/skel/.config/${cdir} ] && [ ! -d ~/.config/${cdir} ] && cp -rf /etc/skel/.config/${cdir} ~/.config/
    [ "$cdir" = "waybar" ] && waybar_fix.sh
done


[ ! -f ~/.config/nwg-launchers/nwgbar/bar.json ] && 
[ -f /etc/skel/.config/nwg-launchers/nwgbar/bar-${LANG}.json ] &&
ln -s /etc/skel/.config/nwg-launchers/nwgbar/bar-${LANG}.json ~/.config/nwg-launchers/nwgbar/bar.json

# Milis uygulamaları desktop dosya kontrolü
desktop_list="/usr/milis/ayarlar/uygulama/desktop.list"
user_app_dir=".local/share/applications"
if [ -f ${desktop_list} ];then
    for dosya in `cat ${desktop_list}`;do
      if [ -f $dosya ];then 
	      mkdir -p ~/${user_app_dir}
	      cp -f $dosya ~/${user_app_dir}/
      fi
      bdosya=`basename $dosya`
      [ ! -f $dosya ] && [ -f ~/${user_app_dir}/${bdosya} ] && rm -f ~/${user_app_dir}/${bdosya}
    done
fi
