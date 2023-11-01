-- alsa restore
-- save and restore alsa state

local task={
	desc="to restore alsasound",
			
	start={
		cmd="alsactl restore",
	},
	stop={
		cmd="alsactl store",
	},	
}
return task
