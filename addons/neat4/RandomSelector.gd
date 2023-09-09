class_name RandomSelector
extends RefCounted

var objects: Array[Object]
var scores: Array[float]

var total_score: float = 0

func add(element: Object, score: float):
	objects.append(element)
	scores.append(score)
	total_score += score
	
func random() -> Object:
	var v: float = randf() *total_score
	var c: float = 0
	for i in range(objects.size()):
		c+= scores[i]
		if (c >= v):
			return objects[i]
			
	return null
	
func reset():
	objects.clear()
	scores.clear()
	total_score = 0
