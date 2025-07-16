class_name ArrayList extends Object


var _list: Array


func _init(list: Array):
	_list = list
	
	
func equals(list: Array) -> bool:

	if _list.empty() and list.empty(): return true
		
	for i in _list:
		var exist = false
		for j in list:
			if i == j: 
				exist = true
				break
		if not exist: return false;
		
	return true

	
func _to_string() -> String: return str(_list)


func to_array() -> Array: return _list





