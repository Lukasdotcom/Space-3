extends Button

func _button_up() -> void: # Used to start the game
	get_tree().change_scene("res://src/scene/Arena.tscn")



func _on_Preferences_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")


func _on_Quit_button_up() -> void:
	get_tree().quit()
