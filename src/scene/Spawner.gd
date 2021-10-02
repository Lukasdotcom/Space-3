extends Node2D
export var maxX = 1920
export var maxY = 1080
var _rng = RandomNumberGenerator.new()
func _ready():
	_rng.randomize()
func spawn(number: int) -> void:
	for _x in range(number):
		var fighter = load("res://src/fighters/Enemy.tscn")
		fighter = fighter.instance()
		fighter.position = Vector2(_rng.randf() * maxX, _rng.randf() * maxY)
		get_node("/root/Arena/").add_child_below_node(get_node("/root/Arena/"),fighter)

