extends Control
var information = {}
onready var controls: CheckBox = $Controls
onready var colors: CheckBox = $Colors

func _on_Button_button_up() -> void:
	if information:
		var flags = []
		if controls.pressed:
			flags.append("controls")
		if colors.pressed:
			flags.append("colors")
		Preferences.changed_specific(information, flags)
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")
	self.queue_free()
