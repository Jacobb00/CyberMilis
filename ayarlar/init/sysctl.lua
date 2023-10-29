-- sysctl kernel runtime parameters

local task={
	desc="to setup kernel runtime parameters",
			
	start=function()
		_,control=l5.readlink("/etc/sysctl.conf")
		-- control=2 file not exist
		if control ~= 2 then
			action("sysctl -q -p")
		end
		result=0
		return result
	end,
}
return task
