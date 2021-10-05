extends Node

export(Dictionary) var preferences: = {
	"player" : {
		"brake" : -600,
		"accelerate" : 600,
		"rotation" : 2,
		"reload" : 1000
	},
	"enemy" : {
		"AI" : [
			{
				"action" : "accelerate",
				"strength" : 1,
				"time" : 3000,
				"variance" : 100
			},
			{
				"action" : "brake",
				"strength" : 0,
				"time" : 1000,
				"variance" : 100
			}
		],
		"brake" : -500,
		"accelerate" : 500,
		"rotation" : 1.7,
		"reload" : 1200,
		"reloadConsistency" : 100,
		"bannedSpawn" : [
			[200, 1720, 200, 880]
		]
	},
	"friction" : 0.2,
	"scale" : 1,
	"bullet" : {
		"speed" : 700
	},
	"waitAfterDeath" : 1
} setget changed

func changed(value: Dictionary) -> void:
	preferences = correctValues(preferences, value, [])

func correctValues(old: Dictionary, new: Dictionary, treePath: Array) -> Dictionary:
	for x in new:
		if typeof(old[x]) == TYPE_DICTIONARY:
			var newTreePath = treePath.duplicate()
			newTreePath.append(x)
			correctValues(old[x], new[x], treePath)
		else:
			old[x] = new[x]
	return old
