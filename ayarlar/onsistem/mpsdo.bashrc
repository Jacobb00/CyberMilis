set +h
umask 022
MILIS_HOME="/opt"
MILIS_REPO="$MILIS_HOME/milis23"
MPS_PATH="$MILIS_HOME/mps23"
ONSISTEM_CHROOT="$MILIS_HOME/onsistem"
TALIMATNAME="$MILIS_REPO/talimatname"
MPS_NOROOT="yes"
LC_ALL=C
ONSISTEM_TARGET=x86_64-milis-linux-gnu
PATH=$MPS_PATH/static:$MPS_PATH/bin:/tools/bin:/tools/sbin:/usr/local/bin:/bin:/sbin:/usr/sbin:/usr/bin:/root/bin:/usr/milis/bin:/usr/bin/core_perl
export ONSISTEM_CHROOT LC_ALL ONSISTEM_TARGET PATH MILIS_HOME MILIS_REPO MPS_PATH TALIMATNAME MPS_NOROOT
