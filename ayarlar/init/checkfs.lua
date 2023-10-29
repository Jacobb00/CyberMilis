-- checkfs

local task={
	desc="to mount read-only and checking file systems",
			
	start={
		cmd={
		"mount -n -o remount,ro /",
		-- diğer fs de kontrol edilecek
		-- https://github.com/void-linux/void-runit/blob/master/core-services/03-filesystems.sh
		-- /etc/crypttab varsa bu devreye
		"vgchange --sysinit -a y",
		-- fsck fix !!!
		"fsck -A -T -a -t noopts=_netdev > /dev/null",
		}
	},
}
return task
