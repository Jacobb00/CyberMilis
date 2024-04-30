#!/bin/bash

log_file="/tmp/oto-diskpart.log"

disk=$1
echo "$(date) $disk otodisk başladı" >> $log_file

if [ ! -z $disk ];then
  [ ! -b $disk ] &&  echo "$disk !!!" && exit 1
  [ ! -f /usr/bin/sfdisk ] && echo "sfdisk command!!!" && exit 1
  bir="1"
  iki="2"
  # nvme kontrol
  nvme list | grep ${disk}
  if [ $? -eq 0 ];then
    bir="p1"
    iki="p2"
  fi
  if [ -d /sys/firmware/efi ];then
    echo -e ",300M,EF\n;" | sfdisk $disk
    echo "$disk 2 parça ayrılacak." >> $log_file
    mkfs.vfat -F32 ${disk}${bir} || echo "${disk}${bir} formatlanamadı." >> $log_file
    # lvm kontrol
    lvs -o +devices --no-headings | grep ${disk}${iki}
    if [ $? -eq 0 ];then
      vgchange -an `lvs -o +devices --no-headings | grep ${disk}${iki} | awk '{print $2}'`
      echo "${disk}${iki} lvm pasif edildi." >> $log_file
    fi
    mkfs.ext4 -F ${disk}${iki} || echo "${disk}${iki} formatlanamadı." >> $log_file
    echo "$disk 2 parça ayrıldı." >> $log_file
  else
    echo -e ",,L" | sfdisk $disk
    echo "$disk 1 parça ayrılacak." >> $log_file
    mkfs.ext4 -F ${disk}${bir} || echo "${disk}${bir} formatlanamadı." >> $log_file
    echo "$disk 1 parça ayrıldı." >> $log_file
  fi
else
  echo "disk parameter!!!"
fi

echo "`blkid | grep $disk`" >> $log_file
echo "$(date) otodisk bitti" >> $log_file
