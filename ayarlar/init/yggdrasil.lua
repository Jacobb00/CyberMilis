local task={
	
	desc="Yggdrasil Server",
	program="yggdrasil",
	start={
	    cmd="yggdrasil -useconffile /etc/yggdrasil.conf 2>&1> /var/log/yggdrasil.log &",
	},
	stop={type="program"},
	status={type="program"}
}
return task


   
