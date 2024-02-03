extends CharacterBody2D

class_name Player

signal died

var speed : float = 200.0
var gravity : float = 15.0
var max_fall_velocity : float = 1000.00
var jump_velocity : float = -800.0
var accelerometerer_speed = 130.0

var viewport_size

var use_accelerometer = false
var dead : bool = false

var animations = {
	"fall" : "fall",
	"jump" : "jump"
}

@onready var animation_player =	$AnimationPlayer
@onready var cshape = $CollisionShape2D
@onready var sprite_2d = $Sprite2D


func _ready():
	viewport_size = get_viewport_rect().size
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		use_accelerometer = true		
			

func _process(_delta):
	play_animation()

func _physics_process(_delta):
	
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	if !dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			print("Acc" + str(mobile_input))
			velocity.x = mobile_input.x * accelerometerer_speed
		else:
			var direction = Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * speed 
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var margin = 20
	
	if global_position.x > viewport_size.x + 20:
		global_position.x = -margin 
	elif global_position.x < -margin:
		global_position.x = viewport_size.x + 20

func jump():
	velocity.y = jump_velocity
	Singletones.add_log_message("player jumped")
	SoundFx.play("Jump")
	
func play_animation():
	if velocity.y >0:
		animation_player.play(animations.fall)
	else:
		animation_player.play(animations.jump)


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()

func die():
	if dead:
		return
		
	SoundFx.play("Fall")
	cshape.set_deferred("disabled", true)
	dead = true
	died.emit()	
	

func use_new_skin():
	animations["jump"] = "jump_red"
	animations["fall"] = "fall_red"
	if sprite_2d:
		sprite_2d.texture = preload("res://assets/textures/character/Skin2Idle.png")
