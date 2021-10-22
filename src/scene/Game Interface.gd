extends Control

onready var score_label: Label = $Score
onready var round_label: Label = $Round

func _ready() -> void:
	data.connect("update_game_interface", self, "update_score")
	update_score()

func update_score() -> void:
	score_label.text = "Score: %s" % data.score
	round_label.text = "Round: %s" % data.round_number
