extends Node

static func compact(array: Array, predicate: Callable) -> void:
	var write_index := 0
	
	for i in array.size():
		var item = array[i]
		
		if not predicate.call(item):
			if write_index != i: array[write_index] = item
			write_index += 1
	
	array.resize(write_index)
