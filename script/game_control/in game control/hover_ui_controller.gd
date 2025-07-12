extends Node

class_name UIController

@onready var _health_label: Label = $"Game State Overlay/VBoxContainer/HBoxContainer/HBoxContainer/Player Health"
@onready var _game_over_overlay: Control = $"Game Over Overlay"
@onready var _game_state_overlay: MarginContainer = $"Game State Overlay"
@onready var _game_menu_overlay: Control = $"Game Menu Overlay"
@onready var _upgrade_menu_overlay: Control = $"Upgrade Menu Overlay"
@onready var player_level: Label = $"Game State Overlay/VBoxContainer/HBoxContainer/Player Level"
@onready var game_controller: Node = %GameController

func _ready() -> void:
	_game_over_overlay.visible = false;
	_game_state_overlay.visible = true;
	_game_menu_overlay.visible = false;
	_upgrade_menu_overlay.visible = false;

func _process(_delta):
	if Input.is_action_just_pressed("in_game_settings_key"):
		_game_menu_overlay.visible = !_game_menu_overlay.visible;
		if _game_menu_overlay.visible:
			game_controller.on_menu_open();
		else:
			game_controller.on_menu_closed();

func update_player_health_display(entity_data: EntityData) -> void:
	_health_label.text = "Health: %d / %d" % [entity_data.health, entity_data.max_health]
	pass # Replace with function body.

func set_over_overlay_visible(visible: bool):
	_game_over_overlay.visible = visible;


func _on_settings_button_back_pressed() -> void:
	_game_menu_overlay.visible = false;
	game_controller.on_menu_closed();

func display_upgrade_menu() -> void:
	_upgrade_menu_overlay.visible = true;

# 0 - Left, 1 - Mid, 2 - Right
func _on_upgrade_button_pressed(button_id: int) -> void:
	print("Upgrade UI Button Pressed: %d" % button_id);
	game_controller.player_upgrade(button_id);
	_upgrade_menu_overlay.visible = false;

func update_player_level(level: int):
	player_level.text = "Player Level: %d" % level;
