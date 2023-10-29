if [ ! -z "$(id nginx)" ]; then
	userdel nginx
fi
if [ ! -z "$(getent group nginx)" ]; then
	groupdel -f nginx
fi
