#!/usr/bin/python3
# -*- coding: utf-8 -*-

#source : https://gist.github.com/zobayer1/d86a59e45ae86198a9efc6f3d8682b49

import sys
import importlib.util

bcrypt_module = importlib.util.find_spec('bcrypt')

if not bcrypt_module:
  print("pip3 install bcrypt")
  sys.exit(1)

import bcrypt

def encrypt_password(username, password):
  bcrypted = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt(rounds=12)).decode("utf-8")
  return f"{username}:{bcrypted}"

if len(sys.argv) != 3:
  print("kullanim: httpasswd.py username password")
  sys.exit(1)

user = sys.argv[1]
passwd = sys.argv[2]

print(encrypt_password(user,passwd))
