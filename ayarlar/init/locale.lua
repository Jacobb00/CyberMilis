
local task={
	desc="to set locale...",
			
	start=function()
		language="tr_TR.utf-8"
		locale_file="/etc/profile.d/i18n.sh"
		env_file="/etc/environment"
		if loconfig.language then language=loconfig.language end
		if kconfig and kconfig.language then language=kconfig.language end
		_, p=language:find("_")
		lang=language:sub(0,p-1)
		if loconfig.lang then lang=loconfig.lang end
		if kconfig and kconfig.lang then lang=kconfig.lang end
		
		locale_str = [[
[ -z $LANG ] && export LANG=%s
[ -z $LANGUAGE ] && export LANGUAGE=%s
[ -z $LC_ALL ] && export LC_ALL=%s
]]
		f=io.open(locale_file,"w")
		f:write(locale_str:format(language, lang, language))
		
		cmd="echo LANG=%s > %s"
		result=action(cmd:format(language,env_file))
		return result
	end,
}
return task
