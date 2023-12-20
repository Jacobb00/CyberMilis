prog = "/usr/local/bin/ipfs"
opt = " daemon --init 2>&1 > /dev/null &"

local task={
	desc="IPFS daemon",
	program=prog,		
	start=function()
		_,control=l5.readlink(prog)
		if control == 2 then
			action("ipfs_setup.sh")
		end
		_,control=l5.readlink("/root/.ipfs/repo.lock")
		if control == 2 then			
			action(prog..opt)
		end
		result=0
		return result
	end,
	stop={
		cmd = { 
			prog.." shutdown",
			kill -9 $(lsof -t -i:5001),
		},
	},
	status={
		type = "program",
	},
	
}

return task
