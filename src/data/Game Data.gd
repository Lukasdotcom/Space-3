extends Node
signal update_game_interface # will be sent if the score or round changes
var maxEnemies = 1
var enemies = 0
var score: = 0 setget add_score
var round_number = 1
var preferences = Preferences.preferences.duplicate(true)
	
func enemy_died() -> void: # When an enemy died checks if the round is over
	enemies -= 1
	add_score(score + 1)
	if enemies <= 0:
		round_number += 1
		maxEnemies += 1
		get_node("/root/Arena/Spawner").spawn(maxEnemies)
		enemies = maxEnemies
		emit_signal("update_game_interface")

func add_score(value: int) -> void: # Changes the score
	score = value
	emit_signal("update_game_interface")

func start_game():
	preferences = Preferences.preferences.duplicate(true) # These are the preferences that are actually live during the game
	get_tree().change_scene("res://src/scene/Arena.tscn")
	maxEnemies = 1
	enemies = 0
	score = 0
	round_number = 1
