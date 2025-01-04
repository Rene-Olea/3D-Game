extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_button_3_pressed():
	get_tree().quit()
