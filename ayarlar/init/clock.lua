-- clock

local task={
	desc="to set clock and timezone",
			
	start=function()
		action("mkdir -p /var/lib/hwclock")
		cmd="ln -sf /usr/share/zoneinfo/%s /etc/localtime"
		action(cmd:format(loconfig.timezone))
		cmd="hwclock --directisa --hctosys --utc"
		if loconfig.utc then
			action(cmd)
		else
			cmd="hwclock -s --localtime"
			action(cmd)
			cmd="hwclock -w --localtime"
			action(cmd)
		end
		result=0
		return result
	end,

	stop=function()
		cmd="hwclock --systohc %s"
		if loconfig.utc then
			utcparam="--utc"
		else
			utcparam="--localtime"
		end
		action(cmd:format(utcparam))
		result=0
		return result
	end,
}
return task
