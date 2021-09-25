extends Physics
export var _brake: = -1000
export var _accelerate: = 1000
export var _rotation: = 3
export var _speed = 0.1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("shoot"):
		_shoot()
	_speed *= pow(_friction, delta)
	_speed += Input.get_action_strength("accelerate") * _accelerate * delta
	_speed += Input.get_action_strength("brake") * _brake * delta
	rotate(((Input.get_action_strength("right") - Input.get_action_strength("left")) * _rotation * delta))
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation_degrees), _speed, delta)
	_speed = _result[0]
	self.rotate(-self.rotation_degrees * 3.1415 / 180)
	self.rotate(_result[1])


func _body_entered(body: Node) -> void:
	body.queue_free()
	queue_free()

func _shoot():
	var bullet = load("res://src/fighters/Bullet.tscn")
	bullet = bullet.instance()
	print(get_node("/root/Arena"))
	bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation_degrees), 50)
	bullet.rotation_degrees = self.rotation_degrees
	get_node("/root/Arena/").add_child_below_node(get_node("/root/Arena/"),bullet)
