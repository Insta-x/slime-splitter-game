extends Area2D


var size : int

var target : Node2D
var velocity := Vector2(0, 0)
var acceleration := 11.0
var max_speed := 33.0


func _ready():
	scale *= (size + 2)
	acceleration -= size
	max_speed -= size * 3


func _physics_process(delta: float) -> void:
	global_position += velocity
	if not target:
		velocity = velocity.move_toward(Vector2(0, 0), acceleration * delta)
		return
	var direction := (target.global_position - global_position).normalized()
	velocity = velocity.move_toward(max_speed * direction, acceleration * delta)


func _on_PlayerDetector_body_entered(body: Node) -> void:
	target = body


func _on_PlayerDetector_body_exited(_body: Node) -> void:
	target = null
