#!/bin/bash
# kullanıcı dizinlerinin kontrolü ve yerel dile göre kurulması.

dil=$(echo `servis oku locale.language`| cut -d_ -f1)

user_file="/etc/skel/.config/en-user-dirs.dirs"

[ -f /etc/skel/.config/${dil}-user-dirs.dirs ] && user_file="/etc/skel/.config/${dil}-user-dirs.dirs"

if [ -f ${user_file} ];then
	cp ${user_file} ~/.config/user-dirs.dirs
	for dznstr in `envsubst < ${user_file}`;do
		dzn=`echo $dznstr|cut -d= -f2|tr -d '"'`
		[ ! -d ${dzn} ] && install -dm755 ${dzn}
	done
fi


