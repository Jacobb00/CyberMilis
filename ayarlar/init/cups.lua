local task={
	desc="CUPS",
	program="/usr/bin/cupsd",
	pid="/var/run/cups/cupsd.pid",		
	start ={type="program"},
	stop  ={type="pid"},
	status={type="pid"},
}
return task
