class_name Species
extends RefCounted

var clients: RandomHashSet = RandomHashSet.new()

var representative: Client
var score: float

func _init(_representative: Client):
	representative = _representative
	representative.species = self
	
	clients.add(representative)
	
func size():
	return clients.size()

func put(_client: Client) -> bool:
	if(_client.distance(representative) < representative.genome.neat.cp):
		_client.species = self
		clients.add(_client)
		return true
	else:
		return false

func force_put(_client: Client):
	_client.species = self
	clients.add(_client)

func go_extinct():
	for c in clients.data:
		c.species = null
		
func evaluate_score():
	var v: float = 0
	for c in clients.data:
		v += c.score
	score += v/ clients.size()
	
func reset():
	representative = clients.random_element()
	for c in clients.data:
		c.species = null
	clients.clear()
	clients.add(representative)
	representative.species = self
	
	score = 0
	
func kill(percentage: float):
	clients.data.sort_custom(
		func compareTo(o1: Client, o2: Client):
			return -1 if o1.score > o2.score else 1 if o1.score < o2.score else 0
	)
	
	var amount: float = percentage * self.clients.size()
	for i in range(amount):
		self.clients.get_item(0).species = null
		self.clients.remove_at(0)

func breed() -> Genome:
	var c1: Client = clients.random_element()
	var c2: Client = clients.random_element()
	
	if (c1.score > c2.score ): return Genome.cross_over(c1.genome, c2.genome)
	return Genome.cross_over(c2.genome, c1.genome)
