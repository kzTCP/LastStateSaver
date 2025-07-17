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


func is_older_than_week(date_str: String) -> bool:
	
	# Step 1: Parse the string into a DateTime dictionary
	var date_parts = date_str.split(" ")
	var date = date_parts[0].split("-")
	var time = date_parts[1].split(":")
	
	var target_time = {
		"year": int(date[0]),
		"month": int(date[1]),
		"day": int(date[2]),
		"hour": int(time[0]),
		"minute": int(time[1]),
		"second": int(time[2])
	}

	# Step 2: Convert both to UNIX timestamps
	var target_timestamp = OS.get_unix_time_from_datetime(target_time)
	var now = OS.get_unix_time()
	
	# Step 3: Check if more than 7 days (in seconds) have passed
	var seconds_in_week = 7 * 24 * 60 * 60
	return now - target_timestamp > seconds_in_week


func _enter_tree():

	
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = session.refresh_rate
	timer.connect("timeout", self, "_signal_refrech_time_out")
	add_child(timer)


func finalize(obj):
	
	if session.debug: session.out(["done"])
	
	timer.queue_free() 
	
	# remove log file after a week
	var data = json_log.read()
	if data:
		var creation_date = data.keys()[0]
		if is_older_than_week(creation_date):
			json_log.remove()
	
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
	
