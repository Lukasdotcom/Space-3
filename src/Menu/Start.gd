extends Button

func _ready() -> void: # Checks if the game is up to date
	if Preferences.latestVersionCheck:
		var http_request = load("res://src/shared/HTTPRequest.tscn")
		http_request = http_request.instance()
		http_request.information["link"] = "https://api.github.com/repos/lukasdotcom/space-3/git/refs/tags"
		http_request.information["get"] = {}
		add_child(http_request)
		http_request.connect("request_completed",self,"version_check")
	
func version_check(result, response_code, headers, body): # Will check if the versions match
	if body.get_string_from_utf8():
		var version = JSON.parse(body.get_string_from_utf8()).result
		version = version[-1]["ref"]
		if version != Preferences.latestVersion:
			var _popup = load("res://src/shared/Popup.tscn")
			_popup = _popup.instance()
			_popup.text = "You are not on the latest version. The latest version is " + version.lstrip("refs/tags/") + ". To download this go to the official github."
			get_node("/root").call_deferred("add_child", _popup)
		Preferences.latestVersionCheck = false
	

func _button_up() -> void: # Used to start the game
	data.start_game()

func _on_Preferences_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Edit Preference.tscn")


func _on_Quit_button_up() -> void:
	get_tree().quit()


func _on_Credits_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Credits.tscn")


func _on_Online_button_up() -> void:
	get_tree().change_scene("res://src/Menu/Online Addon/Menu.tscn")
