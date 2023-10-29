-- tunefs
-- create files and set permissions

local task={
	desc="to tune filesystem",
			
	start={
		cmd={
		"install -m0664 -o root -g utmp /dev/null /var/run/utmp",
		"rm -rf /tmp && mkdir /tmp && chmod 1777 /tmp",
		"chmod 664 /sys/power/state && chgrp wheel /sys/power/state",
		},
	},
}
return task
