extends NinePatchRect


signal restart_pressed
signal exit_pressed


func score(value : int) -> void:
	$VBoxContainer/Score.text = str(value)


func _on_RestartButton_pressed() -> void:
	emit_signal("restart_pressed")


func _on_ExitButton_pressed() -> void:
	emit_signal("exit_pressed")
