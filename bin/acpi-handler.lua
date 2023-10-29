#!/usr/bin/env slua
-- acpi olay yönetim betiği
-- milisarge 2021

function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

p1=""
p2=""
p3=""

if arg[1] ~= nil then p1=arg[1] end
if arg[2] ~= nil then p2=arg[2] end
if arg[3] ~= nil then p3=arg[3] end

local mode=""
local display=os.capture("wlopm | awk '{print $1}'| head -n 1")
local lock_cmd="swaylock -f -c 000000"
local suspend_ram_cmd="echo -n mem | tee /sys/power/state"
local bs_cmd="wlopm --toggle "..display
local notify_cmd="notify-send"

modes={
	lid={
		open="lock",
		close="suspend_ram"
	},
	sleep="blackscreen",
	headphone={
		plug="notify",
		unplug="notify",
	}
}

functions={
	suspend_ram=function() os.execute(suspend_ram_cmd) end,
	hibernate=function() print("--- hibernate") end,
	blackscreen=function() os.execute(bs_cmd) end,
	nothing=function() print("--- nothing") end,
	lock=function() os.execute(lock_cmd) end,
	notify=function(title, msg) os.execute(notify_cmd.." -a "..title.." "..msg) end,
}

if p1 and p2 and p3 then
	if p1 == "button/volumeup" and p2 == "VOLUP" then
		print("--- volumeup triggered")
	elseif p1 == "button/volumedown" and p2 == "VOLDN" then
		print("--- volumedown triggered")
	elseif p1 == "button/sleep" and (p2 == "SBTN" or p2 == "SLBP") then
		print("---",p1,p2)
		mode=modes.sleep
		functions[mode]()
	elseif p1 == "button/lid" and p2 == "LID" then
		if p3 == "open" then
			mode=modes.lid.open
			functions[mode]()
		elseif p3 == "close" then
			mode=modes.lid.close
			functions[mode]()
		else
			print(p1,p2,p3,"not implemented")
		end
	elseif p1 == "jack/headphone" and p2 == "HEADPHONE" then
		if p3 == "plug" then
			mode=modes.headphone.plug
			functions[mode]("Kulaklık","takıldı")
		elseif p3 == "unplug" then
			mode=modes.headphone.unplug
			functions[mode]("Kulaklık","çıkarıldı")
		else
			print(p1,p2,p3,"not implemented")
		end
	end
	
else
	print(p1,p2,"not implemented")
end
