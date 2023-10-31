#!/bin/env python3

import subprocess
import sys

limine_item = """
:{}
  PROTOCOL={}
  KERNEL_PATH=guid://{}{}
  MODULE_PATH=guid://{}{}
  CMDLINE={}
"""

# os-prober ile sistemlerin tespiti
result = subprocess.run("os-prober",capture_output=True)

sistemler = result.stdout.decode().split("\n")[0:-1]
#print("s:",sistemler)
#sys.exit()
disks={}
for sistem in sistemler:
  disk = sistem.split(":")[0]
  etiket = sistem.split(":")[1]
  protokol = sistem.split(":")[3]
  disks[disk] = protokol

# cmdline kernel initrd analiz
for disk in disks:
  #print("#",disk)
  result = subprocess.run(["linux-boot-prober",disk],capture_output=True)
  infos = result.stdout.decode().split("\n")[0:-1]
  for info in infos:
    protocol = disks[disk]
    label = info.split(":")[2]
    kernel = info.split(":")[3]
    initrd = info.split(":")[4]
    cmdline = info.split(":")[5]
    if label != "":
      uuid = cmdline.split("UUID=")[1].split()[0]
      print(limine_item.format(label,protocol,uuid,kernel,uuid,initrd,cmdline))
  print()
