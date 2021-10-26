extends Node

const preference_file = "user://preferences.json"


export(Dictionary) var startPreference: = {
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
	"bullet": {
		"color" : {
			"alpha": 1,
			"blue": 1,
			"green" : 1,
			"red" : 1
		},
		"speed": 700
	},
	"color" : {
		"alpha": 1,
		"blue": 0,
		"green" : 0,
		"red" : 1
	},
	"events": [

	],
	"reload": 1200,
	"reloadConsistency": 100,
	"rotation": 1.7
},
"global": {
	"backgroundColor" : {
		"blue": 0.301961,
		"green" : 0.301961,
		"red" : 0.301961
	},
	"events": [
		{
			"name": "newRound",
			"stats": [
				{
					"path": [
						"global",
						"scale"
					],
					"time": 0,
					"type": "change",
					"value": -0.1
				}
			],
		}
	],
	"friction": 0.2,
	"scale": 1.5,
	"waitAfterDeath": 1
},
"player": {
	"abilityReload": 5000,
	"accelerate": 600,
	"brake": -600,
	"bullet": {
		"color" : {
			"alpha": 1,
			"blue": 1,
			"green" : 1,
			"red" : 1
		},
		"speed": 700
	},
	"color" : {
		"alpha": 1,
		"blue": 1,
		"green" : 0,
		"red" : 0
	},
	"events": [
		{
			"name": "ability",
			"stats": [
				{
					"path": [
						"player",
						"reload"
					],
					"time": 2000,
					"type": "set",
					"value": 500
				},
				{
					"path": [
						"player",
						"bullet",
						"speed"
					],
					"time": 2000,
					"type": "set",
					"value": 1500
				}
			]
		}
	],
	"reload": 1000,
	"rotation": 2
},
"version": "0.3.3"
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
	preferences = value
	if not preferences.has_all(["version"]):
		reset()
	if preferences["version"] == "0.2.2": # Updates the preferences to be compatible with new version
		preferences["version"] = "0.3.0"
		preferences["global"] = {
					"events": [],
					"friction": preferences["friction"],
					"scale": preferences["scale"],
					"waitAfterDeath": preferences["waitAfterDeath"]
						}
		preferences["player"]["events"] = []
		preferences["player"]["bullet"] = preferences["bullet"]
		preferences["player"]["abilityReload"] = startPreference["player"]["abilityReload"]
		preferences["enemy"]["events"] = []
		preferences["enemy"]["bullet"] = preferences["bullet"]
		preferences.erase("scale")
		preferences.erase("waitAfterDeath")
		preferences.erase("friction")
		preferences.erase("bullet")
	if preferences["version"] == "0.3.0": # adds all the color preferences to the default colors
		preferences["enemy"]["bullet"]["color"] = {"alpha": 1, "blue": 1, "green" : 1, "red" : 1}
		preferences["enemy"]["color"] = {"alpha": 1, "blue": 0, "green" : 0, "red" : 1}
		preferences["global"]["backgroundColor"] = {"blue": 0.301961, "green" : 0.301961, "red" : 0.301961}
		preferences["player"]["bullet"]["color"] = {"alpha": 1, "blue": 1, "green" : 1, "red" : 1}
		preferences["player"]["color"] = {"alpha": 1, "blue": 1, "green" : 0, "red" : 0}
	if preferences["version"] != startPreference["version"]:
		reset()
	save()


func save() -> void:
	var file = File.new()
	file.open(preference_file, File.WRITE)
	file.store_string(to_json(preferences))
	file.close()
