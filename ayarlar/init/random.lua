-- random seed generator

local task={
	desc="to initialize kernel random number generator",
			
	start=function()
		_,control=l5.readlink("/var/lib/random-seed")
		-- control=2 file not exist
		if control ~= 2 then
			action("cat /var/lib/random-seed >/dev/urandom")
		end
		action("dd if=/dev/urandom of=/var/lib/random-seed count=1 &> /dev/null")
		result=0
		return result
	end,
	
	stop={
		cmd="dd if=/dev/urandom of=/var/tmp/random-seed count=1 &>/dev/null",
	},
}
return task


   
