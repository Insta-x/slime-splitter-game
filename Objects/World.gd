extends Node2D

class_name GameWorld


const slime_scenes := [preload("res://Objects/Slimes/NormalSlime.tscn"), preload("res://Objects/Slimes/DashSlime.tscn"), preload("res://Objects/Slimes/MotherSlime.tscn")]

onready var player : Player = $Player
onready var TileMapGenerator : TileMap = $TileMapGenerator

var slime_count := 0
var global_world_seed := 0


func _ready() -> void:
	Global.world = self
	global_world_seed = randi()
	TileMapGenerator.global_world_seed = global_world_seed
	TileMapGenerator.generate_map(Vector2.ZERO)


func create_slime(type : int, size : int, pos : Vector2, vel : Vector2 = Vector2.ZERO, stun_time_left : float = 0.0, Merged : int = 0) -> void:
	slime_count += 1
	var slime : Slime = slime_scenes[type].instance()
	slime.type = type
	slime.size = size
	slime.global_position = pos
	slime.velocity = vel
	slime.stun_time_left = stun_time_left
	if Merged == 1:
		slime.get_node("MergeSlime").play()
	elif Merged == 2:
		slime.get_node("DeadSlime").play()
	call_deferred("add_child", slime)


func _on_WorldUpdateTimer_timeout() -> void:
	TileMapGenerator.update_map(player.global_transform.origin)
