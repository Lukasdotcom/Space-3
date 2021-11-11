extends Control

onready var title: RichTextLabel = $Title
onready var description: RichTextLabel = $Description
onready var author: RichTextLabel = $Author
onready var title2: TextEdit = $Title2
onready var description2: TextEdit = $Description2
onready var editButton: Button = $Edit
onready var delete: Button = $Delete
onready var download: Button = $Download
onready var likes: RichTextLabel = $Likes
onready var downloads: RichTextLabel = $Downloads
onready var likeButton: Button = $Like

var information

func _ready() -> void: # Will load the information
	if not information:
		self.queue_free()
	title.text = information["title"]
	description.text = information["description"]
	author.text = information["owner"]
	title2.text = information["title"]
	description2.text = information["description"]
	if not information["owner"] == Preferences.userName: # Will check if that preference is owned by that user
		editButton.disabled = true
		delete.visible = false
		if Preferences.userName:
			if information["liked"]:
				likeButton.text = "Unlike"
			likeButton.visible = true
	if not information["id"]: # Will check if it is a new upload choice
		delete.visible = false
		editButton.visible = false
		title2.visible = true
		description2.visible = true
		download.set_text("Upload")
	else:
		likes.text = "%s Likes" % information["likes"]
		downloads.text = "%s Downloads" % information["downloads"]


func _on_Download_button_up() -> void: # Will download the preferences or upload them to overwrite the old ones
	if download.get_text() == "Download": # Checks if it is a download action
		# Will actually download the data
		var http_request = load("res://src/shared/HTTPRequest.tscn")
		http_request = http_request.instance()
		http_request.information["link"] = "/api/space3.php"
		http_request.information["get"] = {
			"download" : information["id"]
		}
		add_child(http_request)
		http_request.connect("request_completed",self,"finish_download")
	else:
		_update(true)

func finish_download(result, response_code, headers, body): # Used to update preferences after the download is done.
	if response_code == 200:
		var _popup = load("res://src/Menu/Online Addon/Choices.tscn")
		_popup = _popup.instance()
		_popup.information = JSON.parse(body.get_string_from_utf8()).result
		get_node("/root").call_deferred("add_child", _popup)
	else:
		var _popup = load("res://src/shared/Popup.tscn")
		_popup = _popup.instance()
		_popup.text = body.get_string_from_utf8()
		get_node("/root").call_deferred("add_child", _popup)


func _on_Delete_button_up() -> void: # Will delete the entry if this is owned by that owner
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api/space3.php"
	http_request.information["post"] = {
		"delete" : information["id"]
	}
	add_child(http_request)
	self.visible = false

func _on_Edit_button_up() -> void: # Will either save or edit the entry
	if editButton.get_text() == "Edit": # Enables the editing
		editButton.set_text("Save")
		download.set_text("Overwrite")
		title2.visible = true
		description2.visible = true
	else: # Saves the editing
		_update(false)
		
func _update(overwrite: bool): # Used to update a preference
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api/space3.php"
	http_request.information["post"] = {
		"update" : "true",
		"id" : information["id"],
		"title" : title2.text,
		"description" : description2.text
	}
	if overwrite:
		http_request.information["post"]["preferences"] = JSON.print(Preferences.preferences)
	add_child(http_request)
	editButton.set_text("Edit")
	download.set_text("Download")
	title2.visible = false
	description2.visible = false
	title.text = title2.text
	description.text = description2.text
	delete.visible = true
	editButton.visible = true


func _on_Like_button_up() -> void: # Is used to like or unlike a preference
	var http_request = load("res://src/shared/HTTPRequest.tscn")
	http_request = http_request.instance()
	http_request.information["link"] = "/api/space3.php"
	http_request.information["post"] = {
		"like" : information["id"]
	}
	add_child(http_request)
	if likeButton.text == "Unlike":
		likeButton.text = "Like"
		information["likes"] -= 1
	else:
		likeButton.text = "Unlike"
		information["likes"] += 1
	likes.text = "%s Likes" % information["likes"] 
