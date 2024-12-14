extends Node
@export var animation_tree : AnimationTree
@export var player : CharacterBody3D
@export var footstep_player: AudioStreamPlayer3D
# Add a second audio player for one-shot sounds like jumping
@export var effect_player: AudioStreamPlayer3D
var tween : Tween

# Sound effect variables
@export var walk_sound: AudioStream
@export var run_sound: AudioStream
@export var jump_sound: AudioStream  # Add the jump sound variable
var current_sound: AudioStream = null

var on_floor_blend : float = 1
var on_floor_blend_target : float = 1

func _physics_process(delta):
	on_floor_blend_target = 1 if player.is_on_floor() else 0
	on_floor_blend = lerp(on_floor_blend, on_floor_blend_target, 10 * delta)
	animation_tree["parameters/on_floor_blend/blend_amount"] = on_floor_blend
	
	# Stop sound if player is in air
	if !player.is_on_floor() and footstep_player.playing:
		footstep_player.stop()
	
func _jump(jump_state : MyJumpState):
	footstep_player.stop()  # Stop footstep sounds when jumping
	
	# Play the jump sound
	if effect_player and jump_sound:
		effect_player.stream = jump_sound
		effect_player.play()
		
	animation_tree["parameters/" + jump_state.animation_name+ "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _on_set_movement_state(_movement_state : MovementState):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(animation_tree,"parameters/BlendSpace1D/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree,"parameters/TimeScale/scale", _movement_state.animation_speed, 0.7)
	
	# Handle sound effects based on movement state
	var new_sound = null
	match _movement_state.id:
		0:  # Idle
			footstep_player.stop()
		1:  # Walking
			new_sound = walk_sound
		2:  # Running
			new_sound = run_sound
	
	# Change the sound if it's different from the current one
	if new_sound != current_sound and new_sound != null:
		current_sound = new_sound
		footstep_player.stream = current_sound
		if player.is_on_floor() and !footstep_player.playing:
			footstep_player.play()
