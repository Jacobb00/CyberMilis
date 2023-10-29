local task={
	
	desc="Polkit Daemon",
	
	program="/usr/lib/polkit-1/polkitd",
			
	start={
		cmd="/usr/lib/polkit-1/polkitd --no-debug &",
	},
	stop={
		type="program",
	},
	status={type="program"}
}

return task


   
