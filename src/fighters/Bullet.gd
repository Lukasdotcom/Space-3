extends Physics
var shooter = "";
var _speed = 0;

func _ready() -> void:
	if shooter == "player":
		self.set_collision_layer(2)
		_speed = preferences["player"]["bullet"]["speed"]
	else:
		self.set_collision_layer(32)
		_speed = preferences["enemy"]["bullet"]["speed"]

func _physics_process(delta: float) -> void:
	var _answer = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	if _answer[2]:
		queue_free()
