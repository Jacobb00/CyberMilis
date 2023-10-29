-- hostname i ayarlar
local task={
	desc="to set hostname...",
			
	start=function()
		host_name="milis"
		if loconfig.data then host_name=loconfig.data end
		cmd="echo %s > /etc/hostname"
		action(cmd:format(host_name))
		result=action("hostname -F /etc/hostname")
		return result
	end,
}
return task
