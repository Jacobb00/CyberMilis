prog = "/usr/local/bin/ipfs"
opt = " daemon --init 2>&1 >> /var/log/ipfs.log &"

local task={
	desc="IPFS daemon",
	program=prog,		
	start=function()
		_,control=l5.readlink(prog)
		if control == 2 then
			action("echo 'ilk kurulum' >> /var/log/ipfs.log")
			action("ipfs_setup.sh")
		end
		_,control=l5.readlink("/root/.ipfs/repo.lock")
		if control == 2 then			
			l5.setenv("IPFS_PATH","/root/.ipfs")
			action(prog..opt)
		end
		result=0
		return result
	end,
	stop={
		cmd = { 
			prog.." shutdown",
			"kill -9 $(lsof -t -i:5001)",
		},
	},
	status={
		type = "program",
	},
	
}

return task
