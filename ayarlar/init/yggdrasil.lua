local task={
	
	desc="Yggdrasil Server",
	program="yggdrasil",
	start={
	    cmd="yggdrasil -useconffile /etc/yggdrasil.conf",
	},
	stop={type="program"},
	status={type="program"}
}
return task


   
