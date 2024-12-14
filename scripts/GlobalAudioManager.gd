extends Node

var main_menu_music = preload("res://assets/sounds/Game Music/3D GAME MENU MUSIC.wav")
var audio_player = AudioStreamPlayer.new()

func _ready():
	add_child(audio_player)
	audio_player.stream = main_menu_music
	audio_player.play()
