extends KinematicBody2D

class_name Player


signal get_loot(size)
signal dead
signal shooting(duration, strength)

const gun_bullet := preload("res://Objects/Bullet/GunBullet.tscn")
const splitter_bullet := preload("res://Objects/Bullet/SplitterBullet.tscn")

var movement_speed := 150.0
var dash_speed := 500.0
var direction := Vector2.ZERO
var last_dir := Vector2.ZERO

var shooting_gun := false
var shooting_split := false
var gun_cd := false
var split_cd := false
var dead := false

var can_dash := true
var dash_dir := Vector2.ZERO
var dashing := false


func _ready() -> void:
	Global.player = self


func _physics_process(delta : float) -> void:
	if dead:
		return
	
	# Aiming and shooting
	look_at(get_global_mouse_position())
	if shooting_gun and not gun_cd:
		var bullet := gun_bullet.instance()
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.global_position = global_position
		bullet.global_rotation = global_rotation
		get_parent().add_child(bullet)
		gun_cd = true
		$GunShot.play()
		emit_signal("shooting", 0.15, 6)
		$GunCD.start(0.3)
	if shooting_split and not split_cd:
		var bullet := splitter_bullet.instance()
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.global_position = global_position
		get_parent().add_child(bullet)
		split_cd = true
		$SplitterShot.play()
		emit_signal("shooting", 0.07, 3)
		$SplitCD.start(0.2)
	
	# Movement
	if dashing:
		move_and_slide(direction * dash_speed)
		return
	if Input.is_action_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		$DashCD.start()
		$DashStop.start()
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_and_slide(direction.normalized() * movement_speed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("normal_gun"):
		shooting_gun = event.is_pressed()
	if event.is_action("splitter_gun"):
		shooting_split = event.is_pressed()


func died() -> void:
	emit_signal("dead")
	visible = false
	dead = true


func _on_GunCD_timeout():
	gun_cd = false


func _on_SplitCD_timeout():
	split_cd = false


func _on_SlimeDetector_body_entered(_body: Node) -> void:
	died()
	$SlimeDetector.set_deferred("monitoring", false)
	$SlimeLootDetector.set_deferred("monitoring", false)


func _on_SlimeLootDetector_area_entered(area : Area2D) -> void:
	emit_signal("get_loot", area.size)
	area.queue_free()


func _on_DashStop_timeout():
	dashing = false


func _on_DashCD_timeout():
	can_dash = true
