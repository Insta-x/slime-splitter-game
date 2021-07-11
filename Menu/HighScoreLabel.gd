extends Label


const pretext := "High Score\n"

var high_score := 0 setget set_high_score


func set_high_score(value : int) -> void:
	high_score = value
	text = pretext + str(value)
