extends KinematicBody2D

class_name Bullet


var bullet_type : int
var movement_speed := 500
var direction := Vector2.ZERO


func _physics_process(delta):
	move_and_slide(direction * movement_speed)


func _hit() -> void:
	queue_free()
