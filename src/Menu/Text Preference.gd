extends TextEdit

func _ready():
	set_text(JSON.print(Preferences.preferences, "\t")) 


func _on_Save_and_Return_button_up() -> void:
	Preferences.preferences = JSON.parse(get_text()).result
	returnMainMenu()


func _on_Return_button_up() -> void:
	returnMainMenu()

func returnMainMenu():
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")



func _on_Reset_button_up() -> void:
	Preferences.reset()
	get_tree().reload_current_scene()
