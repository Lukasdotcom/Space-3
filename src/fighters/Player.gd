extends Physics
var _brake = preferences["player"]["brake"]
var _accelerate = preferences["player"]["accelerate"]
var _rotation = preferences["player"]["rotation"]
var _reload = preferences["player"]["reload"]
var _speed = 0.1
var _last_shot = 0
signal death # emitted on death of player

func _ready() -> void:
	self.connect("death",get_node("/root/Arena/"),"on_player_death")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("shoot"):
		_shoot()
	_speed *= pow(_friction, delta)
	_speed += Input.get_action_strength("accelerate") * _accelerate * delta
	_speed += Input.get_action_strength("brake") * _brake * delta
	rotate(((Input.get_action_strength("right") - Input.get_action_strength("left")) * _rotation * delta))
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	_speed = _result[0]
	self.rotate(-self.rotation)
	self.rotate(_result[1])


func _body_entered(body: Node) -> void:
	self.queue_free()
	body.queue_free()

func _shoot(): # Used to shoot a bullet
	if _last_shot + _reload < OS.get_ticks_msec(): # makes sure that the player can shoot
		_last_shot = OS.get_ticks_msec()
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		bullet.shooter = "player"
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 45 * preferences["global"]["scale"])
		bullet.rotation = self.rotation
		get_node("/root/Arena/").add_child(bullet)

func _ability(): # Used to start ability
	Events.start_event("player", "ability")

func _exit_tree() -> void:
	emit_signal("death")
