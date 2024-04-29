#!/bin/bash

log_file="/tmp/oto-diskpart.log"

disk=$1
echo "$(date) $disk otodisk başladı" >> $log_file

if [ ! -z $disk ];then
  [ ! -b $disk ] &&  echo "$disk !!!" && exit 1
  [ ! -f /usr/bin/sfdisk ] && echo "sfdisk command!!!" && exit 1
  if [ -d /sys/firmware/efi ];then
    echo -e ",100M,EF\n;" | sfdisk $disk
    echo "$disk 2 parça ayrılacak." >> $log_file
    mkfs.vfat -F32 ${disk}1 || echo "${disk}1 formatlanamadı." >> $log_file
    # lvm kontrol
    lvs -o +devices --no-headings | grep ${disk}2
    if [ $? -eq 0 ];then
      vgchange -an `lvs -o +devices --no-headings | grep ${disk}2 | awk '{print $2}'`
      echo "${disk}2 lvm pasif edildi." >> $log_file
    fi
    mkfs.ext4 -F ${disk}2 || echo "${disk}2 formatlanamadı." >> $log_file
    echo "$disk 2 parça ayrıldı." >> $log_file
  else
    echo -e ",,L" | sfdisk $disk
    echo "$disk 1 parça ayrılacak." >> $log_file
    mkfs.ext4 -F ${disk}1 || echo "${disk}1 formatlanamadı." >> $log_file
    echo "$disk 1 parça ayrıldı." >> $log_file
  fi
else
  echo "disk parameter!!!"
fi

echo "`blkid | grep $disk`" >> $log_file
echo "$(date) otodisk bitti" >> $log_file
