#!/usr/bin/python3
import gi, subprocess, os, sys
gi.require_version('Gtk', '3.0')
gi.require_version("GtkLayerShell","0.1")
from gi.repository import Gio, Gtk, Gdk, GdkPixbuf, GtkLayerShell, GLib
import configparser

icon_text = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="64"
   height="64"
   version="1"
   id="svg12"
   sodipodi:docname="System.svg"
   inkscape:version="0.92.4 (5da689c313, 2019-01-14)">
  <metadata
     id="metadata18">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs16" />
  <sodipodi:namedview
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1"
     objecttolerance="10"
     gridtolerance="10"
     guidetolerance="10"
     inkscape:pageopacity="0"
     inkscape:pageshadow="2"
     inkscape:window-width="1908"
     inkscape:window-height="1044"
     id="namedview14"
     showgrid="false"
     inkscape:zoom="3.6875"
     inkscape:cx="-14.915254"
     inkscape:cy="32"
     inkscape:window-x="4"
     inkscape:window-y="28"
     inkscape:window-maximized="0"
     inkscape:current-layer="svg12" />
  <path
     style="opacity:0.2"
     d="M 30.599609,5 C 27.497209,5 25,7.4972093 25,10.599609 v 2.625 a 21,21 0 0 0 -6.623047,3.826172 l -2.275391,-1.3125 c -2.686757,-1.5512 -6.09919,-0.635976 -7.6503901,2.050781 l -1.4003907,2.421876 c -1.5511999,2.686758 -0.6359758,6.09919 2.0507813,7.65039 l 2.2656255,1.308594 A 21,21 0 0 0 11,33 a 21,21 0 0 0 0.367188,3.830078 l -2.2656255,1.308594 c -2.6867571,1.5512 -3.6019813,4.963633 -2.0507813,7.65039 l 1.4003907,2.421876 c 1.5512001,2.686757 4.9636331,3.601981 7.6503901,2.050781 l 2.259766,-1.304688 A 21,21 0 0 0 25,52.769531 v 2.63086 C 25,58.502791 27.497209,61 30.599609,61 h 2.800782 C 36.502791,61 39,58.502791 39,55.400391 v -2.640625 a 21,21 0 0 0 6.623047,-3.810547 l 2.275391,1.3125 c 2.686757,1.5512 6.09919,0.635977 7.65039,-2.050781 l 1.400391,-2.421876 c 1.5512,-2.686757 0.635975,-6.09919 -2.050781,-7.65039 L 52.632812,36.830078 A 21,21 0 0 0 53,33 21,21 0 0 0 52.632812,29.169922 l 2.265626,-1.308594 c 2.686757,-1.5512 3.601981,-4.963632 2.050781,-7.65039 l -1.400391,-2.421876 c -1.5512,-2.686758 -4.963633,-3.601981 -7.65039,-2.050781 l -2.259766,1.304688 A 21,21 0 0 0 39,13.228516 V 10.599609 C 39,7.4972093 36.502791,5 33.400391,5 Z"
     id="path2" />
  <path
     style="fill:#546e7a"
     d="M 30.599609,4 C 27.497209,4 25,6.4972094 25,9.5996094 v 2.6249996 a 21,21 0 0 0 -6.623047,3.826172 l -2.275391,-1.3125 c -2.686757,-1.5512 -6.09919,-0.635976 -7.6503901,2.050781 l -1.4003907,2.421876 c -1.5511999,2.686758 -0.6359758,6.09919 2.0507813,7.65039 l 2.2656255,1.308594 A 21,21 0 0 0 11,32 a 21,21 0 0 0 0.367188,3.830078 l -2.2656255,1.308594 c -2.6867571,1.5512 -3.6019813,4.963633 -2.0507813,7.65039 l 1.4003907,2.421876 c 1.5512001,2.686757 4.9636331,3.601981 7.6503901,2.050781 l 2.259766,-1.304688 A 21,21 0 0 0 25,51.769531 v 2.63086 C 25,57.502791 27.497209,60 30.599609,60 h 2.800782 C 36.502791,60 39,57.502791 39,54.400391 v -2.640625 a 21,21 0 0 0 6.623047,-3.810547 l 2.275391,1.3125 c 2.686757,1.5512 6.09919,0.635976 7.65039,-2.050781 l 1.400391,-2.421876 c 1.5512,-2.686757 0.635975,-6.09919 -2.050781,-7.65039 L 52.632812,35.830078 A 21,21 0 0 0 53,32 21,21 0 0 0 52.632812,28.169922 l 2.265626,-1.308594 c 2.686757,-1.5512 3.601981,-4.963632 2.050781,-7.65039 l -1.400391,-2.421876 c -1.5512,-2.686758 -4.963634,-3.601981 -7.65039,-2.050781 l -2.259766,1.304688 A 21,21 0 0 0 39,12.228516 V 9.5996094 C 39,6.4972094 36.502791,4 33.400391,4 Z"
     id="path4" />
  <path
     style="opacity:0.1;fill:#ffffff"
     d="M 30.599609,4 C 27.497209,4 25,6.4972094 25,9.5996094 V 10.599609 C 25,7.4972094 27.497209,5 30.599609,5 h 2.800782 C 36.502791,5 39,7.4972094 39,10.599609 V 9.5996094 C 39,6.4972094 36.502791,4 33.400391,4 Z M 25,12.224609 a 21,21 0 0 0 -6.623047,3.826172 l -2.275391,-1.3125 c -2.686757,-1.5512 -6.09919,-0.635976 -7.6503901,2.050781 l -1.4003907,2.421876 c -0.6033566,1.045044 -0.8286088,2.200037 -0.7265624,3.3125 0.069736,-0.789767 0.3027074,-1.578362 0.7265624,-2.3125 l 1.4003907,-2.421876 c 1.5512001,-2.686757 4.9636331,-3.601981 7.6503901,-2.050781 l 2.275391,1.3125 A 21,21 0 0 1 25,13.224609 Z m 14,0.0039 v 1 a 21,21 0 0 1 6.638672,3.814453 l 2.259766,-1.304688 c 2.686757,-1.5512 6.09919,-0.635977 7.65039,2.050781 l 1.400391,2.421876 c 0.423855,0.734138 0.656827,1.522733 0.726562,2.3125 0.102046,-1.112463 -0.123206,-2.267456 -0.726562,-3.3125 l -1.400391,-2.421876 c -1.5512,-2.686758 -4.963633,-3.601981 -7.65039,-2.050781 l -2.259766,1.304688 A 21,21 0 0 0 39,12.228516 Z M 52.767578,29.09179 52.632812,29.16992 A 21,21 0 0 1 52.974609,32.541016 21,21 0 0 0 53,32 21,21 0 0 0 52.767578,29.091797 Z m -41.529297,0.0039 A 21,21 0 0 0 11,32 a 21,21 0 0 0 0.02539,0.458984 21,21 0 0 1 0.341797,-3.289062 z m 41.523438,6.808594 a 21,21 0 0 1 -0.128907,0.925781 l 2.265626,1.308594 c 1.641712,0.947843 2.617034,2.590267 2.777343,4.33789 0.185479,-2.100574 -0.824725,-4.210545 -2.777343,-5.33789 z m -41.529297,0.0039 -2.1308595,1.230469 c -1.9526187,1.127345 -2.9628223,3.237316 -2.7773437,5.33789 0.1603097,-1.747623 1.1356309,-3.390047 2.7773437,-4.33789 l 2.2656255,-1.308594 a 21,21 0 0 1 -0.134766,-0.921875 z"
     id="path6" />
  <path
     style="opacity:0.2"
     d="m 32.000237,21.00088 c 6.627221,0 11.999676,5.372455 11.999676,11.999676 0,6.627221 -5.372455,11.999676 -11.999676,11.999676 -6.627221,0 -11.999676,-5.372455 -11.999676,-11.999676 0,-6.627221 5.372455,-11.999676 11.999676,-11.999676 z"
     id="path8" />
  <path
     style="fill:#ffffff"
     d="m 32.000237,20.001334 c 6.627221,0 11.999676,5.372455 11.999676,11.999676 0,6.627221 -5.372455,11.999676 -11.999676,11.999676 -6.627221,0 -11.999676,-5.372455 -11.999676,-11.999676 0,-6.627221 5.372455,-11.999676 11.999676,-11.999676 z"
     id="path10" />
</svg>"""

config = configparser.ConfigParser()

lang = {
	"tr": {
		"All" : "Tümü",
		"Favorites":"Favoriler",
		"Development":"Geliştirme",
		"Education":"Eğitim",
		"Game":"Oyun",
		"Graphics":"Grafik",
		"Multimedia":"Medya",
		"Network":"Ağ",
		"Office":"Ofis",
		"Science":"Teknik",
		"System":"Sistem",
		"Utility":"Araç",
		"Other":"Diğer",
	}
}


def translate(str):
	lg = os.getenv("LANGUAGE")
	if lg and lg != "" and lg in lang and str in lang[lg]:
		return lang[lg][str]
	return str

def rtranslate(str):
	lg = os.getenv("LANGUAGE")
	if lg and lg != "" and lg in lang:
		return	list(lang[lg].keys())[list(lang[lg].values()).index(str)]
	return str

class MMenu(Gtk.ApplicationWindow):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self.categories = {
		"All":[],
		"Favorites":[],
		"Development":[],
		"Education":[],
		"Favorites":[],
		"Game":[],
		"Graphics":[],
		"Multimedia":[],
		"Network":[],
		"Office":[],
		"Science":[],
		"System":[],
		"Utility":[],
		"Other":[],}
		
		self.category_icons = {
		"Utility" : "applications-utilities",
		"Favorites" : "love",
		"All" : "applications-all",
		"Science" : "applications-science",
		"System" : "applications-system",
		"Multimedia" : "applications-multimedia",
		"Office" : "applications-office",
		"Development" : "applications-development",
		"Education" : "applications-education",
		"Game" : "applications-games",
		"Graphics" : "applications-graphics",
		"Network" : "applications-network",
		"Other" : "applications-other",
		}
	
		#Menu Settings
		self.set_type_hint(Gdk.WindowTypeHint.UTILITY)
		self.set_decorated(False)
		self.menu_width = 640
		self.menu_height = 400
		self.is_full_screen = False
		self.menu_close = True
		self.icon_size = 32
		self.logout_command = "logout.sh"
		self.restart_command = "sudo reboot"
		self.shutdown_command = "sudo poweroff"
		self.single_click = False
		self.show_generic_name = False
		self.show_description = False
		self.horizontal = False
		self.hide_categories = True
		self.menu_position = 0
		self.d_icon_theme = Gtk.IconTheme.get_default()

		self.config_file = os.path.expanduser("~/.config/menu.ini")
		if not os.path.exists(self.config_file):
			f = open(self.config_file, "w")
			f.write("""[settings]
width = 640
height = 400
fullscreen = 1
menu_close = 1
icon_size = 64
single_click = 1
show_description = 0
show_generic_name = 0
horizontal = 0
hide_categories = 0
;0 orta, 1 sol-alt, 2 sol-üst, 3 sağ-alt, 4 sağ-üst
menu_position = 1
""")
			f.close()


		self.get_config_settings()
		################################ UI #################################
		#main box
		m_box = Gtk.VBox()
		self.add(m_box)

		#search entry add to machine
		self.search_entry = Gtk.SearchEntry()
		self.search_entry.connect("search-changed",self.change_search_entry)

		#Entry add box center
		s_box = Gtk.HBox()
		s_box.pack_start(self.search_entry,True,True,10)
		m_box.pack_start(s_box,False,True,10)

		self.settings_button = Gtk.Button()
		self.settings_button.connect("clicked",self.click_settings_button)
		#image = self.get_pixbuf_to_image("settings.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("settings",16))
		self.settings_button.set_image(image)
		# ayarlara girince menü kitleniyor todo!!!
		s_box.pack_start(self.settings_button,False,False,2)

		self.logout_button = Gtk.Button()
		self.logout_button.connect("clicked",self.click_logout_button)
		#image = self.get_pixbuf_to_image("Log-out.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("system-log-out",16))
		self.logout_button.set_image(image)
		s_box.pack_start(self.logout_button,False,False,2)

		self.restart_button = Gtk.Button()
		self.restart_button.connect("clicked",self.click_restart_button)
		#image = self.get_pixbuf_to_image("Reboot.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("system-reboot",16))

		self.restart_button.set_image(image)
		s_box.pack_start(self.restart_button,False,False,2)

		self.shutdown_button = Gtk.Button()
		self.shutdown_button.connect("clicked",self.click_shutdown_button)
		#image = self.get_pixbuf_to_image("Shutdown.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("system-shutdown",16))

		self.shutdown_button.set_image(image)
		s_box.pack_start(self.shutdown_button,False,False,2)

		if not self.hide_categories:
			#Add Paned
			self.paned = Gtk.HPaned()
			m_box.pack_end(self.paned,True,True,10)

			#Paned split left and right
			l_box = Gtk.HBox()
			r_box = Gtk.HBox()
			self.paned.pack1(l_box)
			self.paned.pack2(r_box)

		#Categories Store-List
		self.cteg_store = Gtk.ListStore(GdkPixbuf.Pixbuf,str)
		self.cteg_list = Gtk.TreeView(model=self.cteg_store)
		self.cteg_list.connect("cursor-changed",self.activated_cteg_list)
		# simge, kategori yazmasına gerek yok
		self.cteg_list.set_headers_visible(False)
		renderer = Gtk.CellRendererPixbuf()
		coloumn = Gtk.TreeViewColumn("Simge",renderer, gicon = 0)
		self.cteg_list.append_column(coloumn)
		renderer = Gtk.CellRendererText()
		coloumn = Gtk.TreeViewColumn("Kategoriler",renderer, text = 1)
		self.cteg_list.append_column(coloumn)
		if not self.hide_categories:
			l_box.pack_start(self.set_scroll_win(self.cteg_list),True,True,10)

		#Applications Store-List
		self.apps_store = Gtk.ListStore(str,GdkPixbuf.Pixbuf,Gio.DesktopAppInfo)
		self.apps_list = Gtk.IconView(model=self.apps_store)
		self.apps_list.connect("button_press_event", self.apps_list_click)
		self.apps_list.set_text_column(0)
		self.apps_list.set_pixbuf_column(1)
		if self.horizontal:
			self.apps_list.set_item_orientation(Gtk.Orientation.HORIZONTAL)
			if self.hide_categories:
				self.apps_list.set_item_width(350)
			else:
				self.apps_list.set_item_width(250)
		else:
			self.apps_list.set_item_width(self.icon_size+1280/self.icon_size)
		if self.hide_categories:
			m_box.pack_end(self.set_scroll_win(self.apps_list),True,True,10)
		else:
			r_box.pack_start(self.set_scroll_win(self.apps_list),True,True,10)
		########################################################################


		#Key press focus widget change
		self.connect("key-press-event",self.key_press)

		#Default Selection List
		self.get_applications()
		self.set_categories_ui()
		self.cteg_list.set_cursor(0)


	def get_config_settings(self):
		try:
			config.read(self.config_file)
			if "settings" in config:
				settings = config["settings"]
				if "width" in settings:
					self.menu_width = int(settings["width"]	)
				if "height" in settings:
					self.menu_height = int(settings["height"])
				if "fullscreen" in settings:
					self.is_full_screen = int(settings["fullscreen"])
				if "menu_close" in settings:
					self.menu_close = int(settings["menu_close"])
				if "icon_size" in settings:
					self.icon_size = int(settings["icon_size"])
				if "single_click" in settings:
					self.single_click = int(settings["single_click"])
				if "show_generic_name" in settings:
					self.show_generic_name = int(settings["show_generic_name"])
				if "show_description" in settings:
					self.show_description = int(settings["show_description"])
				if "horizontal" in settings:
					self.horizontal = int(settings["horizontal"])
				if "hide_categories" in settings:
					self.hide_categories = int(settings["hide_categories"])
				if "menu_position" in settings:
					self.menu_position = int(settings["menu_position"])
		except Exception as e:
			print("Not read config file:", e)

	def click_settings_button(self,widget):
		subprocess.Popen(["xdg-open",self.config_file])
		self.destroy()

	def click_logout_button(self,widget):
		if self.logout_command != "":
			subprocess.call(self.logout_command.split())


	def click_restart_button(self,widget):
		if self.restart_command != "":
			subprocess.call(self.restart_command.split())


	def click_shutdown_button(self,widget):
		if self.shutdown_command != "":
			subprocess.call(self.shutdown_command.split())


	def get_pixbuf_to_image(self,file_,size=24):
		pb =  GdkPixbuf.Pixbuf.new_from_file_at_size(self.icon_dir+file_,size,size)
		image = Gtk.Image.new_from_pixbuf(pb)
		return image


	def key_press(self, widget, event):
		"""Key press Arrows focus list,
		Key press Enter run app,
		Else focus entry"""
		key_name = Gdk.keyval_name(event.keyval)
		arrow_keys = ["Up","Down","Left","Right"]
		if key_name in arrow_keys:
			self.apps_list.grab_focus()
		elif key_name == "Return":
			if len(self.apps_list.get_selected_items()) != 0:
				self.activated_apps_list(self.apps_list,self.apps_list.get_selected_items()[0])
		elif key_name == "Escape":
			self.destroy()
		else:
			if not self.search_entry.is_focus():
				self.search_entry.grab_focus()


	def get_global_pointer(self):
		"""Global cursor position and screen size"""
		root_win = Gdk.get_default_root_window()
		pointer = root_win.get_pointer()
		return (pointer.x, pointer.y,root_win.get_width(),root_win.get_height())


	def get_applications(self):
		"Applications get and set categories"
		apps = Gio.DesktopAppInfo.get_all()
		for app in apps:
			name_ = app.get_name()
			g_name = app.get_generic_name()
			desc_ = app.get_description()
			icon_ = app.get_icon()
			mime_ = app.get_supported_types()
			exec_ = app.get_executable()
			nodisp = app.get_nodisplay()
			cteg_ = app.get_categories()
			desktop_ = app.get_id()
			app = [name_,desc_,icon_,app,desktop_,exec_,g_name]
			if not nodisp:
				self.set_categories(app,cteg_)
		self.categories["All"].sort()
		self.categories["Favorites"].sort()
		self.categories["Development"].sort()
		self.categories["Education"].sort()
		self.categories["Favorites"].sort()
		self.categories["Game"].sort()
		self.categories["Graphics"].sort()
		self.categories["Multimedia"].sort()
		self.categories["Network"].sort()
		self.categories["Office"].sort()
		self.categories["Science"].sort()
		self.categories["System"].sort()
		self.categories["Utility"].sort()
		self.categories["Other"].sort()

	def get_icon(self,icon_name, size = None):
		"""Get icon theme or file path or default icon"""
		if not size :
			size = self.icon_size
		try:
			icon = self.d_icon_theme.load_icon(icon_name,size,Gtk.IconLookupFlags.FORCE_SIZE)
		except:
			if os.path.exists(icon_name):
				icon =  GdkPixbuf.Pixbuf.new_from_file_at_size(icon_name,size,size)
			else:
				loader = GdkPixbuf.PixbufLoader()
				loader.set_size(size,size)
				loader.write(icon_text.encode())
				loader.close()
				icon = loader.get_pixbuf()
		return icon


	def set_categories(self,app,cteg):
		"""applications set categories"""
		if cteg == None:
			self.categories["Other"].append(app)
		else:
			ctegs = cteg.split(";")
			for c in ctegs:
				if c in self.categories.keys():
					self.categories[c].append(app)
				elif c == "AudioVideo" or c == "Audio" or c == "Video":
					if app not in self.categories["Multimedia"]:
						self.categories["Multimedia"].append(app)
		self.categories["All"].append(app)


	def change_search_entry(self,widget):
		search_text = widget.get_text().lower()
		if search_text != "":
			find_apps = []
			for app in self.categories["All"]:
				name = app[0]
				desc = app[1]
				if name == None:
					name = ""
				if desc == None:
					desc = ""
				name = name.lower()
				desc = desc.lower()
				if search_text in name or search_text in desc:
					find_apps.append(app)
			find_apps.sort()
			self.set_apps(find_apps)
		else:
			self.set_apps(self.categories["All"])

	def set_scroll_win(self,list_):
		"""Two scroll win maybe write a func"""
		scroll = Gtk.ScrolledWindow()
		scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
		scroll.add(list_)
		return scroll


	def set_categories_ui(self):
		"""categories list add to store"""
		for category in self.categories.keys():
			ctg = self.category_icons[category]
			
			if len(self.categories[category]) != 0:
				#print(ctg)
				icon =  self.get_icon(ctg)
				#icon = GdkPixbuf.Pixbuf.new_from_file(self.icon_dir+category+".svg")
				self.cteg_store.append([icon,translate(category)])
				#self.cteg_store.append([icon,category])
			elif category == "All":
				#icon = GdkPixbuf.Pixbuf.new_from_file(self.icon_dir+category+".svg")
				icon =  self.get_icon(ctg)
				self.cteg_store.append([icon,translate(category)])
				#self.cteg_store.append([icon,category])


	def activated_cteg_list(self,widget):
		selection = widget.get_selection()
		tree_model, tree_iter = selection.get_selected()
		category = tree_model[tree_iter][1]
		category = rtranslate(category)
		#print("c",category)
		self.set_apps(self.categories[category])


	def activated_apps_list(self,widget,path):
		"""Application start and close window"""
		model = widget.get_model()
		app = model[path][2]
		app.launch(None,None)
		if self.menu_close:
			self.destroy()

	def apps_list_click(self,widget,event):
		model = self.apps_list.get_model()
		path = self.apps_list.get_path_at_pos(event.x, event.y)
		if event.type == Gdk.EventType.BUTTON_PRESS:
			if path != None:
				if event.button == 1 and self.single_click:
					self.activated_apps_list(self.apps_list,path)
		elif event.type == Gdk.EventType._2BUTTON_PRESS and not self.single_click:
			if path != None:
				self.activated_apps_list(self.apps_list,path)


	def set_apps(self,apps):
		"""Store clear and add"""
		self.apps_store.clear()
		for app in apps:
			if app[2] == None:
				p_b = GdkPixbuf.Pixbuf.new_from_file_at_size(self.icon_dir+"System.svg",
															self.icon_size,
															self.icon_size)
			else:
				p_b = self.get_icon(app[2].to_string())
			name = app[0]
			if self.show_generic_name and app[-1] != None:
				name = app[-1]
			if self.show_description and app[1] != None:
				name += "\n"
				name += app[1]
			self.apps_store.append([name,p_b,app[3]])
		model = self.apps_list.get_model()
		if len(model) != 0:
			iter = model[0]
			self.apps_list.select_path(iter.path)






class Application(Gtk.Application):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, application_id="gitlab.com.milislinux.menu", flags=Gio.ApplicationFlags.HANDLES_COMMAND_LINE, **kwargs)
		GLib.set_application_name("menu")
		GLib.set_prgname('menu')
		self.settings = GLib.KeyFile()

		self.win = None
		self.add_main_option("new", ord("n"), GLib.OptionFlags.NONE, GLib.OptionArg.STRING, "NewWindow", None)

	def do_start_up(self):
		Gtk.Application.do_startup(self)

	def do_activate(self):
		if not self.win:
			self.win = MMenu(application=self)
			GtkLayerShell.init_for_window(self.win)
			screen = Gdk.Display.get_default()
			monitors = screen.get_n_monitors()
			active_monitor = screen.get_monitor(0)
			SIZE = active_monitor.get_geometry()
			if self.win.is_full_screen == 0:
				w_space_l = 10
				w_space_r = 10
				h_space_t = 10
				h_space_b = 10
				if self.win.menu_position == 0:
					w_space_l = (SIZE.width - self.win.menu_width) // 2
					w_space_r = (SIZE.width - self.win.menu_width) // 2
					h_space_t = (SIZE.height - self.win.menu_height) // 2
					h_space_b = (SIZE.height - self.win.menu_height) // 2
				# 1 sol alt köşe
				elif self.win.menu_position == 1:
					w_space_r = (SIZE.width - (self.win.menu_width+10))
					h_space_t = (SIZE.height - (self.win.menu_height+10))
				# 2 sol üst köşe
				elif self.win.menu_position == 2:
					w_space_r = (SIZE.width - (self.win.menu_width+10))
					h_space_b = (SIZE.height - (self.win.menu_height+10))
				# 3 sağ alt köşe
				elif self.win.menu_position == 3:
					w_space_l = (SIZE.width - (self.win.menu_width+10))
					h_space_t = (SIZE.height - (self.win.menu_height+10))
				# 4 sağ üst köşe
				elif self.win.menu_position == 4:
					w_space_l = (SIZE.width - (self.win.menu_width+10))
					h_space_b = (SIZE.height - (self.win.menu_height+10))

			else:
				w_space_l = 0
				w_space_r = 0
				h_space_b = 0
				h_space_t = 0

			GtkLayerShell.set_margin(self.win, GtkLayerShell.Edge.TOP, h_space_t)
			GtkLayerShell.set_margin(self.win, GtkLayerShell.Edge.BOTTOM, h_space_b)
			GtkLayerShell.set_margin(self.win, GtkLayerShell.Edge.LEFT, w_space_l)
			GtkLayerShell.set_margin(self.win, GtkLayerShell.Edge.RIGHT, w_space_r)
			GtkLayerShell.set_anchor(self.win, GtkLayerShell.Edge.TOP, 1)
			GtkLayerShell.set_anchor(self.win, GtkLayerShell.Edge.BOTTOM, 1)
			GtkLayerShell.set_anchor(self.win, GtkLayerShell.Edge.LEFT, 1)
			GtkLayerShell.set_anchor(self.win, GtkLayerShell.Edge.RIGHT, 1)
			GtkLayerShell.set_keyboard_mode(self.win, GtkLayerShell.KeyboardMode.EXCLUSIVE)

			
			#win.maximize()
			self.win.show_all()
			if not self.win.hide_categories:
				self.win.paned.set_position(150)
			self.win.connect("destroy", Gtk.main_quit)
		else:
			self.win.destroy()

	def do_command_line(self, command_line):
		options = command_line.get_options_dict()
		options = options.end().unpack()
		self.do_activate()

if __name__ == '__main__':
	app = Application()
	app.run(sys.argv)
