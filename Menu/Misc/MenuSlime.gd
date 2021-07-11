extends KinematicBody2D


var velocity := Vector2.ZERO
var max_speed = 150
var accel = 75


func _physics_process(delta : float) -> void:
	var direction := (get_global_mouse_position() - global_position).normalized()
	velocity = velocity.move_toward(direction * max_speed, accel * delta)
	velocity = move_and_slide(velocity)
	$AnimatedSprite.flip_h = (get_global_mouse_position() - global_position).x < 0
