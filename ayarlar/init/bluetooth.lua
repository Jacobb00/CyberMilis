local task={
	
	desc="Bluetoothd",
	
	program="/usr/lib/bluetooth/bluetoothd",
			
	start={
		cmd ={
		  "rfkill unblock all",
		  "nice -n 0 /usr/lib/bluetooth/bluetoothd 2>&1 >/dev/null &",
		  "sleep 1",
		  "rfkill unblock bluetooth",
		},
	},
	stop={
		type="program",
	},
	status={type="program"}
}

return task
