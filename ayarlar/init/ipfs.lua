local task={
	desc="IPFS daemon",
	program="ipfs",		
	start=function()
		_,control=l5.readlink("/usr/local/bin/ipfs")
		if control == 2 then
			action("ipfs_setup.sh")
		end
		action("ipfs daemon --init &")
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
