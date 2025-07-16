tool
extends EditorPlugin


const json_script = preload("res://addons/LastStateSaver/scripts/json.gd")
const array_list_scirpt = preload("res://addons/LastStateSaver/scripts/ArrayList.gd")
const session_scirpt = preload("res://addons/LastStateSaver/scripts/Session.gd")

var session: Session = session_scirpt.new("LastStateSaver")


var json_save: kzJsonLSS

var interface: EditorInterface
var file_system: FileSystemDock


var _main_screen_editor: String = ""
# change when you selecte a scene or script in a scene
func _on_main_screen_editor_btn_toggled(button_pressed: bool, btn_name: String):
	if not button_pressed: return 
	_main_screen_editor = btn_name
	if session.debug: session.out(["name: ", btn_name])
	

func get_main_screen_editor() -> String: 
	return _main_screen_editor


func _listen_to_main_screen_editor():
	
	var base = interface.get_base_control()

	var sub_base: VBoxContainer
	# get fist VBoxContainer
	for node in  base.get_children():
		if node is VBoxContainer:
			sub_base = node
			break;	

	var top_bar: HBoxContainer = sub_base.get_children()[0]

	var center_container: HBoxContainer = top_bar.get_children()[2]
	
	for b in center_container.get_children():
		
		var btn = b as ToolButton
		
		btn.connect(
			"toggled", self, "_on_main_screen_editor_btn_toggled", [btn.name]
		)


func _enter_tree():
	
	if session.debug: session.out(["_enter_tree:"])
	
	interface = get_editor_interface()
	
	_listen_to_main_screen_editor()

	file_system = interface.get_file_system_dock()
	
	json_save = json_script.new(session.json_path + "save.json")
	
	var obj = json_save.read()
	
	if obj == null: return
	if not session.not_openned_scenes_key in obj: 
		if session.debug: session.out(["invalid key 1"])
		return
	
	if not session.openned_scenes_key in obj: 
		if session.debug: session.out(["invalid key 2"])
		return
	
#	session.out([session.plugin_name, "obj", obj])
	var scenes_to_open: ArrayList = array_list_scirpt.new(
		obj[session.not_openned_scenes_key]
	)
	
	var openned_scenes: Array = obj[session.openned_scenes_key]
	
	if session.debug: session.out(["obj:", obj])
	
	# done loading
	if scenes_to_open.equals(openned_scenes):
		
		if session.debug: session.out(["before done"])
		
		# navigate to scene dir
		for scene_path in openned_scenes:
			file_system.navigate_to_path(scene_path)
		
		
		# in fileSystem, navigate to last openned scripts dir
		# i might remove this. cause it's too overpower
		if session.openned_scripts_key in obj: 
			var paths = obj[session.openned_scripts_key]
			for path in paths:
				file_system.navigate_to_path(path)

		
		# nav to last selected file path
		if session.last_selected_path_key in obj: 
			var path = obj[session.last_selected_path_key]
			if path != null:
				if session.debug: session.out(["path", path])
				file_system.navigate_to_path(path)
				

		# opne last scene (feels so use less)
		# this one blocks edit_script() from working
		if session.last_scene_key in obj:
			var last_scene = obj[session.last_scene_key]
			if last_scene != null:
				if session.debug: session.out(["open_scene_from_path"])
				interface.open_scene_from_path(last_scene)


		# edit last script
		if session.last_script_key in obj: 
			var script_path = obj[session.last_script_key]
			if script_path != null:
				if session.debug: session.out(["edit_script"])
				
				# "open_scene_from_path()" call's "edit_script()"
				# which affect my function. so i solved that with delay
				yield(
					get_tree().create_timer(session.refresh_rate/2), 
					"timeout"
				)
				
				interface.set_main_screen_editor("Script")
				interface.edit_script(load(script_path) as Script)
				
		
		# open last area "2D", "3D", "Script" or "AssetLib"
		if session.main_screen_editor_key in obj:
			var tab_name: String = obj[session.main_screen_editor_key]
			if not tab_name.empty():
				if session.debug: session.out(["tab_name"])
				interface.set_main_screen_editor(tab_name)

		
		obj[session.stop_key] = true
		json_save.write(obj)
		if session.debug: session.out(["after done \n"])
		return
		
	
	# open a not openned scenes
	for scene_path in scenes_to_open.to_array():
		
		if not scene_path in interface.get_open_scenes():
			# open scene
			interface.open_scene_from_path(scene_path)

	# update data
	obj[session.not_openned_scenes_key] = scenes_to_open.to_array()
	obj[session.openned_scenes_key] = interface.get_open_scenes()
	json_save.write(obj)
	


func reset_json_save_content():
	
	interface = get_editor_interface()
	
	var editor = interface.get_script_editor()

	var script = editor.get_current_script()
	
	var openned_scripts = []
	for s in editor.get_open_scripts():
		openned_scripts.append((s as Script).resource_path)
	
	json_save.write({ 
		session.not_openned_scenes_key: interface.get_open_scenes(),
		session.openned_scenes_key: [] ,
		session.last_selected_path_key: interface.get_selected_path(),
		session.last_script_key: script.resource_path if script != null else null,
		session.last_scene_key: interface.get_edited_scene_root().filename,
		session.main_screen_editor_key: get_main_screen_editor(),
		session.openned_scripts_key: openned_scripts
	})
	
	if session.debug:
		session.out(["reset_json_save_content:", json_save.read()])


func _exit_tree():
	
	if session.debug: session.out(["_exit_tree:"])
	
	json_save = json_script.new(session.json_path + "save.json")

	var obj = json_save.read()

	if obj == null: 
		reset_json_save_content()
		return
