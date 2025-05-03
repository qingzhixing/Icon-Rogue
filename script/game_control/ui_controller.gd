extends Node

class_name UIController

@onready var health_label: Label = $"MarginContainer/VBoxContainer/HBoxContainer/Player Health"
@onready var game_over_overlay: Control = $"Game Over Overlay"

func _ready() -> void:
	game_over_overlay.visible = false;

func update_player_health_display(health: int) -> void:
	health_label.text = "Health: " + str(health)
	pass # Replace with function body.
