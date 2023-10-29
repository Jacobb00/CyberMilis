cd /opt
git clone https://github.com/choff/anbox-modules
cd anbox-modules/binder;make
mkdir -p /usr/lib/modules/$(uname -r)/kernel/anbox
cp *.ko /usr/lib/modules/$(uname -r)/kernel/anbox/
depmod -a
modprobe binder_linux
