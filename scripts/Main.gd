extends Node

@onready var game = $Game
@onready var screens = $Screens
@onready var iap_manager = $IAPManager


var game_in_progress = false

func _ready():
	DisplayServer.window_set_window_event_callback(_on_window_event)
		
	screens.start_game.connect(on_screens_start_game)
	screens.delete_level.connect(on_screens_delete_level)
	screens.purchase_skin.connect(purchase_skin)
	game.player_died.connect(on_game_player_died)
	game.pause_game.connect(on_pause_game)
	
	iap_manager.unlocked_new_skin.connect(unlocked_new_skin)
	
func unlocked_new_skin():
	if not game.new_skin_unlocked:
		game.new_skin_unlocked = true
	

func purchase_skin():
	iap_manager.purchase_skin()

func on_screens_start_game():
	game.new_game()
	game_in_progress = true

func on_game_player_died(score, highscore):
	game_in_progress = false
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, highscore)

func on_screens_delete_level():
	game_in_progress = false
	game.reset_game()

func _on_window_event(event):
	match event:
		#DisplayServer.WINDOW_EVENT_FOCUS_IN:
			#print("focus in")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			if game_in_progress and not get_tree().paused:				
				on_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()
	
func on_pause_game():
	screens.pause_game()
	get_tree().paused = true
