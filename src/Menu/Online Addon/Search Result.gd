extends Control

onready var title: RichTextLabel = $Title
onready var description: RichTextLabel = $Description
onready var author: RichTextLabel = $Author

var information

func _ready() -> void: # Will load the information
	if not information:
		self.queue_free()
	title.text = information["title"]
	description.text = information["description"]
	author.text = information["owner"]


func _on_Download_button_up() -> void:
	Preferences.changed(JSON.parse(information["preferences"]).result)
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")
