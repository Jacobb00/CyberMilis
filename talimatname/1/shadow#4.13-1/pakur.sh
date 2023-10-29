make DESTDIR=$PKG install

sed -i 's/yes/no/' $PKG/etc/default/useradd
sed -i 's/GROUP/# GROUP/' $PKG/etc/default/useradd
	
	# Following sed comment appropriate lines in etc/login.defs, and stop login
# from performing these functions. First backup the etc/login.defs
install -v -m644 $PKG/etc/login.defs{,.orig}
for FUNCTION in FAIL_DELAY FAILLOG_ENAB \
                LASTLOG_ENAB \
                MAIL_CHECK_ENAB \
                OBSCURE_CHECKS_ENAB \
                PORTTIME_CHECKS_ENAB \
                QUOTAS_ENAB \
                CONSOLE MOTD_FILE \
                FTMP_FILE NOLOGINS_FILE \
                ENV_HZ PASS_MIN_LEN \
                SU_WHEEL_ONLY \
                CRACKLIB_DICTPATH \
                PASS_CHANGE_TRIES \
                PASS_ALWAYS_WARN \
                CHFN_AUTH ENCRYPT_METHOD \
                ENVIRON_FILE
do
    sed -i "s/^${FUNCTION}/# &/" $PKG/etc/login.defs
done

#
# Configuration files for pam
mkdir -p $PKG/etc/pam.d
cat > $PKG/etc/pam.d/system-account << "EOF"
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > $PKG/etc/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > $PKG/etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password  required    pam_pwhistory.so  retry=3
password  required    pam_unix.so       sha512 shadow try_first_pass

# End /etc/pam.d/system-password
EOF

cat > $PKG/etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so
session   optional    pam_loginuid.so
session   optional    pam_ck_connector.so nox11

# Systemd additions
session   required    pam_loginuid.so
session    optional    pam_systemd.do

# End /etc/pam.d/system-session
EOF

cat > $PKG/etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login

# Set failure delay before next prompt to 3 seconds
auth      optional    pam_faildelay.so  delay=3000000

# Check to make sure that the user is allowed to login
auth      requisite   pam_nologin.so

# Check to make sure that root is allowed to login 
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth      required    pam_securetty.so

# Additional group memberships - disabled by default
#auth      optional    pam_group.so

# include the default auth settings
auth      include     system-auth

# check access for the user
account   required    pam_access.so

# include the default account settings
account   include     system-account

# Set default environment variables for the user
session   required    pam_env.so

# Set resource limits for the user
session   required    pam_limits.so

# Display date of last login - Disabled by default
#session   optional    pam_lastlog.so

# Display the message of the day - Disabled by default
#session   optional    pam_motd.so

# Check user's mail - Disabled by default
#session   optional    pam_mail.so      standard quiet

# include the default session and password settings
session   include     system-session
password  include     system-password

# End /etc/pam.d/login
EOF

cat > $PKG/etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd

password  include     system-password

# End /etc/pam.d/passwd
EOF

cat > $PKG/etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su

# always allow root
auth      sufficient  pam_rootok.so
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/su
EOF

cat > $PKG/etc/pam.d/chage << "EOF"
#Begin /etc/pam.d/chage

# always allow root
auth      sufficient  pam_rootok.so

# include system defaults for auth account and session
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so

# End /etc/pam.d/chage
EOF

for PROGRAM in chfn chgpasswd chpasswd chsh groupadd groupdel \
               groupmems groupmod newusers useradd userdel usermod
do
    install -v -m644 $PKG/etc/pam.d/chage $PKG/etc/pam.d/${PROGRAM}
    sed -i "s/chage/$PROGRAM/" $PKG/etc/pam.d/${PROGRAM}
done

# Backup others
[ -f $PKG/pam.d/other ] && install -v -m644 $PKG/etc/pam.d/other{,.orig}

# Other 
#
cat > $PKG/etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF

rm $PKG/usr/share/man/man8/nologin.8
rm -f $PKG/etc/limits
rm -f $PKG/etc/login.access
mv $PKG/usr/sbin/* $PKG/usr/bin/
rm -rf $PKG/usr/sbin
