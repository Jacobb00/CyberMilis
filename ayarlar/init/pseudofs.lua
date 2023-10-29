-- mount pseudo/virtual dosya sistemlerini bağlar

local pseudofs={
	desc="to mount pseudo filesystems...",
			
	start=function()
		cmd="mount -T %s > /dev/null"
		cmd1=cmd:format(loconfig.fstab)
		action(cmd1)
		result=0
		if result == 0 then 
			action("mkdir -p /run/lock /run/shm")
			action("chmod 1777 /run/shm /run/lock")
		end
		-- bunların mount olayı 
		-- /sys/kernel/security
		-- cgroup v1 v2
		-- mount -o mode=0755 -t tmpfs cgroup /sys/fs/cgroup
		return result
	end,
}
return pseudofs
