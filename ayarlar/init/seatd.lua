local task={
	
	desc="Seatd Daemon",
	program="seatd",
	start={
		cmd="seatd -g video -l error &",
	},
	status={type="program"}
}

return task


   
