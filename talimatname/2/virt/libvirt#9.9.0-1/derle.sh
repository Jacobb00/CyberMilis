pip3 install docutils

cd $SRC/libvirt-$surum

sed -i 's|/usr/libexec/qemu-bridge-helper|/usr/lib/qemu/qemu-bridge-helper|g' \
    src/qemu/qemu.conf.in \
    src/qemu/test_libvirtd_qemu.aug.in

patch src/remote/libvirtd.rules < $SRC/libvirt-polkit-group.patch

milis-meson build --libexecdir=lib/libvirt \
-Dbash_completion=disabled \
-Drunstatedir=/run \
-Dtests=disabled \
-Dexpensive_tests=disabled \
-Dqemu_user=libvirt \
-Dqemu_group=kvm \
-Dglusterfs=disabled \
-Daudit=disabled \
-Dinit_script=none \
-Ddocs=enabled \
-Dnetcf=disabled \
-Dopenwsman=disabled \
-Dapparmor=disabled \
-Dapparmor_profiles=disabled \
-Dselinux=disabled \
-Dwireshark_dissector=disabled  \
-Ddriver_bhyve=disabled \
-Ddriver_hyperv=disabled \
-Ddriver_libxl=disabled \
-Ddriver_vz=disabled \
-Dsecdriver_apparmor=disabled \
-Dsecdriver_selinux=disabled \
-Dstorage_vstorage=disabled \
-Dstorage_gluster=disabled \
-Dstorage_iscsi=disabled \
-Dstorage_rbd=disabled \
-Dstorage_zfs=disabled \
-Dsanlock=disabled \
-Ddtrace=disabled -Dnumad=disabled 

LC_ALL=C ninja -C build
DESTDIR="$PKG" ninja -C build install
