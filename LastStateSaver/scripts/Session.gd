class_name Session extends Object



const json_path = "res://addons/LastStateSaver/json/"



const not_openned_scenes_key = 'scenes_to_open'
const openned_scenes_key = 'openned_scenes'
const last_selected_path_key = "last_dir"
const last_script_key = 'last_script'
const last_scene_key = "last_scene"
const main_screen_editor_key = "main_screen_editor"
const openned_scripts_key = "openned_scripts"
const stop_key = "stop"


const debug: bool = false
const refresh_rate: float = 0.25



var _plugin_name: String

func _init(plugin_name: String):
	
	_plugin_name = plugin_name


func out(args: Array):
	
	var size = args.size()
	var data = _plugin_name + " " if size > 0 else ""
	for i in size:
		var arg = args[i]
		data += str(arg) + (" " if i != size-1 else "")
	print(data)


