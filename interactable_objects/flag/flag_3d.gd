extends Node3D

@onready var _area_3d: Area3D = $Area3D
@onready var transition_screen: CanvasLayer = $FlagReachedScreen
@onready var animation_player: AnimationPlayer = $FlagReachedScreen/AnimationPlayer

var is_transitioning = false

func _ready() -> void:
	# Error checking
	if not transition_screen:
		print("Error: TransitionScreen not found")
	if not animation_player:
		print("Error: AnimationPlayer not found")
	
	_area_3d.body_entered.connect(_on_body_entered)
	if transition_screen:
		transition_screen.hide()

func _on_body_entered(body: PhysicsBody3D) -> void:
	if !is_transitioning:
		_start_transition()

func _start_transition() -> void:
	is_transitioning = true
	if transition_screen:
		transition_screen.show()
	if animation_player:
		animation_player.play("fade_in")
		await animation_player.animation_finished
		# Only quit if the animation finished successfully
		if get_tree():
			get_tree().change_scene_to_file("res://scenes/victory_menu.tscn")
		else:
			print("Animation or scene transition failed")
