extends CharacterBody3D

signal pressed_jump(jump_state : MyJumpState)
signal changed_movement_state(_movement_state : MovementState)
signal changed_movement_direction(_movement_direction : Vector3)

@export var jump_states : Dictionary
@export var movement_states : Dictionary

var movement_direction : Vector3

func _input(_event):
	# Calculate movement direction
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
	
	if is_movement_ongoing():
		# Check for specific states
		if Input.is_action_pressed("run"):
			changed_movement_state.emit(movement_states["run"])  # Running
		else:
			changed_movement_state.emit(movement_states["walk"])  # Walking (default)
	else:
		# No movement input; set to idle
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
