extends Control

func _ready():
	# Hide the pause menu initially
	visible = false

func resume():
	visible = false  # Hide the pause menu
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock the mouse back for gameplay

func pause():
	visible = true  # Show the pause menu
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show the mouse cursor for menu interaction

func testEsc():
	if Input.is_action_just_pressed("ui_cancel"):  # Use "ui_cancel" for Esc
		if visible:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_exit_pressed():
	get_tree().quit()

func _process(_delta):
	testEsc()
