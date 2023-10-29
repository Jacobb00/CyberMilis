prog="/usr/bin/virtlogd"
--conf="/etc/php/php-fpm.conf"
gpid="/var/run/virtlogd.pid"
opts=" --daemon"

local task={
	desc="Virtualization logging daemon",
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
