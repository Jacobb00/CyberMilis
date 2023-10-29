local mysql_pid_dir="/run/mysqld"
local mysql_pid_file=mysql_pid_dir.."/mysqld.pid"
local mysql_data_dir="/var/lib/mysql/data"
local mysql_log_dir="/var/log/mysql"
local mysql_dirs={mysql_pid_dir,mysql_data_dir,mysql_log_dir}
local mysqld="/usr/bin/mysqld"
local mysql_initialize="/usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir="..mysql_data_dir

local task={
	desc="MySQL daemon",
	pid=mysql_pid_file,
	start=function()
		_,control=l5.readlink(mysqld)
		if control == 2 then
			print("mysql kurulu değil!")
			result=false
			return result
		end
		-- gerekli dizinlerin kontrolü
		for _,dir in ipairs(mysql_dirs) do
			_,control=l5.readlink(dir)
			if control == 2 then
				action("mkdir -p "..dir)
				action("chown mysql:mysql "..dir)
			end
		end
		-- ilkleme kontrolü
		_,control=l5.readlink(mysql_data_dir.."/mysql")
		if control == 2 then
			action(mysql_initialize)
		end
		-- başlatma
		start_cmd="/usr/bin/mysqld_safe --user=mysql --datadir="..mysql_data_dir.." --pid-file="..mysql_pid_file.." --log-error="..mysql_log_dir.."/mysql.log".." 2>&1 >/dev/null &"
		action(start_cmd)
		result=0
		return result
	end,
	stop={
		type="pid",
	},
	status={
		type="pid",
	},
	
}

return task
