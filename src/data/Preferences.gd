extends Node

const preference_file = "user://preferences.json"


export(Dictionary) var startPreference: = {
	"bullet": {
		"speed": 700
	},
	"enemy": {
		"AI": [
			{
				"action": "accelerate",
				"strength": 1,
				"time": 3000,
				"variance": 100
			},
			{
				"action": "brake",
				"strength": 0,
				"time": 1000,
				"variance": 100
			}
		],
		"accelerate": 500,
		"bannedSpawn": [
			[
				200,
				1720,
				200,
				880
			]
		],
		"brake": -500,
		"reload": 1200,
		"reloadConsistency": 100,
		"rotation": 1.7
	},
	"friction": 0.2,
	"player": {
		"accelerate": 600,
		"brake": -600,
		"reload": 1000,
		"rotation": 2
	},
	"scale": 1,
	"version" : "0.2.2",
	"waitAfterDeath": 1
} 
export var preferences: Dictionary = startPreference.duplicate() setget changed

func _ready() -> void:
	var file = File.new()
	if file.file_exists(preference_file):
		file.open(preference_file, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			changed(data)


func reset() -> void:
	preferences = startPreference.duplicate()
	save()


func changed(value: Dictionary) -> void:
	preferences = correctValues(preferences, value)
	save()


func save() -> void:
	var file = File.new()
	file.open(preference_file, File.WRITE)
	file.store_string(to_json(preferences))
	file.close()

func correctValues(old: Dictionary, new: Dictionary) -> Dictionary:
	for x in old:
		if typeof(old[x]) == TYPE_DICTIONARY:
			if x in new:
				old[x] = correctValues(old[x], new[x])
		else:
			if x in new:
				old[x] = new[x]
	return old
