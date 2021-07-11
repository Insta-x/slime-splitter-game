extends Node


const file_path := "user://Settings/keybinds.cfg"
const mouse_button_text := {
	1 : "LMB",
	2 : "RMB",
	3 : "MMB",
	4 : "Wheel Up",
	5 : "Wheel Down",
	6 : "Wheel Left",
	7 : "Wheel Right",
	8 : "XMB1",
	9 : "XMB2",
}

var config := ConfigFile.new()
var section := "Keybinds"
var custom_actions := [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
	"normal_gun",
	"splitter_gun",
	"dash",
]


func save_key() -> void:
	for action in custom_actions:
		config.set_value(section, action, InputMap.get_action_list(action)[0])
	config.save(file_path)


func load_key() -> void:
	var err := config.load(file_path)
	if err != OK:
		save_key()
		return
	for action in custom_actions:
		if config.has_section_key(section, action):
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, config.get_value(section, action))
		else:
			config.set_value(section, action, InputMap.get_action_list(action)[0])


func change_key(action : String, old_event : InputEvent, event : InputEvent) -> void:
	InputMap.action_erase_event(action, old_event)
	InputMap.action_add_event(action, event)


func check_key(action_name : String, old_event : InputEvent, event : InputEvent) -> void:
	for action in custom_actions:
		if action == action_name:
			continue
		if event.is_action(action):
			change_key(action, InputMap.get_action_list(action)[0], old_event)
			break
	change_key(action_name, old_event, event)
