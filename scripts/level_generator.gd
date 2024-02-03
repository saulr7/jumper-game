extends Node2D


var platform_scene = preload("res://scenes/platform.tscn")

@onready var platform_parent = $PlatformParent
@onready var player : Player = null


# Level gen variables
var start_platform_y
var y_distance_between_platforms = 160
var level_size = 50
var viewport_size
var generated_platform_count = 0


func _ready():
	viewport_size = get_viewport_rect().size
	
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 2)
	

func start_generation():
	generate_level(start_platform_y, true)
	

func _process(_delta):
	if not player:
		return
	
	var py = player.global_position.y
	var end_of_level_pos = start_platform_y - (generated_platform_count * y_distance_between_platforms)
	
	var thresold = end_of_level_pos + (y_distance_between_platforms * 6)
	if py <= thresold:
		generate_level(end_of_level_pos, false)


func setup(_player: Player):
	if not _player:
		return
		
	player = _player

func create_plaform(location : Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform
	
func generate_level(start_y: float, generate_ground: bool):
	# Generate the ground
	var platform_width = 136
	var ground_layer_platform_count = (viewport_size.x / platform_width) +1
	
	if generate_ground:		
		var ground_layer_y_offset = 62
		
		for i in range(ground_layer_platform_count):
			var ground_location = Vector2( i * platform_width, viewport_size.y- ground_layer_y_offset)
			create_plaform(Vector2(ground_location))
		
	# Generate the rest of the level	
	for i in range(level_size):
		var location = Vector2()
		var max_x_position = viewport_size.x - platform_width
		location.x = randf_range(1, max_x_position)
		location.y = start_y - (y_distance_between_platforms * i)
		create_plaform(location)
		generated_platform_count += 1

func reset_level():
	for p in platform_parent.get_children():
		p.queue_free()
