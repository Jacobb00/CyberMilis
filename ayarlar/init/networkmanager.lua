-- NetworkManager service

local task={
	desc="NetworkManager",
			
	start=function()
		_,control=l5.readlink("/var/run/NetworkManager")
		-- control=2 file not exist
		if control == 2 then
			action("install -d -o root -g root -m 755 /var/run/NetworkManager")
		end
		action("NetworkManager")
		result=0
		return result
	end,
	
	stop={
		cmd={
		"pkill -F /var/run/NetworkManager/NetworkManager.pid",
		"rm -f /var/run/NetworkManager/NetworkManager.pid",
		},
	},
	
}
return task


   
