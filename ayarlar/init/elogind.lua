local task={
	
	desc="ELogind Daemon",
	program="elogind-daemon",
	start={
		cmd="sleep 3 && /usr/lib/elogind.wrapper &",
	},
	status={type="program"}
}

return task
