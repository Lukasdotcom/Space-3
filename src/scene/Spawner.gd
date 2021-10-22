extends Node2D
export var maxX = 1920
export var maxY = 1080
var _rng = RandomNumberGenerator.new()

func _ready():
	Events.start_event("global", "gameStart")
	_rng.randomize()
	var player = load("res://src/fighters/Player.tscn") # Spawns player
	player = player.instance()
	player.position = Vector2(840, 580)
	player.rotation = 3.1415/2
	get_node("/root/Arena/").call_deferred("add_child", player)
	spawn(1) # Spawns 1 enemy
	
	
func spawn(number: int) -> void:
	Events.start_event("global", "newRound")
	for _x in range(number):
		var fighter = load("res://src/fighters/Enemy.tscn")
		fighter = fighter.instance()
		while true:
			fighter.position.x = _rng.randf() * maxX
			fighter.position.y = _rng.randf() * maxY
			var _exit = true
			for _range_values in Preferences.preferences["enemy"]["bannedSpawn"]:
				if (fighter.position.x >= _range_values[0] and fighter.position.x <= _range_values[1]) or (fighter.position.y >= _range_values[2] and fighter.position.y <= _range_values[3]):
					_exit = false
			if _exit:
				break
		var _angle = (Vector2(maxX/2, maxY/2) - fighter.position).angle()
		fighter.set_rotation(_angle + 3.141592/2)
		get_node("/root/Arena/").call_deferred("add_child", fighter)

