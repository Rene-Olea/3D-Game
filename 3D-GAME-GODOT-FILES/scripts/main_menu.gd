extends Control

func _ready():
	# MainMenuAudioPlayer is a global script.
	# This allows for the music to not stop 
	# whenever transitioning 
	# to different menu scenes.	
	MainMenuAudioPlayer.play_menu_music()

# Transitions to the "game level" scene
func _on_button_pressed():
	# Stops the global audio player music
	# in order to make way for the game level music.			
	MainMenuAudioPlayer.stop_menu_music()
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")

# Transitions to "How to play" menu scene
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/HtP_menu.tscn")

# Transitions to "About" menu scene
func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/about_menu.tscn")

# Quits the game
func _on_button_4_pressed():
	get_tree().quit()
