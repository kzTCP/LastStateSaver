tool
extends EditorPlugin



const jsno_script = preload("res://addons/LastStateSaver/scripts/json.gd")
const array_list_scirpt = preload("res://addons/LastStateSaver/scripts/ArrayList.gd")
const session_scirpt = preload("res://addons/LastStateSaver/scripts/Session.gd")


const plugin_name: String = "LastStateSaver"
var session: Session = session_scirpt.new(plugin_name + "Refresher")

var json_save: kzJsonLSS = jsno_script.new(session.json_path + "save.json")
var json_log: kzJsonLSS = jsno_script.new(session.json_path + "log.json")

var timer: Timer


func _enter_tree():
	
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = session.refresh_rate
	timer.connect("timeout", self, "_signal_refrech_time_out")
	add_child(timer)


func finalize(obj):
	
	if session.debug: session.out(["done"])
	
	timer.queue_free() 
	
	json_log.obj_append(obj)
	
	json_save.remove()



func _refrech_plugin():

	var obj = json_save.read()
	
	if obj == null: return
	
	if not session.not_openned_scenes_key in obj: 
#		session.out([label, "invalid key 1"])
		return
		
	if not session.openned_scenes_key in obj:
#		session.out([label, "invalid key 2"])
		return
	
	if session.debug: session.out(["_refrech_plugin"])
	
	var scenes_to_open = array_list_scirpt.new(
		obj[session.not_openned_scenes_key]
	)
	
	var openned_scenes = obj[session.openned_scenes_key]
	
	
#	if scenes_to_open.equals(openned_scenes):
	if session.stop_key in obj:
		finalize(obj)
		return

	var enabled = get_editor_interface().is_plugin_enabled(plugin_name)
	if enabled: # can only disable an active plugin
		get_editor_interface().set_plugin_enabled(plugin_name, false)
		
	get_editor_interface().set_plugin_enabled(plugin_name, true)
	


func _signal_refrech_time_out():
	
	timer.stop()

	_refrech_plugin()
	
	timer.start()
	
