extends Button

func _button_up() -> void: # Used to start the game
	data.start_game()



func _on_Preferences_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")


func _on_Quit_button_up() -> void:
	get_tree().quit()


func _on_Credits_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Credits.tscn")
