extends Physics

func _physics_process(delta: float) -> void:
	_speed *= pow(_friction, delta)
	_speed += Input.get_action_strength("accelerate") * _accelerate * delta
	_speed += Input.get_action_strength("brake") * _brake * delta
	rotate(((Input.get_action_strength("right") - Input.get_action_strength("left")) * _rotation * delta))
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation_degrees), _speed, delta)
	_speed = _result[0]
	self.rotate(-self.rotation_degrees * 3.1415 / 180)
	self.rotate(_result[1])
