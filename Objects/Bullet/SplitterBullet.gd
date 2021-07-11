extends Bullet

class_name SplitterBullet


func _ready() -> void:
	bullet_type = 0


func _on_Timer_timeout() -> void:
	queue_free()
