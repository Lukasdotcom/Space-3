extends Timer
var information

func _ready():
	if information["length"] <= 0:
		finish()
	self.set_wait_time(information["length"]/1000)
	self.start()
	get_node("/root/Arena/Timer").connect("timeout", self, "finish")

func finish(): # Deletes the node
	self.queue_free()

func _on_Event_Timer_timeout() -> void: # Resets the event to remove the effects it started
	Events.change_value(information["path"], information["value"], information["type"], data.preferences)
	finish()
