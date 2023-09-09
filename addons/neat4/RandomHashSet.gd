class_name RandomHashSet
extends RefCounted

var start = 0
var current = 0
var end = 0
var increment = 1

var data: Array = []
var set: Dictionary = {}

func _init():
	data = []
	set = {}
	
func contains(t: Object) -> bool:
	return set.has(t)

func add(t: Object) -> void:
	if !(set.has(t)):
		set[t] = t
		data.append(t)
		end += 1
		
func clear():
	set.clear()
	data.clear()
	
func size() -> int:
	return data.size()

func get_item(index: int) -> Object:
	if (index < 0 || index >= size()): return null
	return data[index]
	
func add_sorted(object: Object):
	for i in range(size()):
		var innovation = data[i].innovation_number
		if object.innovation_number < innovation:
			data.insert(i, object)
			set[object] = object
			return
	data.append(object)
	set[object] = object
			
func remove(object: Object):
	set.erase(object)
	data.erase(object)
			
func remove_at(idx: int):
	if (idx < 0 || idx >= size()): return
	set.erase(data[idx])
	data.remove_at(idx)
		
func random_element():
	if(set.size() > 0):
		return data[randi() % size()]
	return null
		
func _iter_init(arg):
	current = start
	end = size()
	return should_continue()

func _iter_next(arg):
	current += increment
	return should_continue()


func should_continue():
	return (current < end)
func _iter_get(arg):
	return current
