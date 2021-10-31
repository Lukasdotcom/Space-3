extends HTTPRequest
var information = {}
var domain = "http://0.0.0.0"

func _ready() -> void:
	var _link = domain + information["link"]
	if information.has_all(["get"]): # Used for get requests
		_link += "?"
		for x in information["get"]:
			_link += x + "=" + information["get"][x].percent_encode() + "&"
	self.request(_link)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	self.queue_free()
