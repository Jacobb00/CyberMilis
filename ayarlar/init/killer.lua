-- process killer
local task={
	desc="processes with TERM and KILL signals",
	
	-- bu pid dosyaları var mı kontrol edilmeli!!!
	stop={
		cmd={
		"pkill --inverse -s0,1 -TERM",
		"sleep 1",
		"pkill --inverse -s0,1 -KILL",
		},
	},
}
return task


   
