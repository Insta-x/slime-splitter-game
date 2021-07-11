extends Control


onready var HighScoreLabel := $MainMenu/MarginContainer/VBoxContainer/CenterContainer2/HighScoreLabel
onready var ScreenFader := $ScreenFader
onready var music_button := $MainMenu/HBoxContainer/MusicButton
onready var sfx_button  := $MainMenu/HBoxContainer/SFXButton

var music_disabled := false
var sfx_disabled := false


func _ready() -> void:
	# User saves
	var loadf := File.new()
	if loadf.file_exists("user://asd.sav"):
		loadf.open("user://asd.sav", File.READ)
		HighScoreLabel.high_score = loadf.get_64()
	else:
		HighScoreLabel.high_score = 0
	loadf.close()
	
	# User settings
	GlobalKeybind.load_key()
	
	ScreenFader.fade_in(1)
	yield(ScreenFader, "animation_finished")


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://GameMode/Game.tscn")



func _on_HelpButton_pressed() -> void:
	$MainMenu.visible = false
	$Help.visible = true


func _on_SettingButton_pressed() -> void:
	$MainMenu.visible = false
	$Setting.visible = true


func _on_CreditsButton_pressed() -> void:
	$MainMenu.visible = false
	$Credits.visible = true


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_MusicButton_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !music_disabled)
	music_disabled = !music_disabled
	$MainMenu/HBoxContainer/MusicButton/DisabledTexture.visible = music_disabled


func _on_SFXButton_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !sfx_disabled)
	sfx_disabled = !sfx_disabled
	$MainMenu/HBoxContainer/SFXButton/DisabledTexture.visible = sfx_disabled


func _on_HelpCloseButton_pressed() -> void:
	$MainMenu.visible = true
	$Help.visible = false


func _on_SettingCloseButton_pressed() -> void:
	$MainMenu.visible = true
	$Setting.visible = false


func _on_CreditsCloseButton_pressed() -> void:
	$MainMenu.visible = true
	$Credits.visible = false
