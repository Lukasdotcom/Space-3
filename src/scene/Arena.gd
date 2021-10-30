extends Node2D
onready var _tile_map: TileMap = $TileMap

func _ready() -> void: # Adjusts the aspect ratio of the map so it fits correctly with user aspect ratio
	var _new_scale = get_viewport().size
	if _new_scale.x / _new_scale.y * 1080 / 1920 > 1:
		_tile_map.set_scale(Vector2(_new_scale.x / 1920 * 1080 / _new_scale.y, 1))
	else:
		_tile_map.set_scale(Vector2(1, _new_scale.y / 1080 * 1920 / _new_scale.x))


func on_player_death() -> void:
	get_node("Timer").start(Preferences.preferences["global"]["waitAfterDeath"])


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")
