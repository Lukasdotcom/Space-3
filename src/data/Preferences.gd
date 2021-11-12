extends Node

var latestVersionCheck = true # Says if it should be checked if you are on the latest version
var latestVersion = "refs/tags/v0.4.0" # This is the github tag of this version
const preference_file = "user://preferences.json"
var key = ""
var userName = "" 

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
			"blue": 0.5,
			"green" : 0.5,
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
		"blue": 0.1,
		"green" : 0.1,
		"red" : 0.1
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
	"controls" : {
		"accelerate" : 16777232,
		"brake" : 16777234,
		"right" : 16777233,
		"left" : 16777231,
		"shoot" : 32,
		"ability" : 65
	},
	"events" : [
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
				},
				{
					"path": [
						"player",
						"color",
						"green"
					],
					"time": 2000,
					"type": "change",
					"value": 0.2
				},
				{
					"path": [
						"player",
						"color",
						"green"
					],
					"time": 5000,
					"type": "change",
					"value": 0.2
				}
			]
		}
	],
	"reload": 1000,
	"rotation": 2
},
"version": "0.3.4"
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
	changed_specific(value)


func changed_specific(value: Dictionary, flags: Array = []) -> void:
	if not value.has_all(["version"]):
		reset()
	if value["version"] == "0.2.2": # Updates the preferences to be compatible with new version
		value["version"] = "0.3.0"
		value["global"] = {
					"events": [],
					"friction": value["friction"],
					"scale": value["scale"],
					"waitAfterDeath": value["waitAfterDeath"]
						}
		value["player"]["events"] = []
		value["player"]["bullet"] = value["bullet"]
		value["player"]["abilityReload"] = startPreference["player"]["abilityReload"]
		value["enemy"]["events"] = []
		value["enemy"]["bullet"] = value["bullet"]
		value.erase("scale")
		value.erase("waitAfterDeath")
		value.erase("friction")
		value.erase("bullet")
	if value["version"] == "0.3.0": # adds all the color preferences to the default colors
		value["enemy"]["bullet"]["color"] = {"alpha": 1, "blue": 1, "green" : 1, "red" : 1}
		value["enemy"]["color"] = {"alpha": 1, "blue": 0, "green" : 0, "red" : 1}
		value["global"]["backgroundColor"] = {"blue": 0.301961, "green" : 0.301961, "red" : 0.301961}
		value["player"]["bullet"]["color"] = {"alpha": 1, "blue": 1, "green" : 1, "red" : 1}
		value["player"]["color"] = {"alpha": 1, "blue": 1, "green" : 0, "red" : 0}
		value["version"] = "0.3.3"
	if value["version"] == "0.3.3":
		value["player"]["controls"] = startPreference["player"]["controls"]
		value["version"] = "0.3.4"
	if value["version"] != startPreference["version"]:
		reset()
	if flags.has("controls"): # Checks if controls should be ignored
		value["player"]["controls"] = preferences["player"]["controls"].duplicate(true)
	if flags.has("colors"): # Checks if colors should be ignored
		value["enemy"]["color"] = preferences["enemy"]["color"].duplicate(true)
		value["enemy"]["bullet"]["color"] = preferences["enemy"]["bullet"]["color"].duplicate(true)
		value["player"]["color"] = preferences["player"]["color"].duplicate(true)
		value["player"]["bullet"]["color"] = preferences["player"]["bullet"]["color"].duplicate(true)
		value["global"]["backgroundColor"] = preferences["global"]["backgroundColor"].duplicate(true)
	preferences = value
	save()


func save() -> void:
	var file = File.new()
	file.open(preference_file, File.WRITE)
	file.store_string(to_json(preferences))
	file.close()
