signal changeValues
extends Node

func start_event(category: String, name: String) -> void: # Used to start an event
	if category in Preferences.preferences:
		if "events" in Preferences.preferences[category]:
			var _counter = 0
			for x in Preferences.preferences[category]["events"]:
				if x["name"] == name:
					var _preference_change = Preferences.preferences[category]["events"][_counter]["stats"]
					for y in _preference_change:
						var timer = load("res://src/data/Event Timer.tscn")
						timer = timer.instance()
						if y["type"] == "set":
							timer.information = {"length" : y["time"],
												"path" : y["path"].duplicate(),
												"value" : get_value(y["path"].duplicate(), data.preferences),
												"type" : "set"}
						else:
							timer.information = {"length" : y["time"],
												"path" : y["path"].duplicate(),
												"value" : (-1 * y["value"]),
												"type" : "change"}
						self.add_child(timer)
						data.preferences = change_value(y["path"].duplicate(), y["value"], y["type"], data.preferences)
				_counter += 1
			emit_signal("changeValues")
	

func get_value(path: Array, preference: Dictionary):
	var path_name = path.pop_front()
	var value
	if path:
		value = get_value(path, preference[path_name])
	else:
		value = preference[path_name]
	return value

func change_value(path: Array, value, type: String, preference: Dictionary) -> Dictionary:
	var path_name = path.pop_front()
	if path:
		preference[path_name] = change_value(path, value, type, preference[path_name])
	else:
		if type == "set":
			preference[path_name] = value
		elif type == "change":
			preference[path_name] += value
	return preference