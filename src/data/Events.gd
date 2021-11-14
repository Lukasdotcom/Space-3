signal changeValues
extends Node

func start_event(category: String, name: String, id: String = "") -> void: # Used to start an event
	if category in Preferences.preferences: # Will check if it exists
		var event_list
		if category == "player":
			event_list = Preferences.preferences["player"][id]
		else:
			event_list = Preferences.preferences[category]
		if "events" in event_list: # Will check if it exists
			var _counter = 0
			for x in event_list["events"]:
				if x["name"] == name:
					var _preference_change = event_list["events"][_counter]["stats"]
					for y in _preference_change:
						y = y.duplicate(true)
						if y["path"][0] == "self" and not id: # Checks if no id is given but self is still asked for and then does nothing
							print("ERROR self is not defined skipping.")
						elif y["path"][0] == "enemy": # Checks if all enemies need to be changed
							y["path"].pop_front()
							var _yPath = y["path"].duplicate()
							for enemy in data.preferences["enemy"].keys():
								y["path"] = ["enemy", enemy]
								y["path"].append_array(_yPath)
								quick_change(y)
						elif y["path"][0] == "player": # Checks if all players need to be edited
							y["path"].pop_front()
							var _yPath = y["path"].duplicate()
							for player in data.preferences["player"].keys():
								y["path"] = ["player", player]
								y["path"].append_array(_yPath)
								print(y)
								quick_change(y)
						elif y["path"][0] == "self": # Checks if self shortcut is used
							y["path"].pop_front()
							var cat_id = [category, id]
							cat_id.append_array(y["path"])
							y["path"] = cat_id
							quick_change(y)
						else: # Done if nothing special has to be done
							quick_change(y)
				_counter += 1
			emit_signal("changeValues")
	
func quick_change(y):
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

func changed_value(): # Emits signal that value was changed
	emit_signal("changeValues")
