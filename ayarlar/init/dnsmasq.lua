prog="/usr/bin/dnsmasq"
opts=" -k --enable-dbus --user=nobody --pid-file"
-- pid yoluna göre tip pid yapılacak

local task={
	desc="DNSmasq server",
	program=prog,
	start={
	    cmd=prog..opts,
	    type="program"
	},
	stop={
	    type="program"
	},
	status={type="program"}
	reload={type="program"}
}

return task
