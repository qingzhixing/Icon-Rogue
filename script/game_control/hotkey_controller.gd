extends Node

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen_key"):
		GlobalSettings.toggle_fullscreen();