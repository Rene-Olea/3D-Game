#extends CanvasLayer
#
#@onready var _animation_player: AnimationPlayer = %AnimationPlayer
#
#
#func _ready() -> void:
	#Events.flag_reached.connect(func on_flag_reached() -> void:
		#await get_tree().create_timer(2.0).timeout
		#_animation_player.play("fade_in")
		#await _animation_player.animation_finished
		#get_tree().quit()
	#)


extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Signal callback for when the flag is reached
func _on_flag_reached() -> void:
	# Assuming you have a timer or delay mechanism before starting the animation
	await get_tree().create_timer(2.0).timeout
	animation_player.play("fade_in")
	
	# Wait for the animation to finish before quitting the game
	await animation_player.animation_finished
	get_tree().quit()

# Optionally, if you want to control the animation manually or from another script
#func fade_out_and_quit() -> void:
	#animation_player.play("fade_out")  # Assuming you also have a fade_out animation
	#await animation_player.animation_finished
	#get_tree().quit()
