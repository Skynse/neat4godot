class_name Calculator
extends Resource

var input_nodes: Array[GNode] = []
var hidden_nodes: Array[GNode] = []
var output_nodes: Array[GNode] = []

func _init(g: Genome):
	var nodes: RandomHashSet = g.nodes #NodeGene
	var cons: RandomHashSet = g.connections #ConnectionGene
	
	
	var nodeHashMap: Dictionary = {} #int, Node
	
	for n in nodes.data:
		#assert(n.is_class("NodeGene"))
		var node: GNode = GNode.new(n.x)
		nodeHashMap[n.innovation_number] = node
		
		if (n.x <= 0.1):
			input_nodes.push_back(node)
		elif n.x >= 0.9:
			output_nodes.push_back(node)
		else:
			hidden_nodes.push_back(node)
			
	hidden_nodes.sort_custom(
		func compareTo(o1: GNode, o2: GNode):
			return o1.compareTo(o2)
	)
	for c in cons.data:
		var from: NodeGene = c.from
		var to: NodeGene = c.to
		
		var node_from: GNode = nodeHashMap.get(from.innovation_number)
		var node_to: GNode = nodeHashMap.get(to.innovation_number)
		
		var con: Connection = Connection.new(node_from, node_to)
		con.weight = c.weight
		con.enabled = c.enabled
		
		node_to.connections.push_back(con)
		

func calculate(input: Array[float]) :
	assert(input.size() == input_nodes.size())
	for i in range(input_nodes.size()):
		input_nodes[i].setOutput(input[i])
	for n in hidden_nodes:
		n.calculate()
		
	var output: Array[float] = []
	output.resize(output_nodes.size())
	
	for i in range(output_nodes.size()):
		output_nodes[i].calculate()
		output[i] = output_nodes[i].output
		
	return output
