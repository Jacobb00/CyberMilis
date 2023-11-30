local task={
	
	desc="Ayguci server",
	
	program="/usr/milis/ayguci/go/ayguci",		
	start={
		type="program",
	},
	stop={
		cmd="killall ayguci",
	},
	status={type="program"}
}

return task


   
