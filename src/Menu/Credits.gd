extends RichTextLabel

onready var anim_player: AnimationPlayer = get_node("../AnimationPlayer")

func _ready() -> void:
	anim_player.play("Scroll")


func _on_Return_To_Menu_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")
