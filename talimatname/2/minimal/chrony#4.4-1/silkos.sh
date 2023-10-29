if [ ! -z "$(id chrony)" ]; then
	userdel chrony
fi
if [ ! -z "$(getent group chrony)" ]; then
	groupdel -f chrony
fi
