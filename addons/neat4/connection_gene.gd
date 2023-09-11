class_name ConnectionGene #LinkGene
extends Gene

var from: NodeGene
var to: NodeGene

var weight: float
var enabled: bool = true

func equals(o: Object):
	if !o.is_class("ConnectionGene"): 
		return false
	var c: ConnectionGene = o as ConnectionGene
	return from.equals(c.from) && to.equals(c.to)

func _init(_from: NodeGene, _to: NodeGene):
	self.from = _from
	self.to = _to

func hashcode() -> int:
	return from.innovation_number  * Neat.MAX_NODES * to.innovation_number
