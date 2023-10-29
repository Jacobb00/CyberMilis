-- linux console

local console={
	desc="to set up Linux console",
			
	start=function()
		-- set unicode mode maybe it can be control with config.lua
		-- default with unicode
		keyboard="trq"
		cmd="kbd_mode -u"
		action(cmd)
		-- set keyboard
		cmd="loadkeys -q -u %s"
		if loconfig.keyboard then keyboard=loconfig.keyboard end
		if kconfig and kconfig.keyboard then keyboard=kconfig.keyboard end
		action(cmd:format(keyboard))
		-- set font
		-- frambuffer device kontrol edilip aktif edilir.
		cmd="/usr/bin/setfont %s -C %s &>/dev/null"
		-- /dev/tty[0-9] tespit edilecek inittab veya dev altından
		action(cmd:format(loconfig.font,"/dev/tty1"))
		result=0
		return result
	end,
}
return console
