extends Physics

var _speed = preferences["bullet"]["speed"]
func _physics_process(delta: float) -> void:
	var _answer = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	if _answer[2]:
		queue_free()
