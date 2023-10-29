local task={
	
	desc="Chrony NTP Daemon",
	program="/usr/bin/chronyd",		
	start={
		cmd="/usr/bin/chronyd -u chrony -r",
	},
	pid="/var/run/chrony/chronyd.pid",
	stop  ={type="pid"},
	status={type="pid"},
}

return task
