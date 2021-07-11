extends Node


const file_path := "user://Settings/audio.cfg"

var config := ConfigFile.new()
var custom_buses := [
	"Music",
	"SFX",
]


func save_audio() -> void:
	for bus in custom_buses:
		config.set_value(bus, "volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))
	config.save(file_path)


func load_audio() -> void:
	var err := config.load(file_path)
	if err != OK:
		save_audio()
		return
	for bus in custom_buses:
		if config.has_section_key(bus, "volume"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), config.get_value(bus, "volume"))
		else:
			config.set_value(bus, "volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))


func change_audio(bus_name : String, volume : float, muted : bool) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), volume)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), muted)
