class_name kzJsonLSS extends Object


var _path: String

var _dir = Directory.new()

var debug: bool = false



func _init(path: String):
	_path = path


func write(data) -> void:
	
	if debug:  print("write", _path)
	
	# create file if not exists
	if not _dir.file_exists(_path): _create_file()
	
	var file = File.new()
	file.open(_path, File.WRITE)
	file.store_string(
		JSON.print(data)
	)
	file.close()
	
		

func read() -> Dictionary:
	
	if debug: print("read", _path)
		
	var data = null
	
	var file = File.new()

	if file.file_exists(_path):
		file.open(_path, File.READ)
		data = file.get_as_text()
		file.close()
	
	return  JSON.parse(data).result if data else null
	

func obj_append (dic: Dictionary) -> void:
	
	if debug: pass
	
	print("obj_append: ", dic)
		
	var saved_obj = read()
	if not saved_obj: 
		saved_obj = {}
	
	saved_obj[
		Time.get_datetime_string_from_system(true, true)
	] = dic

	write(saved_obj)
	



func _obj_compaire(obj1: Dictionary, obj2: Dictionary) -> bool:
	return str(obj1) == str(obj2)
	

func clear() -> void:

	if debug: print(_path, "clear")	
	write({})


func _create_file():


	# Extract directory and file
	var directory_path = _path.get_base_dir()

	# Create the directory if it doesn't exist
	if not _dir.dir_exists(directory_path):
		var err = _dir.make_dir_recursive(directory_path)
		if err != OK:
			push_error("❌Failed to create directory: " + directory_path)
			return


	# Create the file if it doesn't exist
	if not _dir.file_exists(_path):
		var file = File.new()
		var err = file.open(_path, File.WRITE)
		if err != OK:
			push_error("❌Failed to create file: " + _path)
			return
		file.store_string("{}")
		file.close()
	else:
		print("⚠️File already exists:", _path)
		

func remove():
	
	if _dir.file_exists(_path):
		_dir.remove(_path)
	
