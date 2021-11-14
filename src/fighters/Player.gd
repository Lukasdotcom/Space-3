extends Physics
onready var _sprite: Sprite = $fighter # Gets the sprite for the player
var id
var _color
var _brake
var _accelerate
var _rotation
var _reload
var _ability_reload
var _speed = 0.1
var _last_shot = 0
var _last_ability = 0
signal death # emitted on death of player

func _ready() -> void:
	settings_reloaded()
	self.connect("death",get_node("/root/Arena/"),"on_player_death")
	Events.connect("changeValues",self,"settings_reloaded")

func settings_reloaded():
	self.name = id
	_color = preferences["player"][id]["color"]
	_brake = preferences["player"][id]["brake"]
	_accelerate = preferences["player"][id]["accelerate"]
	_rotation = preferences["player"][id]["rotation"]
	_reload = preferences["player"][id]["reload"]
	_ability_reload = preferences["player"][id]["abilityReload"]
	_sprite.set_self_modulate(Color(_color["red"], _color["green"], _color["blue"], _color["alpha"]))
	_brake = preferences["player"][id]["brake"]
	_accelerate = preferences["player"][id]["accelerate"]
	_rotation = preferences["player"][id]["rotation"]
	_reload = preferences["player"][id]["reload"]
	_ability_reload = preferences["player"][id]["abilityReload"]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot" + id):
		_shoot()
	if Input.is_action_just_pressed("ability" + id):
		_ability()
	_speed *= pow(_friction, delta)
	_speed += Input.get_action_strength("accelerate" + id) * _accelerate * delta
	_speed += Input.get_action_strength("brake" + id) * _brake * delta
	rotate(((Input.get_action_strength("right" + id) - Input.get_action_strength("left" + id)) * _rotation * delta))
	var _result = move_and_slide_angles(fix_rotation_calculation(self.rotation), _speed, delta)
	_speed = _result[0]
	if _result[2]:
		Events.start_event("player", "wallBounce", id)
	self.rotate(-self.rotation)
	self.rotate(_result[1])


func _body_entered(body: Node) -> void:
	self.queue_free()
	body.queue_free()

func _shoot(): # Used to shoot a bullet
	if _last_shot + _reload < OS.get_ticks_msec(): # makes sure that the player can shoot
		Events.start_event("player", "shoot", id)
		_last_shot = OS.get_ticks_msec()
		var bullet = load("res://src/fighters/Bullet.tscn")
		bullet = bullet.instance()
		bullet.id = id
		bullet.shooter = "player"
		bullet.position = self.position + calcVelcoity(fix_rotation_calculation(self.rotation), 45 * preferences["global"]["scale"])
		bullet.rotation = self.rotation
		get_node("/root/Arena/").add_child(bullet)

func _ability(): # Used to start ability
	if _last_ability + _ability_reload < OS.get_ticks_msec(): # makes sure that the player can use their ability
		_last_ability = OS.get_ticks_msec()
		Events.start_event("player", "ability", id)

func _exit_tree() -> void:
	emit_signal("death", id)
