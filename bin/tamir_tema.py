#!/bin/python3
import configparser
import os
import xml.etree.cElementTree as ET
from gi.repository import Gtk, Gio, GObject, GLib

homedir = os.path.expanduser( '~' )
config_dir = homedir + "/.config/"

# masa.ini
config = configparser.ConfigParser()
config.read(config_dir + "masa.ini")

# GTK
# keyfile tanımlı değilse, sistem ilk açılış

# yedek degerler
_theme = "Arc-Milis-Dark"
_icon = "Papirus-Dark"
_cursor = "volantes_cursors_milis"
_font = "Sans Regular 11"

if not os.path.exists(config_dir + "glib-2.0/settings/keyfile"):
	
	if "theme" in config :
	
		if "name" in config["theme"]:
			_theme = config["theme"]["name"]
		
		if "icon" in config["theme"]:
			_icon = config["theme"]["icon"]
		
		if "cursor" in config["theme"]:
			_cursor = config["theme"]["cursor"]
		
		if "font" in config["theme"]:	
			_font = config["theme"]["font"]

	set_desktop="gsettings set org.gnome.desktop.interface"
	set_sound="gsettings set org.gnome.desktop.sound"

	os.system("{} {} {}".format(set_desktop,"gtk-theme",_theme))
	os.system("{} {} {}".format(set_desktop,"icon-theme",_icon))
	os.system("{} {} {}".format(set_desktop,"cursor-theme",_cursor))
	os.system("{} {} {}".format(set_desktop,"cursor-size",24))
	os.system("{} {} {}".format(set_desktop,"font-name","'"+_font+"'"))

	os.system("{} {} {}".format(set_desktop,"toolbar-style", "both-horiz"))
	os.system("{} {} {}".format(set_desktop,"toolbar-icons-size", "large"))
	os.system("{} {} {}".format(set_desktop,"font-hinting", "slight"))
	os.system("{} {} {}".format(set_desktop,"font-antialiasing", "grayscale"))

	os.system("{} {} {}".format(set_sound,"event-sounds", "true"))
	os.system("{} {} {}".format(set_sound,"input-feedback-sounds", "true"))
	
	# decoration düzeltme
	os.system("gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'")
	os.system("gsettings set org.gnome.desktop.wm.preferences button-layout 'menu:minimize,maximize,close'")
	
# active tema
else:
	gio_cfg = Gio.Settings.new("org.gnome.desktop.interface")
	_theme = gio_cfg.get_string("gtk-theme")
		
# Labwc
rc_xml_file = config_dir + "labwc/rc.xml"
if os.path.exists(rc_xml_file):
	tree = ET.parse(rc_xml_file)
	root = tree.getroot()
	for tema in root.findall('theme'):
		name = tema.find("name")
		name.text = _theme
		tree.write(rc_xml_file)
	# tema aktif olması için labwc reconfigure gerekli
	if os.environ.get("LABWC_PID"):
		os.system("labwc -r")	

# Geany - .config/geany/color_schemes altındaki *.conf olarak yazılmalı
if "theme" in config and "geany" in config["theme"]:
	geany_ini_file = config_dir + "geany/geany.conf"
	# geany files bölümünde aynı değere sahip anahtarlar tutuyor - onun için raw
	config_g = configparser.RawConfigParser()
	config_g.optionxform = lambda option: option
	config_g.read(geany_ini_file)
	config_g.set('geany', 'color_scheme', config["theme"]["geany"])
	with open(geany_ini_file,"w") as g_file:
		config_g.write(g_file) 

# Swaync
if "theme" in config and "swaync" in config["theme"]:
	target_dir = config_dir + "swaync/"
	source_file = config["theme"]["swaync"]
	os.system("cp -fv {} {}".format(source_file, target_dir+"style.css"))

# nwg
if "theme" in config and "nwg" in config["theme"]:
	source_file = config["theme"]["nwg"]
	target_dir = config_dir + "nwg-bar/"
	os.system("cp -fv {} {}".format(source_file, target_dir+"style.css"))
	target_dir = config_dir + "nwg-drawer/"
	os.system("cp -fv {} {}".format(source_file, target_dir+"drawer.css"))

# Waybar
if "theme" in config and "waybar" in config["theme"]:
	target_dir = config_dir + "waybar/"
	source_file = config["theme"]["waybar"]
	os.system("cp -fv {} {}".format(source_file, target_dir+"style.css"))

	
"""
import gi
gi.require_version("Gtk","3.0")

from gi.repository import Gtk, Gio, GObject, GLib

config.read(homedir + "/.config/gtk-3.0/settings.ini")

_theme = config["Settings"]["gtk-theme-name"]
_icon  = config["Settings"]["gtk-icon-theme-name"]
_cursor  = config["Settings"]["gtk-cursor-theme-name"]
_font  = config["Settings"]["gtk-font-name"]

gtk_cfg = Gtk.Settings.get_default()

#print(gtk_cfg.get_property("gtk-theme-name"))

gtk_cfg.set_property("gtk-theme-name",_theme)
gtk_cfg.set_property("gtk-icon-theme-name",_icon)
gtk_cfg.set_property("gtk-cursor-theme-name",_cursor)
gtk_cfg.set_property("gtk-font-name",_font)

# gio ayarlarını ayarla
gio_cfg = Gio.Settings.new("org.gnome.desktop.interface")
gio_cfg.set_string("gtk-theme",_theme)
gio_cfg.set_string("icon-theme",_icon)
gio_cfg.set_string("cursor-theme",_cursor)
gio_cfg.set_string("font-name",_font)
#print(gio_cfg.get_string("gtk-theme"))
"""
