class_name NodeGene
extends Gene

var x: float
var y: float

func _equals(o: Object) -> bool:
	if !o.is_class("NodeGene"): return false
	return innovation_number == o.innovation_number

func hashcode() -> int:
	return innovation_number

func _init(_innovation_number: int):
	super(_innovation_number)
