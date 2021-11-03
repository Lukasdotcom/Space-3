extends Control

onready var _search_text: LineEdit = $SearchText
onready var _vbox: VBoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void: # Makes sure that there is a result instantly
	_on_Search_button_up()

func _on_Search_button_up() -> void: # Used to search
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api/space3.php"
	http_request.information["get"] = {
		"search" : _search_text.get_text()
	}
	add_child(http_request)
	var _http: HTTPRequest = $HTTPRequest
	_http.connect("request_completed",self,"_search_done")
	# Removes all the old search results
	var _children = _vbox.get_children()
	for x in _children:
		x.queue_free()


func _search_done(result, response_code, headers, body): # Loads all the search results
	var _search_result = JSON.parse(body.get_string_from_utf8()).result
	if Preferences.userName:
		var _upload = load("res://src/Menu/Online Addon/Search Result.tscn")
		_upload = _upload.instance()
		_upload.information = {
			"title" : "",
			"owner" : Preferences.userName,
			"description" : "",
			"id" : "",
		}
		_vbox.call_deferred("add_child", _upload)
	if _search_result: # Checks if there is something in the response and then goes through every response and adds it to the results
		for _result in _search_result:
			var _result_answer = load("res://src/Menu/Online Addon/Search Result.tscn")
			_result_answer = _result_answer.instance()
			_result_answer.information = _result
			_vbox.call_deferred("add_child", _result_answer)


func _on_Return_button_up() -> void: # Button used to return to main menu
	get_tree().change_scene("res://src/Menu/Main Menu.tscn")
