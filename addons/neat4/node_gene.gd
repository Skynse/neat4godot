class_name NodeGene
extends Gene

var x: float
var y: float

var activation_func: Callable

func _equals(o: Object) -> bool:
	if !o.is_class("NodeGene"): return false
	return innovation_number == o.innovation_number

func hashcode() -> int:
	return innovation_number

func _init(_innovation_number: int, _activation_func: Callable = GNode.tanh_activation):
	activation_func = _activation_func
	super(_innovation_number)
