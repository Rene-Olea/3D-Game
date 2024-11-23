extends Node

signal set_cam_rotation(_cam_rotation : float)

@onready var camera_yaw = $CameraYaw
@onready var camera_pitch = $CameraYaw/CameraPitch
@onready var camera_3d = $CameraYaw/CameraPitch/SpringArm3D/Camera3D

var yaw : float = 0
var pitch : float = 0

var yaw_sens : float = 0.07
var pitch_sens : float = 0.07

var yaw_accel : float = 15
var pitch_accel : float = 15

var pitch_max : float = 75
var pitch_min : float = -55

var tween : Tween

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sens
		pitch += event.relative.y * pitch_sens
		
func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	camera_yaw.rotation_degrees.y = lerp(camera_yaw.rotation_degrees.y, yaw, yaw_accel * delta)
	camera_pitch.rotation_degrees.x = lerp(camera_pitch.rotation_degrees.x, pitch, pitch_accel * delta)
	#camera_yaw.rotation_degrees.y = yaw
	#camera_pitch.rotation_degrees.x = pitch
	
	set_cam_rotation.emit(camera_yaw.rotation.y)

func _on_set_movement_state(_movement_state : MovementState):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(camera_3d, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
