extends KinematicBody2D
class_name Physics
var preferences = data.preferences
var _friction = preferences["global"]["friction"]
const FLOOR_NORMAL = Vector2.UP

func _ready() -> void:
	Events.connect("changeValues",self,"physics_set_reloaded")
	physics_set_reloaded()

func physics_set_reloaded():
	self.set_scale(Vector2(preferences["global"]["scale"], preferences["global"]["scale"]))
	_friction = preferences["global"]["friction"]

func fix_rotation_calculation(angle: float) -> float: # Used to fix the calculation of the self.rotation_degrees
	return (angle * -1 + 3.14159265/2)

func reverse_fix_rotation_calculation(angle: float) -> float: # Reverse of fix_rotation_calculation()
	return ((angle * 180 / 3.14159265) - 90) * -1

func move_and_slide_angles(angle: float, speed: float, delta: float) -> Array: # move and slide but with angle support and returns new speed, angle, and collisions
	var _velocity = calcVelcoity(angle, speed)*delta
	var _correction = move_and_collide(_velocity)
	var _test = _velocity
	_velocity =  _velocity.bounce(_correction.normal) if _correction else _velocity
	angle = _velocity.angle() + 3.141592/2
	return [_velocity.length()/delta if speed > 0 else -1 * _velocity.length()/delta, angle if speed > 0 else angle - 3.1415, _correction]
	

func calcVelcoity(angle: float, speed: float) -> Vector2: # calculates the velocity with angles and speed
	return Vector2( cos(angle) * speed, -sin(angle) * speed)

func turn_to_target(target: float, speed: float, angle: float, delta: float) -> float:
	var difference = angle - target
	while difference > 3.1415:
		difference -= 3.1415*2
	while difference < -3.1415:
		difference += 3.1415*2
	return difference / abs(difference) * speed * delta
