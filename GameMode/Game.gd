extends Node

class_name Game


onready var world : Node2D = $World
onready var player : Player = $World/Player
onready var GameOverLabel : Label = $HUD/CenterContainer/GameOverLabel

var score := 0 setget set_score
var target_score := 500 setget set_target_score
var avg_size := 1

var game_done := false

var time := 60.0 setget set_time
var target_score_inc := 500
var LootContainer = [0,0,0]

func _ready() -> void:
	randomize()
	$Camera2D.player = player
	player.connect("get_loot", self, "add_score")
	player.connect("shooting", $Camera2D, "shake")
	player.connect("dead", self, "game_over")
	player.connect("dashed",self,"player_dashed")



func _process(delta: float) -> void:
	self.time -= delta * int(not get_tree().paused)


func _input(event: InputEvent) -> void:
	if game_done:
		if event.is_action("Exit") and event.is_pressed():
			get_tree().change_scene("res://Menu/Menu.tscn")
		if event.is_action("restart") and event.is_pressed():
			get_tree().change_scene("res://GameMode/Game.tscn")
		get_tree().set_input_as_handled()
	else:
		if event.is_action("pause") and event.is_pressed():
			get_tree().paused = not get_tree().paused
			$HUD/CenterContainer/PauseLabel.visible = get_tree().paused
			if get_tree().paused:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -30)
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)


func game_over() -> void:
	if game_done:
		return
	game_done = true
	var high_score := 0
	var loadf := File.new()
	if loadf.file_exists("user://asd.sav"):
		loadf.open("user://asd.sav", File.READ)
		high_score = loadf.get_64()
	loadf.close()
	var savef := File.new()
	if score > high_score:
		savef.open("user://asd.sav", File.WRITE)
		savef.store_64(score)
	savef.close()
	
	if score > high_score:
		GameOverLabel.text = "High Score!\n"
	else:
		GameOverLabel.text = "Score\n"
	GameOverLabel.text += str(score) + "\nPress Esc to exit\nPress R to restart"
	
	OS.delay_msec(500)
	GameOverLabel.visible = true
	$Music.stop()
	$GameOverAudio.play()


func add_score(size : int, type : int) -> void:
	self.score += 1 << (size - 1)
	LootContainer[type] += size
	player.dash_count =  LootContainer[2]
	$HUD/DashLabel.text = "Dash :\n" + str(LootContainer[2])


func  player_dashed() -> void:
	LootContainer[2] -= 1
	$HUD/DashLabel.text = "Dash :\n" + str(LootContainer[2])


func _on_SpawnTimer_timeout() -> void:
	if world.slime_count < 1000:
		var rand := randi() % 100
		var type := 0
		if rand < 70:
			type = 0
		elif rand < 95:
			type = 1
		else:
			type = 2
		var size := randi() % avg_size + 1
		var rot := rand_range(0, 2 * PI)
		world.create_slime(type, size, player.global_position + Vector2(cos(rot), sin(rot)) * (randi() % 500 + 1000))


func set_score(value : int) -> void:
	score = value
	if score >= target_score:
		self.time += 30.0
		self.target_score += target_score_inc
		target_score_inc = min(target_score_inc + 100, 2000)
	avg_size = min(1 + score / 1000, 3)
	$HUD/ScoreLabel.text = "Score\n" + str(score)


func set_target_score(value : int) -> void:
	target_score = value
	$HUD/TargetLabel.text = "Target\n" + str(target_score)


func set_time(value : float) -> void:
	time = value
	if time <= 0.0 and not game_done:
		player.died()
	$HUD/TimeLabel.text = str(max(0, int(ceil(time))))


