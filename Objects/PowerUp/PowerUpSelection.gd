extends Control

signal power_up(type)


var PowerSelected = "null"


func _on_AtkSpeed_pressed():
	PowerSelected = "Atk Speed"
	emit_signal("power_up", PowerSelected)


func _on_Damage_pressed(): 
	PowerSelected = "Damage"
	emit_signal("power_up", PowerSelected)


