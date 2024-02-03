extends Control

signal pause_game

@onready var top_bar = $TopBar
@onready var top_bar_bg = $TopBarBG
@onready var score_label = $TopBar/ScoreLabel

func _ready():
	var os_name = OS.get_name()
	
	if os_name == "Android" || os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top = (safe_area_top / screen_scale)
		
		top_bar.position.y += safe_area_top
		var margin = 10
		top_bar_bg.size.y += safe_area_top + margin
		print(safe_area)
		
		Singletones.add_log_message("safe area" + str(safe_area))


func set_score(score:int):
	score_label.text = str(score)

func _on_pause_button_pressed():
	SoundFx.play("Click")
	pause_game.emit()
	#get_tree().paused = !get_tree().paused
