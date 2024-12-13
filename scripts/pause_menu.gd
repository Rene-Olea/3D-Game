extends Control

func _ready():
	visible = false

func resume():
	visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func testEsc():
	if Input.is_action_just_pressed("ui_cancel"):
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
