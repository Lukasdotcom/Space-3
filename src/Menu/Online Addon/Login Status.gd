extends Control

onready var loginButton: Button = $Button
onready var status: Label = $Status

func _ready() -> void: # Checks if the user is logged in
	if Preferences.userName:
		loginButton.queue_free()
		status.set_text("Logged in as " + Preferences.userName)


func _on_Button_button_up() -> void: # Goes to sign in screen
	get_tree().change_scene("res://src/Menu/Online Addon/Sign in.tscn")
