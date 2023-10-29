_bashconfig=(-DDEFAULT_PATH_VALUE=\'\"/usr/local/sbin:/usr/local/bin:/usr/bin\"\'
-DSTANDARD_UTILS_PATH=\'\"/usr/bin\"\'
-DSYS_BASHRC=\'\"/etc/bash.bashrc\"\'
-DSYS_BASH_LOGOUT=\'\"/etc/bash.bash_logout\"\'
-DNON_INTERACTIVE_LOGIN_SHELLS)
export CFLAGS="${CFLAGS} ${_bashconfig[@]}"

./configure --prefix=/usr \
--with-curses \
--enable-readline \
--without-bash-malloc \
--with-installed-readline
make
make check
