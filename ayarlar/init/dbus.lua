-- D-bus daemon

local task={
	desc="the D-Bus Messagebus Daemon",
	program="/usr/bin/dbus-daemon",		
	
	start={
		cmd={
		"mkdir -p /var/lib/dbus",
		"mkdir -p /run/dbus",
		"/usr/bin/dbus-uuidgen --ensure",
		"nice -n 0 /usr/bin/dbus-daemon --system",
		},		
	},
	stop={
		cmd={
		"pkill -F /var/run/dbus/pid",
		"rm -f /var/run/dbus/pid",
		"rm -f /var/run/dbus/system_bus_socket",
		}
	},
	status={type="program"}
}
return task
