#!/usr/bin/python3
import gi, subprocess, os
gi.require_version('Gtk', '3.0')
gi.require_version("GtkLayerShell","0.1")
from gi.repository import Gio, Gtk, Gdk, GdkPixbuf, GtkLayerShell
import configparser

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

class MMenu(Gtk.Window):
	def __init__(self):
		Gtk.Window.__init__(self)
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
		self.d_icon_theme = Gtk.IconTheme.get_default()

		self.config_file = os.path.expanduser("~/.config/menu.ini")
		if not os.path.exists(self.config_file):
			f = open(self.config_file, "w")
			f.write("""
[settings]
width = 640
height = 400
fullscreen = 0
menu_close = 1
icon_size = 32
single_click = 0
show_description = 0
show_generic_name = 0
horizontal = 0
hide_categories = 0
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
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("off-outline",16))
		self.logout_button.set_image(image)
		s_box.pack_start(self.logout_button,False,False,2)

		self.restart_button = Gtk.Button()
		self.restart_button.connect("clicked",self.click_restart_button)
		#image = self.get_pixbuf_to_image("Reboot.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("system-reboot-symbolic",16))

		self.restart_button.set_image(image)
		s_box.pack_start(self.restart_button,False,False,2)

		self.shutdown_button = Gtk.Button()
		self.shutdown_button.connect("clicked",self.click_shutdown_button)
		#image = self.get_pixbuf_to_image("Shutdown.svg")
		image =  Gtk.Image.new_from_pixbuf(self.get_icon("system-shutdown-symbolic",16))

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
		except Exception as e:
			print("Not read config file:", e)

	def click_settings_button(self,widget):
		subprocess.Popen(["xdg-open",self.config_file])


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
			icon = self.d_icon_theme.load_icon(icon_name,size,Gtk.IconLookupFlags.FORCE_REGULAR)
		except:
			if os.path.exists(icon_name):
				icon =  GdkPixbuf.Pixbuf.new_from_file_at_size(icon_name,self.icon_size,size)
			else:
				icon = self.d_icon_theme.load_icon("system",size,Gtk.IconLookupFlags.FORCE_REGULAR)
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
		iter = model[0]
		self.apps_list.select_path(iter.path)




if __name__ == '__main__':
	win = MMenu()
	GtkLayerShell.init_for_window(win)
	#GtkLayerShell.auto_exclusive_zone_enable(win)
	#GtkLayerShell.set_keyboard_mode(pen,GtkLayerShell.KeyboardMode.EXCLUSIVE )

	screen = Gdk.Display.get_default()
	monitors = screen.get_n_monitors()
	active_monitor = screen.get_monitor(0)
	SIZE = active_monitor.get_geometry()
	print(SIZE.width,SIZE.height)
	
	if win.is_full_screen == 0:
		w_space = (SIZE.width - win.menu_width) // 2
		h_space = (SIZE.height - win.menu_height) // 2
	else:
		w_space = 0
		h_space = 0

	GtkLayerShell.set_margin(win, GtkLayerShell.Edge.TOP, h_space)
	GtkLayerShell.set_margin(win, GtkLayerShell.Edge.BOTTOM, h_space)
	GtkLayerShell.set_margin(win, GtkLayerShell.Edge.LEFT, w_space)
	GtkLayerShell.set_margin(win, GtkLayerShell.Edge.RIGHT, w_space)
	GtkLayerShell.set_anchor(win, GtkLayerShell.Edge.TOP, 1)
	GtkLayerShell.set_anchor(win, GtkLayerShell.Edge.BOTTOM, 1)
	GtkLayerShell.set_anchor(win, GtkLayerShell.Edge.LEFT, 1)
	GtkLayerShell.set_anchor(win, GtkLayerShell.Edge.RIGHT, 1)
	GtkLayerShell.set_keyboard_mode(win, GtkLayerShell.KeyboardMode.EXCLUSIVE)

	
	#win.maximize()
	win.show_all()
	if not win.hide_categories:
		win.paned.set_position(150)
	win.connect("destroy", Gtk.main_quit)

	Gtk.main()
