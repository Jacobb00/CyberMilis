#!/bin/sh
milis="/sources/gitlab.com.milislinux.milis23.git"
if [ -d $milis ];then
milisj="{\"milis\":\"güncel değil\"}"

wid=`curl -s https://gitlab.com/api/v4/projects/51691781/repository/commits?per_page=1 | jq -r .[].id`

cd $milis
lid=`git log --pretty=oneline | head -n1| awk '{print $1}'`

[ "$lid" == "$wid" ] && milisj="{\"milis\":\"güncel\"}"
else
milisj="{\"milis\":\"dizin yok\"}"
fi
mps="/usr/milis/mps"
mpsj="{\"mps\":\"güncel değil\"}"

wid=`curl -s https://gitlab.com/api/v4/projects/51691929/repository/commits?per_page=1 | jq -r .[].id`

cd $mps
lid=`git log --pretty=oneline | head -n1| awk '{print $1}'`

[ "$lid" == "$wid" ] && mpsj="{\"mps\":\"güncel\"}"

echo "[$milisj,$mpsj]"
