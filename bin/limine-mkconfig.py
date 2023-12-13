#!/bin/env python3

import subprocess
import sys
import json
import os

param = ""

if len(sys.argv) > 1:
  param = sys.argv[1]

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
if param == "+b":
  print(blocks)
if "blockdevices" in blocks:
  for block in blocks["blockdevices"]:
    if "children" in block and block["type"] == "disk":
      for child in block["children"]: 
        #print(block["name"],child["name"])
        if child["fstype"] in ["ext4","vfat"]:
          mntp = child["mountpoint"]
          if mntp == None:
            result = subprocess.run(["udisksctl","mount","-b","/dev/"+child["name"]],capture_output=True)
            # udisksctl çıktı vermiyosa bağlama olmadı, bir sonrakine geçilir.
            if result.stdout.decode() == "" : continue
            mntp = result.stdout.decode().split()[3]
          if param == "+d":
            print("#",child["name"],mntp)
          label = "/dev/"+child["name"]
          cmdline=""
          # canlı imaj değilse kontrolü
          if child["fstype"] == "vfat" and child["label"] != "Milis_EFI":
            # find gubx64
            gpath=""
            for efi in ["grubx64.efi","bootmgfw.efi"]:
                result = subprocess.run(["find",mntp,"-name",efi],capture_output=True)
                result = result.stdout.decode()
                if result != "":
                  gpath = result.split("\n")[0].strip().split("EFI")[-1]
                  # bir kernel bulunca çık
                  break
            uuid = child["uuid"]
            if child["label"]: label=child["label"]
            label = "EFI " + label
            print(chainload_item.format(label,uuid,"/EFI"+gpath))
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
              elif os.path.exists(mntp+"/etc/lsb-release"):
                with open(mntp+"/etc/lsb-release") as f:
                  cnt = f.read().split("\n")
                  label = cnt[0].split("=")[1]+" "
                  label += cnt[1].split("=")[1]
                  label = label.replace('"',"")
              print(linux_item.format(label,uuid,kernel,uuid,initrd,uuid,cmdline))
