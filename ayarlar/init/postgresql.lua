local postgres_data_dir="/var/lib/postgres/data"
local postgres_pid_dir="/run/postgresql"
if loconfig and loconfig.data_dir then postgres_data_dir=loconfig.data_dir end

local task={
	desc="PostgreSQL daemon",
	program="postgres",		
	start=function()
		_,control=l5.readlink("/usr/bin/psql")
		if control == 2 then
			print("postgresql kurulu değil!")
			result=false
			return result
		end
		_,control=l5.readlink(postgres_pid_dir)
		if control == 2 then
			action("install -v -dm755 "..postgres_pid_dir)
			action("chown -Rv postgres:postgres /run/postgresql")
		end
		_,control=l5.readlink(postgres_data_dir.."/base")
		-- control=2 file not exist
		if control == 2 then
			action("chsh -s /bin/bash postgres")
			action("install -v -dm700 "..postgres_data_dir)
			action("chown -Rv postgres:postgres "..postgres_data_dir)
			initdb_cmd="su - postgres -c '/usr/bin/initdb -E UTF8 -D %s'"
			action(initdb_cmd:format(postgres_data_dir))
		end
		start_cmd="su - postgres -c '/usr/bin/pg_ctl start -s -W -D "..postgres_data_dir..
		" -l "..postgres_data_dir.."/logfile -o \"-i\" '"
		action(start_cmd)
		result=0
		return result
	end,
	stop={
		cmd="su - postgres -c '/usr/bin/pg_ctl stop -s -m smart -D "..postgres_data_dir.."'",
	},
	status={
		cmd="su - postgres -c '/usr/bin/pg_ctl status -D "..postgres_data_dir.."'",
	},
	
}

return task
