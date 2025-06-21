extends Node

class_name UIController

@onready var health_label: Label = $"MarginContainer/VBoxContainer/HBoxContainer/Player Health"
@onready var game_over_overlay: Control = $"Game Over Overlay"

func _ready() -> void:
	game_over_overlay.visible = false;

func update_player_health_display(entity_data: EntityData) -> void:
	health_label.text = "Health: %d / %d" % [entity_data.health, entity_data.max_health]
	pass # Replace with function body.

func set_over_overlay_visible(visible: bool):
	game_over_overlay.visible = visible;
