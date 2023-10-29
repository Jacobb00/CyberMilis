-- swap
local task={
	desc="to mount all swap files/partitions",
	start={cmd="swapon -a"},
	stop={cmd="swapoff -a"},
}
return task



