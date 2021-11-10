extends HTTPRequest
var information = {}
var domain = "http://0.0.0.0"
var loading = self

func _ready() -> void:
	var _link = ""
	if information["link"].left(4) == "http":
		_link = information["link"]
	else:
		_link = domain + information["link"]
	if information.has_all(["get"]): # Used for get requests
		_link += "?key=" + Preferences.key + "&"
		for x in information["get"]:
			_link += x + "=" + str(information["get"][x]).percent_encode() + "&"
		self.request(_link)
	if information.has_all(["post"]): # Does a urlencoded post request to that link
		var _data = "key=" + Preferences.key + "&"
		for x in information["post"]:
			_data += x + "=" + str(information["post"][x]).percent_encode() + "&"
		self.request(_link, ["Content-type: application/x-www-form-urlencoded"], true, HTTPClient.METHOD_POST, _data)
	loading = load("res://src/shared/Loading.tscn")
	loading = loading.instance()
	get_node("/root").call_deferred("add_child", loading)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	loading.queue_free()
	self.queue_free()
