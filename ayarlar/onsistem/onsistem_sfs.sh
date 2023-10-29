#!/bin/bash

hata_olustu(){
	if [ ! -z "$1" ];then 
		echo "$1"
		exit 1
	fi
}

# Ön sistemin sıkıştırılmadan önce hatalarının kontrolü
#grep -l 'compilation terminated' /tmp/*.log
#grep -l '.h: No such file or directory' /tmp/*.log

[ -z $ONSISTEM_CHROOT ] && hata_olustu "ONSISTEM_CHROOT tanmlı değil!"
mksquashfs $ONSISTEM_CHROOT ${MILIS_HOME}/onsistem-$(date --utc +"%F_%H-%M").sfs -comp xz
mksquashfs /tmp/*.log ${MILIS_HOME}/onsistem-$(date --utc +"%F_%H-%M").log.sfs -comp xz
