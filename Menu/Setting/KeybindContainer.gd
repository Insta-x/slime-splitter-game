extends HBoxContainer


export(String) var action_name : String
export(String) var label_name : String
var event : InputEvent setget set_event
var wait_input := false setget set_wait_input

onready var button : TextureButton = $TextureButton
onready var event_label : Label = $TextureButton/Label


func _ready() -> void:
	assert(InputMap.has_action(action_name))
	$Label.text = label_name
	event = InputMap.get_action_list(action_name)[0]
	if event is InputEventKey:
		event_label.text = event.as_text()
	elif event is InputEventMouseButton:
		event_label.text = GlobalKeybind.mouse_button_text[event.button_index]
#	event_label.text = OS.get_scancode_string(event.scancode)


func _input(event: InputEvent) -> void:
	if wait_input:
		if event is InputEventKey or event is InputEventMouseButton:
			self.event = event
			self.wait_input = false
		get_tree().set_input_as_handled()


func set_event(value : InputEvent) -> void:
	GlobalKeybind.check_key(action_name, event, value)
	event = value
	if event is InputEventKey:
		event_label.text = event.as_text()
	elif event is InputEventMouseButton:
		event_label.text = GlobalKeybind.mouse_button_text[event.button_index]


func set_wait_input(value : bool) -> void:
	wait_input = value
	button.disabled = wait_input
	if wait_input:
		event_label.text = "Input any key"


func _on_TextureButton_pressed() -> void:
	self.wait_input = true
