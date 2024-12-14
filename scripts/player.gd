extends CharacterBody3D

signal pressed_jump(jump_state : MyJumpState)
signal changed_movement_state(_movement_state : MovementState)
signal changed_movement_direction(_movement_direction : Vector3)
signal health_changed(new_health: float)
signal player_died

@export var max_health: float = 100.0
var current_health: float = max_health
@export var jump_states : Dictionary
@export var movement_states : Dictionary
@export var death_sound_player: AudioStreamPlayer3D
@export var death_sound: AudioStream

var movement_direction : Vector3

func _input(_event):
	# Calculate movement direction
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
	
	if is_movement_ongoing():
		# Check for specific states
		if Input.is_action_pressed("run"):
			
			changed_movement_state.emit(movement_states["run"])
		else:
			changed_movement_state.emit(movement_states["walk"])
	else:
		changed_movement_state.emit(movement_states["idle"])

func _ready():
	# Start with the idle state
	changed_movement_state.emit(movement_states["idle"])

func _physics_process(_delta):
	# Emit movement direction if ongoing
	if is_movement_ongoing():
		changed_movement_direction.emit(movement_direction)
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			pressed_jump.emit(jump_states["jump"])

func is_movement_ongoing() -> bool:
	# Determine if any movement input is active
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
	
func take_damage(amount: float):
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		if death_sound_player and death_sound:
			death_sound_player.stream = death_sound
			death_sound_player.play()
			# Wait for sound to start playing before changing scene
			await get_tree().create_timer(0.1).timeout
		
		player_died.emit()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/death_menu.tscn")
