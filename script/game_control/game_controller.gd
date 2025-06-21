extends Node

@onready var hover_ui: UIController = %HoverUI
@onready var player: PlayerController = %Player

var _in_dead_process: bool = false;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if _in_dead_process && Input.is_action_just_pressed("respawn_key"):
		_in_dead_process = false;
		GameStopper.set_game_stopped(false);
		get_tree().change_scene_to_file("res://scene/start_page.tscn");

func on_player_dead():
	if _in_dead_process:
		return
	_in_dead_process = true;
	GameStopper.set_game_stopped(true);
	print("Player Died!");
	# Sound Effect
	GlobalSoundPlayer.play_sfx("game_state/Lose.ogg");
	hover_ui.set_over_overlay_visible(true);
