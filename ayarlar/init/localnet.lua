-- localnet loopback
local task={
	desc="to bring up the loopback interface",
			
	start={
		cmd="ip link set up dev lo",
	},
	
	stop={
		cmd="ip link set lo down",
	},
}
return task
