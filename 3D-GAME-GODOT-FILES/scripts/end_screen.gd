extends CanvasLayer

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
		await get_tree().create_timer(2.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		get_tree().quit()
