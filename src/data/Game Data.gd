extends Node

var maxEnemies = 1
var enemies: = 0 setget enemies_change

func enemies_change(value: int) -> void:
	enemies = value
	if enemies <= 0:
		maxEnemies += 1
		get_node("/root/Arena/Spawner").spawn(maxEnemies)
		enemies = maxEnemies
