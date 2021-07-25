extends KinematicBody2D

class_name Slime


var type : int # 0 = normal, 1 = dash, 2 = mother
var max_health := 1
var health := 1 setget set_health
var size := 1 setget _set_size
var movespeed := 75.0
var friction := 150.0

var velocity := Vector2.ZERO
var stun_time_left := 0.0 setget set_stun_time_left
var can_join := false
var dead := false

var slime_loot = preload("res://Objects/SlimeLoot/SlimeLoot.tscn")


func _ready() -> void:
	z_index = size
	$Stat/Size/SizeLabel.text = str(size)
	$Stat/Health/HealthLabel.text = str(health)


func _physics_process(delta: float) -> void:
	self.stun_time_left = move_toward(stun_time_left, 0.0, delta)
	if global_position.distance_to(Global.player.global_position) > 2000:
		var rot := rand_range(0, 2 * PI)
		global_position = Vector2(cos(rot), sin(rot)) * (randi() % 500 + 1000)
	$StunnedSprite.visible = stun_time_left > 0.0


func join(body : KinematicBody2D) -> void:
	var t = type
	Global.world.create_slime(t, size+body.size, (global_position + body.global_position) / 2, Vector2.ZERO,0.0,1)
	can_join = false
	body.can_join = false
	Global.world.slime_count -= 2
	body.queue_free()
	queue_free()


func split() -> void:
	if size == 1:
		return
	var dir : float = Global.player.global_position.angle_to_point(global_position)
	Global.world.create_slime(type, size >> 1, global_position + Vector2.UP.rotated(dir) * 32, Vector2.UP.rotated(dir) * 100, 3.0,2)
	Global.world.create_slime(type, (size >> 1) + (size & 1), global_position + Vector2.UP.rotated(dir - PI) * 32, Vector2.UP.rotated(dir - PI) * 100, 3.0)
	Global.world.slime_count -= 1
	queue_free()


func die() -> void:
	Global.world.slime_count -= 1
	var loot = slime_loot.instance()
	loot.size = size
	loot.position = global_position
	loot.get_node("Sprite").frame = type
	Global.world.call_deferred("add_child", loot)
	$DeadSlime.play()
	dead = true
	$AnimatedSprite.play("Death")
	$CollisionShape2D.set_deferred("disabled", true)
	$BulletDetector.set_deferred("monitoring", false)
	$SlimeDetector.set_deferred("monitoring", false)


func _on_AnimatedSprite_animation_finished() -> void:
	if dead:
		queue_free()


func _on_BulletDetector_body_entered(body : Bullet) -> void:
	if body.bullet_type == 0:
		split()
		if size == 1:
			return
	self.health -= body.bullet_type
	body._hit()


func _on_SlimeDetector_body_entered(body : KinematicBody2D) -> void:
	if body == self:
		return
	if size + body.size > 10:
		return
	if not (can_join and body.can_join):
		return
	if type != body.type:
		return
	join(body)


func set_health(value : int) -> void:
	if value <= 0:
		die()
	health = value
	$Hit.play()
	$Stat/Health/HealthLabel.text = str(health)


func _set_size(value : int) -> void:
	scale = Vector2.ONE * (0.6 + value * 0.2)
	max_health = value
	health = max_health
	size = value
	movespeed = 75.0 + (size * 10.0)


func set_stun_time_left(value : float) -> void:
	can_join = (value == 0.0)
	stun_time_left = value
