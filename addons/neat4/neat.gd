class_name Neat
extends RefCounted

static var MAX_NODES: int = (pow(2, 20))

var all_connections: Dictionary = {} # ConnectionGene, ConnectionGene
var all_nodes: RandomHashSet = RandomHashSet.new()

var clients: RandomHashSet = RandomHashSet.new()
var species: RandomHashSet = RandomHashSet.new()

var input_size = 0
var output_size = 0


@export var PROBABILITY_MUTATE_LINK: float  = 0.6
@export var PROBABILITY_MUTATE_NODE:float = 0.4
@export var PROBABILITY_MUTATE_WEIGHT_SHIFT:float = 0.4
@export var PROBABILITY_MUTATE_WEIGHT_RANDOM:float  = 0.4
@export var PROBABILITY_MUTATE_TOGGLE_LINK:float   = 0.2
@export var WEIGHT_SHIFT_STRENGTH: float = 0.3
@export var WEIGHT_RANDOM_STRENGTH: float = 1

var SURVIVORS = 0.8
	
var max_clients: int

var c1: float = 1
var c2: float = 1
var c3: float = 1
var cp:int = 4

func print_species():
	for s in self.species.data:
		print(s, " ", s.score, " ", s.size())

func _init(_inp: int, out: int, _clients: int):
	reset(_inp, out, _clients)
	
	
func reset(inp: int, o: int, c: int):
	self.input_size = inp
	self.output_size = o
	self.max_clients = c
	
	self.all_connections.clear()
	self.all_nodes.clear()
	self.clients.clear()
	
	for i in range(input_size):
		var n: NodeGene  = _get_node()
		n.x = 0.1
		n.y = (i+1)/ ((input_size + 1) as float)
		
	for i in range(output_size):
		var n: NodeGene  = _get_node()
		n.x = 0.9
		n.y = (i+1)/ ((input_size + 1) as float)
		
	for i in range(max_clients):
		var cc: Client = Client.new()
		cc.genome = empty_genome()
		cc.generate_calculator()
		
		clients.add(cc)
		
		
func evolve() -> void:
	
	gen_species()
	kill()
	remove_extinct_species()
	reproduce()
	mutate()
	
	for c in clients.data:
		c.generate_calculator()

func remove_extinct_species():
	for i in range(species.size()-1, -1, -1):
		if species.get_item(i).size() <= 1:
			species.get_item(i).go_extinct()
			
func reproduce():
	var selector: RandomSelector = RandomSelector.new()
	for s in species.data:
		selector.add(s, s.score)
	for c in clients.data:
		if c.species == null:
			var s: Species = selector.random()
			c.genome = s.breed()
			s.force_put(c)

func mutate():
	for c in clients.data:
		c.call_deferred("mutate")

func gen_species():
	for s in species.data:
		s.reset()
	for c in clients.data:
		if c.species != null: continue
		var found = false
		for s in species.data:
			if s.put(c):
				found = true
				break
				
		if !found:
			species.add(Species.new(c))
			
	for s in species.data:
		s.evaluate_score()
		
func kill():
	for s in species.data:
		s.kill(1-SURVIVORS)
	
func get_client_at(idx: int):
	return clients.get_item(idx)


	
	
func empty_genome() -> Genome:
	var _g: Genome = Genome.new(self)
	for i in range(input_size+output_size):
		_g.nodes.add(_get_node(i+1))
	return _g
		

# Instance method to create a connection gene given two node genes
# Static method to create a connection gene from an existing one
static func get_connection_from_existing(con: ConnectionGene) -> ConnectionGene:
	var c: ConnectionGene = ConnectionGene.new(con.from, con.to)
	c.innovation_number = con.innovation_number
	c.weight = con.weight
	c.enabled = con.enabled
	return c

# Instance method to create a connection gene given two node genes
func get_connection(node1: NodeGene, node2: NodeGene) -> ConnectionGene:
	var connection_gene: ConnectionGene = ConnectionGene.new(node1, node2)

	if all_connections.keys().has(connection_gene):
		connection_gene.innovation_number = all_connections.get(connection_gene).innovation_number
	else:
		connection_gene.innovation_number = all_connections.size() + 1
		all_connections[connection_gene] = connection_gene
		

	return connection_gene

func _get_node(id: int = -1) -> NodeGene:
	if id == -1:
		var n: NodeGene = NodeGene.new(all_nodes.size() + 1)
		all_nodes.add(n)
		return n
	else:
		if id <= all_nodes.size():
			return all_nodes.get_item(id - 1)
		return _get_node()

#func set_replace_index(node1: NodeGene, node2: NodeGene, index: int):
#	all_connections.get(ConnectionGene.new(node1, node2)).set_replace_index(index)
#	
#func get_replace_index(node1: NodeGene, node2: NodeGene):
#	var con: ConnectionGene = ConnectionGene.new(node1, node2)
#	var data: ConnectionGene = all_connections.get(con)
#	if data==null: return 0
#	return data.get_replace_index()

func get_probability_mutate_link() -> float:
	return PROBABILITY_MUTATE_LINK

# Getter method for PROBABILITY_MUTATE_NODE
func get_probability_mutate_node() -> float:
	return PROBABILITY_MUTATE_NODE

# Getter method for PROBABILITY_MUTATE_WEIGHT_SHIFT
func get_probability_mutate_weight_shift() -> float:
	return PROBABILITY_MUTATE_WEIGHT_SHIFT

# Getter method for PROBABILITY_MUTATE_WEIGHT_RANDOM
func get_probability_mutate_weight_random() -> float:
	return PROBABILITY_MUTATE_WEIGHT_RANDOM

# Getter method for PROBABILITY_MUTATE_TOGGLE_LINK
func get_probability_mutate_toggle_link() -> float:
	return PROBABILITY_MUTATE_TOGGLE_LINK

