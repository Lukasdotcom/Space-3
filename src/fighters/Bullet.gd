extends Physics
var shooter = "";
var _speed = 0;
var id = "original"
onready var _sprite: Sprite = $bullet # Gets the sprite for the bullet

func _ready() -> void:
	var _color = Color(1, 1, 1, 1)
	if shooter == "player":
		self.set_collision_layer(2)
		_speed = preferences["player"]["bullet"]["speed"]
		_color = preferences["player"]["bullet"]["color"]
	else:
		self.set_collision_layer(32)
		_speed = preferences["enemy"][id]["bullet"]["speed"]
		_color = preferences["enemy"][id]["bullet"]["color"]
	_sprite.set_self_modulate(Color(_color["red"], _color["green"], _color["blue"], _color["alpha"]))

func _physics_process(delta: float) -> void:
	var _answer = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	if _answer[2]:
		queue_free()
