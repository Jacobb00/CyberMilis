local task={
	
	desc="Cronjob Server",
	pid="/var/run/crond.pid",
	program="/usr/bin/crond",
			
	start={type="program"},
	stop={type="pid"},
	status={type="pid"},
}

return task
