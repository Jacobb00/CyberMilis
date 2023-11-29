local task={
	desc="IPFS daemon",
	program="ipfs",		
	start=function()
		_,control=l5.readlink("/usr/local/bin/ipfs")
		if control == 2 then
			action("ipfs_setup.sh")
		end
		_,control=l5.readlink("/root/.ipfs/version")
		if control == 2 then
			action("ipfs init")
		end
		action("ipfs daemon")
		result=0
		return result
	end,
	stop={
		type = "program",
	},
	status={
		type = "program",
	},
	
}

return task
