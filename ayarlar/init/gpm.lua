local task={
	
	desc="GPM console mouse server",
	
	program="/usr/bin/gpm",
			
	start={
		cmd="nice -n 0 /usr/bin/gpm -m /dev/input/mice -t imps2",
	},
	stop={
		type="program",
	},
	status={type="program"}
}

return task


   
