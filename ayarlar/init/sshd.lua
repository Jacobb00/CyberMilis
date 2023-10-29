local task={
	
	desc="SSH Server",
	pid="/var/run/sshd.pid",
	program="/usr/bin/sshd",
			
	start={
		cmd="ssh-keygen -A &> /dev/null",
		type="program",
	},
	stop={type="pid"},
	status={type="pid"},
}

return task
