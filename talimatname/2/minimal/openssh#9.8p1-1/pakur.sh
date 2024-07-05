make DESTDIR=$PKG install

if [ -f /etc/pam.d/login ]; then
	mkdir -p $PKG/etc/pam.d
	sed 's@d/login@d/sshd@g' /etc/pam.d/login > $PKG/etc/pam.d/sshd
	chmod 644 $PKG/etc/pam.d/sshd
fi
install -Dm755 contrib/findssl.sh $PKG/usr/bin/findssl.sh
install -v -m755 contrib/ssh-copy-id $PKG/usr/bin
install -v -m644 contrib/ssh-copy-id.1 $PKG/usr/share/man/man1

rm -rf $PKG/var
