extends KinematicBody2D


var dash_cooldown := 3.0
var can_dash := true
var readying_dash := false
var dash_target := Vector2(0, 0)
var velocity = Vector2.ZERO
var friction = 150
var movespeed = 80


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity.length() < 10.0 and not readying_dash:
		$AnimatedSprite.play("Idle")
	if can_dash:
		can_dash = false
		readying_dash = true
		dash_target = get_global_mouse_position()
		$AnimatedSprite.play("ReadyDash")
		$AnimatedSprite.flip_h = (dash_target - global_position).x < 0
	velocity = move_and_slide(velocity)

func _on_DashTimer_timeout() -> void:
	can_dash = true

func _on_AnimatedSprite_animation_finished() -> void:
	if readying_dash:
		$DashTimer.start(dash_cooldown)
		var direction := (dash_target - global_position).normalized()
		velocity = direction * movespeed * 5
		readying_dash = false
		$AnimatedSprite.play("Dash")
