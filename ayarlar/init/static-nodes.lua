-- kernel modulleri yükler

local task={
	desc="to load static dev nodes...",
			
	start=function()
		cmd="modprobe -b %s"
		local skmods=shell("kmod static-nodes")
		for km in skmods:gmatch("[^\r\n]+") do
			a,b=km:find("Module:")
			if b then
				smod=km:sub(b+2,-1)
				action(cmd:format(smod))
			end
		end
		--local skmods=shell("kmod static-nodes 2>/dev/null|awk '/Module/ {print $2}'")
		--for km in skmods:gmatch("[^\r\n]+") do
			--action(cmdst:format(km))
		--end
		result=0
		return result
	end,
}
return task
