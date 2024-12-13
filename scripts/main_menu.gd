extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/HtP_menu.tscn")


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/about_menu.tscn")


func _on_button_4_pressed():
	get_tree().quit()
