local task={
	
	desc="LXC Utils",
	pid="/var/run/lxc/dnsmasq.pid",
			
	start={
		cmd="/usr/bin/lxc-cgroups start && /usr/lib/lxc/lxc-net start",
	},
	stop={
		cmd="/usr/bin/lxc-cgroups stop && /usr/lib/lxc/lxc-net stop",
	},
	status={type="pid"},
}

return task
