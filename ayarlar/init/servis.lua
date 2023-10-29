#!/usr/bin/env slua

-- Milis Linux 2.3 Servis Yönetim Betiği
-- milisarge 2023/10

-- servis yolları 
service_repo = "/usr/milis/ayarlar/init"
service_dir = "/etc/init"

-- talimat.lua ini okumak için
package.path  = service_dir.."/?.lua"      .. ";".. package.path

t = require("ini")
config_file=service_dir.."/system.ini"
svc = t.load(config_file)

-- servislerde cmd çalıştırma veya yazdırma amaçlı atanan
action=print

premsg={start="Starting",stop="Stopping",status="Status"}

--split string
function string:split(delimiter)
  local result = {}
  if delimiter == "." then  
    for i in string.gmatch(self, "[^%.]+") do
	  table.insert(result,i)
    end
  else
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
  end
  return result
end

l5=require("l5")
if os.getenv("init_color") == nil then
	l5.setenv("init_color","1")
end

-- Renk
color=require("colors")

local function cwrite(str,clr)
  if os.getenv("init_color") == "1" or l5.getppid() == 1 then
    str=color("%{"..clr.."}"..str)
  end
  io.write(str)
end

print_star= function() cwrite("  *   ","lgreen") end
print_ok  = function() cwrite("[+]\n","lgreen") end
print_fail=function() cwrite("[X]\n","lred") end

function help()
	--if arg[0] == "/usr/milis/bin/servis" then
	if os.getenv("LANGUAGE") == "tr" then		
		print ("Milis Linux 2.3 Servis Yönetim Betiği")
		print ("-------------------------------------")
		local script="servis"
		print(script,"ekle","servis_adı","| servis sistemine ekleme")
		print(script,"sil","servis_adı","| servis sisteminden silme")

		print(script,"aktif","servis_adı","| servis otomatik başlatma")
		print(script,"pasif","servis_adı","| servis otomatik başlatmama")

		print(script,"kos","servis_adı","| servis başlatma")
		print(script,"dur","servis_adı","| servis durdurma")

		print(script,"bil","servis_adı","| servis bilgisi")

		print(script,"liste",'            ',"| aktif servis listesi")
		print(script,"eliste",'            ',"| ekli servis listesi")
		print(script,"dliste",'            ',"| depo servis listesi")
		
		print(script,"oku","bolum.anahtar","| ayar okuma")
		print(script,"yaz","bölüm anahtar deger","| ayar yazma")
	else
		print ("Milis Linux 2.3 Service Management")
        print ("-------------------------------------")
        local script="service"
        print(script,"add","service","| add service")
        print(script,"del","service","| remove service")

        print(script,"active","service","| autostart service")
        print(script,"pasive","service","| disable autostart service")

        print(script,"start","service","| start service")
        print(script,"stop","service","| stop service")

        print(script,"status","service","| service status")

        print(script,"list",'    ',"| autostart service list")
        print(script,"alist",'   ',"| added service list")
        print(script,"rlist",'   ',"| service repo list")
        
        print(script,"get","section.key","| read setting")
		print(script,"set","section key value","| write setting")
	end
	os.exit()
end

function not_ready()
	print("hazır değil!")
	os.exit()
end

function service_not_found(srv)
	if srv == nil then 
		print("servis parametresi eksik!")
	else
		print(srv.." servisi bulunamadı!")
	end
	os.exit()
end

function auth()
	if shell("id -u") ~= "0" then 
		print ("Yetkili çalıştırın!")
		os.exit()
	end
end

function shell(command)
	local handle=io.popen(command)
	local result=handle:read('*all')
	handle:close()
	-- komut çıktısı sonu yeni satır karakterin silinmesi - en sondaki \n
	if result:sub(-1) == "\n" then
		result=result:sub(1,-2)
	end
	return result
end

function get_content(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function swrite()
	svcw = io.open(config_file, "w")
	for sect, tab in pairs(svc) do
		sect_str = ("[%s]"):format(sect)
		print(sect_str)
		svcw:write(sect_str.."\n");
		for k, v in pairs(tab) do
			print(k,"=",v)
			svcw:write(("%-10s = %s\n"):format(k,v));
		end
		print()			
		svcw:write("\n");
	end
	svcw:close();
end

function sprint()
	for sect, tab in pairs(svc) do
		print(("[%s]"):format(sect))
		for k, v in pairs(tab) do
			print(k,"=",v)
		end
		print()
	end
end

-- proc/cmdline ayrıştırılarak kconfig yüklenmesi
local function kernel_config(task)
	local t=nil
	local cfg=""
	local value=""
	local poz=-1
	local cmdline=get_content("/proc/cmdline")
	while cmdline:find(task) do
		_,poz=cmdline:find(task)
		if cmdline:sub(poz+1,poz+1) == "." then
			if not t then t={} end
			cmdline=cmdline:sub(poz+2,cmdline:len())
			poz=cmdline:find("=")
			cfg=cmdline:sub(1,poz-1)
			if cmdline:find(" ") then
				value=cmdline:sub(poz+1,cmdline:find(" ")-1)
			else
				value=cmdline:sub(poz+1,cmdline:len())
			end
			t[cfg]=value
		else
			cmdline=cmdline:sub(poz+1,cmdline:len())
		end
	end
	return t
end

function drive(task,operation)
	t=require(task)
	-- check task/service has given operation 
	if t[operation] == nil then return 0 end
	print_star()
	
	local dprint=print
	
	-- system.ini ayar çalıştırma modunda ise
	if svc.system.action == "execute" then
		dprint=io.write
		action=os.execute
	end
	
	dprint(("%-5s %-50s"):format(premsg[operation],t.desc))
	
	-- ilgili servisin ayarı system.ini içinde varsa loconfig e yüklüyoruz.
	-- servis ayarı yoksa loconfig nil de olabilir
	loconfig=svc[task]
	-- servis ile ilgili kernel başlatma ayarlarının yüklenmesi
	kconfig=kernel_config(task)
	result=nil
	-- task kendi custom start işlevine sahipse o koşulacak
	if type(t[operation]) == "function" then
		result=t[operation]()
	elseif type(t[operation]) == "table" then
		if t[operation]["cmd"] ~= nil then
			local cmd={}
			if type(t[operation]["cmd"]) == "table" then
				cmd=t[operation]["cmd"]
			elseif type(t[operation]["cmd"]) == "string" then
				table.insert(cmd,t[operation]["cmd"])
			else
				print(task,"servis hata: cmd tip yanlış")
			end 
			if next(cmd) ~= nil then
				-- run one by one
				-- onebyone result control olursa
				-- her komutun başarımı kontrol edilecek
				for _,c in ipairs(cmd) do
					-- en son komuta göre başarım kontrol edilecek
					-- başarım kontrolü için cmd index verilebilecek
					-- ona göre burası ayarlanacak
					result,_,errno = action(c)
					if not errno then errno = "print_mode" end
					-- debug açıksa koşulan her komutun analizi yapılacak
					if svc.system.debug == "on" then
						print("**",c,"->",errno)
					end
				end
			end
		end

		if t[operation]["type"] ~= nil then
			local op_type=t[operation]["type"]
			local cmd_table={
				program={
					start="nice -n 0 %s 2>&1 >/dev/null &",
					stop="killall	%s",
					status="ps -aux | grep %s | grep -v grep",
				},
				pid={
					stop="pkill -F %s",
					status=function(pid) 
						local _, pid_exist=l5.readlink(pid)
						if pid_exist == 2 then return false
						else return true end 
					end,
				}
			}
			if t[op_type] ~= nil then
				local cmd_obj=cmd_table[op_type][operation]
				if type(cmd_obj) == "string" then
					result=action(cmd_obj:format(t[op_type]))
				elseif type(cmd_obj) == "function" then
					result=cmd_obj(t[op_type])
				end
			else
				print(task,"servis hatası: bilinmeyen type!")
			end
		end

		-- start/stop operation içi boş olmamalı table olup ta
		-- kontrol edilmeli todo!!!
 	end
	if action == print then result=1 end
	if result then  
		print_ok()
		--log print todo!!!
	else
		print_fail()
		--log print todo!!!
	end
	return result
end

-- aktif profildeki servisleri listeler
function list(srv)
	-- aktif profili bul
	-- profildeki servisleri listele
	local aktif = svc.system.profile
	for _, servis in ipairs(svc.profile[aktif]:split(",")) do
		print(servis)
	end
end

function elist(srv)
	for s,_ in pairs(service_list(service_dir)) do
		print(s)
	end
end

function dlist(srv)
	for s,_ in pairs(service_list(service_repo)) do
		print(s)
	end
end

function service_list(path)
	local services = {}
	for fn in shell("ls "..path.."/*.lua"):gmatch('[^\n]+') do
	   if get_content(fn):match("local task={") then
		local name = fn:match("[^/]*.lua$")
		services[name:sub(0, #name - 4)]=true
	   end
	end
	-- servis.lua kendisini de ekliyor, silmek için
	services.servis=nil
	return services
end

function check(srv)
	if service_list(service_dir)[srv] == nil then service_not_found(srv) end
end

function add(srv)
	if not srv then service_not_found(srv) end
	--os.execute("cp -fv /usr/milis/ayarlar/init/"..srv..".lua /etc/init/")
	local cmd = "cp -fv %s/%s.lua %s/"
	os.execute(cmd:format(service_repo, srv, service_dir))
end

function delete(srv)
	if not srv then service_not_found(srv) end
	local cmd="rm -v %s/%s.lua"
	os.execute(cmd:format(service_dir, srv))
end

function run(srv)
	-- toplu açılış - başlangıç
	if srv == "all" then
		local aktif = svc.system.profile
		local tasks = svc.profile[aktif]:split(",")
		for _,task in ipairs(tasks) do
			drive(task,"start")
		end
	else
		check(srv)
		drive(srv,"start")
	end
end

function stop(srv)
	-- toplu durdurma - kapanış
	if srv == "all" then
		local aktif = svc.system.profile
		local tasks = svc.profile[aktif]:split(",")
		for order,task in ipairs(tasks) do
			drive(tasks[#tasks-order+1],"stop")
		end
	else
		check(srv)
		local st = drive(srv,"status")
		if st then
			drive(srv,"stop")
		end
	end
end

function restart(srv)
	check(srv)
	drive(srv,"stop")
	os.execute("sleep 1")
	drive(srv,"start")
end

function info(srv)
    check(srv)
	drive(srv,"status")
end

-- servisin aktif edilmesi - açılışta başlaması
-- aktif edilen servis aktif profil servis listesine eklenir
function activate(srv)
	if not srv then service_not_found(srv) end
	
	local edit = ""
	local aktif = svc.system.profile
	local pservices = svc.profile[aktif]:split(",")
	for i, servis in ipairs(pservices) do
		edit = edit..servis..","
		if i+1 == #pservices then
			edit = edit..srv..","..pservices[#pservices]
			break
		end
	end
	--print(edit)
	-- değişiklikleri system.ini yaz
	svc.profile[aktif] = edit
	swrite()
end

function deactivate(srv)
	if not srv then service_not_found(srv) end
		
	local aktif = svc.system.profile
	local pservices = svc.profile[aktif]:split(",")
	local edit = ""
	for i, servis in ipairs(pservices) do
		if i == #pservices then
			edit = edit..servis
		elseif srv ~= servis then
			edit = edit..servis..","
		end
	end
	--print(edit)
	svc.profile[aktif] = edit
	-- değişiklikleri system.ini yaz
	swrite()
end

function cfgread(input)
	if not input then
		sprint()
		return
	end
	sect = input:split(".")[1]
	key  = input:split(".")[2]
	--print(sect,key)
	if key then
		if not key:match("%D") then
			key = tonumber(key)
		end
		print(svc[sect][key])
	elseif type(svc[sect]) == "table" then
		for k,v in pairs(svc[sect]) do
			print(k,"=",v)
		end
	end
end

function cfgwrite()
	-- direk konsoldan girilen anahtar girdi analiz
	local sect    = arg[2]
	local anahtar = arg[3]
	local deger   = arg[4]
	if not sect or not anahtar or not deger then
		help()
	end 
	svc[sect][anahtar] = deger
	if deger == "" then
		svc[sect][anahtar] = nil
	end
	swrite()
end

command=arg[1]
service=arg[2]

-- yetkili çalıştırma kontrolü
auth()

if command == nil then help() end

commands={
	liste=list,
	dliste=dlist,
	eliste=elist,
	ekle=add,
	sil=delete,
	kos=run,
	dur=stop,
	aktif=activate,
	pasif=deactivate,
	bil=info,
	yebaslat=restart,
	yaz=cfgwrite,
	oku=cfgread,
	-- english
	list=list,rlist=dlist,alist=elist,add=add,del=delete,
	start=run,stop=stop,active=activate,pasive=deactivate,status=info,
	restart=restart,set=cfgwrite,get=cfgread,
}

if commands[command] then commands[command](service)
else help()
end
