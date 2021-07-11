extends Camera2D


var player : Player

var shake_time_left := 0.0
var shake_total_time := 0.0
var strength := 0


func _process(delta: float) -> void:
	shake_time_left = move_toward(shake_time_left, 0.0, delta)
	if not player:
		return
	global_position = player.global_position + (get_global_mouse_position() - player.global_position) / 6
	
	# Shakes
	if shake_time_left > 0.01:
		var damping := ease(shake_time_left / shake_total_time, 1.0)
		offset = Vector2(
			randi() % strength * damping,
			randi() % strength * damping
			)


func shake(duration : float, power : int = 20) -> void:
	shake_time_left = duration
	shake_total_time = duration
	strength = power
