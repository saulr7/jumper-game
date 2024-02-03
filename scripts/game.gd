extends Node2D

signal player_died(score, highScore)
signal pause_game

var camera_scene = preload("res://scenes/game_camera.tscn")
var player_scene = preload("res://scenes/player.tscn")

@onready var level_generator = $LevelGenerator

@onready var parallax1 = $ParallaxBackground/ParallaxLayer
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3
@onready var HUD = $UILayer/HUD

var player_spawn_position : Vector2


var camera = null
var player : Player = null
var player_spawn_y_offset : float = 135.0
var viewport_size
var score: int = 0
var highscore: int = 0
var save_file_path : String = "user://highscore.save"

var new_skin_unlocked = false

func _ready():
	viewport_size = get_viewport_rect().size
	player_spawn_position.x = viewport_size.x / 2.0
	player_spawn_position.y = viewport_size.y - player_spawn_y_offset
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	HUD.visible = false
	load_score()
	HUD.set_score(0)
	HUD.pause_game.connect(on_pause_game)
	#new_game()

func _process(_delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
		
	if player:
		if score < (viewport_size.y - player.global_position.y):
			score = (viewport_size.y - player.global_position.y)
			HUD.set_score(score)
		
func new_game():	
	reset_game()
	player = player_scene.instantiate()
	player.global_position =player_spawn_position 
	player.died.connect(on_player_died)
	
	add_child(player)
	
	if new_skin_unlocked:
		player.use_new_skin()
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	level_generator.setup(player)
	level_generator.start_generation()
	
	HUD.visible = true
	score = 0


func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var texture = parallax_sprite.get_texture()
	var parallax_width = texture.get_width()
	
	var scale_texture = viewport_size.x / parallax_width
	var result = Vector2(scale_texture, scale_texture)
	return result

func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if not parallax_sprite:
		return
	
	parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
	var my = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
	parallax_layer.motion_mirroring.y = my
		
	
func on_player_died():
	HUD.visible = false
	if score > highscore:
		highscore = score
		save_score()
	player_died.emit(score,highscore)


func reset_game():
	HUD.set_score(0)
	HUD.visible = false
	level_generator.reset_level()
	if player:
		player.queue_free()
		player = null
		level_generator.player = null
	
	if camera:
		camera.queue_free()
		camera = null


func save_score():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
	
func load_score():
	if not FileAccess.file_exists(save_file_path):
		return
	
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	highscore = file.get_var()
	file.close()
	

func on_pause_game():
	pause_game.emit()
