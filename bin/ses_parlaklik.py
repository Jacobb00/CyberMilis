#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys, subprocess, time

# Capslock info cat /sys/class/leds/input17::capslock/brightness


def get_icon(percent, n):
	if n == "ses":
		is_on = percent[1]
		percent = percent[0]
		if is_on == "off":
			name = "volume-level-muted"
		elif percent == 0:
			name = "volume-level-none"
		elif percent < 30:
			name = "volume-level-low"
		elif percent < 70:
			name = "volume-level-medium"
		else:
			name = "volume-level-high"
	else:
		if percent < 30:
			name = "gpm-brightness-lcd-invalid"
		elif percent < 70:
			name = "gpm-brightness-lcd-disabled"
		else:
			name = "gpm-brightness-lcd"
	return name

def brightness_up():
	run_command("light -A 5;light -O")

def brightness_down():
	run_command("light -U 5;light -O")

def sound_up():
	run_command("amixer sset Master 5%+")

def sound_down():
	run_command("amixer sset Master 5%-")

def sound_toggle():
	run_command("amixer sset Master toggle")

def get_light():
	l = run_command("light -G")[:-1]
	return int(l.split(".")[0])

def get_sound():
	s = run_command("amixer get Master").split("\n")
	ns = ""
	for i in s:
		if "Front Right:" in i:
			ns = i
			break
	if ns != "":
		ns = ns.split()
		sound = ns[4][1:-2]
		is_on = ns[5][1:-1]
		return (int(sound), is_on)
	return (0,"on")
			
def run_command(command):
	get = subprocess.Popen(["sh","-c",command], stdout = subprocess.PIPE)
	get.wait()
	get = get.communicate()[0]
	get = get.decode("utf-8","strict")
	return get

if __name__ == '__main__':
	args = sys.argv
	for a in args:
		if a == "ses" or a == "parlaklik" or a == "capslock" or a == "numlock":
			args = args[args.index(a):]
			break
	if args[0] == "ses":
		if args[1] == "+":
			sound_up()
		elif args[1] == "-":
			sound_down()
		elif args[1] == "x":
			sound_toggle()
		s = get_sound()
		run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "{}" "Ses : {}"'.format(get_icon(s,"ses"),s[0]))
	elif args[0] == "parlaklik":
		if args[1] == "+":
			brightness_up()
		elif args[1] == "-":
			brightness_down()
		l = get_light()
		run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "{}" "Parlaklık : {}"'.format(get_icon(l,"parlaklik"),l))
	elif args[0] == "capslock":
		time.sleep(0.5)
		r = run_command("cat /sys/class/leds/input*capslock/brightness")
		r = r.split("\n")[0]
		if r == "0":
			run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "caps-lock-off" "CapsLock Kapandı"')
		else:
			run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "caps-lock-on" "CapsLock Açıldı"')
	elif args[0] == "numlock":
		time.sleep(0.5)
		r = run_command("cat /sys/class/leds/input*numlock/brightness")
		r = r.split("\n")[0]
		if r == "0":
			run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "num-lock-off" "NumLock Kapandı"')
		else:
			run_command('notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "num-lock-on" "NumLock Açıldı"')
	else:
		print("Hatalı argüman ses +/-/x veya parlaklik +/-")
		
