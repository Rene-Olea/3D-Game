# MainMenuAudioPlayer is a global script.

# This script can be used globally.
# This allows for the music to not stop 
# whenever transitioning to different menu scenes.
extends AudioStreamPlayer

const main_menu_music = preload("res://assets/sounds/Game Music/3D GAME MENU MUSIC.wav")

func _play_music(music: AudioStream, volume = 2.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_menu_music():
	_play_music(main_menu_music)

func stop_menu_music():
	if stream == main_menu_music:
		# Stop whatever is playing
		stop()
		# Clear any existing stream settings
		stream = null
		# stream = null is a IMPORTANT STEP.
		# This allows for the transitioning 
		# from the game over or victory screen 
		# back to the menu screen to work correctly.
