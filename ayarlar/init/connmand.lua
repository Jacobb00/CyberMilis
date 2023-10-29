local task={
	
	desc="Connman network manager daemon",
	
	program="/usr/bin/connmand",
			
	start={
		cmd="wpa_supplicant -usB",
		type="program",
	},
	stop={
		type="program",
	},
	status={type="program"}
}

return task
