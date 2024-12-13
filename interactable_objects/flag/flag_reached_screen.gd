extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_flag_reached() -> void:
	await get_tree().create_timer(2.0).timeout
	animation_player.play("fade_in")
	
	await animation_player.animation_finished
	get_tree().quit()
