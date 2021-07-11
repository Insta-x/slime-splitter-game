extends Slime

class_name MotherSlime


var randpos := Vector2.ZERO

func _ready() -> void:
	type = 2


func _physics_process(delta : float) -> void:
	if dead:
		return
	if stun_time_left <= 0.0:
		if randpos.distance_to(position) < 20:
			$ChangeMove.stop() 
			_on_ChangeMove_timeout()
		var direction := (randpos - global_position).normalized()
		velocity = velocity.move_toward(direction * movespeed, movespeed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)
	$AnimatedSprite.playing = stun_time_left <= 0
	$AnimatedSprite.flip_h = velocity.x < 0


func _on_ChangeMove_timeout():
	randpos = Global.player.position + Vector2.RIGHT.rotated(randf() * PI * 2) * (randi() % 300)
	$ChangeMove.start()


func _on_SpawnTimer_timeout():	
	var dir := (randf()) * PI * 2
	Global.world.create_slime(randi() % 2, size, global_position + Vector2.UP.rotated(dir) * 32, Vector2.UP.rotated(dir) * 10, size / 2)


func _set_size(value : int) -> void:
	._set_size(value)
	scale = Vector2.ONE * (0.8 + value * 0.2)
	max_health = 5 * value
	health = max_health
