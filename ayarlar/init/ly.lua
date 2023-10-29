local task={
	
	desc="Ly login manager",
	program="/usr/bin/ly",
	start={
		cmd="exec setsid agetty -nl /usr/bin/ly tty7 38400 linux &",
	},
	status={type="program"}
}

return task


   
