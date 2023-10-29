./configure $CONF_OPT \
--with-vardir=/var/db/sudo \
--docdir=/usr/share/doc/sudo-$surum \
--with-all-insults \
--with-logfac=auth \
--with-env-editor \
--with-pam \
--without-sendmail \
--with-passprompt="[sudo] password/şifre for %p: "

make
