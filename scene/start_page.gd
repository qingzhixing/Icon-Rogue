extends Node

func _on_btn_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game_scene.tscn");


func _on_btn_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/settings_page.tscn");


func _on_btn_about_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/about_page.tscn");


func _on_btn_exit_pressed() -> void:
	get_tree().quit();
