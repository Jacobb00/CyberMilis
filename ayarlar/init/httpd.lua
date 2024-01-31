prog="/usr/bin/httpd"

local task={
	desc="Apache HTTP Server",
	program=prog,
	start={
	    cmd=prog.." -k start",
	},
	stop={
	    cmd="apachectl -k stop"
	},
	status={type="program"}
}

return task
