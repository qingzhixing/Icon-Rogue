extends Node

class_name UIController

@onready var health_label: Label = $"Game State Overlay/VBoxContainer/HBoxContainer/Player Health"
@onready var game_over_overlay: Control = $"Game Over Overlay"
@onready var game_state_overlay: MarginContainer = $"Game State Overlay"
@onready var game_menu_overlay: Control = $"Game Menu Overlay"


@onready var game_controller: Node = %GameController

func _ready() -> void:
	game_over_overlay.visible = false;
	game_state_overlay.visible = true;
	game_menu_overlay.visible = false;

func _process(_delta):
	if Input.is_action_just_pressed("in_game_settings_key"):
		game_menu_overlay.visible = !game_menu_overlay.visible;
		if game_menu_overlay.visible:
			game_controller.on_menu_open();
		else:
			game_controller.on_menu_closed();

func update_player_health_display(entity_data: EntityData) -> void:
	health_label.text = "Health: %d / %d" % [entity_data.health, entity_data.max_health]
	pass # Replace with function body.

func set_over_overlay_visible(visible: bool):
	game_over_overlay.visible = visible;


func _on_settings_button_back_pressed() -> void:
	game_menu_overlay.visible = false;
	game_controller.on_menu_closed();
