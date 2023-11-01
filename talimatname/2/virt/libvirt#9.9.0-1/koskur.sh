if [ -z "`getent passwd libvirt`" ]; then
	/usr/bin/useradd -r -g kvm -d /etc/libvirt -s /bin/false -c "libvirt user" libvirt
	/usr/bin/passwd -l libvirt
fi
