extends Physics
export var _brake: = -700
export var _accelerate: = 700
export var _rotation: = 2
var _speed = 0.1
export var _reload = 1000
var _last_shot = 0
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
	body.queue_free()
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")

func _shoot():
	if _last_shot + _reload < OS.get_ticks_msec():
		_last_shot = OS.get_ticks_msec()
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		print(get_node("/root/Arena"))
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 50)
		bullet.rotation = self.rotation
		get_node("/root/Arena/").add_child_below_node(get_node("/root/Arena/"),bullet)

