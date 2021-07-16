extends Slime

class_name NormalSlime


var max_speed : float
var accel : float
var target : Vector2


func _ready() -> void:
	type = 0


func _physics_process(delta : float) -> void:
	if dead:
		return
	if target.distance_to(position) < 20:
		target = Global.player.position
	if target.distance_to(Global.player.position) > 200:
		target = Global.player.position + Vector2.RIGHT.rotated(randf() * PI * 2) * (randi() % 100)
	if stun_time_left <= 0.0:
		var direction : Vector2 = (target - global_position).normalized()
		velocity = velocity.move_toward(direction * max_speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)
	$AnimatedSprite.playing = stun_time_left <= 0
	$AnimatedSprite.flip_h = (Global.player.global_position - global_position).x < 0


func _set_size(value : int) -> void:
	._set_size(value)
	max_speed = 2.0 * movespeed
	accel = 0.5 * movespeed
