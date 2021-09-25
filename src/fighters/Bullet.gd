extends Physics

export var _speed = 1500
func _physics_process(delta: float) -> void:
	var _answer = move_and_slide_angles(fix_rotation_calculation(self.rotation_degrees), _speed, delta)
	if _answer[2]:
		queue_free()
