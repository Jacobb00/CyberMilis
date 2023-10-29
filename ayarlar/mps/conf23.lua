#!/usr/bin/env lua

local mpsconf={
	repo_dizin="/sources",
	sunucu={
		[1]="https://mls.akdeniz.edu.tr/paketler23",
		--[1]="http://10.0.2.2:9999",
	},
	talimatdepo={
		-- git repo adres, ilgili düzeye aktarılacak içerik
		-- tname düzeylere göre
		 [1]={["https://mls.akdeniz.edu.tr/git/milislinux/milis23"]="talimatname/1"},
		 [2]={["https://mls.akdeniz.edu.tr/git/milislinux/milis23"]="talimatname/2"},
		 -- [3]={
		 --	["https://mls.akdeniz.edu.tr/git/aliabc/milis"]="2/xorg",
		 -- ["https://mls.akdeniz.edu.tr/git/velidef/milis"]="2/xfce4",
		 --},
		
	},
	betikdepo={
		-- ilgili repodan bin/ ayarlar/ gibi betik içeren dizinlerin alınması
		bin={["https://mls.akdeniz.edu.tr/git/milislinux/milis23"]="bin"},
		ayarlar={["https://mls.akdeniz.edu.tr/git/milislinux/milis23"]="ayarlar"},
	},
}

return mpsconf
