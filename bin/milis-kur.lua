#!/usr/bin/env slua

-- Milis Linux 2.3 Konsol Kurulum Betiği
-- milisarge 2024/03

l5=require("l5")

inc_dir = "/etc/init"

-- talimat.lua ini okumak için
package.path  = inc_dir.."/?.lua"      .. ";".. package.path

t = require("ini")

if os.getenv("init_color") == nil then
	l5.setenv("init_color","1")
end

-- Renk
color=require("colors")

function cwrite(str,clr)
  if os.getenv("init_color") == "1" or l5.getppid() == 1 then
    str=color("%{"..clr.."}"..str)
  end
  io.write(str)
end

config_file = arg[1]

if config_file == nil then 
  config_file = "/tmp/setup.ini"
end 

_,cfg_stat=l5.readlink(config_file)

if cfg_stat == 2 then
  cwrite(config_file .. " ayar dosyası bulunamadı!\n", "red")
  os.exit(1)
end

cfg = t.load(config_file)

--shell_file = io.open("setup_script.sh","w")

--split string
function string:split(delimiter)
  local result = {}
  if delimiter == "." then  
    for i in string.gmatch(self, "[^%.]+") do
	  table.insert(result,i)
    end
  else
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
  end
  return result
end

function shell(command)
	-- Open log file in append mode
	local logger = io.open(helper.shell_log, "a")
	logger:write(command.."\n");
	logger:close();
	local handle=io.popen(command)
	local result=handle:read('*all')
	handle:close()
	-- komut çıktısı sonu yeni satır karakterin silinmesi - en sondaki \n
	if result:sub(-1) == "\n" then
		--result=result:gsub("\n", "")
		result=result:sub(1,-2)
	end
	return result
end

function swrite(cmd)
  --io.write(("%s\n"):format(cmd))
  print(("%s\n"):format(cmd))
end

function create_fs()
  swrite("# 1. Dosya sistemlerinin hazırlanması")
  -- swap
  if cfg.filesystem.swap then
    print(("#%s disk bölümü"):format("swap"))
    val = cfg.filesystem.swap
    swrite("swapoff "..val)
    -- tek swap disk bölümü olduğu için varsayılan formatla
    swrite("mkswap "..val)
    swrite("swapon "..val)
    -- uuid = shell(val)
    swrite(("uuid=$(blkid -o value -s UUID \"%s\")"):format(val))
    swrite("echo \"UUID=$uuid none swap sw 0 0\" >>$TARGET_FSTAB")
  end
  if cfg.filesystem.root then
    print(("#%s disk bölümü"):format("root"))
    val = cfg.filesystem.root
    part = val:split(";")[1]
    fs_type = val:split(";")[2]
    size = val:split(";")[3]
    mountp = val:split(";")[4]
    fs_format = val:split(";")[5]
    -- hedef disk bölümü bağlı olabilir, çözmek için
    swrite(("mount | grep -q \"%s\" && umount -l %s"):format(part, part))
    if fs_format == "1" then
      if fs_type == "ext4" then
        swrite(("mke2fs -F -t ext4 %s"):format(part))
      end
      if fs_type == "btrfs" then
        swrite(("mkfs.btrfs -f %s"):format(part))
      end
    end
    -- rootfs bağlanması
    swrite("mkdir -p $HEDEF")
    swrite(("mount -t %s %s $HEDEF"):format(fs_type, part))
    swrite(("uuid=$(blkid -o value -s UUID \"%s\")"):format(part))
    swrite(("echo \"UUID=$uuid %s %s defaults 0 1\" >>$TARGET_FSTAB"):format(mountp, fs_type))
  end
        
  if cfg.filesystem.efi then 
    print(("#%s disk bölümü"):format("EFI"))
    val = cfg.filesystem.efi
    part = val:split(";")[1]
    fs_type = val:split(";")[2]
    size = val:split(";")[3]
    mountp = val:split(";")[4]
    fs_format = val:split(";")[5]
    if fs_format == "1" then
      swrite(("mkfs.vfat -F32 %s"):format(part))
    end
    swrite(("mount -t %s %s ${HEDEF}%s"):format(fs_type, part, mountp))
    swrite(("uuid=$(blkid -o value -s UUID \"%s\")"):format(part))
    swrite(("echo \"UUID=$uuid %s %s defaults 0 2\" >>$TARGET_FSTAB"):format(mountp, fs_type))
  end
end

function copy_rootfs()
  swrite("# 2. Sistemin kopyalanması")
  cmd = "tar --create --one-file-system --xattrs -f - / 2>/dev/null | tar --extract --xattrs --xattrs-include='*' --preserve-permissions -v -f - -C $HEDEF"
  swrite(cmd)
end

function mount_fs()
  swrite("# 3. Temel dosya sistemlerinin bağlanması")
  cmd = "mount --bind /%s $HEDEF/%s "
  for _,fs in ipairs {"sys", "proc", "dev"} do
        -- [ ! -d $HEDEF/$f ] && mkdir $HEDEF/$f
        -- echo "Mounting $HEDEF/$f..." >>$LOG
        swrite(cmd:format(fs,fs))
  end
end

function prepare_boot()
  swrite("# 4. Açılış dosyalarının düzenlenmesi")
  -- kernel sürüm bul
  --local sonek="milis"
  --local kversion=`ls $HEDEF/boot/kernel-* | xargs -I {} basename {} | head -n1 |cut -d'-' -f2`
  cmd = {
    "rm -f $HEDEF/boot/{initramfs*,initrd*,kernel*}",
    "cp /boot/kernel-* $HEDEF/boot/",
    "sonek=\"milis\"",
    "kversion=`ls $HEDEF/boot/kernel-* | xargs -I {} basename {} | head -n1 |cut -d'-' -f2`", 
    "chroot $HEDEF dracut -H --xz --omit systemd --add-drivers ahci -f /boot/initrd.img-${kversion} $kversion-$sonek --force",
    "rmdir $HEDEF/mnt/target",
    "cat $TARGET_FSTAB > $HEDEF/etc/fstab",
  }
  for _,c in ipairs(cmd) do
    swrite(c)
  end
end

function configure_sys()
  swrite("# 5. Sistem ayarlarının yapılması")
  cmd = {
    ("chroot $HEDEF /usr/milis/bin/servis yaz locale language %s"):format(cfg.system.locale),
    ("chroot $HEDEF /usr/milis/bin/servis yaz clock timezone %s"):format(cfg.system.timezone),
    ("chroot $HEDEF /usr/milis/bin/servis yaz console keyboard %s"):format(cfg.system.keymap),
    ("echo \"127.0.0.1 %s\" >> $HEDEF/etc/hosts"):format(cfg.system.hostname),
    ("chroot $HEDEF /usr/milis/bin/servis yaz hostname data %s"):format(cfg.system.hostname),
  }
  for _,c in ipairs(cmd) do
    swrite(c)
  end
end

function configure_user()
  swrite("# 6. Kullanıcı hesaplarının ayarlanması")
  cmd = {
    --"mls canlı kullanıcı sil (userdel, sudoers)",
    ("chroot $HEDEF userdel -r %s"):format(cfg.user.live),
    ("sed -i -e \"/%s ALL=.*/d\" $HEDEF/etc/sudoers"):format(cfg.user.live),
	--"Root hesap şifre",
	("echo \"root:%s\" | chpasswd -R $HEDEF -c SHA512"):format(cfg.user.r_passwd),
	-- "Yeni kullanıcının ayarlanması",
	("useradd -R $HEDEF -G %s -c \"%s\" %s"):format(cfg.user.groups, cfg.user.name, cfg.user.name),
    ("echo \"%s:%s\" | chpasswd -R $HEDEF -c SHA512"):format(cfg.user.name, cfg.user.passwd),
	--"özel ayarların kopyalanması",
	("mkdir -p $HEDEF/home/%s"):format(cfg.user.name),
	"cp -rf /run/initramfs/live/updates/etc/skel/. $HEDEF/etc/skel/",
	-- "gereksiz dosyaların silinmesi",
	"rm -f $HEDEF/root/bin/canli_kullanici.sh",
	"rm -rf $HEDEF/opt/Milis-Yukleyici",
	"rm -f $HEDEF/usr/share/applications/kurulum.desktop",
	"rm -f $HEDEF/etc/{shadow-,gshadow-,passwd-,group-,canli_kullanici}",
	-- "ev dizinin kullanıcı sahiplik ayarlanması",
	("chroot $HEDEF chown %s:%s -R /home/%s"):format(cfg.user.name, cfg.user.name,cfg.user.name),
	-- sudo ayarları
	"sed -i $HEDEF/etc/sudoers -e \"s;#.*%wheel ALL=(ALL) ALL;%wheel ALL=(ALL) ALL;\"",
	-- "/dev/snd ses sahiplik ayarlanması",
	("[ -d $HEDEF/dev/snd ] && chroot $HEDEF  setfacl -m u:%s:rw /dev/snd/*"):format(cfg.user.name),
	
  }
  for _,c in ipairs(cmd) do
    swrite(c)
  end
end

function set_bootloader()
  swrite("# 7. Önyükleyicinin ayarlanması")
  -- efi tespit 
  efi_path = "/sys/firmware/efi/systab"
  _,control=l5.readlink(efi_path)
  -- efili sistem değilse
  if control == 2 then
    if cfg.bootloader.program == "limine" then
      swrite(("chroot $HEDEF limine bios-install %s"):format(cfg.bootloader.diskpart))
      swrite("cp /usr/share/limine/limine-bios.sys $HEDEF/boot/")
    end
    if cfg.bootloader.program == "grub" then
      swrite(("chroot $HEDEF grub-install --force %s"):format(cfg.bootloader.diskpart))
    end
  else
    swrite("mount -t efivarfs efivarfs /sys/firmware/efi/efivars")
    swrite("mount --bind /sys/firmware/efi/efivars $HEDEF/sys/firmware/efi/efivars")
    if cfg.bootloader.program == "limine" then
      swrite("mkdir -p $HEDEF/boot/efi/EFI/boot/")
      swrite("cp /usr/share/limine/BOOTX64.EFI $HEDEF/boot/efi/EFI/boot/")
    end
    if cfg.bootloader.program == "grub" then
      swrite(("chroot $HEDEF grub-install --force --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=boot --recheck %s"):format(cfg.bootloader.diskpart))
	  swrite("cp $HEDEF/boot/efi/EFI/boot/grubx64.efi $HEDEF/boot/efi/EFI/boot/bootx64.efi")
    end
  end
  -- ayarların üretilmesi
  if cfg.bootloader.program == "limine" then
    swrite("cp /usr/milis/ayarlar/limine/limine.cfg.sample $HEDEF/boot/limine.cfg")
    swrite("limine-mkconfig.py >> $HEDEF/boot/limine.cfg")
  end
  if cfg.bootloader.program == "grub" then
	swrite("LC_ALL=C chroot $HEDEF grub-mkconfig -o /boot/grub/grub.cfg")
  end
end

function umount_fs()
  swrite("# 8. Dosya sistemlerinin ayrılması")
  swrite("sync && sync && sync")
  points = {
    "sys/fs/fuse/connections", "sys/firmware/efi/efivars", "sys", "proc", "dev",
  }
  for _,f in ipairs(points) do
    swrite(("[ -d $HEDEF/%s ] && umount $HEDEF/%s"):format(f, f))
  end
  if cfg.filesystem.swap then
    swrite("swapoff "..cfg.filesystem.swap)
  end
  swrite("[ -d $HEDEF/boot/efi ] && umount $HEDEF/boot/efi")
  swrite("umount $HEDEF")
end

function main()
  -- 0 değişkenler
  swrite("# 0. Başlangıç ayarları")
  swrite("exec 19>/tmp/setup.log")
  swrite("BASH_XTRACEFD=19")
  swrite("set -x")
  swrite("HEDEF=\"/mnt/target\"")
  swrite("TARGET_FSTAB=$(mktemp -t fstab-XXXXXXXX || exit 1)")
  -- 1. create filesystems
  create_fs()
  -- 2. copy rootfs to target
  copy_rootfs()
  -- 3. Sistem dosya sistemlerinin bağlanması
  mount_fs()
  -- 4. prepare boot file - kernel ve initrd
  prepare_boot()
  -- 5. system settings - locale, keyboard, timezone
  configure_sys()
  -- 6. user settings
  configure_user()
  -- 7. set bootloader
  set_bootloader()
  -- 8. umount filesystems
  umount_fs()
end

main()

--io.close(shell_file)

