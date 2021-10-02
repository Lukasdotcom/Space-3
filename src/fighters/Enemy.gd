extends Physics
var _brake = preferences["enemy"]["brake"]
var _accelerate = preferences["enemy"]["accelerate"]
var _rotation = preferences["enemy"]["rotation"]
var _reload = preferences["enemy"]["reload"]
var _low_reload_random = -1 * preferences["enemy"]["reloadConsistency"]
var _high_reload_random = preferences["enemy"]["reloadConsistency"]
var _speed = 0.1
var _last_shot = 0
var _rng = RandomNumberGenerator.new()
func _ready():
	_rng.randomize()
	_last_shot = OS.get_ticks_msec() + _reload * _rng.randf()

func _physics_process(delta: float) -> void:
	_shoot()
	_speed *= pow(_friction, delta)
	_speed += 1 * _accelerate * delta
	var _opponent_pos = Vector2(0, 0)
	if get_node("/root/Arena/Player"):
		_opponent_pos = get_node("/root/Arena/Player").position
	var _distance = self.position - _opponent_pos
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	_speed = _result[0]
	self.rotate(-self.rotation)
	self.rotate(_result[1])
	self.rotate(turn_to_target(_distance.angle() + 3.1415/2, _rotation, self.rotation, delta))


func _body_entered(body: Node) -> void:
	get_node("/root/Arena/Game Data").enemies -= 1
	body.queue_free()
	queue_free()

func _shoot():
	if _last_shot + _reload < OS.get_ticks_msec():
		_last_shot = OS.get_ticks_msec() + _rng.randi_range(_low_reload_random, _high_reload_random)
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 50)
		bullet.rotation = self.rotation
		get_node("/root/Arena/").add_child_below_node(get_node("/root/Arena/"),bullet)
