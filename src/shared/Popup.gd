extends Control

onready var label: Label = $text

var text = ""


func _ready() -> void: # Puts the correct text in the popup
	label.text = text




func _on_Button_button_up() -> void: # Used to close the popup
	self.queue_free()
