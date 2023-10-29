-- udev

local task={
	desc="udev and waiting for devices to settle",
	program="udevd",		
	start={
		cmd={
		"udevd --daemon",
		"udevadm trigger --action=add --type=subsystems",
		"udevadm trigger --action=add --type=devices",
		"udevadm settle",
		},		
	},
	--stop={
	--	cmd="udevadm control --exit",
	--},
	status={type="program"}
}
return task


   
