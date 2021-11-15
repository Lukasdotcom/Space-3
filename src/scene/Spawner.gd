extends Node2D
export var maxX = 1920
export var maxY = 1080
var _rng = RandomNumberGenerator.new()
var enemy_id = 0 # Used to store the highest used id

func _ready(): # Will get the game ready
	Events.start_event("global", "gameStart")
	_rng.randomize()
	for playerid in data.preferences["player"].keys(): # Spawns every player
		data.preferences["player"][playerid]["alive"] = true
		spawn_player(playerid)
	spawn(data.preferences["global"]["rounds"]["startEnemy"]) # Spawns starting amount of enemys
	settings_reloaded()
	Events.connect("changeValues",self,"settings_reloaded")
	
func settings_reloaded(): # Will make sure the settings are right.
	var _color = data.preferences["global"]["backgroundColor"]
	VisualServer.set_default_clear_color(Color(_color["red"], _color["green"], _color["blue"]))
	for playerid in data.preferences["player"].keys(): # Will go through each player to edit the controls for them
		var _controls = data.preferences["player"][playerid]["controls"]
		for change in _controls: # Will change each control for that player
			var change2 = change + playerid
			InputMap.erase_action(change2)
			InputMap.add_action(change2)
			var _event_press = InputEventKey.new()
			_event_press.set_scancode(_controls[change])
			InputMap.action_add_event(change2, _event_press)

func spawn_player(id: String) -> void: # Used to spawn a player
	var player = load("res://src/fighters/Player.tscn") # Spawns player
	player = player.instance()
	player.position = Vector2(_rng.randf() * maxX, _rng.randf() * maxY)
	player.rotation = 3.1415/2
	player.id = id
	get_node("/root/Arena/").call_deferred("add_child", player)

func spawn(number: int) -> void: # Used to spawn an emeny
	Events.start_event("global", "newRound")
	for _x in range(number):
		enemy_id += 1 # Increases the id
		var fighter = load("res://src/fighters/Enemy.tscn")
		fighter = fighter.instance()
		fighter.id = str(enemy_id) # Gives this enemy its id
		data.preferences["enemy"][str(enemy_id)] = data.preferences["enemy"]["original"].duplicate(true)
		while true: # Generates locations until a valid location is found for the fighter.
			fighter.position.x = _rng.randf() * maxX
			fighter.position.y = _rng.randf() * maxY
			var _exit = true
			for _range_values in data.preferences["global"]["bannedSpawn"]:
				if (fighter.position.x >= _range_values[0] and fighter.position.x <= _range_values[1]) or (fighter.position.y >= _range_values[2] and fighter.position.y <= _range_values[3]):
					_exit = false
					break
			if _exit: # This will check that the enemy is not to close to the player
				for _player in data.preferences["player"]:
					if get_node("/root/Arena/"+_player):
						if data.preferences["player"][_player]["noEnemySpawnRadius"] > get_node("/root/Arena/"+_player).position.distance_to(fighter.position):
							_exit = false
							break
			if _exit:
				break
		var _angle = (Vector2(maxX/2, maxY/2) - fighter.position).angle()
		fighter.set_rotation(_angle + 3.141592/2)
		get_node("/root/Arena/").call_deferred("add_child", fighter)

