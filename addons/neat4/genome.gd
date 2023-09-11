class_name Genome
extends Resource 

var connections: RandomHashSet = RandomHashSet.new() # ConnectionGene
var nodes: RandomHashSet = RandomHashSet.new() #NodeGene
var calculator: Calculator

var neat: Neat

func _init(n: Neat):
	neat = n

func get_connections() -> RandomHashSet:
	return connections
	
func getNeat() -> Neat:
	return neat
	
func getNodes() -> RandomHashSet:
	return nodes

static func cross_over(g1: Genome, g2: Genome) -> Genome:
	
	var neat: Neat = g1.neat
	var genome: Genome = neat.empty_genome()
	var index1 = 0
	var index2 = 0
	
	while (index1 < g1.connections.size() && index2 < g2.connections.size()):
		var gene1: ConnectionGene = g1.connections.get_item(index1)
		var gene2: ConnectionGene = g2.connections.get_item(index2)
		
		var int1: int = gene1.innovation_number
		var int2: int = gene2.innovation_number
		
		if (int1 == int2):
			
			if randf() > 0.5:
				genome.connections.add(neat.get_connection_from_existing(gene1))
			else:
				genome.connections.add(neat.get_connection_from_existing(gene2))
			index1+=1
			index2+=1
		elif (int1 > int2):
			index2+=1

		else:
			genome.connections.add(neat.get_connection_from_existing(gene1))
			index1+=1
	while (index1 < g1.connections.size()) :
		var gene1: ConnectionGene = g1.connections.get_item(index1)
		genome.connections.add(neat.get_connection_from_existing(gene1))
		index1 += 1

	for c in genome.connections.data:
		genome.nodes.add(c.from)
		genome.nodes.add(c.to)

	return genome
	
func distance(g2: Genome) -> float:
	var g1: Genome = self
	var highest_innovation_gene: int  = 0
	if (g1.connections.size() != 0):
		highest_innovation_gene = g1.connections.get_item(g1.connections.size()-1).innovation_number
	var highest_innovation_gene2: int  = 0
	if (g2.connections.size() != 0):
		highest_innovation_gene2 = g2.connections.get_item(g2.connections.size()-1).innovation_number
	
	if (highest_innovation_gene < highest_innovation_gene2):
		var g: Genome = g1
		g1 = g2
		g2 = g
		
	
	var index1 = 0
	var index2 = 0
	
	var disjoint: int = 0
	var excess: int = 0
	var weight_diff: float = 0.0
	var similar: int = 0
	
	while (index1 < g1.connections.size() && index2 < g2.connections.size()):
		var gene1: ConnectionGene = g1.connections.get_item(index1)
		var gene2: ConnectionGene = g2.connections.get_item(index2)
		
		var int1: int = gene1.innovation_number
		var int2: int = gene2.innovation_number
		
		if (int1 == int2):
			similar+=1
			weight_diff += abs(gene1.weight - gene2.weight)
			index1+=1
			index2+=1
		if (int1 > int2):
			index2+=1
			disjoint+=1
		else:
			index1+=1
			disjoint += 1
			
	weight_diff /= max(1,similar)
	excess = g1.connections.size() - index1
		
	var N: float = max(g1.connections.size(), g2.connections.size())
	if N < 20:
		N= 1
		
	return ((neat.c1 * disjoint) / N) + ((neat.c2 * excess) / N) + (neat.c3 * weight_diff)
	
	
func mutate() -> void:
	if self.neat.get_probability_mutate_link() < randf():
		mutate_link()
	if self.neat.get_probability_mutate_node()  < randf():
		mutate_node()
	if self.neat.get_probability_mutate_weight_shift() < randf():
		mutate_weight_shift()
	if self.neat.get_probability_mutate_weight_random() < randf():
		mutate_weight_random()
	if self.neat.get_probability_mutate_toggle_link() < randf():
		mutate_link_toggle()

func add_custom_connection(from_index: int, to_index: int, weight: float = 1.0):
	var genome = self

	# Create nodes with custom indices
	var from_node = NodeGene.new(from_index)
	var to_node = NodeGene.new(to_index)

	# Calculate the x-coordinates based on your criteria
	from_node.x = 0.1
	to_node.x = 0.9

	# Calculate the y-coordinates based on the total number of nodes
	var total_nodes = genome.neat.input_size + genome.neat.output_size
	from_node.y = (from_index + 1) / (total_nodes + 1)
	to_node.y = (to_index + 1) / (total_nodes + 1)

	# Create a connection between the custom nodes and set its weight
	var connection: ConnectionGene = ConnectionGene.new(from_node, to_node)
	connection.weight = weight

	# Add the custom connection to the genome
	genome.connections.add(connection)

		
func mutate_node():
	var con: ConnectionGene = connections.random_element()
	if (con == null): return
	
	var from: NodeGene = con.from
	var to: NodeGene = con.to
	
	var middle: NodeGene
	#var replace_index: int = neat.get_replace_index(from, to)
	#
	#if replace_index == 0:
	#	middle = neat._get_node()
	#	middle.x =  (from.x  + to.x )/ 2
	#	middle.y =  (from.y  + to.y )/ 2 + randf() * 0.1 - 0.05
	#	neat.set_replace_index(from, to, middle.innovation_number)
	#else:
	#	middle = neat._get_node(replace_index)
	#neat.set_replace_index(from, to, middle.innovation_number)
	#middle = neat._get_node() # Might give own function in the case of getting best agent type games/sims
	middle = NodeGene.new(nodes.size() + 1)
	middle.x =  (from.x  + to.x )/ 2
	middle.y =  (from.y  + to.y )/ 2 + randf() * 0.1 - 0.05
	
	
		
	var con1: ConnectionGene = neat.get_connection(from, middle)
	var con2: ConnectionGene = neat.get_connection(middle, to)
	
	con1.weight = 1
	con2.weight = con.weight
	con2.enabled = con.enabled
	
	connections.remove(con)
	connections.add(con1)
	connections.add(con2)
	
	nodes.add(middle)
	
	pass

	
func mutate_link() -> void:
	for i in range(100):
		var a: NodeGene = nodes.random_element()
		var b: NodeGene = nodes.random_element()
		
		
		if a== null or b == null: continue
		if a.x == b.x: # same node 
			continue
		var con: ConnectionGene
		if a.x < b.x: 
			con = ConnectionGene.new(a, b)

		else:
			con = ConnectionGene.new(b,a )

		if connections.contains(con):
			continue
			
		#con = neat.get_connection(con.from, con.to)
		con = get_connection(con.from, con.to)
		con.weight = (randf() *2 -1) *  neat.WEIGHT_RANDOM_STRENGTH
		connections.add_sorted(con)
		return

func get_connection(node1: NodeGene, node2: NodeGene) -> ConnectionGene:
	var connection_gene: ConnectionGene = ConnectionGene.new(node1, node2)

	if connections.set.keys().has(connection_gene):
		connection_gene.innovation_number = connections.set[connection_gene].innovation_number
	else:
		connection_gene.innovation_number = connections.size() + 1
		connections.set[connection_gene] = connection_gene
		

	return connection_gene


func mutate_weight_shift() -> void:
	var con: ConnectionGene = connections.random_element()
	if (con != null):
		con.weight = con.weight + (randf() *2 -1) *  neat.WEIGHT_SHIFT_STRENGTH
	
func mutate_weight_random() -> void:
	var con: ConnectionGene = connections.random_element()
	if (con != null):
		con.weight = (randf() *2 -1) *  neat.WEIGHT_RANDOM_STRENGTH
	
func mutate_link_toggle() -> void:
	var con: ConnectionGene = connections.random_element()
	if (con != null):
		con.enabled = !con.enabled
	
func clone() -> Genome:
	var c_connections = self.connections.data.duplicate()
	var c_connections_set = self.connections.set.duplicate()
	
	var n_nodes = self.nodes.data.duplicate()
	var n_nodes_set = self.nodes.set.duplicate()
	
	var _g: Genome = Genome.new(self.neat)
	_g.connections.data = c_connections
	_g.connections.set = c_connections_set
	_g.nodes.data = n_nodes
	_g.nodes.set = n_nodes_set
	
	return _g
