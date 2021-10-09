extends Physics
var _brake = preferences["enemy"]["brake"]
var _accelerate = preferences["enemy"]["accelerate"]
var _rotation = preferences["enemy"]["rotation"]
var _reload = preferences["enemy"]["reload"]
var _reload_random = -1 * preferences["enemy"]["reloadConsistency"]
var _AI = preferences["enemy"]["AI"]
var _action = {"number":0, "timeEnd":-0.1}
var _speed = 0.1
var _last_shot = 0
var _rng = RandomNumberGenerator.new()
func _ready():
	_rng.randomize()
	_last_shot = OS.get_ticks_msec() + _reload * _rng.randf()
	# Makes sure that the scale is right
	self.set_scale(Vector2(preferences["scale"], preferences["scale"]))


func _physics_process(delta: float) -> void:
	_shoot()
	_speed *= pow(_friction, delta)
	_speed = _enemy_action(_speed, delta)
	var _opponent_pos = Vector2(0, 0)
	if get_node("/root/Arena/Player"):
		_opponent_pos = get_node("/root/Arena/Player").position
	var _distance = self.position - _opponent_pos
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	_speed = _result[0]
	self.rotate(-self.rotation)
	self.rotate(_result[1])
	self.rotate(turn_to_target(_distance.angle() + 3.1415/2, _rotation, self.rotation, delta))


func _body_entered(body: Node) -> void: #Used to check is the enemy dies
	get_node("/root/Arena/Game Data").enemy_died()
	body.queue_free()
	queue_free()

func _shoot(): #Used to shoot whenever possible
	if _last_shot + _reload < OS.get_ticks_msec():
		_last_shot = OS.get_ticks_msec() + _random_float(_reload_random)
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		bullet.shooter = "enemy"
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 45 * preferences["scale"])
		bullet.rotation = self.rotation
		bullet.set_scale(Vector2(preferences["scale"], preferences["scale"]))
		get_node("/root/Arena/").add_child_below_node(get_node("/root/Arena/"),bullet)

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
