extends NinePatchRect


signal continue_pressed
signal restart_pressed
signal exit_pressed


func _on_ContinueButton_pressed() -> void:
	emit_signal("continue_pressed")


func _on_RestartButton_pressed() -> void:
	emit_signal("restart_pressed")


func _on_ExitButton_pressed() -> void:
	emit_signal("exit_pressed")
