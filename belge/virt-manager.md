Sanal makina yönetimi için kullanılan bir uygulama da libvirt tabanlı virt-manager uygulamasıdır.
Kurulum ve yapılandırma için aşağıdaki adımları uygulanmalıdır.


#### Kurulum
```
[ ~ ]# mps kur virt-manager
```

#### Servis işlemleri
```
[ ~ ]# servis ekle libvirtd
[ ~ ]# servis ekle virtlogd

[ ~ ]# servis kos libvirtd
  *   Starting Virtualization daemon                             [OK]
[ ~ ]# servis kos virtlogd
  *   Starting Virtualization logging daemon                     [OK]
```

#### Sanal NAT ağının ayarlanması
```
[ ~ ]# virsh net-define --file /etc/libvirt/qemu/networks/default.xml 
Network default defined from /etc/libvirt/qemu/networks/default.xml

[ ~ ]# virsh net-start default
Network default started

[ ~ ]# virsh net-list 
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes

```
