#!/bin/env python3

import subprocess
import sys

limine_item = """
:{}
  PROTOCOL={}
  KERNEL=guid://{}
  MODULE_PATH=guid://{}
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
  print("#",disk)
  result = subprocess.run(["linux-boot-prober",disk],capture_output=True)
  infos = result.stdout.decode().split("\n")[0:-1]
  for info in infos:
    protocol = disks[disk]
    label = info.split(":")[2]
    kernel = info.split(":")[3]
    cmdline = info.split(":")[4]
    initrd = info.split(":")[5]
    print(limine_item.format(label,protocol,kernel,cmdline,initrd))
  print()
