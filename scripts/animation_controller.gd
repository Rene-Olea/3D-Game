extends Node

@export var animation_tree : AnimationTree
@export var player : CharacterBody3D
@export var footstep_player: AudioStreamPlayer3D
@export var effect_player: AudioStreamPlayer3D
var tween : Tween

# Sound effect variables
@export var walk_sound: AudioStream
@export var run_sound: AudioStream
@export var jump_sound: AudioStream  
var current_sound: AudioStream = null
var is_walking : bool = false

var on_floor_blend : float = 1
var on_floor_blend_target : float = 1

func _physics_process(delta):
	on_floor_blend_target = 1 if player.is_on_floor() else 0
	on_floor_blend = lerp(on_floor_blend, on_floor_blend_target, 10 * delta)
	animation_tree["parameters/on_floor_blend/blend_amount"] = on_floor_blend
	
	# Manage footstep sound based on movement and ground status
	if player.is_on_floor() and is_walking:
		if !footstep_player.playing:
			footstep_player.play()
	else:
		footstep_player.stop()

func _jump(jump_state : MyJumpState):
	# Stop walking when jumping
	is_walking = false
	# Stop footstep sounds when jumping
	footstep_player.stop()
	
	# Play the jump sound
	if effect_player and jump_sound:
		effect_player.stream = jump_sound
		effect_player.play()
		
	animation_tree["parameters/" + jump_state.animation_name + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

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
			is_walking = false
			footstep_player.stop()
		1:  # Walking
			is_walking = true
			new_sound = walk_sound
		2:  # Running
			is_walking = true
			new_sound = run_sound
	
	# Change the sound if it's different from the current one
	if new_sound != current_sound:
		current_sound = new_sound
		if new_sound:
			footstep_player.stream = new_sound
			if player.is_on_floor():
				footstep_player.play()
		else:
			footstep_player.stop()


# Changes Made:
# Issue 1 - Sound Only Starts on Run: 
# Added an is_walking boolean to track 
# if the player is moving (walking or running). 
# This ensures that the walking sound starts 
# when the player moves, not just when the shift key is pressed.

# Issue 2 - Sound Stops After Jump:
# The _physics_process function now checks 
# if the player is walking and on the floor 
# to play footstep sounds, ensuring they restart 
# upon landing if movement continues.
