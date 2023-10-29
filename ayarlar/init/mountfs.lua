-- moountfs

local task={
	desc="to remount root file system in read-write mode",
			
	start={
		cmd={
		"mount --options remount,rw /",
		"mount --all --test-opts no_netdev",
		},
	},
	
	stop={
		cmd={
		"losetup -D",
		"umount --all --detach-loop --read-only --types notmpfs,nosysfs,nodevtmpfs,noproc,nodevpts >/dev/null",
		"mount --options remount,ro /",
		"sync",
		},
	},
}
return task
