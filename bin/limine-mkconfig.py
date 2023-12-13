#!/bin/env python3

import subprocess
import sys
import json
import os

linux_item = """
:{}
  PROTOCOL=linux
  KERNEL_PATH=guid://{}/boot/{}
  MODULE_PATH=guid://{}/boot/{}
  CMDLINE=root=UUID={} rw {} 
"""

chainload_item = """
:{}
  PROTOCOL=chainload
  IMAGE_PATH=guid://{}{}
"""

# os-prober ile sistemlerin tespiti
cmd = "lsblk -o TYPE,NAME,FSTYPE,LABEL,PARTLABEL,UUID,FSSIZE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT -J"
result = subprocess.run(cmd.split(),capture_output=True)
#print(result)
blocks =json.loads(result.stdout.decode())
#print(blocks)
if "blockdevices" in blocks:
  for block in blocks["blockdevices"]:
    if "children" in block and block["type"] == "disk":
      for child in block["children"]: 
        #print(block["name"],child["name"])
        if child["fstype"] in ["ext4","vfat"] or child["type"] == "part":
          mntp = child["mountpoint"]
          if mntp == None:
            result = subprocess.run(["udisksctl","mount","-b","/dev/"+child["name"]],capture_output=True)
            mntp = result.stdout.decode().split()[3]
          print("#",child["name"],mntp)
          label = "/dev/"+child["name"]
          cmdline=""
          if child["fstype"] == "vfat":
            # find gubx64
            result = subprocess.run(["find",mntp,"-name","grubx64.efi"],capture_output=True)
            grubx = result.stdout.decode()
            gpath = grubx.split(mntp)[1]
            uuid = child["uuid"]
            if child["label"]: label=child["label"]
            print(chainload_item.format(label,uuid,gpath))
          # sadece ext4 olan linux noktalarına bak
          if child["fstype"] == "ext4":
            # find kernel-initrd
            # sadece /boot altında ara
            boot_path = mntp+"/boot"
            if os.path.exists(boot_path):
              initrd = ""
              kernel = ""
              for init in ["initrd.img-*","initrd-*","initramfs-*","initramfs-linux-*"]:
                result = subprocess.run(["find",boot_path,"-name",init],capture_output=True)
                result = result.stdout.decode()
                if result != "":
                  initrd= result.split("\n")[0].strip().split("/boot/")[-1]
                  # bir init bulunca çık
                  break 
              for kern in ["kernel-*","vmlinuz-*","initramfs-linux-*"]:
                result = subprocess.run(["find",boot_path,"-name",kern],capture_output=True)
                result = result.stdout.decode()
                if result != "":
                  kernel = result.split("\n")[0].strip().split("/boot/")[-1]
                  # bir kernel bulunca çık
                  break
              uuid = child["uuid"]
              if child["label"]: label=child["label"]
              if os.path.exists(mntp+"/etc/milis-surum"):
                cmdline += "init=/usr/bin/init quiet"
                with open(mntp+"/etc/milis-surum") as f:
                  label = f.read().strip()
              print(linux_item.format(label,uuid,kernel,uuid,initrd,uuid,cmdline))
