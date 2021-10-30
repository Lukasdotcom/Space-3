extends Node2D
export var maxX = 1920
export var maxY = 1080
var _rng = RandomNumberGenerator.new()

func _ready(): # Will get the game ready
	Events.start_event("global", "gameStart")
	_rng.randomize()
	var player = load("res://src/fighters/Player.tscn") # Spawns player
	player = player.instance()
	player.position = Vector2(840, 580)
	player.rotation = 3.1415/2
	get_node("/root/Arena/").call_deferred("add_child", player)
	spawn(1) # Spawns 1 enemy
	settings_reloaded()
	Events.connect("changeValues",self,"settings_reloaded")
	
func settings_reloaded(): # Will make sure the settings are right.
	var _color = data.preferences["global"]["backgroundColor"]
	VisualServer.set_default_clear_color(Color(_color["red"], _color["green"], _color["blue"]))
	var _controls = data.preferences["player"]["controls"] # Will get all the controls for the player
	for change in _controls: # Will change each control.
		InputMap.action_erase_events(change)
		var _event_press = InputEventKey.new()
		_event_press.set_scancode(_controls[change])
		InputMap.action_add_event(change, _event_press)

func spawn(number: int) -> void: # Used to spawn an emeny
	Events.start_event("global", "newRound")
	for _x in range(number):
		var fighter = load("res://src/fighters/Enemy.tscn")
		fighter = fighter.instance()
		while true: # Generates locations until a valid location is found for the fighter.
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

