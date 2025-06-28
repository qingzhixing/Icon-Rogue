extends Node

@onready var hover_ui: UIController = %HoverUI
@onready var player: PlayerController = %Player

var _in_dead_process: bool = false;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if _in_dead_process && Input.is_action_just_pressed("respawn_key"):
		_in_dead_process = false;
		do_restart();

func do_restart():
	GameStopper.set_game_stopped(false);
	do_exit();

func do_exit():
	GameStopper.set_game_stopped(false);
	get_tree().change_scene_to_file("res://scene/start_page.tscn");

func on_player_dead():
	if _in_dead_process:
		return
	_in_dead_process = true;
	GameStopper.set_game_stopped(true);
	print("Player Died!");
	# Sound Effect
	SoundPlayer.play_sfx("game_state/Lose.ogg");
	hover_ui.set_over_overlay_visible(true);

func on_menu_open():
	GameStopper.set_game_stopped(true);

func on_menu_closed():
	if !_in_dead_process:
		GameStopper.set_game_stopped(false);

func _on_restart_button_pressed() -> void:
	do_restart();


func _on_button_exit_pressed() -> void:
	do_exit();
