extends Control
var information = {}
onready var controls: CheckBox = $Controls
onready var colors: CheckBox = $Colors

func _on_Button_button_up() -> void:
	if information:
		Preferences.changed(information)
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")
	self.queue_free()
