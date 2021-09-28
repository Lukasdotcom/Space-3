extends Button

func _button_up() -> void: # Used to start the game
	get_tree().change_scene("res://src/scene/Arena.tscn")
