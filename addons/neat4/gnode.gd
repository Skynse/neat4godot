class_name GNode
extends Resource

var x: float
var output: float
var connections: Array[Connection] = [] #Connection
var activation_func: Callable

func _init(_x: float, _act: Callable = tanh_activation):
	x = _x
	activation_func = _act
	
func setOutput(_output: float):
	output = _output
	
func set_connections(_connections: Array):
	connections = _connections
	
func get_connections() -> Array:
	return connections

func calculate() -> void:
	var s: float = 0
	for c in self.connections:
		
		if c.enabled:
			
			s += c.weight * c.from.output
	output = activation_func.call(s)

func activation_function(_x: float):
	return tanh_activation(_x)
	
static func sigmoid(_x):
	return 1 / (1 + exp(_x))
	
static func tanh_activation(_x):
	return tanh(_x)
	
static func relu(_x):
	return max(0, _x)

func compareTo(o: GNode) -> int:
	return -1 if x > o.x else 1 if x < o.x else 0
