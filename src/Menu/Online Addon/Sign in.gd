extends Control

onready var username: LineEdit = $Username
onready var password: LineEdit = $Password
onready var error_message: Label = $Error

func _on_Return_button_up() -> void: # Returns to the addon menu
	get_tree().change_scene("res://src/Menu/Online Addon/Menu.tscn")

func _on_Login_button_up() -> void: # Does a login request to the server
	var _enter_username = username.get_text()
	var _enter_password = password.get_text()
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api.php"
	http_request.information["post"] = {
		"username" : username.get_text(),
		"password" : password.get_text(),
		"login" : "login"
	}
	add_child(http_request)
	var _http: HTTPRequest = $HTTPRequest
	_http.connect("request_completed",self,"finish_login")

func _on_Signup_button_up() -> void: # Does a signup and login request to server.
	var _enter_username = username.get_text()
	var _enter_password = password.get_text()
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api.php"
	http_request.information["post"] = {
		"username" : username.get_text(),
		"password" : password.get_text(),
		"login" : "signup"
	}
	add_child(http_request)
	var _http: HTTPRequest = $HTTPRequest
	_http.connect("request_completed",self,"finish_login")


func finish_login(result, response_code, headers, body): # Checks if the login was succesfult
	if response_code == 200:
		Preferences.userName = username.get_text()
		Preferences.key = JSON.parse(body.get_string_from_utf8()).result
		get_tree().change_scene("res://src/Menu/Online Addon/Menu.tscn")
	else:
		error_message.set_text(body.get_string_from_utf8())
