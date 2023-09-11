class_name Client
extends RefCounted

var genome: Genome
var species: Species
var calculator: Calculator

var score: float

func generate_calculator():
	calculator = Calculator.new(genome)
	
func calculate(input: Array[float]):
	if (self.calculator == null): generate_calculator()
	return self.calculator.calculate(input)
	
func distance(other: Client):
	return genome.distance(other.genome)
	
func mutate():
	genome.mutate()


func set_genome(_genome) -> void:
	genome = _genome
	print("Setting genome to  {}", genome)
