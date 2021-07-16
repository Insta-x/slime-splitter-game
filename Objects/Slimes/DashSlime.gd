extends Slime

class_name DashSlime


onready var DashTimer : Timer = $DashTimer

var dash_cooldown := 4.0
var can_dash := true
var readying_dash := false
var dash_target := Vector2(0, 0)


func _ready() -> void:
	type = 1
	friction = 400


func _physics_process(delta: float) -> void:
	if dead:
		return
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity.length() < 10.0 and not readying_dash:
		$AnimatedSprite.play("Idle")
	if can_dash and stun_time_left <= 0:
		can_dash = false
		readying_dash = true
		dash_target = Global.player.global_position + Vector2.RIGHT.rotated(randf() * PI * 2) * (randi() % 100)
		$AnimatedSprite.play("ReadyDash")
		$AnimatedSprite.flip_h = (dash_target - global_position).x < 0
	velocity = move_and_slide(velocity)


func _on_DashTimer_timeout() -> void:
	can_dash = true


func _set_size(value : int) -> void:
	dash_cooldown = 4.0 - (value * 0.2)
	._set_size(value)


func _on_AnimatedSprite_animation_finished() -> void:
	._on_AnimatedSprite_animation_finished()
	if readying_dash:
		DashTimer.start(dash_cooldown)
		var direction := (dash_target - global_position).normalized()
		
		velocity = direction * movespeed * 6
		readying_dash = false
		$AnimatedSprite.play("Dash")
