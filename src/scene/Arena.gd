extends Node2D



func _on_Player_died() -> void:
	get_node("Timer").start(Preferences.preferences["global"]["waitAfterDeath"])


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")
