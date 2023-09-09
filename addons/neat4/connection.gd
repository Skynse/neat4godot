class_name Connection
extends Resource

var from: GNode
var to: GNode

var weight: float
var enabled: bool = true

func _init(_from: GNode, _to: GNode):
	from = _from
	to = _to
