local task={
	
	desc="Bluetoothd",
	
	program="/usr/lib/bluetooth/bluetoothd",
			
	start={
		type="program",
		-- rfkill bloke var ise kaldırmak için
		cmd ="rfkill unblock all",
	},
	stop={
		type="program",
	},
	status={type="program"}
}

return task
