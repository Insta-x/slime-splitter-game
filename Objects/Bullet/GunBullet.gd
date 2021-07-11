extends Bullet

class_name GunBullet


var hit_vfx := preload("res://Objects/VFX/Particles2DVFX.tscn")


func _ready() -> void:
	bullet_type = 1


func _hit() -> void:
	var vfx : Particles2D = hit_vfx.instance()
	vfx.global_position = global_position
	vfx.global_rotation = global_rotation
	Global.world.call_deferred("add_child", vfx)
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
