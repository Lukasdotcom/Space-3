extends Control
var information = {}
onready var controls: CheckBox = $Controls


func _on_Button_button_up() -> void:
	print(1)
	if information:
		var flags = []
		if controls.pressed:
			flags.append("controls")
		Preferences.changed_specific(information, flags)
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")
	self.queue_free()
