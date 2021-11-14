extends Physics
onready var _sprite: Sprite = $fighter # Gets the sprite for the player
var id = "original"
var _color = preferences["enemy"][id]["color"]
var _brake = preferences["enemy"][id]["brake"]
var _accelerate = preferences["enemy"][id]["accelerate"]
var _rotation = preferences["enemy"][id]["rotation"]
var _reload = preferences["enemy"][id]["reload"]
var _reload_random = -1 * preferences["enemy"][id]["reloadConsistency"]
var _AI = preferences["enemy"][id]["AI"]
var _action = {"number":0, "timeEnd":-0.1}
var _speed = 0.1
var _last_shot = 0
var _rng = RandomNumberGenerator.new()
onready var _opponent_node = "/root/Arena/Player"

func _ready():
	Events.start_event("enemy", "spawn", id)
	_rng.randomize()
	_last_shot = OS.get_ticks_msec() + _reload * _rng.randf()
	Events.connect("changeValues",self,"settings_reloaded")
	_sprite.set_self_modulate(Color(_color["red"], _color["green"], _color["blue"], _color["alpha"]))

func settings_reloaded():
	if preferences["enemy"].has(id): # Makes sure to not crash the program if the id is missing
		_brake =  preferences["enemy"][id]["brake"]
		_accelerate = preferences["enemy"][id]["accelerate"]
		_rotation = preferences["enemy"][id]["rotation"]
		_reload = preferences["enemy"][id]["reload"]
		_reload_random = -1 * preferences["enemy"][id]["reloadConsistency"]
		_sprite.set_self_modulate(Color(_color["red"], _color["green"], _color["blue"], _color["alpha"]))

func _physics_process(delta: float) -> void:
	_shoot()
	_speed *= pow(_friction, delta)
	_speed = _enemy_action(_speed, delta)
	var _opponent_pos = Vector2(0, 0)
	if get_node(_opponent_node): # Will check if the oponnent is still alive
		_opponent_pos = get_node(_opponent_node).position
	else: # If the opponent is dead it will pick a random player to target
		var _player = data.preferences["player"].keys()[_rng.randi() % data.preferences["player"].size()]
		if data.preferences["player"][_player]["alive"]:
			_opponent_node = "/root/Arena/" + _player
	var _distance = self.position - _opponent_pos
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	_speed = _result[0]
	if _result[2]:
		Events.start_event("enemy", "wallBounce", id)
	self.rotate(-self.rotation)
	self.rotate(_result[1])
	self.rotate(turn_to_target(_distance.angle() + 3.1415/2, _rotation, self.rotation, delta))


func _body_entered(body: Node) -> void: #Used to check is the enemy dies
	data.enemy_died(id)
	Events.start_event("enemy", "death")
	body.queue_free()
	queue_free()

func _shoot(): #Used to shoot whenever possible
	if _last_shot + _reload < OS.get_ticks_msec():
		Events.start_event("enemy", "shoot", id)
		_last_shot = OS.get_ticks_msec() + _random_float(_reload_random)
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		bullet.shooter = "enemy"
		bullet.id = id
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 45 * preferences["global"]["scale"])
		bullet.rotation = self.rotation
		get_node("/root/Arena/").add_child(bullet)

func _enemy_action(speed: float, delta: float) -> float: #Used to calculate the new speed
	if _action["timeEnd"] < OS.get_ticks_msec():
		_action["number"] += 1
		if _action["number"] >= _AI.size():
			_action["number"] = 0
		_action["timeEnd"] = OS.get_ticks_msec() + _AI[_action["number"]]["time"] + _random_float(_AI[_action["number"]]["variance"])
	var _action_name = _AI[_action["number"]]["action"]
	var _action_strength = _AI[_action["number"]]["strength"]
	if _action_name == "brake":
		return speed + _action_strength * _brake * delta
	elif _action_name == "accelerate":
		return speed + _action_strength * _accelerate * delta
	else:
		return speed

func _random_float(value: float) -> float: # returns a random float between the entered values negative and positive.
	return value * (_rng.randf() * 2 - 1)
