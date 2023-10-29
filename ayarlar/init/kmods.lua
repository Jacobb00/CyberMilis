-- kernel modulleri yükler

local task={
	desc="to load kernel modules...",
			
	start=function()
		cmd="modprobe %s %s"
		cmdst="modprobe -b %s"
		local smod=""
		for modul,options in pairs(loconfig) do
			action(cmd:format(modul,options))
		end
		-- static dev nodes
		local skmods=shell("kmod static-nodes")
		for km in skmods:gmatch("[^\r\n]+") do
			a,b=km:find("Module:")
			if b then
				smod=km:sub(b+2,-1)
				action(cmdst:format(smod))
			end
		end
		result=0
		return result
	end,
}
return task
