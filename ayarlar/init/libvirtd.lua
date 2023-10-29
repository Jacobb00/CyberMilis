prog="/usr/bin/libvirtd"
--conf="/etc/php/php-fpm.conf"
gpid="/var/run/libvirtd.pid"
opts=" --daemon"

local task={
	desc="Virtualization daemon",
	pid=gpid,
	start={
	    cmd=prog..opts,
	},
	stop={
	    cmd="pkill -F "..gpid
	},
	status={type="pid"}
}

return task
