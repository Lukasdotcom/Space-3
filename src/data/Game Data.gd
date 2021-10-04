extends Node

signal update_game_interface # will be sent if the score or round changes

var maxEnemies = 1
var enemies = 0
var score: = 0 setget add_score
var round_number = 1

func enemy_died() -> void:
	enemies -= 1
	add_score(score + 1)
	if enemies <= 0:
		round_number += 1
		maxEnemies += 1
		get_node("/root/Arena/Spawner").spawn(maxEnemies)
		enemies = maxEnemies
		emit_signal("update_game_interface")

func add_score(value: int) -> void:
	score = value
	emit_signal("update_game_interface")
