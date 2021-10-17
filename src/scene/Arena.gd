extends Node2D



func on_player_death() -> void:
	get_node("Timer").start(Preferences.preferences["global"]["waitAfterDeath"])


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")
