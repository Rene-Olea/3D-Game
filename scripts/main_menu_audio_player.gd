extends AudioStreamPlayer


const main_menu_music = preload("res://assets/sounds/Game Music/3D GAME MENU MUSIC.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_menu_music():
	_play_music(main_menu_music)
