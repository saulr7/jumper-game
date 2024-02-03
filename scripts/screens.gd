extends CanvasLayer


signal start_game
signal delete_level
signal purchase_skin

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOver
@onready var score_label = $GameOver/Box/ScoreLabel
@onready var higher_score = $GameOver/Box/HigherScore
@onready var shop_screen = $ShopScreen


var current_screen = null

func _ready():
	console.visible = false
	
	regisger_buttons()
	change_screen(title_screen)


func _process(_delta):
	pass

func regisger_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() >0:
		for b in buttons:
			if b is ScreenButton:
				b.clicked2.connect(_on_button_pressed)
		

func _on_toggle_console_pressed():
	console.visible = !console.visible

func _on_button_pressed(button):
	SoundFx.play("Click")
	match button.name:
		"TitlePLay":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"GameOverRetry":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"GameOverBack":
			change_screen(title_screen)
			delete_level.emit()
		"PauseRetryButton":
			change_screen(null)
			await(get_tree().create_timer(0.4).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseBack":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"PauseClose":
			change_screen(null)
			await(get_tree().create_timer(0.4).timeout)
			get_tree().paused = false
		"TitleShop":
			change_screen(shop_screen)
		"ShopBack":
			change_screen(title_screen)
		"ShopPurchaseSkin":
			purchase_skin.emit()
			
			
			
			
func change_screen(new_screen):
	if current_screen:
		var tween = current_screen.disappear()
		await(tween.finished)
	
	current_screen = new_screen
	if current_screen:
		var tween = current_screen.appear()
		await(tween.finished)
		get_tree().call_group("buttons","set_disabled",false)
			
			
func game_over(score, highscore):
	score_label.text = "Score: " + str(score)
	higher_score.text = "Best: " + str(highscore)
	change_screen(game_over_screen)

func pause_game():
	change_screen(pause_screen)
