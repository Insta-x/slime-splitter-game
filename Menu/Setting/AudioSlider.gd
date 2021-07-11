extends HScrollBar


export(String) var bus_name := "Master"


func _on_AudioSlider_value_changed(value: float) -> void:
	GlobalAudio.change_audio(bus_name, value, is_equal_approx(value, min_value))
