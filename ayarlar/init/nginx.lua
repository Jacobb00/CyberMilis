prog="/usr/bin/nginx"
conf="/etc/nginx/nginx.conf"
pid="/var/run/nginx.pid"

local task={
	desc="Nginx Server",
	program=prog,
	start={
	    cmd=prog.." -c "..conf,
	},
	stop={
	    cmd="pkill -F "..pid
	},
	status={type="program"}
}

return task
