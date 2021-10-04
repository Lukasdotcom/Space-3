extends Control

onready var score_label: Label = $Score
onready var round_label: Label = $Round

func _ready() -> void:
	get_node("../Game Data").connect("update_game_interface", self, "update_score")
	update_score()

func update_score() -> void:
	score_label.text = "Score: %s" % get_node("../Game Data").score
	round_label.text = "Round: %s" % get_node("../Game Data").round_number
