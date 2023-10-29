-- system and kernel log daemon
local task={
	desc="system and kernel log daemon",
	program="syslogd",
	start={
		cmd={
		"nice -n 0 syslogd -m 0",
		},
	},
	-- pid dosya kontrol edilmeli todo!!!
	stop={
		cmd={
		"pkill -F /var/run/syslogd.pid",
		"rm -f /var/run/syslogd.pid",
		},
	},
	status={type="program"}
}
return task


   
