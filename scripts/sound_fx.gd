extends Node


@onready var sound_players = get_children()

var sounds = {
	"Click"	: load("res://assets/sound/Click.wav"), 
	"Jump" 	: load("res://assets/sound/Jump.wav"),
	"Fall" 	: load("res://assets/sound/Fall.wav")
}

func play(sound_name : String):
	var sound_to_play = sounds[sound_name]
	for s in sound_players:
		if s.playing:
			continue

		s.stream = sound_to_play
		s.play()
		return
