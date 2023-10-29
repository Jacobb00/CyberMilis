prog="/usr/bin/php-fpm"
conf="/etc/php/php-fpm.conf"
gpid="/var/run/php-fpm.pid"
opts=" --daemonize --fpm-config "..conf.." --pid "..gpid

local task={
	desc="PHP fastCGI Process Manager",
	program="php-fpm",
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
