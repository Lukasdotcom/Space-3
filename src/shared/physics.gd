extends KinematicBody2D
class_name Physics

export var _friction: = 0.1
export var _brake: = -1000
export var _accelerate: = 1000
export var _rotation: = 3
const FLOOR_NORMAL = Vector2.UP
var _speed = 0.1

func fix_rotation_calculation(angle: float) -> float: # Used to fix the calculation of the self.rotation_degrees
	return (angle * -1 + 90) / 180 * 3.14159265

func reverse_fix_rotation_calculation(angle: float) -> float: # Reverse of fix_rotation_calculation()
	return ((angle * 180 / 3.14159265) - 90) * -1

func move_and_slide_angles(angle: float, speed: float, delta: float) -> Array: # move and slide but with angle support
	var _velocity = calcVelcoity(angle, speed)*delta
	var _correction = move_and_collide(_velocity)
	var _test = _velocity
	_velocity =  _velocity.bounce(_correction.normal) if _correction else _velocity
	print(_correction.normal) if _correction else null
	angle = _velocity.angle() + 3.141592/2
	print(_velocity.length()/delta if speed > 0 else -1 * _velocity.length())
	return [_velocity.length()/delta if speed > 0 else -1 * _velocity.length()/delta, angle if speed > 0 else angle - 3.1415]
	

func calcVelcoity(angle: float, speed: float) -> Vector2: # calculates the velocity with angles and speed
	return Vector2( cos(angle) * speed, -sin(angle) * speed)
